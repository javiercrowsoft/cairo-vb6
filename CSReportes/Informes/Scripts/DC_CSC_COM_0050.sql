/*---------------------------------------------------------------------
Nombre: Movimientos de Cuenta Corriente (Debe - Haber)
---------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0050]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0050]
GO

/*

	select * from proveedor where prov_nombre like '%acu%'

 [DC_CSC_COM_0050] 1,'20060501','20070430','69','0','1',0

*/
create procedure DC_CSC_COM_0050 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@prov_id           varchar(255),
@@suc_id            varchar(255),
@@emp_id            varchar(255),
@@con_saldo_cero    tinyint,

@@bSaldoInicial     tinyint

)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id 	int
declare @suc_id 	int
declare @emp_id   int

declare @ram_id_Proveedor int
declare @ram_id_Sucursal 	int
declare @ram_id_Empresa   int

declare @ClienteID 		int
declare @IsRaiz    		tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id, 	@suc_id out, 	@ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, 	@emp_id out, 	@ram_id_Empresa out

exec sp_GetRptId @ClienteID out

if @ram_id_Proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Proveedor, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Proveedor, @ClienteID 
	end else 
		set @ram_id_Proveedor = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @ClienteID 
	end else 
		set @ram_id_Sucursal = 0
end


if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @ClienteID 
	end else 
		set @ram_id_Empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

SALDOS INICIALES

/////////////////////////////////////////////////////////////////////// */

create table #Debito(
  prov_id               int not null,
  emp_id                int not null,
  debito_total          decimal(18,6) not null,
  debito_pendiente      decimal(18,6) not null
)

create table #Credito(
  prov_id               int not null,
  emp_id                int not null,
  credito_total         decimal(18,6) not null,
  credito_pendiente     decimal(18,6) not null
)

create table #CrdDeb (
  prov_id               int not null,
  emp_id                int not null,
  debito_total          decimal(18,6) not null,
  debito_pendiente      decimal(18,6) not null,
  credito_total         decimal(18,6) not null,
  credito_pendiente     decimal(18,6) not null
)


