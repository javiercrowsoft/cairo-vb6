/*---------------------------------------------------------------------
Nombre: Movimientos de Cuenta Corriente (Debe - Haber) con fecha de vencimiento del documento
---------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*

 [DC_CSC_VEN_0055] 1,'20060501 00:00:00','20070430 00:00:00','0','0','1',0,0

*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0055]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0055]
GO

create procedure DC_CSC_VEN_0055 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cli_id            varchar(255),
@@suc_id            varchar(255),
@@emp_id            varchar(255),
@@con_saldo_cero    			tinyint,
@@incluir_saldo_inicial		tinyint
)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id 	int
declare @suc_id 	int
declare @emp_id   int

declare @ram_id_Cliente 	int
declare @ram_id_Sucursal 	int
declare @ram_id_Empresa   int

declare @ClienteID 		int
declare @IsRaiz    		tinyint

exec sp_ArbConvertId @@cli_id,  @cli_id out,  @ram_id_Cliente out
exec sp_ArbConvertId @@suc_id, 	@suc_id out, 	@ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, 	@emp_id out, 	@ram_id_Empresa out

exec sp_GetRptId @ClienteID out

if @ram_id_Cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cliente, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cliente, @ClienteID 
	end else 
		set @ram_id_Cliente = 0
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
  cli_id                int not null,
  emp_id                int not null,
  debito_total          decimal(18,6) not null,
  debito_pendiente      decimal(18,6) not null
)

create table #Credito(
  cli_id                int not null,
  emp_id                int not null,
  credito_total         decimal(18,6) not null,
  credito_pendiente     decimal(18,6) not null
)

create table #CrdDeb (
  cli_id                int not null,
  emp_id                int not null,
  debito_total          decimal(18,6) not null,
  debito_pendiente      decimal(18,6) not null,
  credito_total         decimal(18,6) not null,
  credito_pendiente     decimal(18,6) not null
)

-----------------------------------------------------
--
--
-- DEBITOS
--
--
-----------------------------------------------------

					insert into #Debito (cli_id, emp_id, debito_total, debito_pendiente)
					
					select cli_id,
					       cobz.emp_id,
					       sum(cobz_total),
					       sum(cobz_pendiente)
					from
					       Cobranza cobz
					
					where
									cobz_fecha < @@Fini

							and	cobz.est_id <> 7
					
							-- Arboles
							--
							and (exists(select * from EmpresaUsuario where emp_id = cobz.emp_id and us_id = @@us_id) or (@@us_id = 1))
							and (cobz.cli_id = @cli_id or @cli_id=0)
							and (cobz.emp_id = @emp_id or @emp_id=0)
							and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = cobz.cli_id)) or (@ram_id_Cliente = 0))
							and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and rptarb_hojaid = cobz.emp_id)) or (@ram_id_Empresa = 0))
							--
					
					group by
					          cli_id,
					          cobz.emp_id
					
					----------------
					union all
					----------------
					
					select cli_id,
					       doc.emp_id,
					       sum(fvd_importe),
					       sum(fvd_pendiente)
					from
					       FacturaVenta nc inner join Documento doc on nc.doc_id = doc.doc_id
																 left join FacturaVentaDeuda fvd on nc.fv_id = fvd.fv_id
					
					where					
									fvd_fecha < @@Fini

								and	nc.doct_id = 7 /* 7	Nota de Credito Venta */

								and nc.est_id <> 7
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (nc.cli_id = @cli_id or @cli_id=0)
								and (doc.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = nc.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
								--
					
					group by
					          cli_id,
					          doc.emp_id

					----------------
					union all
					----------------
					
					select cli_id,
					       doc.emp_id,
					       sum(fvp_importe),
					       0
					from
					       FacturaVenta nc inner join Documento doc on nc.doc_id = doc.doc_id
																 left join FacturaVentaPago fvp on nc.fv_id= fvp.fv_id
					
					where					
									fvp_fecha < @@Fini

								and	nc.doct_id = 7 /* 7	Nota de Credito Venta */

								and nc.est_id <> 7
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (nc.cli_id = @cli_id or @cli_id=0)
								and (doc.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = nc.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
								--
					
					group by
					          cli_id,
					          doc.emp_id


-----------------------------------------------------
--
--
-- CREDITOS
--
--
-----------------------------------------------------

					insert into #Credito (cli_id, emp_id, credito_total, credito_pendiente)
					
					select cli_id,
					       doc.emp_id,
					       sum(fv_total),
					       sum(fvd_pendiente)
					from
					       FacturaVenta nd inner join Documento doc on nd.doc_id = doc.doc_id
																 left join FacturaVentaDeuda fvd on nd.fv_id = fvd.fv_id
					
					where

									fvd_fecha < @@Fini

								and	nd.doct_id = 9 /* 9	Nota de Debito Venta */

								and nd.est_id <> 7
					
								-- Arbol
								--
								and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (nd.cli_id = @cli_id or @cli_id=0)
								and (doc.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = nd.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
								--
					
					group by
					          cli_id,
					          doc.emp_id					

/*-----------------------------*/
				union all
/*-------------------------------*/
					select cli_id,
					       doc.emp_id,
					       sum(fvp_importe),
					       0
					from
					       FacturaVenta nd inner join Documento doc on nd.doc_id = doc.doc_id
																 left join FacturaVentaPago fvp on nd.fv_id = fvp.fv_id

					where

									fvp_fecha < @@Fini

								and	nd.doct_id = 9 /* 9	Nota de Debito Venta */

								and nd.est_id <> 7
					
								-- Arbol
								--
								and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (nd.cli_id = @cli_id or @cli_id=0)
								and (doc.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = nd.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
								--
					
					group by
					          cli_id,
					          doc.emp_id					

					----------------
					union
					----------------

					select cli_id,
								 doc.emp_id,

								 sum(fvd_importe),
								 sum(fvd_pendiente)
					from 
								FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
																left join FacturaVentaDeuda fvd on fv.fv_id = fvd.fv_id

					where 

							fvd_fecha < @@Fini

					and fv.est_id <> 7
					and fv.doct_id = 1 -- Facturas de Venta

					-- Arbol
					--
					and (exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1))
					and (fv.cli_id = @cli_id or @cli_id=0)
 					and (doc.emp_id = @emp_id or @emp_id=0)
 					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = fv.cli_id)) or (@ram_id_Cliente = 0))
 					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = doc.emp_id)) or (@ram_id_Empresa = 0))
					--

					group by
					          cli_id,
					          doc.emp_id

