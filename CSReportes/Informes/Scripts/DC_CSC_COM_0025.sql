/*---------------------------------------------------------------------
Nombre: Aplicacion de documentos de compra
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0025]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0025]

/*

[DC_CSC_COM_0025] 1,'20080101 00:00:00','20081231 00:00:00','100','0','N84951','0',0

[dc_csc_com_0025] 1,'20080101 00:00:00','20081231 00:00:00','314','0','N84951','0',0

exec [dc_csc_com_0025] 1,'20080101 00:00:00','20081231 00:00:00','314','0','N84951','0',0

*/

go
create procedure DC_CSC_COM_0025 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@prov_id 		varchar(255),
@@suc_id  		varchar(255),
@@cico_id			varchar(255), 
@@emp_id  		varchar(255),
@@pendientes	smallint			-- <> 0: solo pendientes
														-- =  0: todas

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id  int
declare @suc_id   int
declare @cico_id  int
declare @emp_id   int 

declare @ram_id_Proveedor int
declare @ram_id_Sucursal  int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

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

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

----------------------------------------

if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end
----------------------------------------

/*- ///////////////////////////////////////////////////////////////////////

SALDOS

/////////////////////////////////////////////////////////////////////// */

	create table #t_opg_ids (opg_id int)
	create table #t_fc_ids  (fc_id int)

	-- Notas de credito por debito automatico
	-- y sus Ordenes de Pago 
	--
	create table #t_opg_da_ids (opg_id int)
	create table #t_nc_da_ids  (fc_id int)