if @@bSaldoInicial <> 0 begin

	-----------------------------------------------------
	--
	--
	-- DEBITOS
	--
	--
	-----------------------------------------------------
	
						insert into #Credito (prov_id, emp_id, credito_total, credito_pendiente)
						
						select prov_id,
						       opg.emp_id,
						       sum(opg_total),
						       sum(opg_pendiente)
						from
						       OrdenPago opg
						
						where
										opg_fecha < @@Fini
	
								and	opg.est_id <> 7
						
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = opg.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (opg.prov_id = @prov_id or @prov_id=0)
								and (opg.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 29 and rptarb_hojaid = opg.prov_id)) or (@ram_id_Proveedor = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and rptarb_hojaid = opg.emp_id)) or (@ram_id_Empresa = 0))
								--
						
						group by
						          prov_id,
						          opg.emp_id
						
						----------------
						union
						----------------
						
						select prov_id,
						       doc.emp_id,
						       sum(fc_total),
						       sum(fc_pendiente)
						from
						       FacturaCompra nc inner join Documento doc on nc.doc_id = doc.doc_id
						
						where					
										fc_fecha < @@Fini
	
									and	nc.doct_id = 8 /* 8	Nota de Credito Compra */
	
									and nc.est_id <> 7
						
									-- Arboles
									--
									and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
									and (nc.prov_id = @prov_id or @prov_id=0)
									and (doc.emp_id = @emp_id or @emp_id=0)
									and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 29 and rptarb_hojaid = nc.prov_id)) or (@ram_id_Proveedor = 0))
									and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
									--
						
						group by
						          prov_id,
						          doc.emp_id
	
	-----------------------------------------------------
	--
	--
	-- CREDITOS
	--
	--
	-----------------------------------------------------
	
						insert into #Debito (prov_id, emp_id, debito_total, debito_pendiente)
						
						select prov_id,
						       doc.emp_id,
						       sum(fc_total),
						       sum(fc_pendiente)
						from
						       FacturaCompra nd inner join Documento doc on nd.doc_id = doc.doc_id
						
						where
	
										fc_fecha < @@Fini
	
									and	nd.doct_id = 10 /* 10	Nota de Debito Compra */
	
									and nd.est_id <> 7
						
									-- Arbol
									--
									and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
									and (nd.prov_id = @prov_id or @prov_id=0)
									and (doc.emp_id = @emp_id or @emp_id=0)
									and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 29 and rptarb_hojaid = nd.prov_id)) or (@ram_id_Proveedor = 0))
									and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
									--
						
						group by
						          prov_id,
						          doc.emp_id					
	
						----------------
						union
						----------------
	
						select prov_id,
									 doc.emp_id,
	
									 sum(
												case
									
													when fc_totalcomercial = 0 
													 and fc_fechavto < getdate()
													 and fc_fechavto < @@Ffin			then 	0
										
													when fc_totalcomercial = 0 
													 and (    fc_fechavto >= getdate()	
													       or fc_fechavto >= @@Ffin
																)    										then 	fc_total
										
													else 																fc_totalcomercial
												end
											),
	
									 sum(fc_pendiente)
						from 
									FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
	
						where 
	
								fc_fecha < @@Fini
	
						and fc.est_id <> 7
						and fc.doct_id = 2 -- Facturas de Compra
	
						-- Arbol
						--
						and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
						and (fc.prov_id = @prov_id or @prov_id=0)
	 					and (doc.emp_id = @emp_id or @emp_id=0)
	 					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 29 and rptarb_hojaid = fc.prov_id)) or (@ram_id_Proveedor = 0))
	 					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
						--
	
						group by
						          prov_id,
						          doc.emp_id
	
	-----------------------------------------------------
	--
	--
	-- DEBITOS Y CREDITOS
	--
	--
	-----------------------------------------------------
	
						insert into #CrdDeb (prov_id,emp_id,debito_total,debito_pendiente,credito_total,credito_pendiente)
						select prov_id,emp_id, sum(debito_total), sum(debito_pendiente),0,0 from #Debito group by prov_id,emp_id
						
						update #CrdDeb set 
						
						  credito_total      = IsNull(
																	 (select sum(c.credito_total) 
	                                  from #Credito c 
	                                  where #CrdDeb.prov_id = c.prov_id 
	                                    and #CrdDeb.emp_id = c.emp_id
																		group by prov_id,emp_id
																	 ),0),
						  credito_pendiente  = IsNull(
																	 (select sum(c.credito_pendiente)
	                                  from #Credito c 
	                                  where #CrdDeb.prov_id = c.prov_id 
	                                    and #CrdDeb.emp_id = c.emp_id
																		group by prov_id,emp_id
																	 ),0)					
	
						insert into #CrdDeb (prov_id,emp_id,debito_total,debito_pendiente,credito_total,credito_pendiente)
						select prov_id,emp_id,0,0, sum(credito_total), sum(credito_pendiente) from #Credito
						where not exists(select * from #CrdDeb where #CrdDeb.prov_id = #Credito.prov_id and #CrdDeb.emp_id = #Credito.emp_id)
						group by prov_id,emp_id

end

-----------------------------------------------------
--
--
-- SALDOS INICIALES
--
--
-----------------------------------------------------

					select 
					
						0         								 				as opg_id,
					  0                          				as fc_id,
						0																	as comp_id,
						0																	as doct_id,
						prov_nombre								 				as Proveedor,
					  emp_nombre                 				as [Empresa],
					  -Sum(IsNull(debito_total,0))    	as [OrdenPago/NC Total],
					
					  Sum(IsNull(debito_total,0))
					  -Sum(IsNull(debito_pendiente,0))	as [OrdenPago/NC Aplicado],
					  null                        			as [Fecha],
					  ''                          			as [Documento],
					  'Saldo Inicial'                   as [Comprobante],
						''																as [Factura],
					  ''                          			as [Numero],
					  ''                          			as [Moneda],
					
					  Sum(IsNull(credito_total,0))
					  -Sum(IsNull(debito_total,0))    	as [Saldo],
					
					
						Sum(IsNull(credito_total,0))    	as [Total],
					
					  Sum(IsNull(credito_total,0))
					  -Sum(IsNull(credito_pendiente,0))	as [Aplicado],
					  ''                           			as [Legajo],
					
					
						Sum(IsNull(credito_total,0)) 
					  -Sum(round(IsNull(debito_total,0),2))     	as [Total2],
					
					  -1                       					as Orden
					  
					
					from
					
					    Proveedor prov       left join #CrdDeb cd          on prov.prov_id = cd.prov_id
					                         left join Empresa e           on cd.emp_id  = e.emp_id
					
					where 
					
					          ( IsNull(credito_total,0) <> 0 or IsNull(debito_total,0) <> 0 or @@con_saldo_cero <> 0)
					
					group by
					
					          e.emp_id, emp_nombre,
					          prov.prov_id, prov_nombre
					
union

-----------------------------------------------------
--
--
-- ORDENES DE PAGO
--
--
-----------------------------------------------------

					select 
					
						opg.opg_id								as opg_id,
					  0                         as fc_id,  
						opg.opg_id								as comp_id,
						opg.doct_id								as doct_id,
						prov_nombre								as Proveedor,
					  emp_nombre                as [Empresa],
					  0                					as [OrdenPago/NC Total],
					  0            							as [OrdenPago/NC Aplicado],
					  opg_fecha                 as [Fecha],
					  docopg.doc_nombre         as [Documento],
					  opg_nrodoc                as [Comprobante],
						''												as [Factura],
					  opg_numero                as [Numero],
					  ''                        as [Moneda],
					  opg_pendiente             as [Saldo], 
						opg_total                 as [Total],
					  (opg_total
					  -opg_pendiente)           as [Aplicado],
					  lgjopg.lgj_codigo         as [Legajo],
					
						round(opg_total,2)                 as [Total2],
					
					  1                       	as Orden
					  
					
					from
					
						OrdenPago opg 			inner join Proveedor prov									on opg.prov_id 			= prov.prov_id
																inner join Sucursal                       on opg.suc_id       = Sucursal.suc_id
					                      inner join Documento docopg               on opg.doc_id       = docopg.doc_id
					                      inner join Empresa                        on docopg.emp_id    = Empresa.emp_id 
					                      left  join Legajo lgjopg                  on opg.lgj_id       = lgjopg.lgj_id
					where 
					
									  opg_fecha >= @@Fini
								and	opg_fecha <= @@Ffin 
					      and opg.est_id <> 7
					
								-- Arboles
								and (exists(select * from EmpresaUsuario where emp_id = docopg.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (prov.prov_id = @prov_id or @prov_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 29 and rptarb_hojaid = opg.prov_id)) or (@ram_id_Proveedor = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1007 and rptarb_hojaid = opg.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and rptarb_hojaid = docopg.emp_id)) or (@ram_id_Empresa = 0))
								--

