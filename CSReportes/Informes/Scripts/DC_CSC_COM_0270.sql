/*---------------------------------------------------------------------
Nombre: Cuenta Corriente de Compras
---------------------------------------------------------------------*/

/*
	Para testear:

	select * from proveedor where prov_nombre like '%argent%'

	[DC_CSC_COM_0270] 1,'20050101 00:00:00','20051231 00:00:00','0','0','0','1',-1,'2',3

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0270]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0270]

go
create procedure [dbo].[DC_CSC_COM_0270] (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@prov_id  			varchar(255),
	@@suc_id   			varchar(255),
	@@cue_id	 			varchar(255), 
	@@cico_id				varchar(255),
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

declare @cta_acreedor    tinyint set @cta_acreedor    = 2
declare @cta_acreedoropg tinyint set @cta_acreedoropg = 5

	-- Notas de credito por debito automatico
	-- y sus Ordenes de Pago 
	--
	create table #t_opg_da_ids (opg_id int)

	insert into #t_opg_da_ids (opg_id)

		select opg.opg_id
		from OrdenPago opg inner join FacturaCompraOrdenPago fcopg 
																	on fcopg.opg_id = opg.opg_id
	
											 inner join FacturaCompra fc 
																	on 			fcopg.fc_id = fc.fc_id
																			and fc.doct_id = 8 

											 inner join Documento doc 
																	on opg.doc_id = doc.doc_id
		where 
						  opg_fecha <= @@Ffin
		
					and opg.est_id <> 7
		
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (opg.prov_id  = @prov_id  or @prov_id =0)
		and   (opg.suc_id   = @suc_id   or @suc_id  =0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (exists(select * from OrdenPagoItem where opg_id 			= opg.opg_id 
																								and opgi_tipo 	= @cta_acreedoropg
																								and cue_id 			= @cue_id   
									)
						or @cue_id  =0
					)
		and   (doc.emp_id = @emp_id or @emp_id  =0) 
		
		-- Arboles
		and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 29 and  rptarb_hojaid = opg.prov_id)) or (@ram_id_Proveedor = 0))
		and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1007 and  rptarb_hojaid = opg.suc_id)) or (@ram_id_Sucursal = 0))
		and   ((exists(select rptarb_hojaid from rptArbolRamaHoja 
									 where 	 rptarb_cliente = @clienteID 
											and  tbl_id = 17 
		                  and  (exists(select * from OrdenPagoItem 
																		where opg_id 			= opg.opg_id 
																			and opgi_tipo 	= @cta_acreedoropg
																			and cue_id 			= rptarb_hojaid   
																	)
									   				) 
											)
		           )
		        or (@ram_id_Cuenta = 0))
		and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and  rptarb_hojaid = doc.cico_id)) or (@ram_id_circuitocontable = 0))
		and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))	

--/////////////////////////////////////////////////////////////////////////
--
--	Saldos Iniciales
--
--/////////////////////////////////////////////////////////////////////////

create table #t_dc_csc_com_0270 (

	prov_id			int not null,
  cue_id      int null,
  emp_id      int not null,
  suc_id      int not null,
	debe        decimal(18,6) not null default(0),
	haber       decimal(18,6) not null default(0)
)
--/////////////////////////////////////////////////////////////////////////

--//////////////////////////////////////////
-- Ordenes de Pago
--//////////////////////////////////////////


		insert into #t_dc_csc_com_0270 (prov_id,cue_id,emp_id,suc_id,debe,haber)
		
		select 
		
						prov_id,
						(select min(cue_id) from OrdenPagoItem where opg_id = opg.opg_id and opgi_tipo = 5),
		        doc.emp_id,
		        suc_id,
						case when t.opg_id is null then opg_total else -opg_total end,
						0
		
		from 
		
			OrdenPago opg inner join Documento doc on opg.doc_id = doc.doc_id
										left  join #t_opg_da_ids t on opg.opg_id = t.opg_id	
		
		where 
						  opg_fecha < @@Fini
		
					and opg.est_id <> 7
		
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (opg.prov_id  = @prov_id  or @prov_id =0)
		and   (opg.suc_id   = @suc_id   or @suc_id  =0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		
		and   (exists(
									select * from OrdenPagoItem where opg_id 			= opg.opg_id 
																								and opgi_tipo 	= @cta_acreedoropg
																								and cue_id 			= @cue_id   
									)
						or @cue_id  =0
					)
		
		and   (doc.emp_id   = @emp_id   or @emp_id  =0) 
		
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
		                  and  tbl_id = 17 
		                  and  (
														exists(
																	select * from OrdenPagoItem where opg_id 			= opg.opg_id 
																																and opgi_tipo 	= @cta_acreedoropg
																																and cue_id 			= rptarb_hojaid   
																	)
									   				) 
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

--//////////////////////////////////////////
-- Facturas y Notas de Credito
--//////////////////////////////////////////

		insert into #t_dc_csc_com_0270 (prov_id,cue_id,emp_id,suc_id,debe,haber)
		
		select 
						prov_id,
						cue_id,
		        doc.emp_id,
		        suc_id,
										
			      case fc.doct_id 
							when 8	then	 	 fc_total      
							else						 0
						end
													 as debe,

			      case fc.doct_id 
							when 8	then	   0      
							else						 fc_total
						end
													 as haber
		
		from 
		
			FacturaCompra fc inner join Documento doc                          on fc.doc_id    = doc.doc_id
		                   left  join AsientoItem ai                         on fc.as_id     = ai.as_id and asi_tipo = @cta_acreedor
		                  
		where 
		
						  fc_fecha <  @@Fini
					and fc.est_id <> 7
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (fc.prov_id 	= @prov_id 	or @prov_id	=0)
		and   (fc.suc_id 		= @suc_id 	or @suc_id	=0)
		and   (ai.cue_id 		= @cue_id 	or @cue_id	=0)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id 	or @emp_id	=0) 
		
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

--/////////////////////////////////////////////////////////////////////////
		
		--/////////////////////////////////////
		-- Saldos iniciales
		--/////////////////////////////////////
		select 
		
						0        					 as doct_id,
						0       					 as comp_id,
			      0                  as nOrden_id,
						'Saldo Inicial'		 as Documento,
						@@Fini             as [Fecha],
						''                 as [Numero],
						'Saldo inicial'    as [Comprobante],

						prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
											         as [Proveedor],
						prov_nombre,

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
		
						sum(debe)				 	 as [Debe],
						sum(haber)			 	 as [Haber],
		
						''                 as [Moneda],
						''                 as [Estado],
						cue_nombre         as [Cuenta],
		        ''                 as [Documento],
		        emp_nombre         as [Empresa], 
		        suc_nombre         as [Sucursal],
		        ''                 as [Cond. Pago],
		        ''                 as [Legajo],
		        ''                 as [Centro de Costo],
						''                 as [Observaciones]
		
		from 
		
			#t_dc_csc_com_0270 fc 
											inner join Proveedor prov 												on fc.prov_id 	= prov.prov_id
		                  inner join Empresa emp                            on fc.emp_id    = emp.emp_id 
		                  inner join Sucursal suc                           on fc.suc_id    = suc.suc_id
		                  left  join Cuenta cue                             on fc.cue_id    = cue.cue_id

		group by 

						fc.prov_id,		

						prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel,
						prov_nombre,

						prov_calle + ' ' + 
						prov_callenumero + ' ' + 
						prov_piso + ' ' + 
						prov_codpostal + ' ' + 
						prov_localidad,

						'Tel: ' + 
						prov_tel  + ' | Fax:' + 
						prov_fax  + ' | Email: ' + 
						prov_email  + ' | Web:' + 
						prov_web,

						cue_nombre,
		        suc_nombre,
		        emp_nombre

		union all
		
		--/////////////////////////////////////
		--	Facturas, Notas de Credio/Debito
		--/////////////////////////////////////
		
		select 
						fc.doct_id         as doct_id,
						fc.fc_id					 as comp_id,
		        1                  as nOrden_id,
						doc_nombre				 as Documento,
						fc_fecha           as [Fecha],
						fc_numero          as [Numero],
						fc_nrodoc          as [Comprobante],

						prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
											         as [Proveedor],

						prov_nombre,

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
							when 8 then	fc_total           
							else        0
						end 			 as [Debe],

						case fc.doct_id 
							when 8 then		0
							else          fc_total
						end 			 as [Haber],

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
		
		--/////////////////////////////////////
		--	Ordenes de Pago
		--/////////////////////////////////////
		
		union all
		
		select 
						opg.doct_id        as doct_id,
						opg.opg_id				 as comp_id,
		        1                  as nOrden_id,
						doc_nombre				 as Documento,
						opg_fecha          as [Fecha],
						opg_numero         as [Numero],
						opg_nrodoc         as [Comprobante],

						prov_nombre + ' -RZ: ' + prov_razonsocial + ' -CUIT: ' + prov_cuit + ' -TE: ' + prov_tel
											         as [Proveedor],

						prov_nombre,

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

						case when t.opg_id is null then opg_total else 0 end as [Debe],
						case when t.opg_id is null then 0 else opg_total end as [Haber],
		
						''                 as [Moneda],
						est_nombre         as [Estado],
						(select min(cue_nombre) 
						 from OrdenPagoItem opgi inner join cuenta cue on opgi.cue_id = cue.cue_id
						 where opg_id = opg.opg_id and opgi_tipo = 5)
							                 as [Cuenta],
		        doc_nombre         as [Documento],
		        emp_nombre         as Empresa, 
		        suc_nombre         as [Sucursal],
		        ''                 as [Cond. Pago],
		        case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
		        ccos_nombre        as [Centro de Costo],		            
						opg_descrip        as [Observaciones]
		
		from 
		
			OrdenPago opg    inner join Proveedor prov 												on opg.prov_id 	= prov.prov_id
		                   inner join Estado est                            on opg.est_id   = est.est_id
		                   inner join Documento doc                         on opg.doc_id   = doc.doc_id
		                   inner join Empresa emp                           on doc.emp_id   = emp.emp_id 
		                   inner join Sucursal suc                          on opg.suc_id   = suc.suc_id
		                   left  join Legajo lgj                            on opg.lgj_id   = lgj.lgj_id
		                   left  join CentroCosto ccos                      on opg.ccos_id  = ccos.ccos_id
											 left  join #t_opg_da_ids t 											on opg.opg_id 	= t.opg_id
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
		and   (opg.suc_id 	= @suc_id 	or @suc_id	=0)
		and   (exists(
									select * from OrdenPagoItem where opg_id 			= opg.opg_id 
																								and opgi_tipo 	= @cta_acreedoropg
																								and cue_id      = @cue_id   
									)
						or @cue_id  =0
					)
		and   (doc.cico_id  = @cico_id  or @cico_id =0)
		and   (doc.emp_id 	= @emp_id 	or @emp_id	=0) 
		
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
		                  and  tbl_id = 17 
		                  and  (
														exists(
																	select * from OrdenPagoItem where opg_id 			= opg.opg_id 
																																and opgi_tipo 	= @cta_acreedoropg
																																and cue_id      = rptarb_hojaid   
																	)
									   				) 
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
		
			order by Proveedor, Cuenta, Fecha, nOrden_id
	
end

GO