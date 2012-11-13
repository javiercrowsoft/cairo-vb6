/*---------------------------------------------------------------------
Nombre: Facturas a Pagar
---------------------------------------------------------------------*/

/*
Para testear:

select * from proveedor where prov_nombre like '%argent%'

[DC_CSC_COM_0310] 1,'20050101 00:00:00','20071231 00:00:00','0','0','0',1,'0',0

DC_CSC_COM_0310 
										1,
										@@Fini,
										@@Fini,
										'0',
										'0',
										'0',
										1,
                    '2',
										2


 [DC_CSC_COM_0310] 1,'20050101 00:00:00','20151231 00:00:00','0','0','0','0','0',-1,'0'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0310]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0310]

go
create procedure [dbo].[DC_CSC_COM_0310] (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@prov_id  			varchar(255),
	@@suc_id   			varchar(255),
	@@cue_id	 			varchar(255), 
	@@cico_id				varchar(255),
  @@ccos_id	   		varchar(255),
  @@cpg_id	 			varchar(255),

	@@soloDeudores  smallint,
	@@emp_id   			varchar(255)

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
declare @ccos_id	int
declare @cpg_id	  int

declare @ram_id_Proveedor int
declare @ram_id_Sucursal 	int
declare @ram_id_Cuenta 		int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 
declare @ram_id_centroCosto int
declare @ram_id_condicionPago int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id,  @suc_id out,  @ram_id_Sucursal out
exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_Cuenta out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centroCosto out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 
exec sp_ArbConvertId @@cpg_id, 	@cpg_id out, 	@ram_id_condicionPago out

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

if @ram_id_centroCosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_centroCosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_centroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_centroCosto, @clienteID 
	end else 
		set @ram_id_centroCosto = 0
end

if @ram_id_condicionPago <> 0 begin

--	exec sp_ArbGetGroups @ram_id_condicionPago, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_condicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_condicionPago, @clienteID 
	end else 
		set @ram_id_condicionPago = 0
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

declare @cta_acreedor    tinyint set @cta_acreedor    = 2
declare @cta_acreedoropg tinyint set @cta_acreedoropg = 5

		--/////////////////////////////////////
		--	Facturas, Notas de Credio/Debito
		--/////////////////////////////////////
		
		select 
		        1                  as grp_total,
						fc.doct_id         as doct_id,
						fc.fc_id					 as comp_id,
		        1                  as nOrden_id,
						doc_nombre				 as Documento,
						fc_fecha           as [Fecha],
						fc_numero          as [Numero],
						fc_nrodoc          as [Comprobante],
						prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
											         as [Proveedor],
		
						case fc.doct_id 
							when 8 then -fci_neto            
							else				 fci_neto
						end 							 as [Neto],
				
						case fc.doct_id 
							when 8 then	- (fci_ivari + fci_ivarni)
							else           fci_ivari + fci_ivarni 
						end 			 as [Iva],
		
						case fc.doct_id 
							when 8 then	-	fci_importe
							else          fci_importe
						end 			 as [Total],
		
						mon_nombre         as [Moneda],
						est_nombre         as [Estado],
						cue_nombre         as [Cuenta],
		        doc_nombre         as [Documento],
		        emp_nombre         as Empresa, 
		        suc_nombre         as [Sucursal],
		        cpg_nombre         as [Cond. Pago],
		        case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
		        ccos_nombre        as [Centro de Costo],
		
		            
						fc_descrip         as [Observaciones]
		
		from 
		
			FacturaCompra fc inner join Proveedor prov 												on fc.prov_id 	= prov.prov_id
											 left  join FacturaCompraItem fci                 on fc.fc_id     = fci.fc_id

		                   left  join AsientoItem ai 												on fc.as_id 		= ai.as_id and asi_tipo = @cta_acreedor
		                   left  join Cuenta cue                            on ai.cue_id    = cue.cue_id
		                   inner join Moneda mon                            on fc.mon_id    = mon.mon_id
		                   inner join Estado est                            on fc.est_id    = est.est_id
		                   inner join Documento doc                         on fc.doc_id    = doc.doc_id
		                   inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
		                   inner join Sucursal suc                          on fc.suc_id    = suc.suc_id
		                   left  join Legajo lgj                            on fc.lgj_id    = lgj.lgj_id
		                   inner join CondicionPago cpg                     on fc.cpg_id    = cpg.cpg_id
		                   left  join CentroCosto ccos                      on isnull(fci.ccos_id,fc.ccos_id) = ccos.ccos_id
		where 
		
						  fc_fecha >= @@Fini
					and	fc_fecha <= @@Ffin 		
		
					and fc.est_id <> 7

					and (abs(fc_pendiente)>0.01 or @@soloDeudores = 0)
		
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fc.prov_id 	= @prov_id 	or @prov_id	=0)
		and   (fc.suc_id  	= @suc_id  	or @suc_id 	=0)
		and   (fc.cpg_id 		= @cpg_id 	or @cpg_id	=0)
		and   (ai.cue_id  	= @cue_id  	or @cue_id 	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id  	or @emp_id 	=0) 
		and   (isnull(fci.ccos_id,fc.ccos_id) = @ccos_id or @ccos_id =0)
		
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
		                  and  tbl_id = 17 
		                  and  rptarb_hojaid = ai.cue_id
									   ) 
		           )
		        or 
							 (@ram_id_Cuenta = 0)
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

		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 21 
		                  and  isnull(fci.ccos_id,fc.ccos_id) = rptarb_hojaid
									   ) 
		           )
		        or 
							 (@ram_id_centroCosto = 0)
					 )

		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1005 
		                  and  rptarb_hojaid = fc.cpg_id
									   ) 
		           )
		        or 
							 (@ram_id_condicionPago = 0)
					 )
		
		
			order by Proveedor, Cuenta, Fecha, nOrden_id

end

GO