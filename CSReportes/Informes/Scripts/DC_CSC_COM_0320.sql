/*---------------------------------------------------------------------
Nombre: Imputacion Contable de Comprobantes de Compra por Cuenta
---------------------------------------------------------------------*/

-- Presenta todas las facturas y ordenes de pago y su aplicacion 
-- contra la cuenta de proveedores

/*
	Para testear:

	[DC_CSC_COM_0320] 1,'20080101 00:00:00','20081231 00:00:00','0','0','0','N84953','0',0

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0320]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0320]

go
create procedure [dbo].[DC_CSC_COM_0320] (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@prov_id  			varchar(255),
	@@suc_id   			varchar(255),
	@@cue_id	 			varchar(255), 
	@@cico_id				varchar(255),
	@@emp_id   			varchar(255),
	@@minimo        decimal(18,6)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id  int
declare @suc_id   int
declare @cue_id   int
declare @cico_id  int
declare @emp_id   int 

declare @ram_id_Proveedor int
declare @ram_id_Sucursal 	int
declare @ram_id_Cuenta 		int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id,  @suc_id out,  @ram_id_Sucursal out
exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_Cuenta out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
	end else 
		set @ram_id_Proveedor = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cuenta, @clienteID 
	end else 
		set @ram_id_Cuenta = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


/*- ///////////////////////////////////////////////////////////////////////

ANALISIS DE LOS COMPROBANTES

/////////////////////////////////////////////////////////////////////// */

	create table #t_facturas (fc_id int, cue_id int, asi_debe decimal(18,6), asi_haber decimal(18,6))

	create table #t_facturas_saldo (fc_id int, saldo decimal(18,6))

	insert into #t_facturas (fc_id, cue_id, asi_debe, asi_haber)
	
	select fc_id, asi.cue_id, asi_debe, asi_haber

	from FacturaCompra fc inner join Documento doc 		on fc.doc_id 	= doc.doc_id
												inner join AsientoItem asi 	on fc.as_id 	= asi.as_id
												inner join Cuenta cue 			on 		 asi.cue_id = cue.cue_id
																											 and cue.cuec_id = 8
	where
						  fc_fecha >= @@Fini
					and	fc_fecha <= @@Ffin 		
		
					and fc.est_id <> 7

					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)

		/* -///////////////////////////////////////////////////////////////////////
		
		PARA PODER FILTRAR POR UNA CUENTA
		
		/////////////////////////////////////////////////////////////////////// */

				and (asi.cue_id = @cue_id or @cue_id=0)
				and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = asi.cue_id)) or (@ram_id_Cuenta = 0))

		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fc.prov_id 	= @prov_id 	or @prov_id	=0)
		and   (fc.suc_id  	= @suc_id  	or @suc_id 	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id  	or @emp_id 	=0) 
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 29 
		                  and  rptarb_hojaid = fc.prov_id
									   ) 
		           )
		        or 
							 (@ram_id_Proveedor = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1007 
		                  and  rptarb_hojaid = fc.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_Sucursal = 0)
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
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = doc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )


	insert into #t_facturas_saldo (fc_id, saldo)

	select fc_id, sum(asi_debe-asi_haber)
	from #t_facturas
	group by fc_id

-----------------------------------------------------------------------------

	create table #t_ordenespago (opg_id int, cue_id int, asi_debe decimal(18,6), asi_haber decimal(18,6))

	create table #t_ordenespago_saldo (opg_id int, saldo decimal(18,6))

	insert into #t_ordenespago (opg_id, cue_id, asi_debe, asi_haber)
	
	select opg_id, asi.cue_id, asi_debe, asi_haber

	from OrdenPago opg  inner join Documento doc 		on opg.doc_id 	= doc.doc_id
											inner join AsientoItem asi 	on opg.as_id 		= asi.as_id
											inner join Cuenta cue 			on 		 asi.cue_id  = cue.cue_id
																										 and cue.cuec_id = 8
	where
						  opg_fecha >= @@Fini
					and	opg_fecha <= @@Ffin 		
		
					and opg.est_id <> 7

					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)

		/* -///////////////////////////////////////////////////////////////////////
		
		PARA PODER FILTRAR POR UNA CUENTA
		
		/////////////////////////////////////////////////////////////////////// */

				and (asi.cue_id = @cue_id or @cue_id=0)
				and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = asi.cue_id)) or (@ram_id_Cuenta = 0))

		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (opg.prov_id 	= @prov_id 	or @prov_id	=0)
		and   (opg.suc_id  	= @suc_id  	or @suc_id 	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id  	or @emp_id 	=0) 
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 29 
		                  and  rptarb_hojaid = opg.prov_id
									   ) 
		           )
		        or 
							 (@ram_id_Proveedor = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1007 
		                  and  rptarb_hojaid = opg.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_Sucursal = 0)
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
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = doc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )


	insert into #t_ordenespago_saldo (opg_id, saldo)

	select opg_id, sum(asi_debe-asi_haber)
	from #t_ordenespago
	group by opg_id