-----------------------------------------------------
--
--
-- DEBITOS Y CREDITOS
--
--
-----------------------------------------------------

					insert into #CrdDeb (cli_id,emp_id,debito_total,debito_pendiente,credito_total,credito_pendiente)
					select cli_id,emp_id, sum(debito_total), sum(debito_pendiente),0,0 from #Debito group by cli_id,emp_id
					
					update #CrdDeb set 
					
					  credito_total      = IsNull(
																 (select sum(c.credito_total) 
                                  from #Credito c 
                                  where #CrdDeb.cli_id = c.cli_id 
                                    and #CrdDeb.emp_id = c.emp_id
																	group by cli_id,emp_id
																 ),0),
					  credito_pendiente  = IsNull(
																 (select sum(c.credito_pendiente)
                                  from #Credito c 
                                  where #CrdDeb.cli_id = c.cli_id 
                                    and #CrdDeb.emp_id = c.emp_id
																	group by cli_id,emp_id
																 ),0)					

					insert into #CrdDeb (cli_id,emp_id,debito_total,debito_pendiente,credito_total,credito_pendiente)
					select cli_id,emp_id,0,0, sum(credito_total), sum(credito_pendiente) from #Credito
					where not exists(select * from #CrdDeb where #CrdDeb.cli_id = #Credito.cli_id and #CrdDeb.emp_id = #Credito.emp_id)
					group by cli_id,emp_id

-----------------------------------------------------
--
--
-- SALDOS INICIALES
--
--
-----------------------------------------------------

					select 
					
						0         								 				as cobz_id,
					  0                          				as fv_id,
						0																	as comp_id,
						0																	as doct_id,
						cli_nombre								 				as Cliente,
					  emp_nombre                 				as [Empresa],

					  -Sum(IsNull(debito_total,0))    	as [Cobranza/NC Total],
					
					  Sum(IsNull(debito_total,0))
					  -Sum(IsNull(debito_pendiente,0))	as [Cobranza/NC Aplicado],
					
					  null                        			as [Fecha],
					  ''                          			as [Documento],
					  ''                          			as [Comprobante],
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
					  -Sum(IsNull(debito_total,0))     	as [Total2],
					
					  -1                       					as Orden
					  
					
					from
					
					    Cliente cli       left join #CrdDeb cd          on cli.cli_id = cd.cli_id
					                         left join Empresa e        on cd.emp_id  = e.emp_id
					
					where 
					
					          ( IsNull(credito_total,0) <> 0 or IsNull(debito_total,0) <> 0 or @@con_saldo_cero <> 0)
						and @@incluir_saldo_inicial <> 0
					
					group by
					
					          e.emp_id, emp_nombre,
					          cli.cli_id, cli_nombre
					
union

-----------------------------------------------------
--
--
-- COBRANZAS
--
--
-----------------------------------------------------

					select 
					
						cobz.cobz_id							as cobz_id,
					  0                         as fv_id,  
						cobz.cobz_id							as comp_id,
						cobz.doct_id							as doct_id,
						cli_nombre								as Cliente,
					  emp_nombre                as [Empresa],
					  0                					as [Cobranza/NC Total],
					  0            							as [Cobranza/NC Aplicado],
					  cobz_fecha                as [Fecha],
					  doccobz.doc_nombre        as [Documento],
					  cobz_nrodoc               as [Comprobante],
						''												as [Factura],
					  cobz_numero               as [Numero],
					  ''                        as [Moneda],
					  -cobz_pendiente           as [Saldo], 
						-cobz_total               as [Total],
					  -(cobz_total
					  -cobz_pendiente)          as [Aplicado],
					  lgjcobz.lgj_codigo        as [Legajo],
					
						-cobz_total               as [Total2],
					
					  1                       	as Orden
					  
					
					from
					
						Cobranza cobz 			inner join Cliente cli									on cobz.cli_id 			 = cli.cli_id
																inner join Sucursal                     on cobz.suc_id       = Sucursal.suc_id
					                      inner join Documento doccobz            on cobz.doc_id       = doccobz.doc_id
					                      inner join Empresa                      on doccobz.emp_id    = Empresa.emp_id 
					                      left  join Legajo lgjcobz               on cobz.lgj_id       = lgjcobz.lgj_id
					where 
					
									  cobz_fecha >= @@Fini
								and	cobz_fecha <= @@Ffin 
					      and cobz.est_id <> 7
					
								-- Arboles
								and (exists(select * from EmpresaUsuario where emp_id = doccobz.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (cli.cli_id = @cli_id or @cli_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = cobz.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1007 and rptarb_hojaid = cobz.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and rptarb_hojaid = doccobz.emp_id)) or (@ram_id_Empresa = 0))
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
					
						nc.fv_id     							as cobz_id,
					  0                         as fv_id,
						nc.fv_id								  as comp_id,
						nc.doct_id								as doct_id,
						cli_nombre								as Cliente,
					  emp_nombre                as [Empresa],
					  0                					as [Cobranza/NC Total],
					  0            							as [Cobranza/NC Aplicado],
					  nc.fv_fecha               as [Fecha],
					  docnc.doc_nombre          as [Documento],
					  nc.fv_nrodoc              as [Comprobante],
						''												as [Factura],
					  nc.fv_numero              as [Numero],               
					  ''                        as [Moneda],               
					  -fvd_pendiente 		        as [Saldo],                
						-fvd_importe      	      as [Total],      
					  -(nc.fv_total
					  -nc.fv_pendiente)         as [Aplicado],
					  lgjnc.lgj_codigo          as [Legajo],               
					
						-nc.fv_total              as [Total2],      
					
					  1                       	as Orden
					
					from
					
						FacturaVenta nc 		inner join Cliente cli								on nc.cli_id 			  = cli.cli_id
																inner join Sucursal                   on nc.suc_id        = Sucursal.suc_id
					                      inner join Documento docnc            on nc.doc_id        = docnc.doc_id
					                      inner join Empresa                    on docnc.emp_id     = Empresa.emp_id
					                      left  join Legajo lgjnc               on nc.lgj_id        = lgjnc.lgj_id
																left  join facturaVentaDeuda	fvd			on nc.fv_id					= fvd.fv_id				
					where 
					
									  fvd_fecha >= @@Fini
								and	fvd_fecha <= @@Ffin 
					      and docnc.doct_id = 7 /* 7	Nota de Credito Venta */
					      and nc.est_id <> 7
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (cli.cli_id = @cli_id or @cli_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = nc.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1007 and rptarb_hojaid = nc.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = docnc.emp_id)) or (@ram_id_Empresa = 0))
								--