union

-----------------------------------------------------
--
--
-- NOTAS DE CREDITO
--
--
-----------------------------------------------------

					select 
					
						nc.fc_id     							as opg_id,
					  0                         as fc_id,
						nc.fc_id								  as comp_id,
						nc.doct_id								as doct_id,
						prov_nombre								as Proveedor,
					  emp_nombre                as [Empresa],
					  0                					as [OrdenPago/NC Total],
					  0            							as [OrdenPago/NC Aplicado],
					  nc.fc_fecha               as [Fecha],
					  docnc.doc_nombre          as [Documento],
					  nc.fc_nrodoc              as [Comprobante],
						''												as [Factura],
					  nc.fc_numero              as [Numero],               
					  ''                        as [Moneda],               
					  nc.fc_pendiente           as [Saldo],                
						nc.fc_total               as [Total],      
					  (nc.fc_total
					  -nc.fc_pendiente)         as [Aplicado],
					  lgjnc.lgj_codigo          as [Legajo],               
					
						round(nc.fc_total,2)               as [Total2],      
					
					  1                       	as Orden
					
					from
					
						FacturaCompra nc 		inner join Proveedor prov									on nc.prov_id 			  	= prov.prov_id
																inner join Sucursal                       on nc.suc_id        		= Sucursal.suc_id
					                      inner join Documento docnc                on nc.doc_id        		= docnc.doc_id
					                      inner join Empresa                        on docnc.emp_id         = Empresa.emp_id
					                      left  join Legajo lgjnc                   on nc.lgj_id        		= lgjnc.lgj_id
					where 
					
									  nc.fc_fecha >= @@Fini
								and	nc.fc_fecha <= @@Ffin 
					      and docnc.doct_id = 8 /* 8	Nota de Credito Compra */
					      and nc.est_id <> 7
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (prov.prov_id = @prov_id or @prov_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 29 and rptarb_hojaid = nc.prov_id)) or (@ram_id_Proveedor = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1007 and rptarb_hojaid = nc.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = docnc.emp_id)) or (@ram_id_Empresa = 0))
								--

union