/*- ///////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

	select fc.doct_id			as doct_id,
				 fc.fc_id				as comp_id, 

				 fc.fc_id    		as [ID Cliente],
				 fc.doct_id		  as [DOCTID Cliente],
				 
				 cico_nombre    as Circuito,
				 doct_nombre    as [Tipo Documento],
				 doc_nombre			as Documento,
				 fc_fecha  			as Fecha,
				 fc_nrodoc 			as Comprobante,
				 prov_nombre    as Proveedor,
				 case when fc.doct_id = 8 then -fc_total else fc_total end
								  			as Total,
				 cue_nombre			as Cuenta,
				 asi_debe				as Debe,
				 asi_haber      as Haber,

				 asi_debe-asi_haber
												as Saldo,

				 (  (case when fc.doct_id = 8 then -fc_total else fc_total end) 
					+ saldo
					)							as Diferencia

	from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
												inner join DocumentoTipo doct on doc.doct_id = doct.doct_id
												inner join Proveedor prov on fc.prov_id = prov.prov_id
												left join #t_facturas t on fc.fc_id = t.fc_id
												left join Cuenta cue on t.cue_id = cue.cue_id
												left join #t_facturas_saldo t2 on fc.fc_id = t2.fc_id
												left join CircuitoContable cico on doc.cico_id = cico.cico_id
	where
						  fc_fecha >= @@Fini
					and	fc_fecha <= @@Ffin 		
		
					and fc.est_id <> 7

					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)

		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fc.prov_id 	= @prov_id 	or @prov_id	=0)
		and   (fc.suc_id  	= @suc_id  	or @suc_id 	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id  	or @emp_id 	=0) 
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 29 
		                  and  rptarb_hojaid = fc.prov_id
									   ) 
		           )
		        or 
							 (@ram_id_Proveedor = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1007 
		                  and  rptarb_hojaid = fc.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_Sucursal = 0)
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
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = doc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )

------------------------------------------------------------------------------------------
union all
------------------------------------------------------------------------------------------

	select opg.doct_id			as doct_id,
				 opg.opg_id				as comp_id, 

				 opg.opg_id    	as [ID Cliente],
				 opg.doct_id		as [DOCTID Cliente],
				 
				 cico_nombre    as Circuito,
				 doct_nombre    as [Tipo Documento],
				 doc_nombre			as Documento,
				 opg_fecha  		as Fecha,
				 opg_nrodoc 		as Comprobante,
				 prov_nombre    as Proveedor,
				 case when nc.fc_id is null then -opg_total else opg_total end 		
												as Total,
				 cue_nombre			as Cuenta,
				 asi_debe				as Debe,
				 asi_haber      as Haber,

				 asi_debe-asi_haber
												as Saldo,

				 (  case when nc.fc_id is null then -opg_total else opg_total end
					+ saldo
					)							as Diferencia

	from OrdenPago opg 		inner join Documento doc on opg.doc_id = doc.doc_id
												inner join DocumentoTipo doct on doc.doct_id = doct.doct_id
												inner join Proveedor prov on opg.prov_id = prov.prov_id
												left join #t_ordenespago t on opg.opg_id = t.opg_id
												left join Cuenta cue on t.cue_id = cue.cue_id
												left join #t_ordenespago_saldo t2 on opg.opg_id = t2.opg_id
												left join FacturaCompra nc on opg.opg_id = nc.opg_id
																										and nc.doct_id = 8
												left join CircuitoContable cico on doc.cico_id = cico.cico_id
	where
						  opg_fecha >= @@Fini
					and	opg_fecha <= @@Ffin 		
		
					and opg.est_id <> 7

					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)

		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (opg.prov_id 	= @prov_id 	or @prov_id	=0)
		and   (opg.suc_id  	= @suc_id  	or @suc_id 	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id  	or @emp_id 	=0) 
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 29 
		                  and  rptarb_hojaid = opg.prov_id
									   ) 
		           )
		        or 
							 (@ram_id_Proveedor = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1007 
		                  and  rptarb_hojaid = opg.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_Sucursal = 0)
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
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = doc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )


order by cue_nombre

end
GO
