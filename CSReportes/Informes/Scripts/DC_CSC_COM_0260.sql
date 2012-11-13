/*---------------------------------------------------------------------
Nombre: Proveedores con Facturas de Compra Superiores a X Monto
---------------------------------------------------------------------*/

/*
Para testear:


 [DC_CSC_COM_0260] 1,'20070101','20071231','0','0','0','0','1',30000,0,1


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0260]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0260]

go
create procedure [dbo].[DC_CSC_COM_0260] (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@prov_id  			varchar(255),
	@@suc_id   			varchar(255),
	@@cue_id	 			varchar(255), 
	@@cico_id				varchar(255),
	@@emp_id   			varchar(255),
	@@importeminimo	decimal(18,6),
	@@nc            tinyint, -- Notas de credito
	@@detallado     tinyint

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cta_acreedor    tinyint set @cta_acreedor    = 2
declare @cta_acreedoropg tinyint set @cta_acreedoropg = 5


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

		
		--/////////////////////////////////////
		--	Facturas, Notas de Credio/Debito
		--/////////////////////////////////////
		
		select 
						fc.doct_id         as doct_id,
						fc.fc_id					 as comp_id,
						doc_nombre				 as Documento,
						fc_fecha           as [Fecha],
						fc_numero          as [Numero],
						fc_nrodoc          as [Comprobante],
						prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
											         as [Proveedor],

						prov_calle + ' ' + 
						prov_callenumero + ' ' + 
						prov_piso + ' ' + 
						prov_codpostal + ' ' + 
						prov_localidad 		 as prov_direccion,

						'Tel: ' + 
						prov_tel  + ' | Fax:' + 
						prov_fax  + ' | Email: ' + 
						prov_email  + ' | Web:' + 
						prov_web					 as prov_telefono,
		
						case fc.doct_id 
							when 8 then -fc_neto            
							else				 fc_neto
						end 							 as [Neto],
		
						case fc.doct_id 
							when 8 then -(	fc_importedesc1 
														+ fc_importedesc2  
														)
							else						fc_importedesc1 
														+ fc_importedesc2
						end				 as [Descuento],
		
						case fc.doct_id 
							when 8 then		-fc_subtotal        
							else           fc_subtotal
						end 			 as [Sub Total],
		
						case fc.doct_id 
							when 8 then	- (fc_ivari + fc_ivarni)
							else           fc_ivari + fc_ivarni 
						end 			 as [Iva],
		
						case fc.doct_id 
							when 8 then	-	fc_total           
							else          fc_total
						end 			 as [Total],

						case
			
							when fc_totalcomercial = 0 
							 and fc_fechavto < getdate()
							 and fc_fechavto < @@Ffin			
							 and fc.doct_id = 8						then 	-fc_total
				
							when fc_totalcomercial = 0 
							 and fc_fechavto < getdate()
							 and fc_fechavto < @@Ffin			
							 and fc.doct_id <> 8					then 	fc_total

							else										 						0
						end							as [Pagos],
		
						case fc.doct_id 
							when 8 then - fc_pendiente       
							else          fc_pendiente
						end        as [Pendiente],
		
						mon_nombre         as [Moneda],
						est_nombre         as [Estado],
						cue_nombre         as [Cuenta],
		        doc_nombre         as [Documento],
		        emp_nombre         as Empresa, 
		        suc_nombre         as [Sucursal],
		        cpg_nombre         as [Cond. Pago],
		        case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
		        ccos_nombre        as [Centro de Costo],
		        case 
								when fcd_fecha is not null then fcd_fecha
		            else                            fcp_fecha
		        end                as [Vto.],
		
						case fc.doct_id 
							when 8 then	- (IsNull(fcd_importe,fcp_importe))
							else           IsNull(fcd_importe,fcp_importe)
						end								 as [Vto. Importe],

						case 

							when fc_totalcomercial = 0 
							 and fc_fechavto < getdate()
							 and fc_fechavto < @@Ffin			then 	0
				
							when fc_totalcomercial = 0 
							 and (    fc_fechavto >= getdate()	
							       or fc_fechavto >= @@Ffin
										)
								and fc.doct_id = 8					then 	-fc_total
		
							when fc_totalcomercial = 0 
							 and (    fc_fechavto >= getdate()	
							       or fc_fechavto >= @@Ffin
										)
								and fc.doct_id <> 8					then 	fc_total
				
							when fc.doct_id= 8 						then	- (IsNull(fcd_pendiente,0))
							else					 												 IsNull(fcd_pendiente,0)
		        end                as [Vto. Pendiente],
		            
						fc_descrip         as [Observaciones]
		
		from 
		
			FacturaCompra fc inner join Proveedor prov 												on fc.prov_id 	= prov.prov_id
		                   left  join FacturaCompraDeuda fcd 								on fc.fc_id  		= fcd.fc_id
		                   left  join FacturaCompraPago fcp 								on fc.fc_id  		= fcp.fc_id
		                   left  join AsientoItem ai 												on fc.as_id 		= ai.as_id and asi_tipo = @cta_acreedor
		                   left  join Cuenta cue                            on ai.cue_id    = cue.cue_id
		                   inner join Moneda mon                            on fc.mon_id    = mon.mon_id
		                   inner join Estado est                            on fc.est_id    = est.est_id
		                   inner join Documento doc                         on fc.doc_id    = doc.doc_id
		                   inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
		                   inner join Sucursal suc                          on fc.suc_id    = suc.suc_id
		                   left  join Legajo lgj                            on fc.lgj_id    = lgj.lgj_id
		                   inner join CondicionPago cpg                     on fc.cpg_id    = cpg.cpg_id
		                   left  join CentroCosto ccos                      on fc.ccos_id   = ccos.ccos_id
		where 
		
						  fc_fecha >= @@Fini
					and	fc_fecha <= @@Ffin 		
		
					and fc.est_id <> 7

					and fc_total >= @@importeminimo

					and (fc.doct_id <> 8 or @@nc <> 0)
		
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fc.prov_id 	= @prov_id 	or @prov_id	=0)
		and   (fc.suc_id  	= @suc_id  	or @suc_id 	=0)
		and   (ai.cue_id  	= @cue_id  	or @cue_id 	=0)
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

	order by [Proveedor], [Cuenta]

end

GO