if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CashFlowGetSaldoInicialDetalle]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CashFlowGetSaldoInicialDetalle]

go

/*

sp_CashFlowGetSaldoInicialDetalle 0,0,'20090225 00:00:00',-1,-1,-1,-1,-1,-1,-1

*/
create procedure sp_CashFlowGetSaldoInicialDetalle (
	@@cf_id         int,
	@@cue_id    		int,
	@@fDesde 				datetime,

	@@fechacheque		smallint,
	@@fv						smallint,
	@@rv						smallint,
	@@pv						smallint,
	@@fc						smallint,
	@@rc						smallint,
	@@oc						smallint
)
as

begin

	set nocount on

--//////////////////////////////////////////////////////////////
--
--	VALIDACIONES A CASHFLOWITEM	
--
--//////////////////////////////////////////////////////////////

	declare @cfi_id  int
	declare @comp_id int
	declare @doct_id int
	
	declare c_cfi insensitive cursor for
	
		select comp_id, doct_id
		from CashFlowItem 
		group by comp_id, doct_id having count(*) > 1
	
	open c_cfi
	
	fetch next from c_cfi into @comp_id, @doct_id
	while @@fetch_status=0
	begin
	
		select @cfi_id = max(cfi_id) from CashFlowItem where comp_id = @comp_id and doct_id = @doct_id
	
		delete CashFlowItem where cfi_id = @cfi_id
	
		fetch next from c_cfi into @comp_id, @doct_id
	end
	
	close c_cfi
	deallocate c_cfi

--//////////////////////////////////////////////////////////////

	create table #t_cash_flow_si (
															cfi_id							int null,
															doct_id							int not null,
															comp_id							int not null,  -- En Cobranzas, Ordenes de Pago
																																 --    Facturas Compra y Venta
																																 --    y Movimiento de fondo es
																																 --    deuda o item y no el id del header

															Documento 					varchar(255),
															Tercero   					varchar(255),
															Comprobante					varchar(255),

															Fecha               datetime not null,
															Descrip             varchar(5000) not null,
                              Debe                decimal(18,6) not null,
                              Haber               decimal(18,6) not null,
                              Origen              decimal(18,6) not null,
															cheq_id             int null,
															tjcc_id             int null,
															cli_id              int null,
															prov_id             int null,
															Excluir             tinyint not null,
															Excluir2            tinyint not null,
															importe_real        decimal(18,6) not null,
															fecha_real          datetime
														)

	-- Sino indico cuenta vamos a devolver FC, OP, FV, COBZ, 
  -- MF con cuec_id in (
	--										Caja, 
	--										Banco, 
	--										Documentos en Cartera, 
	--										Acreedores por Compras, 
	--										Deudores por Ventas,
	--                    Cupones Presentados
	--									 )
	-- 

	if isnull(@@cue_id,0) = 0
	begin

		declare @hoy 					datetime
		declare @cotiz  			decimal(18,6)
		declare @mon_legal		int
		declare @mon_id       int
	
		set @hoy = getdate()
		set @hoy = dateadd(hh,-datepart(hh,@hoy),@hoy)
		set @hoy = dateadd(n,-datepart(n,@hoy),@hoy)
		set @hoy = dateadd(s,-datepart(s,@hoy),@hoy)
		set @hoy = dateadd(ms,-datepart(ms,@hoy),@hoy)
		
		create table #t_cotizacion (
																	mon_id			int,
																	cotizacion	decimal(18,6)
																)

		declare c_monedas insensitive cursor for select mon_id from Moneda where mon_legal = 0

		open c_monedas

		fetch next from c_monedas into @mon_id
		while @@fetch_status = 0
		begin

			exec sp_MonedaGetCotizacion @mon_id, @hoy, 0, @cotiz out

			insert into #t_cotizacion (mon_id, cotizacion) values (@mon_id, @cotiz)

			fetch next from c_monedas into @mon_id
		end

		close c_monedas
		deallocate c_monedas

		select @mon_legal = mon_id from Moneda where mon_legal <> 0

		insert into #t_cotizacion (mon_id, cotizacion) values (@mon_legal, 1)

		create table #t_cash_flow (
																cfi_id							int null,
																doct_id							int not null,
																comp_id							int not null,  -- En Cobranzas, Ordenes de Pago
																																	 --    Facturas Compra y Venta
																																	 --    y Movimiento de fondo es
																																	 --    deuda o item y no el id del header

																comp_id2            int,					 -- Usamos este para los casos de arriba

																Fecha               datetime not null,
																Descrip             varchar(5000) not null,
                                Debe                decimal(18,6) not null,
                                Haber               decimal(18,6) not null,
                                Origen              decimal(18,6) not null,
																cheq_id             int null,
																tjcc_id             int null,
																cli_id              int null,
																prov_id             int null,
																Excluir             tinyint not null,
																Excluir2            tinyint not null,
																importe_real        decimal(18,6) not null,
																fecha_real          datetime
															)

			--//////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	CHEQUEAMOS LA INTEGRIDAD DE LA TABLA DE PARAMETROS
			--
			--//////////////////////////////////////////////////////////////////////////////////////////////////

			if exists(select cli_id from CashFlowParam where cf_id = @@cf_id group by cli_id having count(*)>1)
			begin
		
				delete CashFlowParam 
				where cf_id = @@cf_id 
					and cli_id in (select cli_id from CashFlowParam 
													where cf_id = @@cf_id 
													group by cli_id having count(*)>1
												)
			end
		
			if exists(select prov_id from CashFlowParam where cf_id = @@cf_id group by prov_id having count(*)>1)
			begin
		
				delete CashFlowParam 
				where cf_id = @@cf_id 
					and prov_id in (select prov_id from CashFlowParam 
													where cf_id = @@cf_id 
													group by prov_id having count(*)>1
												)
			end
		
			if exists(select bco_id from CashFlowParam where cf_id = @@cf_id group by bco_id having count(*)>1)
			begin
		
				delete CashFlowParam 
				where cf_id = @@cf_id 
					and bco_id in (select bco_id from CashFlowParam 
													where cf_id = @@cf_id 
													group by bco_id having count(*)>1
												)
			end


