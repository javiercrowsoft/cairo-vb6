if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSaveFE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSaveFE]

/*

 sp_DocFacturaVentaSaveFE 124

*/

go
create procedure sp_DocFacturaVentaSaveFE (
  @@fv_id 			int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

	set @@bSuccess 	= 1
	set @@bErrorMsg = '@@ERROR_SP:'

	set nocount on

	declare @es_facturaElectronica tinyint
	declare @cae varchar(50)
	declare @emp_id int
	declare @est_id int

	select @es_facturaElectronica = doc_esfacturaelectronica,
				 @cae = fv_cae,
				 @emp_id = doc.emp_id,
				 @est_id = est_id
	from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
	where fv.fv_id = @@fv_id
		and fv.fv_cae = ''

	-- Si ya tiene cae no hay que hacer nada
	--
	if @cae <> '' return

	if @est_id = 4 /*pendiente de firma*/ return

	-- Solo si es de tipo factura electronica
	--
	if isnull(@es_facturaElectronica,0) <> 0 begin

		-- Solo intentamos una vez
		--
		if not exists (select 1 from FacturaElectronica where fv_id = @@fv_id) begin

			declare @fvfe_id int

			exec sp_dbgetnewid 'FacturaElectronica', 'fvfe_id', @fvfe_id out, 0

			insert into FacturaElectronica (fvfe_id, fv_id) values (@fvfe_id, @@fv_id)

			-- veo si tengo que grabar sincronicamente
			--
			declare @cfg_valor varchar(5000) 
			exec sp_Cfg_GetValor  'Contabilidad-General',
													  'Factura Electronica Asincronica',
													  @cfg_valor out,
													  0
		
		  set @cfg_valor = IsNull(@cfg_valor,0)
			if convert(int,@cfg_valor) = 0 begin
		
				declare @n int
				set @n = 1

				-- Cada 3 segundos veo si ya tengo CAE en la factura (lo hago durante 1 minuto)
				--
				while @n < 20 /* 1 minuto */ and not exists(select 1 from FacturaVenta where fv_id = @@fv_id and fv_cae <> '')
				begin

					exec sp_sleep '000:00:03'
					set @n = @n +1
				end

				-- Chequeo que el servicio de Factura Electronica haya actualizado el CAE
				--
				if not exists(select 1 from FacturaVenta where fv_id = @@fv_id and fv_cae <> '') begin
					update FacturaElectronica set fvfe_rechazado = 1 where fv_id = @@fv_id
					exec sp_sleep '000:01:00' -- espero un minuto mas

					-- Chequeo por ultima vez que el servicio de Factura Electronica no actualice el CAE
					--
					if not exists(select 1 from FacturaVenta where fv_id = @@fv_id and fv_cae <> '') begin

						-- Tengo que desaplicar la factura
						exec sp_DocFacturaVentaSaveDesAplic @@fv_id

						-- Finalmente anulo la factura
						exec sp_DocFacturaVentaDelete @@fv_id, @emp_id, 1 /*administrador*/
	
						set @@bSuccess 	= 0
						set @@bErrorMsg = @@bErrorMsg + 'No se pudo obtener el CAE para esta factura. Intente grabar la factura nuevamente o modifique la configuracion general de contabilidad para trabajar en modo asincronico con el servidor web de AFIP.'

					end -- ultimo chequeo
				end -- ante ultimo chequeo
			end -- grabacion sincronica
		end	-- primer y unico intento
	end -- documento de tipo factura electronica

end

go