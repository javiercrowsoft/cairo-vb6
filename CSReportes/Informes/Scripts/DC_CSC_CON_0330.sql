SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0330]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0330]
GO




/*  


DC_CSC_CON_0330 1,'20080101','20090101','0','0','0','0','0','0',0,1


*/

create procedure DC_CSC_CON_0330 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

	@@ccos_id 				varchar(255),
	@@cue_id          varchar(255),
  @@cico_id         varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@emp_id	 				varchar(255)

)as 

begin
set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id_param int
declare @mon_id   		int
declare @emp_id   		int
declare @cico_id 			int
declare @doc_id				int
declare @ccos_id 			int

declare @ram_id_cuenta           int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_circuitocontable int
declare @ram_id_documento        int
declare @ram_id_centrocosto 		 int

declare @clienteID 			int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@mon_id,  		 @mon_id  out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
exec sp_ArbConvertId @@cue_id,  		 @cue_id_param  out, 	@ram_id_cuenta out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id, 		   @doc_id  out, 				@ram_id_Documento out
exec sp_ArbConvertId @@ccos_id, 		 @ccos_id out, 				@ram_id_centrocosto out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out


if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

if @ram_id_centrocosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
	end else 
		set @ram_id_centrocosto = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


	create table #t_pagos (	fc_id int, 
													pago varchar(5000), 
													opg_fecha datetime, 
													opg_total decimal(18,6), 
													opg_nrodoc varchar(255),
													varios_pagos tinyint
												)
	
	declare @fc_id int
	declare @last_fc_id int
	declare @opg_fecha datetime
	declare @opg_nrodoc varchar(100)
	declare @opg_importe decimal(18,2)
	declare @pago varchar(5000)
	
	declare @last_fecha datetime
	declare @last_total decimal(18,6)
	declare @last_nrodoc varchar(255)
	declare @n int
	set @last_fc_id = 0
	set @n = 0
	
	declare c_pagos insensitive cursor for 
			select fcopg.fc_id, opg_fecha, opg_nrodoc, sum(fcopg_importe)
			from FacturaCompraOrdenPago fcopg inner join OrdenPago opg on fcopg.opg_id = opg.opg_id
			group by fcopg.fc_id, opg_fecha, opg_nrodoc
	
	open c_pagos
	
	fetch next from c_pagos into @fc_id, @opg_fecha, @opg_nrodoc, @opg_importe
	while @@fetch_status = 0
	begin
	
		if @last_fc_id <> @fc_id begin
	
			if @last_fc_id <> 0 begin
	
				if @n > 1 begin
	
					set @last_fecha  = '19000101'
					set @last_total  = 0
					set @last_nrodoc = ''
					set @n = 1
	
				end else set @n = 0
	
				set @pago = substring(@pago,1,len(@pago)-2)
	
				insert into #t_pagos (fc_id, pago, opg_fecha, opg_total, opg_nrodoc, varios_pagos)
											values (@last_fc_id, @pago, @last_fecha, @last_total, @last_nrodoc, @n)
			end
	
			set @pago = ''
			set @last_fc_id = @fc_id
	
			set @last_fecha  = @opg_fecha
			set @last_total  = @opg_importe
			set @last_nrodoc = @opg_nrodoc
	
			set @n = 0
	
		end
	
		set @n = @n+1
	
		set @pago = @pago + convert(varchar,@opg_fecha,102) 
								+ ' ' + @opg_nrodoc 
								+ ' ' + convert(varchar,@opg_importe) + ', '
	
		fetch next from c_pagos into @fc_id, @opg_fecha, @opg_nrodoc, @opg_importe
	end
	
	close c_pagos
	deallocate c_pagos
	
	if @n > 1 begin
	
		set @last_fecha  = '19000101'
		set @last_total  = 0
		set @last_nrodoc = ''
		set @n = 1
	
	end else set @n = 0
	
	set @pago = substring(@pago,1,len(@pago)-2)
	
	insert into #t_pagos (fc_id, pago, opg_fecha, opg_total, opg_nrodoc, varios_pagos)
								values (@last_fc_id, @pago, @last_fecha, @last_total, @last_nrodoc, @n)
	
	select
					fc.fc_id								as comp_id,
					fc.doct_id              as doct_id,

					0                       as orden_aux_id,
	
					'Factura'               as Tipo,
	
					prov_nombre							as Proveedor,
					fc_fecha								as Fecha,
					fc_fechaentrega					as [Fecha Enrega],
					fc_nrodoc								as Comprobante,
					'#'+cue_codigo					as Codigo,
					'#'+cueg_codigo					as [Grupo Cuenta],
					'#'+pr_codigo						as [Codigo Producto],
					pr_nombrecompra					as Producto,
					isnull(ccosfci.ccos_codigo,ccosfc.ccos_codigo) as [Codigo Costo],
					isnull(ccosfci.ccos_nombre,ccosfc.ccos_nombre) as [Centro Costo],
					case when fc.doct_id = 8 then -fci_neto else fci_neto end as Neto,
					case when fc.doct_id = 8 then -fci_ivari else fci_ivari end as IVA,
					case when fc.doct_id = 8 then -fci_importe else fci_importe end as Total,
					t.pago									as Pagos,
					t.opg_fecha							as [Pago Fecha],
					t.opg_nrodoc						as [Orden de Pago],
					t.opg_total							as [Pago Total],
					t.varios_pagos					as [Varios Pagos]					
	
	from Facturacompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
											  left  join centrocosto ccosfc on fc.ccos_id = ccosfc.ccos_id
											  left  join centrocosto ccosfci on fci.ccos_id = ccosfci.ccos_id
												left  join proveedor prov on fc.prov_id = prov.prov_id
											  left  join producto pr on fci.pr_id = pr.pr_id
												left  join #t_pagos t on fc.fc_id = t.fc_id
												left  join documento doc on fc.doc_id = doc.doc_id
												left  join CuentaGrupo cueg on pr.cueg_id_compra = cueg.cueg_id
												left  join Cuenta cue on cueg.cue_id = cue.cue_id
	
	where fc.est_id <> 7
	
						and fc_fechaentrega >= @@Fini
						and	fc_fechaentrega <= @@Ffin 
			
			-- Validar usuario - empresa
						and (
									exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (fc.mon_id 		= @mon_id 	or @mon_id	=0)
			and   (doc.emp_id  	= @emp_id 	or @emp_id	=0)
			and   (doc.cico_id 	= @cico_id  or @cico_id =0)
			and   (fc.doc_id 		= @doc_id 	or @doc_id	=0)
			and   (isnull(fci.ccos_id,fc.ccos_id) = @ccos_id or @ccos_id=0)
			
			-- Arboles
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 17 
			                  and  rptarb_hojaid = cueg.cue_id
										   ) 
			           )
			        or 
								 (@ram_id_cuenta = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 12 
			                  and  rptarb_hojaid = fc.mon_id
										   ) 
			           )
			        or 
								 (@ram_id_moneda = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1018 
			                  and  rptarb_hojaid = doc.emp_id
										   ) 
			           )
			        or 
								 (@ram_id_empresa = 0)
						 )
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = doc.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_circuitocontable = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 4001
			                  and  rptarb_hojaid = fc.doc_id
										   ) 
			           )
			        or 
								 (@ram_id_documento = 0)
						 )
	
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 21 
			                  and  rptarb_hojaid = isnull(fci.ccos_id,fc.ccos_id)
										   ) 
			           )
			        or 
								 (@ram_id_centrocosto = 0)
						 )
	
	--//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	union all
	
	select
					mf.mf_id								as comp_id,
					mf.doct_id              as doct_id,

					mfi.mfi_id              as orden_aux_id,
	
					'Movimiento de Fondos'  as Tipo,
	
					''											as Proveedor,
					mf_fecha								as Fecha,
					mf_fecha       					as [Fecha Enrega],
					mf_nrodoc								as Comprobante,
					'#'+cue_codigo					as Codigo,
					'#'+cue_codigo					as [Grupo Cuenta],
					'#'+cue_codigo					as [Codigo Producto],
					cue_nombre							as Producto,
					isnull(ccosmfi.ccos_codigo,ccosmf.ccos_codigo) as [Codigo Costo],
					isnull(ccosmfi.ccos_nombre,ccosmf.ccos_nombre) as [Centro Costo],
					mfi_importe 						as Neto,
					0 											as IVA,
					mfi_importe 						as Total,
					''											as Pagos,
					'19000101'							as [Pago Fecha],
					''											as [Orden de Pago],
					0												as [Pago Total],
					0												as [Varios Pagos]
	
	from MovimientoFondo mf inner join MovimientoFondoItem mfi on mf.mf_id = mfi.mf_id
												  left  join centrocosto ccosmf on mf.ccos_id = ccosmf.ccos_id
												  left  join centrocosto ccosmfi on mfi.ccos_id = ccosmfi.ccos_id
												  left  join cuenta cue on mfi.cue_id_debe = cue.cue_id
													left  join documento doc on mf.doc_id = doc.doc_id

	where mf.est_id <> 7
	
						and mf_fecha >= @@Fini
						and	mf_fecha <= @@Ffin 
			
			-- Validar usuario - empresa
						and (
									exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (doc.emp_id  	= @emp_id 	or @emp_id	=0)
			and   (doc.cico_id 	= @cico_id  or @cico_id =0)
			and   (mf.doc_id 		= @doc_id 	or @doc_id	=0)
			and   (isnull(mfi.ccos_id,mf.ccos_id) = @ccos_id or @ccos_id=0)
			
			-- Arboles
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 17 
			                  and  rptarb_hojaid = cue.cue_id
										   ) 
			           )
			        or 
								 (@ram_id_cuenta = 0)
						 )
					
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1018 
			                  and  rptarb_hojaid = doc.emp_id
										   ) 
			           )
			        or 
								 (@ram_id_empresa = 0)
						 )
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = doc.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_circuitocontable = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 4001
			                  and  rptarb_hojaid = mf.doc_id
										   ) 
			           )
			        or 
								 (@ram_id_documento = 0)
						 )
	
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 21 
			                  and  rptarb_hojaid = isnull(mf.ccos_id,mf.ccos_id)
										   ) 
			           )
			        or 
								 (@ram_id_centrocosto = 0)
						 )
	
	--//////////////////////////////////////////////////////////////////////////////////////////////////////
	
	union all
	
	select
					mf.mf_id								as comp_id,
					mf.doct_id              as doct_id,

					mfi.mfi_id              as orden_aux_id,
	
					'Movimiento de Fondos'  as Tipo,
	
					''											as Proveedor,
					mf_fecha								as Fecha,
					mf_fecha       					as [Fecha Enrega],
					mf_nrodoc								as Comprobante,
					'#'+cue_codigo					as Codigo,
					'#'+cue_codigo					as [Grupo Cuenta],
					'#'+cue_codigo					as [Codigo Producto],
					cue_nombre							as Producto,
					isnull(ccosmfi.ccos_codigo,ccosmf.ccos_codigo) as [Codigo Costo],
					isnull(ccosmfi.ccos_nombre,ccosmf.ccos_nombre) as [Centro Costo],
					-mfi_importe 						as Neto,
					0 											as IVA,
					-mfi_importe 						as Total,
					''											as Pagos,
					'19000101'							as [Pago Fecha],
					''											as [Orden de Pago],
					0												as [Pago Total],
					0												as [Varios Pagos]
	
	from MovimientoFondo mf inner join MovimientoFondoItem mfi on mf.mf_id = mfi.mf_id
												  left  join centrocosto ccosmf on mf.ccos_id = ccosmf.ccos_id
												  left  join centrocosto ccosmfi on mfi.ccos_id = ccosmfi.ccos_id
												  left  join cuenta cue on mfi.cue_id_haber = cue.cue_id
													left  join documento doc on mf.doc_id = doc.doc_id
	
	where mf.est_id <> 7
	
						and mf_fecha >= @@Fini
						and	mf_fecha <= @@Ffin 
			
			-- Validar usuario - empresa
						and (
									exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
								)
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (doc.emp_id  	= @emp_id 	or @emp_id	=0)
			and   (doc.cico_id 	= @cico_id  or @cico_id =0)
			and   (mf.doc_id 		= @doc_id 	or @doc_id	=0)
			and   (isnull(mfi.ccos_id,mf.ccos_id) = @ccos_id or @ccos_id=0)
			
			-- Arboles
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 17 
			                  and  rptarb_hojaid = cue.cue_id
										   ) 
			           )
			        or 
								 (@ram_id_cuenta = 0)
						 )
					
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1018 
			                  and  rptarb_hojaid = doc.emp_id
										   ) 
			           )
			        or 
								 (@ram_id_empresa = 0)
						 )
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1016 
			                  and  rptarb_hojaid = doc.cico_id
										   ) 
			           )
			        or 
								 (@ram_id_circuitocontable = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 4001
			                  and  rptarb_hojaid = mf.doc_id
										   ) 
			           )
			        or 
								 (@ram_id_documento = 0)
						 )
	
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 21 
			                  and  rptarb_hojaid = isnull(mf.ccos_id,mf.ccos_id)
										   ) 
			           )
			        or 
								 (@ram_id_centrocosto = 0)
						 )
	
	
	order by Tipo, Comprobante, orden_aux_id

	drop table #t_pagos

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