--------------------------------------------------------------------------
	insert into #t_opg_ids (opg_id)

		select opg_id
		from OrdenPago opg inner join Documento doc on opg.doc_id = doc.doc_id
		where 
		
						  opg.opg_fecha <= @@Ffin
					and	opg.est_id <> 7

		---------------------------------------------------------------------------
					and (
								exists(select * from EmpresaUsuario where emp_id = opg.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		---------------------------------------------------------------------------
		
		and   (opg.prov_id = @prov_id or @prov_id=0)
		and   (opg.suc_id = @suc_id or @suc_id=0)
		and   (opg.emp_id = @emp_id or @emp_id=0) 
		and   (doc.cico_id = @cico_id or @cico_id=0)
		
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
		                  and  rptarb_hojaid = opg.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )

--------------------------------------------------------------------------

--------------------------------------------------------------------------
	insert into #t_fc_ids (fc_id)

		select 
		
				nc.fc_id

		from
		
			FacturaCompra nc inner join Documento docnc on nc.doc_id = docnc.doc_id
		                      
		where 

							nc.fc_fecha <= @@Ffin

		      and docnc.doct_id = 8 /* 8	Nota de Credito Compra */
					and nc.est_id <> 7
		
		---------------------------------------------------------------------------
					and (
								exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		---------------------------------------------------------------------------
		
		and   (nc.prov_id   	= @prov_id or @prov_id =0)
		and   (nc.suc_id    	= @suc_id  or @suc_id  =0)
		and   (docnc.emp_id 	= @emp_id  or @emp_id  =0) 
		and   (docnc.cico_id 	= @cico_id or @cico_id =0)
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 29
		                  and  rptarb_hojaid = nc.prov_id
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
		                  and  rptarb_hojaid = nc.suc_id
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
		                  and  rptarb_hojaid = docnc.cico_id
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
		                  and  rptarb_hojaid = docnc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )
		
		--/////////////////////////////////////
		--
		-- FACTURAS
		--

		union all

		select 
		
				fc.fc_id
		
		from
		
			FacturaCompra fc inner join Documento docfc on fc.doc_id = docfc.doc_id
		
		where 
							fc.fc_fecha <= @@Ffin

		      and docfc.doct_id <> 8 /* 8	Nota de Credito Compra */
				  and fc.est_id <> 7
		
		---------------------------------------------------------------------------
					and (
								exists(select * from EmpresaUsuario where emp_id = docfc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		---------------------------------------------------------------------------
		
		and   (fc.prov_id   	= @prov_id 	or @prov_id = 0)
		and   (fc.suc_id    	= @suc_id  	or @suc_id  = 0)
		and   (docfc.emp_id 	= @emp_id  	or @emp_id  = 0) 
		and   (docfc.cico_id  = @cico_id  or @cico_id = 0)
		
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
		                  and  rptarb_hojaid = docfc.cico_id
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
		                  and  rptarb_hojaid = docfc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )

--------------------------------------------------------------------------

	insert into #t_opg_da_ids (opg_id)

	select opg_id
	from #t_opg_ids
	where opg_id in ( select fcopg.opg_id 
										from #t_fc_ids t 
														inner join FacturaCompra fc 
																on 			t.fc_id = fc.fc_id
																		and fc.doct_id = 8 

														inner join FacturaCompraOrdenPago fcopg 
																on t.fc_id = fcopg.fc_id
									)

	delete #t_opg_ids
	where opg_id in (select opg_id from #t_opg_da_ids)

	insert into #t_nc_da_ids (fc_id)
	select fc.fc_id
	from #t_fc_ids t inner join FacturaCompra fc 
																on t.fc_id = fc.fc_id
															 and fc.doct_id = 8
									 inner join FacturaCompraOrdenPago fcopg 
																on fc.fc_id = fcopg.fc_id

	delete #t_fc_ids 
	where fc_id in (select fc_id from #t_nc_da_ids)

--------------------------------------------------------------------------

	create table #t_dc_csc_com_0025 (
	
		prov_id 				int,
		emp_id  				int,
		opgnc_pendiente decimal(18,6),
	  fc_pendiente    decimal(18,6)
	)

		--/////////////////////////////////////
		--
		-- ORDENES DE PAGO
		--
		
		insert into #t_dc_csc_com_0025
		
		select 
		
			prov_id,
		  opg.emp_id,
			opg_total - isnull((select sum(fcopg_importe) 
                          from FacturaCompraOrdenPago fcopg inner join FacturaCompra fc
													 																  on fcopg.fc_id = fc.fc_id			
                          where fcopg.opg_id = opg.opg_id
													  and fc.fc_fecha <= @@Ffin
														and fc.fc_id in (select fc_id from #t_fc_ids)
                        ),0),
			0  
		
		from
		
			OrdenPago opg inner join Documento doc on opg.doc_id = doc.doc_id
		
		where 
		
						  opg.opg_fecha < @@Fini
					and	opg.est_id <> 7

					and (opg_total - isnull((select sum(fcopg_importe) 
                          from FacturaCompraOrdenPago fcopg inner join FacturaCompra fc
													 																  on fcopg.fc_id = fc.fc_id			
                          where fcopg.opg_id = opg.opg_id
													  and fc.fc_fecha <= @@Ffin
														and fc.fc_id in (select fc_id from #t_fc_ids)
                        ),0)<> 0)

					and opg_id in (select opg_id from #t_opg_ids)

		--/////////////////////////////////////
		--
		-- NOTAS DE CREDITO
		--

		union all
		
		select 
		
			prov_id,
		  docnc.emp_id,

			case

				when fc_totalcomercial = 0 
				 and fc_fechavto < getdate()
				 and fc_fechavto < @@Ffin			then 	0
	
				when fc_totalcomercial = 0 
				 and (    fc_fechavto >= getdate()	
				       or fc_fechavto >= @@Ffin
							)    										then 	fc_total
	
				else

		  			fc_totalcomercial
							 - IsNull((select sum(fcnc_importe) 
                         from FacturaCompraNotaCredito fcnc inner join FacturaCompra fc
																												   on fcnc.fc_id_factura = fc.fc_id			
                         where fcnc.fc_id_notacredito = nc.fc_id
												   and fc.fc_fecha <= @@Ffin
													 and fc.fc_id in (select fc_id from #t_fc_ids)
                        ),0)
			end,
			0
		
		from
		
			FacturaCompra nc inner join Documento docnc on nc.doc_id = docnc.doc_id
		                      
		where 

							nc.fc_fecha < @@Fini

		      and docnc.doct_id = 8 /* 8	Nota de Credito Compra */
					and nc.est_id <> 7
		
					and (fc_total - IsNull((select sum(fcnc_importe) 
                         from FacturaCompraNotaCredito fcnc inner join FacturaCompra fc
																												   on fcnc.fc_id_factura = fc.fc_id			
                         where fcnc.fc_id_notacredito = nc.fc_id
												   and fc.fc_fecha <= @@Ffin
													 and fc.fc_id in (select fc_id from #t_fc_ids)
                        ),0)<>0)

					and nc.fc_id in (select fc_id from #t_fc_ids)
		
		--/////////////////////////////////////
		--
		-- FACTURAS
		--

		union all

		select 
		
					prov_id,
				  docfc.emp_id,
				  0,

					case
		
						when fc_totalcomercial = 0 
						 and fc_fechavto < getdate()
						 and fc_fechavto < @@Ffin			then 	0
			
						when fc_totalcomercial = 0 
						 and (    fc_fechavto >= getdate()	
						       or fc_fechavto >= @@Ffin
									)    										then 	fc_total
			
						else

							fc_totalcomercial
															 - IsNull((select sum(fcnc_importe) 
					                               from FacturaCompraNotaCredito fcnc inner join FacturaCompra nc
																																				   on fcnc.fc_id_notacredito = nc.fc_id			
					                               where fcnc.fc_id_factura = fc.fc_id
																				   and nc.fc_fecha <= @@Ffin
																				   and nc.fc_id in (select fc_id from #t_fc_ids)
					                               ),0)
															 - IsNull((select sum(fcopg_importe) 
						                             from FacturaCompraOrdenPago fcopg inner join OrdenPago opg
																					 																  on fcopg.opg_id = opg.opg_id			
						                             where fcopg.fc_id = fc.fc_id
																				   and opg.opg_fecha <= @@Ffin
																					 and opg.opg_id in (select opg_id from #t_opg_ids)
						                             ),0)
					end
		
		from
		
			FacturaCompra fc inner join Documento docfc on fc.doc_id = docfc.doc_id
		
		where 
							fc.fc_fecha < @@Fini

		      and docfc.doct_id <> 8 /* 8	Nota de Credito Compra */
				  and fc.est_id <> 7

					and (fc_total - IsNull((select sum(fcnc_importe) 
	                                from FacturaCompraNotaCredito fcnc inner join FacturaCompra nc
																																   on fcnc.fc_id_notacredito = nc.fc_id			
	                                where fcnc.fc_id_factura = fc.fc_id
																    and nc.fc_fecha <= @@Ffin
																		and fc.fc_id in (select fc_id from #t_fc_ids)
	                                ),0)
											  - IsNull((select sum(fcopg_importe) 
		                              from FacturaCompraOrdenPago fcopg inner join OrdenPago opg
																	 																  on fcopg.opg_id = opg.opg_id			
		                              where fcopg.fc_id = fc.fc_id
																    and opg.opg_fecha <= @@Ffin
																		and opg.opg_id in (select opg_id from #t_opg_ids)
		                              ),0)<>0)
		
					and fc.fc_id in (select fc_id from #t_fc_ids)

/*- //////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

	--/////////////////////////////////////
	--	
	-- SALDOS
	--

	declare @SaldoAl varchar(255)
	set @SaldoAl = 'Saldo al ' + convert(varchar(10),dateadd(d,-1,@@fini),110)

	select 
	
		0         								as opg_id,
	  0       									as fc_id,
		prov_nombre								as Proveedor,
	  emp_nombre                as Empresa, 
	  @@fini  									as [Orden de Pago/NC Fecha],
	  null                      as [Orden de Pago/NC],
	  @SaldoAl                  as [Orden de Pago/NC Comprobante],
	  null               	      as [Orden de Pago/NC Numero],
	  null                     	as [Orden de Pago/NC Total],
	  sum(opgnc_pendiente)			as [Orden de Pago/NC Pendiente],
	  null                      as [Orden de Pago/NC Legajo],
	  null                      as [Factura Fecha],
	  null                      as [Documento de Compra],
	  null                      as [Factura Comprobante],
	  null                      as [Factura Numero],
	  null                      as [Moneda],
	  null                     	as [Aplicacion],
		null                      as [Factura Total],
	  sum(fc_pendiente)         as [Factura Pendiente],
	  null                      as [Factura Legajo],
	  0                       	as Orden
	
	from #t_dc_csc_com_0025 t inner join Proveedor prov on t.prov_id = prov.prov_id
	                          inner join Empresa emp    on t.emp_id  = emp.emp_id

		group by prov_nombre,emp_nombre
	
	union all

	--/////////////////////////////////////
	--	
	-- ENTRE FECHAS
	--

	--/////////////////////////////////////
	--	
	-- ORDENES DE PAGO
	--

	select 
	
		opg.opg_id								as opg_id,
	  fc.fc_id									as fc_id,
		prov_nombre								as Proveedor,
	  emp_nombre                as Empresa, 
	  opg_fecha									as [Orden de Pago/NC Fecha],
	  docopg.doc_nombre         as [Orden de Pago/NC],
	
		case opg.est_id
			when 7 then opg_nrodoc + ' (Anulada)'
			else				opg_nrodoc
		end                     	as [Orden de Pago/NC Comprobante],
	
	  opg_numero               	as [Orden de Pago/NC Numero],
	  
		case opg.est_id
			when 7 then 0
			else				opg_total
		end                     	as [Orden de Pago/NC Total],
	
		case opg.est_id
			when 7 then 0
			else				opg_total - IsNull((select sum(fcopg_importe) 
				                              from FacturaCompraOrdenPago fcopg inner join FacturaCompra fc
																			 																  on fcopg.fc_id = fc.fc_id			
				                              where fcopg.opg_id = opg.opg_id
																			  and fc.fc_fecha <= @@Ffin
																				and fc.fc_id in (select fc_id from #t_fc_ids)
				                              ),0)
		end              					as [Orden de Pago/NC Pendiente],
	
	  lgjopg.lgj_codigo         as [Orden de Pago/NC Legajo],
	  fc_fecha                  as [Factura Fecha],
	  docfc.doc_nombre          as [Documento de Compra],
	  fc_nrodoc                 as [Factura Comprobante],
	  fc_numero                 as [Factura Numero],
	  mon_nombre                as [Moneda],
	
		case opg.est_id
			when 7 then 0
			else				fcopg_importe
		end                     	as [Aplicacion],
	
		fc_total                  as [Factura Total],
	  0                         as [Factura Pendiente],
	  lgjfc.lgj_codigo          as [Factura Legajo],
	  0                       	as Orden
	  
	
	from
	
		OrdenPago opg 			inner join Proveedor prov 										on opg.prov_id 			= prov.prov_id
												inner join Sucursal                       		on opg.suc_id       = Sucursal.suc_id
	                      inner join Documento docopg               		on opg.doc_id       = docopg.doc_id
	                      inner join Empresa                            on docopg.emp_id    = Empresa.emp_id 
	                      left  join Legajo lgjopg                  		on opg.lgj_id       = lgjopg.lgj_id
												left  join FacturaCompraOrdenPago fcopg     	on opg.opg_id 			= fcopg.opg_id
												left  join FacturaCompra fc                		on fcopg.fc_id      = fc.fc_id
												left  join Documento docfc                		on fc.doc_id        = docfc.doc_id
	                      left  join Moneda m                       		on fc.mon_id        = m.mon_id
	                      left  join Legajo lgjfc                   		on fc.lgj_id        = lgjfc.lgj_id
	where 
	
					  opg_fecha >= @@Fini
				and	opg_fecha <= @@Ffin 
	
				and opg.opg_id in (select opg_id from #t_opg_ids)
	
	--/////////////////////////////////////
	--	
	-- NOTAS DE CREDITO
	--

	union all
	
  select 
	
		nc.fc_id     							as opg_id,
	  fc.fc_id									as fc_id,
		prov_nombre								as Proveedor,
	  emp_nombre                as Empresa, 
	  nc.fc_fecha								as [Orden de Pago/NC Fecha],
	  docnc.doc_nombre          as [Orden de Pago/NC],
	
	  case nc.est_id
			when 7 then nc.fc_nrodoc + ' (Anulada)'
			else	      nc.fc_nrodoc
		end												as [Orden de Pago/NC Comprobante],
	
	  nc.fc_numero              as [Orden de Pago/NC Numero],
	
	  case nc.est_id
			when 7 then 0
			else				nc.fc_total
		end				                as [Orden de Pago/NC Total],
	
	  case nc.est_id
			when 7 then 0
			else				nc.fc_total - IsNull((select sum(fcnc_importe) 
					                              from FacturaCompraNotaCredito fcnc inner join FacturaCompra fc
																																				   on fcnc.fc_id_factura = fc.fc_id			
					                              where fcnc.fc_id_notacredito = nc.fc_id
																				  and fc.fc_fecha <= @@Ffin
																					and fc.fc_id in (select fc_id from #t_fc_ids)
					                              ),0)
		end				                as [Orden de Pago/NC Pendiente],
	
	  lgjnc.lgj_codigo          as [Orden de Pago/NC Legajo],
	  fc.fc_fecha               as [Factura Fecha],
	  docfc.doc_nombre          as [Documento de Compra],
	  fc.fc_nrodoc              as [Factura Comprobante],
	  fc.fc_numero              as [Factura Numero],
	  mon_nombre                as [Moneda],
	
	  case nc.est_id
			when 7 then 0
			else				fcnc_importe
		end				                as [Aplicacion],
	
		fc.fc_total               as [Factura Total],
	  0                         as [Factura Pendiente],
	  lgjfc.lgj_codigo          as [Factura Legajo],
	  0                       	as Orden
	  
	
	from
	
		FacturaCompra nc 		inner join Proveedor prov 								on nc.prov_id 			  	= prov.prov_id
												inner join Sucursal                       on nc.suc_id        		= Sucursal.suc_id
	                      inner join Documento docnc                on nc.doc_id        		= docnc.doc_id
	                      inner join Empresa                        on docnc.emp_id         = Empresa.emp_id 
	                      left  join Legajo lgjnc                   on nc.lgj_id        		= lgjnc.lgj_id
												left  join FacturaCompraNotaCredito fcnc  on nc.fc_id 			  		= fcnc.fc_id_notacredito
												left  join FacturaCompra fc               on fcnc.fc_id_factura   = fc.fc_id
												left  join Documento docfc                on fc.doc_id        		= docfc.doc_id
	                      left  join Moneda m                       on fc.mon_id        		= m.mon_id
	                      left  join Legajo lgjfc                   on fc.lgj_id        		= lgjfc.lgj_id
	where 
					  nc.fc_fecha >= @@Fini
				and	nc.fc_fecha <= @@Ffin 

	      and docnc.doct_id = 8 /* 8	Nota de Credito Compra */
	
				and nc.fc_id in (select fc_id from #t_fc_ids)

	--/////////////////////////////////////
	--	
	-- NOTAS DE CREDITO POR DEBITO AUTOMATICO
	--

	union all
	
  select 
	
		nc.fc_id     							as opg_id,
	  opg.opg_id								as fc_id,
		prov_nombre								as Proveedor,
	  emp_nombre                as Empresa, 
	  nc.fc_fecha								as [Orden de Pago/NC Fecha],
	  docnc.doc_nombre          as [Orden de Pago/NC],
	
	  case nc.est_id
			when 7 then nc.fc_nrodoc + ' (Anulada)'
			else	      nc.fc_nrodoc
		end												as [Orden de Pago/NC Comprobante],
	
	  nc.fc_numero              as [Orden de Pago/NC Numero],
	
	  case nc.est_id
			when 7 then 0
			else				nc.fc_total
		end				                as [Orden de Pago/NC Total],
	
	  case nc.est_id
			when 7 then 0
			else				nc.fc_total - IsNull((select sum(fcopg_importe) 
					                             from FacturaCompraOrdenPago fcopg inner join OrdenPago opg
																				 																  on fcopg.opg_id = opg.opg_id			
					                             where fcopg.fc_id = nc.fc_id
																			   and opg.opg_fecha <= @@Ffin
																				 and opg.opg_id in (select opg_id from #t_opg_da_ids)
					                             ),0)

		end				                as [Orden de Pago/NC Pendiente],
	
	  lgjnc.lgj_codigo          as [Orden de Pago/NC Legajo],
	  opg.opg_fecha             as [Factura Fecha],
	  docopg.doc_nombre         as [Documento de Compra],
	  opg.opg_nrodoc            as [Factura Comprobante],
	  opg.opg_numero            as [Factura Numero],
	  mon_nombre                as [Moneda],
	
	  case nc.est_id
			when 7 then 0
			else				fcopg_importe
		end				                as [Aplicacion],
	
		opg.opg_total             as [Factura Total],
	  0                         as [Factura Pendiente],
	  lgjopg.lgj_codigo         as [Factura Legajo],
	  0                       	as Orden
	  
	
	from
	
		FacturaCompra nc 		inner join Proveedor prov 								on nc.prov_id 			  	= prov.prov_id
												inner join Sucursal                       on nc.suc_id        		= Sucursal.suc_id
	                      inner join Documento docnc                on nc.doc_id        		= docnc.doc_id
	                      inner join Empresa                        on docnc.emp_id         = Empresa.emp_id 
	                      left  join Legajo lgjnc                   on nc.lgj_id        		= lgjnc.lgj_id
												left  join FacturaCompraOrdenPago fcopg   on nc.fc_id 			  		= fcopg.fc_id
												left  join OrdenPago opg                  on fcopg.opg_id         = opg.opg_id
												left  join Documento docopg               on opg.doc_id        		= docopg.doc_id
	                      left  join Moneda m                       on docopg.mon_id        = m.mon_id
	                      left  join Legajo lgjopg                  on opg.lgj_id        		= lgjopg.lgj_id
	where 
					  nc.fc_fecha >= @@Fini
				and	nc.fc_fecha <= @@Ffin 

	      and docnc.doct_id = 8 /* 8	Nota de Credito Compra */
	
				and nc.fc_id in (select fc_id from #t_nc_da_ids)
	
	--/////////////////////////////////////
	--	
	-- FACTURAS
	--

	union all
	
	select 
	
		0													as opg_id,
	  fc.fc_id									as fc_id,
		prov_nombre								as Proveedor,
	  emp_nombre                as Empresa, 
	  convert(datetime,'19000101')
				      								as [Orden de Pago/NC Fecha],
	  ''                        as [Orden de Pago/NC],
	  ''                        as [Orden de Pago/NC Comprobante],
	  null             					as [Orden de Pago/NC Numero],
	  0                					as [Orden de Pago/NC Total],
	  0            							as [Orden de Pago/NC Pendiente],
	  ''                        as [Orden de Pago/NC Legajo],

		fc_fecha									as [Factura Fecha],


	  docfc.doc_nombre          as [Documento de Compra],
	
	  case fc.est_id
			when 7 then fc_nrodoc + ' (Anulada)'
			else				fc_nrodoc
		end				                as [Factura Comprobante],
	
	  fc_numero                 as [Factura Numero],
	  mon_nombre                as [Moneda],
	
	  case 
			when fc.est_id = 7						then 	0

			when fc_totalcomercial = 0 
			 and fc_fechavto < getdate()
			 and fc_fechavto < @@Ffin			then 	fc_total

			when fc_totalcomercial = 0 
			 and (    fc_fechavto >= getdate()	
			       or fc_fechavto >= @@Ffin
						)    										then 	0

			else														 		
													 IsNull((select sum(fcnc_importe) 
			                               from FacturaCompraNotaCredito fcnc inner join FacturaCompra nc
																																		   on fcnc.fc_id_notacredito = nc.fc_id			
			                               where fcnc.fc_id_factura = fc.fc_id
																		   and nc.fc_fecha <= @@Ffin
																			 and nc.fc_id in (select fc_id from #t_fc_ids)
			                               ),0)
													 + IsNull((select sum(fcopg_importe) 
				                             from FacturaCompraOrdenPago fcopg inner join OrdenPago opg
																			 																  on fcopg.opg_id = opg.opg_id			
				                             where fcopg.fc_id = fc.fc_id
																		   and opg.opg_fecha <= @@Ffin
																			 and opg.opg_id in (select opg_id from #t_opg_ids)
				                             ),0)

		end				                as [Aplicacion],
	
	  case fc.est_id
			when 7 then 0
			else				fc_total
		end				                as [Factura Total],
	
	  case 
			when fc.est_id = 7 						then  0

			when fc_totalcomercial = 0 
			 and fc_fechavto < getdate()
			 and fc_fechavto < @@Ffin			then 	0

			when fc_totalcomercial = 0 
			 and (    fc_fechavto >= getdate()	
			       or fc_fechavto >= @@Ffin
						)    										then 	fc_total

			else				fc_total - IsNull((select sum(fcnc_importe) 
			                               from FacturaCompraNotaCredito fcnc inner join FacturaCompra nc
																																		   on fcnc.fc_id_notacredito = nc.fc_id			
			                               where fcnc.fc_id_factura = fc.fc_id
																		   and nc.fc_fecha <= @@Ffin
																			 and nc.fc_id in (select fc_id from #t_fc_ids)
			                               ),0)
													 - IsNull((select sum(fcopg_importe) 
				                             from FacturaCompraOrdenPago fcopg inner join OrdenPago opg
																			 																  on fcopg.opg_id = opg.opg_id			
				                             where fcopg.fc_id = fc.fc_id
																		   and opg.opg_fecha <= @@Ffin
																			 and opg.opg_id in (select opg_id from #t_opg_ids)
				                             ),0)
	
		end				                as [Factura Pendiente],
	
	  lgjfc.lgj_codigo          as [Factura Legajo],
	  1                       	as Orden
	
	from
	
		FacturaCompra fc 				inner join Proveedor prov 								on fc.prov_id 		= prov.prov_id
														inner join Sucursal                       on fc.suc_id      = Sucursal.suc_id
														inner join Documento docfc                on fc.doc_id      = docfc.doc_id
	                      		inner join Empresa                        on docfc.emp_id   = Empresa.emp_id 
			                      inner join Moneda m                       on fc.mon_id      = m.mon_id
	                          left  join Legajo lgjfc                   on fc.lgj_id      = lgjfc.lgj_id
	where 
					  fc_fecha >= @@Fini
				and	fc_fecha <= @@Ffin 

				and fc.est_id <> 7
	
			  and ( 	@@pendientes = 0
							or
								(fc_total - IsNull((select sum(fcnc_importe) 
		                               from FacturaCompraNotaCredito fcnc inner join FacturaCompra nc
																																	   on fcnc.fc_id_notacredito = nc.fc_id			
		                               where fcnc.fc_id_factura = fc.fc_id
																	   and nc.fc_fecha <= @@Ffin
																		 and nc.fc_id in (select fc_id from #t_fc_ids)
		                               ),0)
												 - IsNull((select sum(fcopg_importe) 
			                             from FacturaCompraOrdenPago fcopg inner join OrdenPago opg
																		 																  on fcopg.opg_id = opg.opg_id			
			                             where fcopg.fc_id = fc.fc_id
																	   and opg.opg_fecha <= @@Ffin
																		 and opg.opg_id in (select opg_id from #t_opg_ids)
			                             ),0))>0
						)
	
	      and docfc.doct_id in(2,10)  /* 8	Nota de Credito Compra */
	
				and fc.fc_id in (select fc_id from #t_fc_ids)
	
	--///////////////////////////////////////////////////////////////
	
	order by
	
		Proveedor, Orden, [Orden de Pago/NC Fecha], [Factura Fecha]
	
end

go