---------------------------
			union all
---------------------------
					select 
					
						nc.fv_id     							as cobz_id,
					  0                         as fv_id,
						nc.fv_id								  as comp_id,
						nc.doct_id								as doct_id,
						cli_nombre								as Cliente,
					  emp_nombre                as [Empresa],
					  0                					as [Cobranza/NC Total],
					  0            							as [Cobranza/NC Aplicado],
					  nc.fv_fecha               as [Fecha],
					  docnc.doc_nombre          as [Documento],
					  nc.fv_nrodoc              as [Comprobante],
						''												as [Factura],
					  nc.fv_numero              as [Numero],               
					  ''                        as [Moneda],               
					  -0							          as [Saldo],                
						-fvp_importe              as [Total],      
					  -fvp_importe  	          as [Aplicado],
					  lgjnc.lgj_codigo          as [Legajo],               
					
						-fvp_importe              as [Total2],      
					
					  1                       	as Orden
					
					from
					
						FacturaVenta nc 		inner join Cliente cli						on nc.cli_id 		 = cli.cli_id
																inner join Sucursal               on nc.suc_id     = Sucursal.suc_id
					                      inner join Documento docnc        on nc.doc_id     = docnc.doc_id
					                      inner join Empresa                on docnc.emp_id  = Empresa.emp_id
					                      left  join Legajo lgjnc           on nc.lgj_id     = lgjnc.lgj_id
																left  join FacturaVentaPago fvp   on nc.fv_id      = fvp.fv_id
					where 
					
									  fvp_fecha >= @@Fini
								and	fvp_fecha <= @@Ffin 
					      and docnc.doct_id = 7 /* 7	Nota de Credito Venta */
					      and nc.est_id <> 7
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (cli.cli_id = @cli_id or @cli_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 28 and rptarb_hojaid = nc.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1007 and rptarb_hojaid = nc.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and tbl_id = 1018 and  rptarb_hojaid = docnc.emp_id)) or (@ram_id_Empresa = 0))
								--