--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			DETALLE DE SALDOS INICIALES
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--			ASIENTOS CONTABLES - QUE AFECTAN LAS CUENTAS DE DISPONIBILIDADES 
		--													 (CAJA, BANCOS, DOCUMENTOS EN CARTERA)
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
								--
								--		Categorias de Cuentas
								--
								-- 					1		Documentos en Cartera
								-- 					2		Bancos
								-- 					14	Caja

-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 					
-- 				select  ast.doct_id,
-- 								asi_id,
-- 								doc_nombre    as Documento,
-- 								''            as Tercero,
-- 								as_nrodoc     as Comprobante,
-- 								as_fecha 			as Fecha,
-- 								as_descrip    as Descrip,
-- 		
-- 								isnull(case when asi_debe <> 0 then isnull(cfi_importe,asi_debe) 
-- 																else 0 
-- 														end
-- 												,0)	as Debe,
-- 								isnull(case when asi_haber <> 0 then isnull(cfi_importe,asi_haber) 
-- 																else 0 
-- 														end
-- 												,0)	as Haber,
-- 
-- 								0						as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								0  										as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from Asiento ast 				Inner join AsientoItem asi 				 on		ast.as_id  = asi.as_id
-- 																Inner join Cuenta cue							 on 	asi.cue_id = cue.cue_id
-- 																																		and	cue.cuec_id in (1,	-- Documentos en Cartera
-- 																																												2,	-- Bancos
-- 																																												4,	-- Deudores por venta
-- 																																												8,	-- Acreedores por compras
-- 																																												14,	-- Caja
-- 																																												19	-- Cupones Presentados
-- 																																												)
-- 
-- 										 						left join CashFlowItem cfi 				 on 		cfi.cf_id = @@cf_id 
-- 																																			and cfi.comp_id = asi.asi_id 		
-- 																																			and cfi.doct_id = 15
-- 
-- 																left join Cheque cheq        on asi.cheq_id 		 = cheq.cheq_id
-- 																left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
-- 																																and cfp2.bco_id  = cheq.bco_id
-- 
-- 																left join Documento doc on ast.doc_id = doc.doc_id
-- 
-- 				where (			(isnull(cfi_fecha,as_fecha) 					< @@fDesde and (@@fechacheque = 0 or asi.cheq_id is null))
-- 								or	(isnull(cfi_fecha,cheq.cheq_fecha2) 	< @@fDesde and @@fechacheque <> 0)
-- 							)
-- 
-- 					and doc_id_cliente is null
		

		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--			ORDENES DE COMPRA
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		if @@oc <> 0 begin
		
				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
		
				select  oc.doct_id,
								oc.oc_id,
								doc_nombre    as Documento,
								prov_nombre   as Tercero,
								oc_nrodoc     as Comprobante,
								oc_fecha 			as Fecha,
								oc_descrip		as Descrip,		
		
								isnull(case oc.doct_id
										when 36 then isnull(cfi_importe,oc_pendiente * coti.cotizacion)
										else				0
								end,0) 					as Debe,

								isnull(case oc.doct_id
										when 36 then 0
										else				isnull(cfi_importe,oc_pendiente * coti.cotizacion)
								end,0) 					as Haber,

								isnull(case 
									when doc.mon_id <> @mon_legal then isnull(cfi_importe,oc_pendiente) 
									else															 0
								end,0)						as Origen, 

								isnull(cfi_excluir,0) as Excluir,
								isnull(cfp.cfp_id,0)  as Excluir2,

								0,@@fDesde
		
				from OrdenCompra oc left join CashFlowItem cfi on 		cfi.cf_id 	= @@cf_id 
																													and cfi.comp_id = oc.oc_id 		
																													and cfi.doct_id in (35,36)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.prov_id = oc.prov_id

													left join Documento doc on oc.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

													left join Proveedor prov on oc.prov_id = prov.prov_id

				where isnull(cfi_fecha,oc_fecha) < @@fDesde
					and	est_id <> 7
					and oc_pendiente >= 0.01

		end
		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--			REMITOS DE COMPRA
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		if @@rc <> 0 begin
		
				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
		
				select  rc.doct_id,
								rc.rc_id,
								doc_nombre    as Documento,
								prov_nombre   as Tercero,
								rc_nrodoc     as Comprobante,
								rc_fecha 			as Fecha,
								rc_descrip		as Descrip,
		
								isnull(case rc.doct_id
										when 25 then isnull(cfi_importe,rc_pendiente * coti.cotizacion)
										else				0
								end,0) 					as Debe,

								isnull(case rc.doct_id
										when 25 then 0
										else				isnull(cfi_importe,rc_pendiente * coti.cotizacion)
								end,0) 					as Haber,
		
								isnull(case 
									when doc.mon_id <> @mon_legal then isnull(cfi_importe,rc_pendiente) 
									else															 0
								end,0)						as Origen, 
								
								isnull(cfi_excluir,0) as Excluir,
								isnull(cfp.cfp_id,0)  as Excluir2,

								0,@@fDesde
		
				from RemitoCompra rc left join CashFlowItem cfi on 	cfi.cf_id = @@cf_id 
																												and cfi.comp_id = rc.rc_id 		
																												and cfi.doct_id in (4,25)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.prov_id = rc.prov_id

													left join Documento doc on rc.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

													left join Proveedor prov on rc.prov_id = prov.prov_id

				where isnull(cfi_fecha,rc_fecha) < @@fDesde
					and	est_id <> 7
					and rc_pendiente >= 0.01

		end
		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--			FACTURAS DE COMPRA
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		if @@fc <> 0 begin
		
				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
		
				select  fc.doct_id,
								fcd_id,
								doc_nombre    as Documento,
								prov_nombre   as Tercero,
								fc_nrodoc     as Comprobante,
								fcd_fecha			as Fecha,
								fc_descrip  	as Descrip,
		
								isnull(case fc.doct_id
										when 8 then isnull(cfi_importe,fcd_pendiente)
										else				0
								end,0) 					as Debe,

								isnull(case fc.doct_id
										when 8 then 0
										else				isnull(cfi_importe,fcd_pendiente)
								end,0) 					as Haber,

								0						  		as Origen,
								
								isnull(cfi_excluir,0) as Excluir,
								isnull(cfp.cfp_id,0)  as Excluir2,

								0,@@fDesde
		
				from FacturaCompra fc inner join FacturaCompraDeuda fcd on fc.fc_id = fcd.fc_id
										 					left  join CashFlowItem cfi 			on 		cfi.cf_id = @@cf_id 
																																	and cfi.comp_id = fcd.fcd_id 		
																																	and cfi.doct_id in (2,8,10)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.prov_id = fc.prov_id

													left join Documento doc on fc.doc_id = doc.doc_id
													left join Proveedor prov on fc.prov_id = prov.prov_id

				where isnull(cfi_fecha,fcd_fecha2) < @@fDesde
					and	est_id <> 7
					and fcd_pendiente >= 0.01

		end
		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--			PEDIDOS DE VENTA
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		if @@pv <> 0 begin
		
				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
		
				select  pv.doct_id,
								pv.pv_id,
								doc_nombre    as Documento,
								cli_nombre    as Tercero,
								pv_nrodoc     as Comprobante,
								pv_fecha 			as Fecha,
								pv_descrip		as Descrip,
		
								isnull(case pv.doct_id
										when 22 then 0
										else				 isnull(cfi_importe,pv_pendiente * coti.cotizacion)
								end,0) 					as Debe,
		
								isnull(case pv.doct_id
										when 22 then isnull(cfi_importe,pv_pendiente * coti.cotizacion)
										else				 0
								end,0) 					as Haber,
								isnull(case 
									when doc.mon_id <> @mon_legal then isnull(cfi_importe,pv_pendiente) 
									else															 0
								end,0)						as Origen, 
								
								isnull(cfi_excluir,0) as Excluir,
								isnull(cfp.cfp_id,0)  as Excluir2,

								0,@@fDesde
		
				from PedidoVenta pv left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																													and cfi.comp_id = pv.pv_id 		
																													and cfi.doct_id in (5,22)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.cli_id  = pv.cli_id

													left join Documento doc on pv.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

													left join Cliente cli on pv.cli_id = cli.cli_id

				where isnull(cfi_fecha,pv_fecha) < @@fDesde
					and	est_id <> 7
					and pv_pendiente >= 0.01

		end
		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--			REMITOS DE VENTA
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		if @@rv <> 0 begin
		
				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
		
				select  rv.doct_id,
								rv.rv_id,
								doc_nombre    as Documento,
								cli_nombre    as Tercero,
								rv_nrodoc     as Comprobante,
								rv_fecha 			as Fecha,
								rv_descrip 		as Descrip,
		
								isnull(case rv.doct_id
										when 24 then 0
										else				 isnull(cfi_importe,rv_pendiente * coti.cotizacion)
								end,0) 					as Debe,
		
								isnull(case rv.doct_id
										when 24 then isnull(cfi_importe,rv_pendiente * coti.cotizacion)
										else				 0
								end,0) 					as Haber,
								isnull(case 
									when doc.mon_id <> @mon_legal then isnull(cfi_importe,rv_pendiente) 
									else															 0
								end,0)						as Origen, 

								
								isnull(cfi_excluir,0) as Excluir,
								isnull(cfp.cfp_id,0)  as Excluir2,

								0,@@fDesde
		
				from RemitoVenta rv left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																													and	cfi.comp_id = rv.rv_id 		
																													and cfi.doct_id in (3,24)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.cli_id  = rv.cli_id

													left join Documento doc on rv.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

													left join Cliente cli on rv.cli_id = cli.cli_id

				where isnull(cfi_fecha,rv_fecha) < @@fDesde
					and	est_id <> 7
					and rv_pendiente >= 0.01

		end
		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--			FACTURAS DE VENTA
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		if @@fv <> 0 begin
		
				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
					
				select  fv.doct_id,
								fvd_id,
								doc_nombre    as Documento,
								cli_nombre    as Tercero,
								fv_nrodoc     as Comprobante,
								fvd_fecha			as Fecha,
								fv_fecha			as Descrip,
		
								isnull(case fv.doct_id
										when 7 then 0
										else				isnull(cfi_importe,fvd_pendiente)
								end,0) 					as Debe,
		
								isnull(case fv.doct_id
										when 7 then isnull(cfi_importe,fvd_pendiente)
										else				0
								end,0) 					as Haber,
								0						  		as Origen,
								
								isnull(cfi_excluir,0) as Excluir,
								isnull(cfp.cfp_id,0)  as Excluir2,

								0,@@fDesde
		
				from FacturaVenta fv inner join FacturaVentaDeuda fvd on fv.fv_id = fvd.fv_id
										 				 left  join CashFlowItem cfi 			on 		cfi.cf_id = @@cf_id 
																																and cfi.comp_id = fvd.fvd_id 		
																																and cfi.doct_id in (1,7,9)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.cli_id  = fv.cli_id

														left join Documento doc on fv.doc_id = doc.doc_id
													  left join Cliente cli on fv.cli_id = cli.cli_id

				where isnull(cfi_fecha,fvd_fecha2) < @@fDesde
					and	est_id <> 7
					and fvd_pendiente >= 0.01

		end		
		--/////////////////////////////////////////////////////////////////////////////////////////
		--
		--
		--			MOVIMIENTOS DE FONDO
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 					
-- 				select  mf.doct_id,
-- 								mfi_id,
-- 								doc_nombre    as Documento,
-- 								''            as Tercero,
-- 								mf_nrodoc     as Comprobante,
-- 								mf_fecha 			as Fecha,
-- 								mfi_descrip   as Descrip,
-- 		
-- 								isnull(isnull(cfi_importe,mfi_importe),0)	as Debe,
-- 								0 								as Haber,
-- 								0									as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from MovimientoFondo mf Inner join MovimientoFondoItem mfi on		mf.mf_id 				= mfi.mf_id
-- 																Inner join Cuenta cue							 on 	mfi.cue_id_debe = cue.cue_id
-- 																																		and	cue.cuec_id in (1,	-- Documentos en Cartera
-- 																																												2,	-- Bancos
-- 																																												4,	-- Deudores por venta
-- 																																												8,	-- Acreedores por compras
-- 																																												14,	-- Caja
-- 																																												19	-- Cupones Presentados
-- 																																												)
-- 
-- 										 						left join CashFlowItem cfi 				 on 		cfi.cf_id = @@cf_id 
-- 																																			and cfi.comp_id = mfi.mfi_id 		
-- 																																			and cfi.doct_id = 26
-- 
-- 																left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																																and cfp.cli_id  = mf.cli_id
-- 
-- 																left join Cheque cheq        on mfi.cheq_id 		 = cheq.cheq_id
-- 																left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
-- 																																and cfp2.bco_id  = cheq.bco_id
-- 
-- 																left join Documento doc on mf.doc_id = doc.doc_id
-- 
-- 				where (			(isnull(cfi_fecha,mf_fecha) 					< @@fDesde and (@@fechacheque = 0 or mfi.cheq_id is null))
-- 								or	(isnull(cfi_fecha,cheq.cheq_fecha2) 	< @@fDesde and @@fechacheque <> 0)
-- 							)
-- 					and	est_id <> 7
-- 
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  mf.doct_id,
-- 								mfi_id,
-- 								doc_nombre    as Documento,
-- 								''            as Tercero,
-- 								mf_nrodoc     as Comprobante,
-- 								mf_fecha 			as Fecha,
-- 								mfi_descrip   as Descrip,
-- 		
-- 								0									as Debe,
-- 								isnull(isnull(cfi_importe,mfi_importe),0) 	as Haber,
-- 								0									as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from MovimientoFondo mf Inner join MovimientoFondoItem mfi on		mf.mf_id 				 = mfi.mf_id
-- 																Inner join Cuenta cue							 on 	mfi.cue_id_haber = cue.cue_id
-- 																																		and	cue.cuec_id in (1,	-- Documentos en Cartera
-- 																																												2,	-- Bancos
-- 																																												4,	-- Deudores por venta
-- 																																												8,	-- Acreedores por compras
-- 																																												14,	-- Caja
-- 																																												19	-- Cupones Presentados
-- 																																												)
-- 										 						left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
-- 																															and cfi.comp_id = mfi.mfi_id 		
-- 																															and cfi.doct_id = 26
-- 
-- 																left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																																and cfp.cli_id  = mf.cli_id
-- 
-- 																left join Cheque cheq        on mfi.cheq_id 		 = cheq.cheq_id
-- 																left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
-- 																																and cfp2.bco_id  = cheq.bco_id
-- 
-- 																left join Documento doc on mf.doc_id = doc.doc_id
-- 
-- 				where isnull(cfi_fecha,mf_fecha) < @@fDesde
-- 					and	est_id <> 7
-- 
-- 		
-- 		--/////////////////////////////////////////////////////////////////////////////////////////
-- 		--
-- 		--
-- 		--			COBRANZAS
-- 		--
-- 		--
-- 		--/////////////////////////////////////////////////////////////////////////////////////////
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  cobz.doct_id,
-- 								cobzi_id,
-- 								doc_nombre    as Documento,
-- 								cli_nombre    as Tercero,
-- 								cobz_nrodoc   as Comprobante,
-- 								cobz_fecha		as Fecha,
-- 								cobzi_descrip as Descrip,
-- 		
-- 								isnull(isnull(cfi_importe,cobzi_importe),0)	as Debe,
-- 								0 									as Haber,
-- 								0										as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from Cobranza cobz Inner join CobranzaItem cobzi on		cobz.cobz_id 	= cobzi.cobz_id
-- 																													and cobzi_tipo 		= 2 -- Efectivo
-- 																														
-- 										 			 left join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
-- 																														and cfi.comp_id = cobzi.cobzi_id 
-- 																														and cfi.doct_id = 13
-- 
-- 														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																														and cfp.cli_id  = cobz.cli_id
-- 
-- 														left join Documento doc on cobz.doc_id = doc.doc_id
-- 														left join Cliente cli on cobz.cli_id = cli.cli_id
-- 	
-- 				where isnull(cfi_fecha,cobz_fecha) < @@fDesde
-- 					and	est_id <> 7
-- 
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  cobz.doct_id,
-- 								cobzi_id,
-- 								doc_nombre    as Documento,
-- 								cli_nombre    as Tercero,
-- 								cobz_nrodoc   as Comprobante,
-- 								cobz_fecha		as Fecha,
-- 								cobz_descrip  as Descrip,
-- 		
-- 								isnull(case cobzi_otroTipo
-- 									when 1 then isnull(cfi_importe,cobzi_importe)
-- 									else        0
-- 								end,0)									as Debe,
-- 								isnull(case cobzi_otroTipo
-- 									when 2 then isnull(cfi_importe,cobzi_importe)
-- 									else        0
-- 								end,0)									as Haber,
-- 								0												as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from Cobranza cobz Inner join CobranzaItem cobzi on		cobz.cobz_id 		= cobzi.cobz_id
-- 																													and cobzi_tipo 			= 4 -- Otros
-- 																														
-- 										 			 left  join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
-- 																													and cfi.comp_id = cobzi.cobzi_id 
-- 																													and cfi.doct_id = 13
-- 
-- 														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																														and cfp.cli_id  = cobz.cli_id
-- 
-- 														left join Documento doc on cobz.doc_id = doc.doc_id
-- 														left join Cliente cli on cobz.cli_id = cli.cli_id
-- 
-- 				where isnull(cfi_fecha,cobz_fecha) < @@fDesde
-- 					and	est_id <> 7
-- 
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  cobz.doct_id,
-- 								cobzi_id,
-- 								doc_nombre    as Documento,
-- 								cli_nombre    as Tercero,
-- 								cobz_nrodoc   as Comprobante,
-- 								cobz_fecha	  as Fecha,
-- 								cobzi_descrip	as Descrip,
-- 		
-- 								isnull(isnull(cfi_importe,cobzi_importe),0)	as Debe,
-- 								0 									as Haber,
-- 								0										as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from Cobranza cobz Inner join CobranzaItem cobzi on		cobz.cobz_id  = cobzi.cobz_id
-- 													 Inner join Cheque cheq        on   cobzi.cheq_id = cheq.cheq_id 
-- 																														
-- 										 			 left  join CashFlowItem cfi 	 on 	cfi.cf_id = @@cf_id 
-- 																													and cfi.comp_id = cobzi.cobzi_id 
-- 																													and cfi.doct_id = 13
-- 
-- 														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																														and cfp.cli_id  = cobz.cli_id
-- 	
-- 														left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
-- 																														and cfp2.bco_id  = cheq.bco_id
-- 
-- 														left join Documento doc on cobz.doc_id = doc.doc_id
-- 														left join Cliente cli on cobz.cli_id = cli.cli_id
-- 
-- 				where (			(isnull(cfi_fecha,cheq_fecha2) 	< @@fDesde and @@fechacheque <> 0) 
-- 								or 	(isnull(cfi_fecha,cobz_fecha)		< @@fDesde and @@fechacheque = 0 )
-- 							)
-- 					and	est_id <> 7
-- 
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  cobz.doct_id,
-- 								cobzi_id,
-- 								doc_nombre    as Documento,
-- 								cli_nombre    as Tercero,
-- 								cobz_nrodoc   as Comprobante,
-- 								cobz_fecha	  as Fecha,
-- 								cobzi_descrip as Descrip,
-- 		
-- 								isnull(isnull(cfi_importe,cobzi_importe),0)	as Debe,
-- 								0 									as Haber,
-- 								0										as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from Cobranza cobz Inner join CobranzaItem cobzi 				on	 cobz.cobz_id  = cobzi.cobz_id
-- 													 Inner join TarjetaCreditoCupon tjcc  on   cobzi.tjcc_id = tjcc.tjcc_id 
-- 		
-- 										 			 left  join CashFlowItem cfi 					on 		cfi.cf_id = @@cf_id 
-- 																																	and cfi.comp_id = cobzi.cobzi_id 
-- 																																	and cfi.doct_id = 13
-- 
-- 														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																														and cfp.cli_id  = cobz.cli_id
-- 
-- 														left join Documento doc on cobz.doc_id = doc.doc_id
-- 														left join Cliente cli on cobz.cli_id = cli.cli_id
-- 	
-- 							-- Asumimos que todos los cupones son en una sola 
-- 							-- cuota y se cobran a los 20 dias																												
-- 							--
-- 				where isnull(cfi_fecha,dateadd(d,20,cobz_fecha)) < @@fDesde
-- 					and	est_id <> 7
-- 
-- 		
-- 		--/////////////////////////////////////////////////////////////////////////////////////////
-- 		--
-- 		--
-- 		--			ORDENES DE PAGO
-- 		--
-- 		--
-- 		--/////////////////////////////////////////////////////////////////////////////////////////
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  opg.doct_id,
-- 								opgi_id,
-- 								doc_nombre    as Documento,
-- 								prov_nombre   as Tercero,
-- 								opg_nrodoc    as Comprobante,
-- 								opg_fecha   	as Fecha,
-- 								opgi_descrip  as Descrip,
-- 		
-- 								0 									as Debe,
-- 								isnull(isnull(cfi_importe,opgi_importe),0)	as Haber,
-- 								0										as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from OrdenPago opg Inner join OrdenPagoItem opgi on		opg.opg_id 	= opgi.opg_id
-- 																													and opgi_tipo 		= 2 -- Efectivo
-- 																														
-- 										 			 left join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
-- 																														and cfi.comp_id = opgi.opgi_id 	
-- 																														and cfi.doct_id = 16
-- 
-- 														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																														and cfp.prov_id = opg.prov_id
-- 
-- 														left join Documento doc on opg.doc_id = doc.doc_id
-- 														left join Proveedor prov on opg.prov_id = prov.prov_id
-- 	
-- 				where isnull(cfi_fecha,opg_fecha) < @@fDesde
-- 					and	est_id <> 7
-- 
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  opg.doct_id,
-- 								opgi_id,
-- 								doc_nombre    as Documento,
-- 								prov_nombre   as Tercero,
-- 								opg_nrodoc    as Comprobante,
-- 								opg_fecha   	as Fecha,
-- 								opgi_descrip  as Descrip,
-- 		
-- 								isnull(case opgi_otroTipo
-- 									when 1 then isnull(cfi_importe,opgi_importe)
-- 									else        0
-- 								end,0)								as Debe,
-- 								isnull(case opgi_otroTipo
-- 									when 2 then isnull(cfi_importe,opgi_importe)
-- 									else        0
-- 								end,0)								as Haber,
-- 								0											as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from OrdenPago opg Inner join OrdenPagoItem opgi on		opg.opg_id 		= opgi.opg_id
-- 																													and opgi_tipo 		= 4 -- Otros
-- 																														
-- 										 			 left join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
-- 																														and cfi.comp_id = opgi.opgi_id 	
-- 																														and cfi.doct_id = 16
-- 
-- 														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																														and cfp.prov_id = opg.prov_id
-- 
-- 														left join Documento doc on opg.doc_id = doc.doc_id
-- 														left join Proveedor prov on opg.prov_id = prov.prov_id
-- 
-- 	
-- 				where isnull(cfi_fecha,opg_fecha) < @@fDesde
-- 					and	est_id <> 7
-- 
-- 		
-- 				insert into #t_cash_flow_si (doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real)
-- 		
-- 				select  opg.doct_id,
-- 								opgi_id,
-- 								doc_nombre    as Documento,
-- 								prov_nombre   as Tercero,
-- 								opg_nrodoc    as Comprobante,
-- 								opg_fecha   	as Fecha,
-- 								opgi_descrip  as Descrip,
-- 
-- 								0              as Debe,
-- 								isnull(isnull(cfi_importe,opgi_importe),0) as Haber,
-- 								0							 as Origen,
-- 								
-- 								isnull(cfi_excluir,0) as Excluir,
-- 								isnull(cfp.cfp_id,0)  as Excluir2,
-- 
-- 								0,@@fDesde
-- 		
-- 				from OrdenPago opg Inner join OrdenPagoItem opgi on		opg.opg_id   = opgi.opg_id
-- 													 Inner join Cheque cheq        on   opgi.cheq_id = cheq.cheq_id 
-- 																														
-- 										 			 left  join CashFlowItem cfi   on 		cfi.cf_id = @@cf_id 
-- 																														and cfi.comp_id = opgi.opgi_id 	
-- 																														and cfi.doct_id = 16
-- 
-- 														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
-- 																														and cfp.prov_id = opg.prov_id
-- 	
-- 														left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
-- 																														and cfp2.bco_id  = cheq.bco_id
-- 
-- 														left join Documento doc on opg.doc_id = doc.doc_id
-- 														left join Proveedor prov on opg.prov_id = prov.prov_id
-- 
-- 				where (			(isnull(cfi_fecha,cheq_fecha2) 	< @@fDesde and @@fechacheque <> 0) 
-- 								or 	(isnull(cfi_fecha,opg_fecha) 		< @@fDesde and @@fechacheque = 0)
-- 							)
-- 					and	est_id <> 7

	end

	select t.*, doct_codigo as [Tipo Doc.]
	from 
	#t_cash_flow_si t left join DocumentoTipo doct on t.doct_id = doct.doct_id
	order by Fecha
end				