if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_RequestCae]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_RequestCae]

/*

 sp_FE_RequestCae 

	select * from facturaelectronica

*/

go
create procedure [dbo].[sp_FE_RequestCae] (

	@@fv_id int
)

as

begin

	set nocount on

	declare @comprobante varchar(255)
	declare @doc_nombre varchar(255)
	declare @cae varchar(50)

	select @cae = fv_cae,
				 @comprobante = doc_nombre + ' ' + fv_nrodoc,
				 @doc_nombre = doc_nombre
	from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
	where fv.fv_id = @@fv_id

	-- Si ya tiene cae no hay que hacer nada
	--
	if @cae <> '' begin
		select 0 as success, 'La factura ['+@comprobante+'] ya tiene CAE' as Info
		return
	end

	declare @es_facturaElectronica tinyint

	select @es_facturaElectronica = doc_esfacturaelectronica
	from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
	where fv.fv_id = @@fv_id
		and fv.fv_cae = ''

	-- Solo si es de tipo factura electronica
	--
	if isnull(@es_facturaElectronica,0) = 0 begin
		select 0 as success, 'El documento del comprobante ['+@comprobante+'] no es de tipo "Factura Electronica"' as Info
		return
	end

	-- Para obtener el ultimo numero usado
	--
	declare @doct_id  int
	declare @emp_id   int
	declare @pto_vta 	varchar(4)
	declare @letra    varchar(4)

	select 	@doct_id = doct_id, 
					@emp_id = emp_id, 
					@pto_vta = substring(fv_nrodoc,3,4), 
					@letra = substring(fv_nrodoc,1,1)

	from FacturaVenta 
	where fv_id = @@fv_id

	-- La mascara puede estar en Z o en X para documentos 
	-- que aun no tienen CAE
	--
	set @pto_vta = replace(@pto_vta, 'Z','0')
	set @pto_vta = replace(@pto_vta, 'X','0')
	set @pto_vta = replace(@pto_vta, 'W','0')

	declare @last_nrodoc 	varchar(50)
	declare @fecha 				datetime

	select @last_nrodoc = max(convert(int,fv_cae_nrodoc)) 
	from FacturaVenta 
	where doct_id = @doct_id 
		and emp_id = @emp_id
		and substring(fv_nrodoc,3,4) = @pto_vta
		and fv_cae <> ''
		and isnumeric(fv_cae_nrodoc) <> 0
		and substring(fv_nrodoc,1,1) = @letra

	if @last_nrodoc is null begin

		select @fecha = fv_fecha from FacturaVenta where fv_id = @@fv_id
		set @last_nrodoc = '0000'

	end else begin

		select @fecha = fv_fecha
		from FacturaVenta 
		where emp_id = @emp_id
			and fv_cae_nrodoc = @last_nrodoc
			and doct_id = @doct_id

	end

	if isnumeric(@last_nrodoc)=0 begin
		select 0 as success, 'No se pudo obtener el ultimo numero de comprobante con CAE para el documento ['+@doc_nombre+']' as Info
		return
	end

	set @last_nrodoc = rtrim(ltrim(convert(varchar,convert(int,@last_nrodoc)+1)))

	declare @fv_nrodoc varchar(50)

	-- En este intento el sistema paza de Z a X para la mascara temporal del nro de documento
	--
	set @fv_nrodoc = @letra 
										+ '-' + right('XXXX'+rtrim(ltrim(convert(varchar,convert(int,@pto_vta)))),4) -- sucursal
										+ '-'+ right('00000000' + @last_nrodoc,8)     -- numero

	-- Chequeamos que no exista este comprobante
	--
	if exists (	select 1 
							from FacturaVenta 
							where fv_nrodoc = @fv_nrodoc 
								and emp_id = @emp_id 
								and doct_id = @doct_id
								and fv_id <> @@fv_id
						) begin
		select 	0 as success, 
						'Ya existe un comprobante con el numero ' + @fv_nrodoc + char(10) + char(13) +
						'Debe corregir dicho comprobante antes de poder obtener el CAE para el comprobante ['+@comprobante+']' 
						 as Info		
		return

	end

	update FacturaVenta 
			set fv_nrodoc = @fv_nrodoc,
					fv_fecha = @fecha
	where fv_id = @@fv_id

	delete FacturaElectronica where fv_id = @@fv_id

	declare @bSuccess tinyint
	declare @MsgError  varchar(5000) set @MsgError = ''

	exec sp_DocFacturaVentaSaveFE @@fv_id, 
																@bSuccess	out,
																@MsgError out

	if IsNull(@bSuccess,0) = 0 begin

		select 0 as success, 'Ocurrio un error obteniendo el CAE para el comprobante ['+@comprobante+']. Error: ' + @MsgError as Info
		return

	end

	declare @n int
	set @n = 1

	-- Cada 3 segundos veo si ya procese la factura (lo hago durante 15 segundos)
	--
	while @n < 5 /* 1 minuto */ and (
																			not exists(select 1 
																									from FacturaElectronica 
																									where fv_id = @@fv_id 
																										and fvfe_rechazado <> 0)
																		and 
																			not exists(select 1 
																									from FacturaVenta
																									where fv_id = @@fv_id 
																										and fv_cae <> '')
																	)
	begin

		exec sp_sleep '000:00:03'
		set @n = @n +1

	end

	select 1 as success, 'La solicitud de cae para el comprobante ['+@comprobante+'] se efectuo con éxito' as Info

end