/*--------------------------*/
union

-----------------------------------------------------
--
--
-- NOTAS DE DEBITOS
--
--
-----------------------------------------------------

					select 
					
						0													as cobz_id,
					  fv.fv_id									as fv_id,
						fv.fv_id								  as comp_id,
						fv.doct_id								as doct_id,
						cli_nombre								as Cliente,
					  emp_nombre                as [Empresa],
					  0                					as [Cobranza/NC Total],
					  0            							as [Cobranza/NC Aplicado],
					  fvp_fecha                 as [Fecha],
					  docfv.doc_nombre          as [Documento],
					  fv_nrodoc                 as [Comprobante],
						''                        as [Factura],
					  fv_numero                 as [Numero],
					  mon_nombre                as [Moneda],
					  0								          as [Saldo],
						fvp_importe               as [Total],
						fvp_importe               as [Aplicado],
					  lgjfv.lgj_codigo          as [Legajo],
					
						fvp_importe               as [Total2],
					
					  1                       	as Orden
					
					from
					
						FacturaVenta fv 				inner join Cliente cli			    on fv.cli_id 		 = cli.cli_id
																		inner join Sucursal             on fv.suc_id     = Sucursal.suc_id
																		inner join Documento docfv      on fv.doc_id     = docfv.doc_id
					                          inner join Empresa              on docfv.emp_id  = Empresa.emp_id
							                      inner join Moneda m             on fv.mon_id     = m.mon_id
					                          left  join Legajo lgjfv         on fv.lgj_id     = lgjfv.lgj_id
					                          left  join FacturaVentaPago fvp on fv.fv_id      = fvp.fv_id
					where 
					
									  fvp_fecha >= @@Fini
								and	fvp_fecha <= @@Ffin
					      and fv.est_id <> 7
					 
								and docfv.doct_id = 9 /* 9	Nota de Debito Venta */
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (cli.cli_id = @cli_id or @cli_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 28 and rptarb_hojaid = fv.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1007 and rptarb_hojaid = fv.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1018 and  rptarb_hojaid = docfv.emp_id)) or (@ram_id_Empresa = 0))
								--
