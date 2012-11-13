/*---------------------------------------------------------------------
Nombre: Clientees con Facturas de Venta Superiores a X Monto
---------------------------------------------------------------------*/

/*
Para testear:


 [DC_CSC_VEN_0910] 1,'20070101','20071231','0','0','0','0','1',30000,0,1


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0910]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0910]

go
create procedure [dbo].[DC_CSC_VEN_0910] (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cli_id  			varchar(255),
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

declare @cta_deudor     tinyint set @cta_deudor     = 1
declare @cta_deudorcobz tinyint set @cta_deudorcobz = 5

declare @cli_id  int
declare @suc_id   int
declare @cue_id   int
declare @cico_id  int
declare @emp_id   int 

declare @ram_id_Cliente int
declare @ram_id_Sucursal 	int
declare @ram_id_Cuenta 		int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@suc_id,  @suc_id out,  @ram_id_Sucursal out
exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_Cuenta out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
	end else 
		set @ram_id_Cliente = 0
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
						fv.doct_id         as doct_id,
						fv.fv_id					 as comp_id,
						doc_nombre				 as Documento,
						fv_fecha           as [Fecha],
						fv_numero          as [Numero],
						fv_nrodoc          as [Comprobante],
						cli_nombre + ' -RZ: ' + cli_razonsocial + ' -CUIT: ' + cli_cuit + ' -TE: ' + cli_tel
											         as [Cliente],

						cli_calle + ' ' + 
						cli_callenumero + ' ' + 
						cli_piso + ' ' + 
						cli_codpostal + ' ' + 
						cli_localidad 		 as cli_direccion,

						'Tel: ' + 
						cli_tel  + ' | Fax:' + 
						cli_fax  + ' | Email: ' + 
						cli_email  + ' | Web:' + 
						cli_web					 as cli_telefono,
		
						case fv.doct_id 
							when 7 then -fv_neto            
							else				 fv_neto
						end 							 as [Neto],
		
						case fv.doct_id 
							when 7 then -(	fv_importedesc1 
														+ fv_importedesc2  
														)
							else						fv_importedesc1 
														+ fv_importedesc2
						end				 as [Descuento],
		
						case fv.doct_id 
							when 7 then		-fv_subtotal        
							else           fv_subtotal
						end 			 as [Sub Total],
		
						case fv.doct_id 
							when 7 then	- (fv_ivari + fv_ivarni)
							else           fv_ivari + fv_ivarni 
						end 			 as [Iva],
		
						case fv.doct_id 
							when 7 then	-	fv_total           
							else          fv_total
						end 			 as [Total],

						case
			
							when fv_totalcomercial = 0 
							 and fv_fechavto < getdate()
							 and fv_fechavto < @@Ffin			
							 and fv.doct_id = 7						then 	-fv_total
				
							when fv_totalcomercial = 0 
							 and fv_fechavto < getdate()
							 and fv_fechavto < @@Ffin			
							 and fv.doct_id <> 7					then 	fv_total

							else										 						0
						end							as [Pagos],
		
						case fv.doct_id 
							when 7 then - fv_pendiente       
							else          fv_pendiente
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
								when fvd_fecha is not null then fvd_fecha
		            else                            fvp_fecha
		        end                as [Vto.],
		
						case fv.doct_id 
							when 7 then	- (IsNull(fvd_importe,fvp_importe))
							else           IsNull(fvd_importe,fvp_importe)
						end								 as [Vto. Importe],

						case 

							when fv_totalcomercial = 0 
							 and fv_fechavto < getdate()
							 and fv_fechavto < @@Ffin			then 	0
				
							when fv_totalcomercial = 0 
							 and (    fv_fechavto >= getdate()	
							       or fv_fechavto >= @@Ffin
										)
								and fv.doct_id = 7					then 	-fv_total
		
							when fv_totalcomercial = 0 
							 and (    fv_fechavto >= getdate()	
							       or fv_fechavto >= @@Ffin
										)
								and fv.doct_id <> 7					then 	fv_total
				
							when fv.doct_id= 7 						then	- (IsNull(fvd_pendiente,0))
							else					 												 IsNull(fvd_pendiente,0)
		        end                as [Vto. Pendiente],
		            
						fv_descrip         as [Observaciones]
		
		from 
		
			FacturaVenta fv  inner join Cliente cli   											 	on fv.cli_id 	  = cli.cli_id
		                   left  join FacturaVentaDeuda fvd 								on fv.fv_id  		= fvd.fv_id
		                   left  join FacturaVentaPago fvp 								  on fv.fv_id  		= fvp.fv_id
		                   left  join AsientoItem ai 												on fv.as_id 		= ai.as_id and asi_tipo = @cta_deudor
		                   left  join Cuenta cue                            on ai.cue_id    = cue.cue_id
		                   inner join Moneda mon                            on fv.mon_id    = mon.mon_id
		                   inner join Estado est                            on fv.est_id    = est.est_id
		                   inner join Documento doc                         on fv.doc_id    = doc.doc_id
		                   inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
		                   inner join Sucursal suc                          on fv.suc_id    = suc.suc_id
		                   left  join Legajo lgj                            on fv.lgj_id    = lgj.lgj_id
		                   inner join CondicionPago cpg                     on fv.cpg_id    = cpg.cpg_id
		                   left  join CentroCosto ccos                      on fv.ccos_id   = ccos.ccos_id
		where 
		
						  fv_fecha >= @@Fini
					and	fv_fecha <= @@Ffin 		
		
					and fv.est_id <> 7

					and fv_total >= @@importeminimo

					and (fv.doct_id <> 7 or @@nc <> 0)
		
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fv.cli_id 	  = @cli_id 	or @cli_id	=0)
		and   (fv.suc_id  	= @suc_id  	or @suc_id 	=0)
		and   (ai.cue_id  	= @cue_id  	or @cue_id 	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id  	or @emp_id 	=0) 
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 28 
		                  and  rptarb_hojaid = fv.cli_id
									   ) 
		           )
		        or 
							 (@ram_id_Cliente = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1007 
		                  and  rptarb_hojaid = fv.suc_id
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

	order by [Cliente], [Cuenta]

end

GO