-----------------------------------------------------
--
--
-- NOTAS DE DEBITOS
--
--
-----------------------------------------------------

					select 
					
						0													as opg_id,
					  fc.fc_id									as fc_id,
						fc.fc_id								  as comp_id,
						fc.doct_id								as doct_id,
						prov_nombre								as Proveedor,
					  emp_nombre                as [Empresa],
					  0                					as [OrdenPago/NC Total],
					  0            							as [OrdenPago/NC Aplicado],
					  fc_fecha                  as [Fecha],
					  docfc.doc_nombre          as [Documento],
					  fc_nrodoc                 as [Comprobante],
						''                        as [Factura],
					  fc_numero                 as [Numero],
					  mon_nombre                as [Moneda],
					  -fc_pendiente		          as [Saldo],
						-fc_total                 as [Total],
						-(fc_total
					  -fc_pendiente)            as [Aplicado],
					  lgjfc.lgj_codigo          as [Legajo],
					
						-round(fc_total,2)                 as [Total2],
					
					  1                       	as Orden
					
					from
					
						FacturaCompra fc 				inner join Proveedor prov									on fc.prov_id 		= prov.prov_id
																		inner join Sucursal                       on fc.suc_id      = Sucursal.suc_id
																		inner join Documento docfc                on fc.doc_id      = docfc.doc_id
					                          inner join Empresa                        on docfc.emp_id   = Empresa.emp_id
							                      inner join Moneda m                       on fc.mon_id      = m.mon_id
					                          left  join Legajo lgjfc                   on fc.lgj_id      = lgjfc.lgj_id
					where 
					
									  fc_fecha >= @@Fini
								and	fc_fecha <= @@Ffin
					      and fc.est_id <> 7
					 
								and docfc.doct_id = 10 /* 10	Nota de Debito Compra */
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docfc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (prov.prov_id = @prov_id or @prov_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 29 and rptarb_hojaid = fc.prov_id)) or (@ram_id_Proveedor = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1007 and rptarb_hojaid = fc.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1018 and  rptarb_hojaid = docfc.emp_id)) or (@ram_id_Empresa = 0))
								--


union

-----------------------------------------------------
--
--
-- FACTURAS 
--
--
-----------------------------------------------------

					select 
					
						0													as opg_id,
					  fc.fc_id									as fc_id,
						fc.fc_id								  as comp_id,
						fc.doct_id								as doct_id,
						prov_nombre								as Proveedor,
					  emp_nombre                as [Empresa],

					  case 
				
							when fc_totalcomercial = 0 
							 and fc_fechavto < getdate()
							 and fc_fechavto < @@Ffin			then 	fc_total
				
							else	0
					
						end			             			as [OrdenPago/NC Total],

					  0            							as [OrdenPago/NC Aplicado],
					  fc_fecha                  as [Fecha],
					  docfc.doc_nombre          as [Documento],
					  fc_nrodoc                 as [Comprobante],
						''                        as [Factura],
					  fc_numero                 as [Numero],
					  mon_nombre                as [Moneda],

					  -fc_pendiente		          as [Saldo],

						-(
							case 
					
								when fc_totalcomercial = 0 
								 and fc_fechavto < getdate()
								 and fc_fechavto < @@Ffin			then 	0
					
								when fc_totalcomercial = 0 
								 and (    fc_fechavto >= getdate()	
								       or fc_fechavto >= @@Ffin
											)    										then 	fc_total
					
								else	fc_totalcomercial
						
							end
						 )         								as [Total],

						-(
						  case 
					
								when fc_totalcomercial = 0 
								 and fc_fechavto < getdate()
								 and fc_fechavto < @@Ffin			then 	fc_total
					
								when fc_totalcomercial = 0 
								 and (    fc_fechavto >= getdate()	
								       or fc_fechavto >= @@Ffin
											)    										then 	0
					
								else	fc_totalcomercial
										  -fc_pendiente
						
							end
						 )			             			as [Aplicado],

					  lgjfc.lgj_codigo          as [Legajo],
					
						-round(
						 case 
				
							when fc_totalcomercial = 0 
							 and fc_fechavto < getdate()
							 and fc_fechavto < @@Ffin			then 	0
				
							when fc_totalcomercial = 0 
							 and (    fc_fechavto >= getdate()	
							       or fc_fechavto >= @@Ffin
										)    										then 	fc_total
				
							else	fc_totalcomercial

						 end
						,2)                  				as [Total2],
					
					  1                       	as Orden
					
					from
					
						FacturaCompra fc 				inner join Proveedor prov									on fc.prov_id 		= prov.prov_id
																		inner join Sucursal                       on fc.suc_id      = Sucursal.suc_id
																		inner join Documento docfc                on fc.doc_id      = docfc.doc_id
					                          inner join Empresa                        on docfc.emp_id   = Empresa.emp_id
							                      inner join Moneda m                       on fc.mon_id      = m.mon_id
					                          left  join Legajo lgjfc                   on fc.lgj_id      = lgjfc.lgj_id
					where 
									  fc_fecha >= @@Fini
								and	fc_fecha <= @@Ffin

					      and fc.est_id <> 7
					 
								and docfc.doct_id = 2 /* 2	Facturas de Compra */
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docfc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (prov.prov_id = @prov_id or @prov_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 29 and rptarb_hojaid = fc.prov_id)) or (@ram_id_Proveedor = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1007 and rptarb_hojaid = fc.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1018 and  rptarb_hojaid = docfc.emp_id)) or (@ram_id_Empresa = 0))
								--

order by

	Proveedor, Orden, [Fecha], Comprobante

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