---------------------------
union all
---------------------------
					select 
					
						0													as cobz_id,
					  fv.fv_id									as fv_id,
						fv.fv_id								  as comp_id,
						fv.doct_id								as doct_id,
						cli_nombre								as Cliente,
					  emp_nombre                as [Empresa],
					  0                					as [Cobranza/NC Total],
					  0            							as [Cobranza/NC Aplicado],
					  fvd_fecha                 as [Fecha],
					  docfv.doc_nombre          as [Documento],
					  fv_nrodoc                 as [Comprobante],
						''                        as [Factura],
					  fv_numero                 as [Numero],
					  mon_nombre                as [Moneda],
					  fvd_pendiente		          as [Saldo],
						fvd_importe               as [Total],
						fvd_importe
					  -fvd_pendiente            as [Aplicado],
					  lgjfv.lgj_codigo          as [Legajo],
					
						fvd_importe               as [Total2],
					
					  1                       	as Orden
					
					from
					
						FacturaVenta fv 				inner join Cliente cli						on fv.cli_id 		= cli.cli_id
																		inner join Sucursal               on fv.suc_id    = Sucursal.suc_id
																		inner join Documento docfv        on fv.doc_id    = docfv.doc_id
					                          inner join Empresa                on docfv.emp_id = Empresa.emp_id
							                      inner join Moneda m               on fv.mon_id    = m.mon_id
					                          left  join Legajo lgjfv           on fv.lgj_id    = lgjfv.lgj_id
					                          left  join FacturaVentaDeuda fvd  on fv.fv_id     = fvd.fv_id
					where 
					
									  fvd_fecha >= @@Fini
								and	fvd_fecha <= @@Ffin
					      and fv.est_id <> 7
					 
								and docfv.doct_id = 9 /* 9	Nota de Debito Venta */
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (cli.cli_id = @cli_id or @cli_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 28 and rptarb_hojaid = fv.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1007 and rptarb_hojaid = fv.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1018 and  rptarb_hojaid = docfv.emp_id)) or (@ram_id_Empresa = 0))
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
					
						0													as cobz_id,
					  fv.fv_id									as fv_id,
						fv.fv_id								  as comp_id,
						fv.doct_id								as doct_id,
						cli_nombre								as Cliente,
					  emp_nombre                as [Empresa],

						fvd_importe		      			as [Cobranza/NC Total],

					  0            							as [Cobranza/NC Aplicado],
					  fvd_fecha                 as [Fecha],
					  docfv.doc_nombre          as [Documento],
					  fv_nrodoc                 as [Comprobante],
						''                        as [Factura],
					  fv_numero                 as [Numero],
					  mon_nombre                as [Moneda],

					  fvd_pendiente		          as [Saldo],
						fvd_importe 		          as [Total],						

						fvd_importe
            -fvd_pendiente						as [Aplicado],

					  lgjfv.lgj_codigo          as [Legajo],
						fvd_importe          			as [Total2],			
					  1                       	as Orden
					
					from
					
						FacturaVenta fv 	inner join Cliente cli						on fv.cli_id 		= cli.cli_id
															inner join Sucursal               on fv.suc_id    = Sucursal.suc_id
															inner join Documento docfv        on fv.doc_id    = docfv.doc_id
					                    inner join Empresa                on docfv.emp_id = Empresa.emp_id
							                inner join Moneda m               on fv.mon_id    = m.mon_id
					                    left  join Legajo lgjfv           on fv.lgj_id    = lgjfv.lgj_id
					                    left  join FacturaVentaDeuda fvd  on fv.fv_id     = fvd.fv_id
					where 
									  fvd_fecha >= @@Fini
								and	fvd_fecha <= @@Ffin

					      and fv.est_id <> 7
					 
								and docfv.doct_id = 1 /* 1	Facturas de Venta */
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (cli.cli_id = @cli_id or @cli_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 28 and rptarb_hojaid = fv.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1007 and rptarb_hojaid = fv.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1018 and  rptarb_hojaid = docfv.emp_id)) or (@ram_id_Empresa = 0))
								--

union all
					select 
					
						0													as cobz_id,
					  fv.fv_id									as fv_id,
						fv.fv_id								  as comp_id,
						fv.doct_id								as doct_id,
						cli_nombre								as Cliente,
					  emp_nombre                as [Empresa],
						fvp_importe	         			as [Cobranza/NC Total],

					  0            							as [Cobranza/NC Aplicado],
					  fvp_fecha                 as [Fecha],
					  docfv.doc_nombre          as [Documento],
					  fv_nrodoc                 as [Comprobante],
						''                        as [Factura],
					  fv_numero                 as [Numero],
					  mon_nombre                as [Moneda],
					  0								          as [Saldo],
						fvp_importe 							as [Total],
						fvp_importe	         			as [Aplicado],
					  lgjfv.lgj_codigo          as [Legajo],
						fvp_importe          			as [Total2],
					
					  1                       	as Orden
					
					from
					
						FacturaVenta fv 				inner join Cliente cli					on fv.cli_id 		= cli.cli_id
																		inner join Sucursal             on fv.suc_id    = Sucursal.suc_id
																		inner join Documento docfv      on fv.doc_id    = docfv.doc_id
					                          inner join Empresa              on docfv.emp_id = Empresa.emp_id
							                      inner join Moneda m             on fv.mon_id    = m.mon_id
					                          left  join Legajo lgjfv         on fv.lgj_id    = lgjfv.lgj_id
					                          left  join facturaVentaPago fvp on fv.fv_id     = fvp.fv_id
					where 
									  fvp_fecha >= @@Fini
								and	fvp_fecha <= @@Ffin

					      and fv.est_id <> 7
					 
								and docfv.doct_id = 1 /* 1	Facturas de Venta */
					
								-- Arboles
								--
								and (exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1))
								and (cli.cli_id = @cli_id or @cli_id=0)
								and (Sucursal.suc_id = @suc_id or @suc_id=0)
								and (Empresa.emp_id = @emp_id or @emp_id=0)
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 28 and rptarb_hojaid = fv.cli_id)) or (@ram_id_Cliente = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1007 and rptarb_hojaid = fv.suc_id)) or (@ram_id_Sucursal = 0))
								and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @ClienteID and  tbl_id = 1018 and  rptarb_hojaid = docfv.emp_id)) or (@ram_id_Empresa = 0))
								--


order by

	Cliente, Orden, [Fecha], Comprobante

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
