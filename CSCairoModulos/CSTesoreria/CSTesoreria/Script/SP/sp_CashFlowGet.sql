if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CashFlowGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CashFlowGet]

go

/*

 Agregar un movimiento de retencio para cada mes en el entre fechas
 para retenciones a pagar el 13 de cada mes (solo para op en opgi_tipo = 4).

 Tarjetas de credito, agregar a tarjeta tipo (ventas, compras) cuando es compra
 solo pide cuenta de banco. Y presenta una grilla de vencimientos y corte que se usa en
 el cashflow para generar un movimiento con todas los pagos de la tarjeta.

 Inmovilizar el panel en la grilla del cashflow.

*/
create procedure sp_CashFlowGet  (
	@@cf_id         int,
	@@cue_id    		int,
	@@fDesde 				datetime,
	@@fHasta				datetime,

	@@fechacheque		smallint,
	@@fv						smallint,
	@@rv						smallint,
	@@pv						smallint,
	@@fc						smallint,
	@@rc						smallint,
	@@oc						smallint,

	@@bIsForMatrix  tinyint = 0
)
as

begin

	set nocount on

	-- Para incluir movimientos que pueden estar guardados con info de hora
	--
	set @@fHasta = dateadd(d,1,@@fHasta)
	set @@fHasta = dateadd(n,-1,@@fHasta)

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

		if @@bIsForMatrix = 0 begin

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
																	cue_id              int null,
																	Excluir             tinyint not null,
																	Excluir2            tinyint not null,
																	importe_real        decimal(18,6) not null,
																	fecha_real          datetime
																)

			end
	
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
--			SALDOS INICIALES
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

		if @@bIsForMatrix = 0 begin

			declare @saldo_ini										decimal(18,6)
			declare @saldo_ini_disponibilidades		decimal(18,6)
			declare @saldo_ini_pendiente					decimal(18,6)

			declare @fecha_desde_saldo datetime
			set @fecha_desde_saldo = @@fDesde --dateadd(d,-1,@@fDesde)
	
			exec sp_CashFlowGetCuentaSaldo @@cf_id, @fecha_desde_saldo, 1, @saldo_ini_disponibilidades out
	
			exec sp_CashFlowGetSaldoInicialDetalle  @@cf_id         ,
																							@@cue_id    		,
																							@fecha_desde_saldo,
																						
																							@@fechacheque		,
																							@@fv						,
																							@@rv						,
																							@@pv						,
																							@@fc						,
																							@@rc						,
																							@@oc						,
																							1, 
																							@saldo_ini_pendiente out
	
			set @saldo_ini = @saldo_ini_disponibilidades + @saldo_ini_pendiente

			select  @saldo_ini as saldo_inicial, 0 as saldo_ini_excluido

		end
--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			A FUTURO ENTRE FECHAS
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
						-- 					1	Documentos en Cartera
						-- 					2	Bancos
						-- 					14	Caja

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cheq_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)
			
		select  cfi_id,
						ast.doct_id,
						asi_id,
						ast.as_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,as_fecha)			
							else				isnull(cfi_fecha,isnull(cheq.cheq_fecha2,as_fecha))			
						end								as Fecha,

						as_descrip    		as Descrip,

						case when asi_debe <>  0 then isnull(cfi_importe,asi_debe)
								 else 0
						end				as Debe,

						case when asi_haber <>  0 then isnull(cfi_importe,asi_haber)
								 else 0
						end				as Haber,

						isnull(cfi_importe,asi_origen)	as Origen,

						asi.cheq_id,
						isnull(cfi_excluir,0),
						0 as cfp_id,
						asi_debe - asi_haber,
						case @@fechacheque
							when 0 then	as_fecha
							else				isnull(cheq.cheq_fecha2,as_fecha)
						end,

						asi.cue_id

		from Asiento ast 				Inner join AsientoItem asi 				 on		ast.as_id 	= asi.as_id
														Inner join Cuenta cue							 on 	asi.cue_id  = cue.cue_id
																																and	cue.cuec_id in (1,	-- Documentos en Cartera
																																										2,	-- Bancos
																																										4,	-- Deudores por venta
																																										8,	-- Acreedores por compras
																																										14,	-- Caja
																																										19	-- Cupones Presentados
																																										)
														left join Cheque cheq              on asi.cheq_id = cheq.cheq_id

										 				left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																													and cfi.comp_id = asi.asi_id 		
																													and cfi.doct_id = 15

														left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
																														and cfp2.bco_id  = cheq.bco_id

		where (			(isnull(cfi_fecha,as_fecha) 				between @@fDesde and @@fHasta and (@@fechacheque = 0 or asi.cheq_id is null))
						or	(isnull(cfi_fecha,cheq.cheq_fecha2) between @@fDesde and @@fHasta and @@fechacheque <> 0)
					)

					and doc_id_cliente is null

--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			ORDENES DE COMPRA
--
--
--/////////////////////////////////////////////////////////////////////////////////////////
		if @@oc <> 0 begin

			insert into #t_cash_flow (cfi_id, doct_id, comp_id, Fecha, Descrip, Debe, Haber, Origen, prov_id, Excluir, Excluir2, importe_real, fecha_real)
	
			select  cfi_id,
							oc.doct_id,
							oc.oc_id,
							case when isnull(cfi_fecha,oc_fecha) > '19000101' then isnull(cfi_fecha,oc_fecha)
								 else                                              oc_fecha
							end 														as Fecha,
							oc_descrip    									as Descrip,	
	
							case oc.doct_id
									when 36 then oc_pendiente * coti.cotizacion
									else				 0
							end 					as Debe,

							case oc.doct_id
									when 36 then 0
									else				 oc_pendiente * coti.cotizacion
							end 					as Haber,

							0						  as Origen, 
							oc.prov_id,
							isnull(cfi_excluir,0),
							isnull(cfp.cfp_id,0),
							oc_pendiente, 
							oc_fecha
	
			from OrdenCompra oc left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																												and cfi.comp_id = oc.oc_id 		
																												and cfi.doct_id in (35,36)

													left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																												and cfp.prov_id = oc.prov_id

													left join Documento doc on oc.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

			where case when isnull(cfi_fecha,oc_fecha) > '19000101' then isnull(cfi_fecha,oc_fecha)
								 else                                              oc_fecha
						end
									between @@fDesde and @@fHasta
				and	est_id <> 7
				and abs(oc_pendiente) >= 0.01

		end
--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			REMITOS DE COMPRA
--
--
--/////////////////////////////////////////////////////////////////////////////////////////
		if @@rc <> 0 begin

			insert into #t_cash_flow (cfi_id, doct_id, comp_id, Fecha, Descrip, Debe, Haber, Origen, prov_id, Excluir, Excluir2, importe_real, fecha_real)
	
			select  cfi_id,
							rc.doct_id,
							rc.rc_id,
							isnull(cfi_fecha,rc_fecha)			as Fecha,
							rc_descrip    									as Descrip,
	
							case rc.doct_id
									when 25 then rc_pendiente * coti.cotizacion
									else				 0
							end 					as Debe,

							case rc.doct_id
									when 25 then 0
									else				 rc_pendiente * coti.cotizacion
							end 					as Haber,

							case 
								when rc_cotizacion > 0 then isnull(cfi_importe,rc_pendiente) / rc_cotizacion
								else												0
							end						as Origen, 
							rc.prov_id,
							isnull(cfi_excluir,0),
							isnull(cfp.cfp_id,0),
							rc_pendiente,
							rc_fecha
	
			from RemitoCompra rc left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																												and cfi.comp_id = rc.rc_id 		
																												and cfi.doct_id in (4,25)

													 left join CashFlowParam cfp on 	cfp.cf_id   = @@cf_id
																												and cfp.prov_id = rc.prov_id

													left join Documento doc on rc.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

			where isnull(cfi_fecha,rc_fecha) between @@fDesde and @@fHasta
				and	est_id <> 7
				and abs(rc_pendiente) >= 0.01

		end
--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			FACTURAS DE COMPRA
--
--
--/////////////////////////////////////////////////////////////////////////////////////////
		if @@fc <> 0 begin

			insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, prov_id, Excluir, Excluir2, importe_real, fecha_real)
	
			select  cfi_id,
							fc.doct_id,
							fcd_id,
							fc.fc_id,
							isnull(cfi_fecha,fcd_fecha2)		as Fecha,
							fc_descrip    									as Descrip,
	
							case fc.doct_id
									when 8 then isnull(cfi_importe,fcd_pendiente)
									else				0
							end 					as Debe,

							case fc.doct_id
									when 8 then 0
									else				isnull(cfi_importe,fcd_pendiente)
							end 					as Haber,
	
							case 
								when fc_cotizacion > 0 then isnull(cfi_importe,fcd_pendiente) / fc_cotizacion
								else												0
							end						as Origen, 
							fc.prov_id,
							isnull(cfi_excluir,0),
							isnull(cfp.cfp_id,0),
							fcd_pendiente,
							fcd_fecha2
	
			from FacturaCompra fc inner join FacturaCompraDeuda fcd on fc.fc_id = fcd.fc_id
										 				left  join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																													and cfi.comp_id = fcd.fcd_id 		
																													and cfi.doct_id in (2,8,10)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.prov_id = fc.prov_id

			where isnull(cfi_fecha,fcd_fecha2) between @@fDesde and @@fHasta
				and	est_id <> 7
				and abs(fcd_pendiente) >= 0.01

		end
--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			PEDIDOS DE VENTA
--
--
--/////////////////////////////////////////////////////////////////////////////////////////
		if @@pv <> 0 begin

			insert into #t_cash_flow (cfi_id, doct_id, comp_id, Fecha, Descrip, Debe, Haber, Origen, cli_id, Excluir, Excluir2, importe_real, fecha_real)
	
			select  cfi_id,
							pv.doct_id,
							pv.pv_id,
							isnull(cfi_fecha,pv_fecha)			as Fecha,
							pv_descrip    									as Descrip,
	
							case pv.doct_id
									when 22 then 0
									else				 pv_pendiente * coti.cotizacion
							end 					as Debe,
	
							case pv.doct_id
									when 22 then pv_pendiente * coti.cotizacion
									else				 0
							end 					as Haber,
							case 
								when doc.mon_id <> @mon_legal then isnull(cfi_importe,pv_pendiente) 
								else															 0
							end						as Origen, 
							pv.cli_id,
							isnull(cfi_excluir,0),
							isnull(cfp.cfp_id,0),
							pv_pendiente,
							pv_fecha
	
			from PedidoVenta pv left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																												and cfi.comp_id = pv.pv_id 		
																												and cfi.doct_id in (5,22)

													left join CashFlowParam cfp on 		cfp.cf_id  = @@cf_id
																												and cfp.cli_id = pv.cli_id

													left join Documento doc on pv.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

			where isnull(cfi_fecha,pv_fecha) between @@fDesde and @@fHasta
				and	est_id <> 7
				and abs(pv_pendiente) >= 0.01

		end
--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			REMITOS DE VENTA
--
--
--/////////////////////////////////////////////////////////////////////////////////////////
		if @@rv <> 0 begin

			insert into #t_cash_flow (cfi_id, doct_id, comp_id, Fecha, Descrip, Debe, Haber, Origen, cli_id, Excluir, Excluir2, importe_real, fecha_real)
	
			select  cfi_id,
							rv.doct_id,
							rv.rv_id,
							isnull(cfi_fecha,rv_fecha)			as Fecha,
							rv_descrip    									as Descrip,
	
							case rv.doct_id
									when 24 then 0
									else				 rv_pendiente * coti.cotizacion
							end 					as Debe,
	
							case rv.doct_id
									when 24 then rv_pendiente * coti.cotizacion
									else				 0
							end 					as Haber,
							case 
								when doc.mon_id <> @mon_legal then isnull(cfi_importe,rv_pendiente) 
								else															 0
							end						as Origen, 
							rv.cli_id,
							isnull(cfi_excluir,0),
							isnull(cfp.cfp_id,0),
							rv_pendiente,
							rv_fecha
	
			from RemitoVenta rv left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																												and cfi.comp_id = rv.rv_id 		
																												and cfi.doct_id in (3,24)

													left join CashFlowParam cfp on 		cfp.cf_id  = @@cf_id
																												and cfp.cli_id = rv.cli_id

													left join Documento doc on rv.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

			where isnull(cfi_fecha,rv_fecha) between @@fDesde and @@fHasta
				and	est_id <> 7
				and abs(rv_pendiente) >= 0.01

		end
--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			FACTURAS DE VENTA
--
--
--/////////////////////////////////////////////////////////////////////////////////////////
		if @@fv <> 0 begin

			insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cli_id, Excluir, Excluir2, importe_real, fecha_real)
				
			select  cfi_id,
							fv.doct_id,
							fvd_id,
							fv.fv_id,
							isnull(cfi_fecha,fvd_fecha2)		as Fecha,
							fv_descrip    									as Descrip,
	
							case fv.doct_id
									when 7 then 0
									else				isnull(cfi_importe,fvd_pendiente)
							end 					as Debe,
	
							case fv.doct_id
									when 7 then isnull(cfi_importe,fvd_pendiente)
									else				0
							end 					as Haber,
							case 
								when fv_cotizacion > 0 then isnull(cfi_importe,fvd_pendiente) / fv_cotizacion
								else												0
							end						as Origen,
							fv.cli_id,
							isnull(cfi_excluir,0),
							isnull(cfp.cfp_id,0),
							fvd_pendiente,
							fvd_fecha2
	
			from FacturaVenta fv inner join FacturaVentaDeuda fvd on fv.fv_id = fvd.fv_id
										 			 left  join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																													and cfi.comp_id = fvd.fvd_id 		
																													and cfi.doct_id in (1,7,9)

													 left join CashFlowParam cfp on 	cfp.cf_id  = @@cf_id
																												and cfp.cli_id = fv.cli_id

			where isnull(cfi_fecha,fvd_fecha2) between @@fDesde and @@fHasta
				and	est_id <> 7
				and abs(fvd_pendiente) >= 0.01

		end
--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			MOVIMIENTOS DE FONDO
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cheq_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)
			
		select  cfi_id,
						mf.doct_id,
						mfi_id,
						mf.mf_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,mf_fecha)			
							else				isnull(cfi_fecha,isnull(cheq.cheq_fecha2,mf_fecha))			
						end								as Fecha,

						mf_descrip    		as Descrip,

						isnull(cfi_importe,mfi_importe)				as Debe,
						0 																		as Haber,
						isnull(cfi_importe,mfi_importeOrigen)	as Origen,

						mfi.cheq_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						mfi_importe,
						case @@fechacheque
							when 0 then	mf_fecha
							else				isnull(cheq.cheq_fecha2,mf_fecha)
						end,
						mfi.cue_id_debe						

		from MovimientoFondo mf Inner join MovimientoFondoItem mfi on		mf.mf_id 				= mfi.mf_id
														Inner join Cuenta cue							 on 	mfi.cue_id_debe = cue.cue_id
																																and	cue.cuec_id in (1,	-- Documentos en Cartera
																																										2,	-- Bancos
																																										4,	-- Deudores por venta
																																										8,	-- Acreedores por compras
																																										14,	-- Caja
																																										19	-- Cupones Presentados
																																										)
														left join Cheque cheq              on mfi.cheq_id = cheq.cheq_id

										 				left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																													and cfi.comp_id = mfi.mfi_id 		
																													and cfi.doct_id = 26
																													and cfi.cfi_tipo in (0,1)-- debe

														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																														and cfp.cli_id  = mf.cli_id

														left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
																														and cfp2.bco_id  = cheq.bco_id

		where (			(isnull(cfi_fecha,mf_fecha) 				between @@fDesde and @@fHasta and (@@fechacheque = 0 or mfi.cheq_id is null))
						or	(isnull(cfi_fecha,cheq.cheq_fecha2) between @@fDesde and @@fHasta and @@fechacheque <> 0)
					)
			and	est_id <> 7


		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cheq_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)
			
		select  cfi_id,
						mf.doct_id,
						mfi_id,
						mf.mf_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,mf_fecha)			
							else				isnull(cfi_fecha,isnull(cheq.cheq_fecha2,mf_fecha))			
						end								as Fecha,

						mf_descrip    		as Descrip,

						0																			as Debe,
						isnull(cfi_importe,mfi_importe)				as Haber,
						isnull(cfi_importe,mfi_importeOrigen)	as Origen,

						mfi.cheq_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						mfi_importe,
						case @@fechacheque
							when 0 then	mf_fecha
							else				isnull(cheq.cheq_fecha2,mf_fecha)
						end,
						mfi.cue_id_haber

		from MovimientoFondo mf Inner join MovimientoFondoItem mfi on		mf.mf_id 				 = mfi.mf_id
														Inner join Cuenta cue							 on 	mfi.cue_id_haber = cue.cue_id
																																and	cue.cuec_id in (1,	-- Documentos en Cartera
																																										2,	-- Bancos
																																										4,	-- Deudores por venta
																																										8,	-- Acreedores por compras
																																										14,	-- Caja
																																										19	-- Cupones Presentados
																																										)
														left join Cheque cheq              on mfi.cheq_id = cheq.cheq_id

										 				left join CashFlowItem cfi on 		cfi.cf_id = @@cf_id 
																													and cfi.comp_id = mfi.mfi_id 		
																													and cfi.doct_id = 26
																													and cfi.cfi_tipo in (0,2) -- debe

														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																														and cfp.cli_id  = mf.cli_id

														left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
																														and cfp2.bco_id  = cheq.bco_id

		where (			(isnull(cfi_fecha,mf_fecha) 				between @@fDesde and @@fHasta and (@@fechacheque = 0 or mfi.cheq_id is null))
						or	(isnull(cfi_fecha,cheq.cheq_fecha2) between @@fDesde and @@fHasta and @@fechacheque <> 0)
					)
			and	est_id <> 7

--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			DEPOSITO BANCARIO
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cheq_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)
			
		select  cfi_id,
						dbco.doct_id,
						dbcoi_id,
						dbco.dbco_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,dbco_fecha)			
							else				isnull(cfi_fecha,isnull(cheq.cheq_fecha2,dbco_fecha))			
						end								as Fecha,

						dbco_descrip    		as Descrip,

						isnull(cfi_importe,dbcoi_importe)				as Debe,
						0 																		  as Haber,
						isnull(cfi_importe,dbcoi_importeOrigen)	as Origen,

						dbcoi.cheq_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						dbcoi_importe,
						case @@fechacheque
							when 0 then	dbco_fecha
							else				isnull(cheq.cheq_fecha2,dbco_fecha)
						end,
						dbco.cue_id

		from DepositoBanco dbco Inner join DepositoBancoItem dbcoi on		dbco.dbco_id = dbcoi.dbco_id
														Inner join Cuenta cue							 on 	dbcoi.cue_id = cue.cue_id
																																and	cue.cuec_id in (1,	-- Documentos en Cartera
																																										2,	-- Bancos
																																										4,	-- Deudores por venta
																																										8,	-- Acreedores por compras
																																										14,	-- Caja
																																										19	-- Cupones Presentados
																																										)
														left join Cheque cheq              on dbcoi.cheq_id = cheq.cheq_id

										 				left join CashFlowItem cfi on 		cfi.cf_id 	= @@cf_id 
																													and cfi.comp_id = dbcoi.dbcoi_id 		
																													and cfi.doct_id = 17

														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																																and dbco.bco_id = cfp.bco_id

														left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
																														and cfp2.bco_id  = cheq.bco_id

		where (isnull(cfi_fecha,dateadd(d,1,dbco_fecha)) between @@fDesde and @@fHasta)
			and	est_id <> 7

-- 					(			(isnull(cfi_fecha,dbco_fecha) 			between @@fDesde and @@fHasta and (@@fechacheque = 0 or dbcoi.cheq_id is null))
-- 						or	(isnull(cfi_fecha,cheq.cheq_fecha2) between @@fDesde and @@fHasta and @@fechacheque <> 0)
-- 					)

		union all

		select  cfi_id,
						dbco.doct_id,
						dbcoi_id,
						dbco.dbco_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,dbco_fecha)			
							else				isnull(cfi_fecha,isnull(cheq.cheq_fecha2,dbco_fecha))			
						end								as Fecha,

						dbco_descrip    		as Descrip,

						0 																		  as Debe,
						isnull(cfi_importe,dbcoi_importe)				as Haber,
						isnull(cfi_importe,dbcoi_importeOrigen)	as Origen,

						dbcoi.cheq_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						dbcoi_importe,
						case @@fechacheque
							when 0 then	dbco_fecha
							else				isnull(cheq.cheq_fecha2,dbco_fecha)
						end,
						dbcoi.cue_id				

		from DepositoBanco dbco Inner join DepositoBancoItem dbcoi on		dbco.dbco_id = dbcoi.dbco_id
														Inner join Cuenta cue							 on 	dbcoi.cue_id = cue.cue_id
																																and	cue.cuec_id in (1,	-- Documentos en Cartera
																																										2,	-- Bancos
																																										4,	-- Deudores por venta
																																										8,	-- Acreedores por compras
																																										14,	-- Caja
																																										19	-- Cupones Presentados
																																										)
														left join Cheque cheq              on dbcoi.cheq_id = cheq.cheq_id

										 				left join CashFlowItem cfi on 		cfi.cf_id 	= @@cf_id 
																													and cfi.comp_id = dbcoi.dbcoi_id 		
																													and cfi.doct_id = 17

														left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																																and dbco.bco_id = cfp.bco_id

														left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
																														and cfp2.bco_id  = cheq.bco_id

		where (isnull(cfi_fecha,dateadd(d,1,dbco_fecha)) between @@fDesde and @@fHasta)
			and	est_id <> 7

-- 					(			(isnull(cfi_fecha,dbco_fecha) 			between @@fDesde and @@fHasta and (@@fechacheque = 0 or dbcoi.cheq_id is null))
-- 						or	(isnull(cfi_fecha,cheq.cheq_fecha2) between @@fDesde and @@fHasta and @@fechacheque <> 0)
-- 					)

--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			COBRANZAS
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cli_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  cfi_id,
						cobz.doct_id,
						cobzi_id,
						cobz.cobz_id,

						isnull(cfi_fecha,cobz_fecha)			as Fecha,
						cobz_descrip    									as Descrip,

						isnull(cfi_importe,cobzi_importe)				as Debe,
						0 									as Haber,
						isnull(cfi_importe,cobzi_importeOrigen)	as Origen,
						cobz.cli_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						cobzi_importe,
						cobz_fecha,
						cobzi.cue_id

		from Cobranza cobz Inner join CobranzaItem cobzi on		cobz.cobz_id 	= cobzi.cobz_id
																											and cobzi_tipo 		= 2 -- Efectivo
																												
										 	 left  join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
																												and cfi.comp_id = cobzi.cobzi_id 
																												and cfi.doct_id = 13

											 left  join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																												and cfp.cli_id  = cobz.cli_id

		where isnull(cfi_fecha,cobz_fecha) between @@fDesde and @@fHasta
			and	est_id <> 7


		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cli_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  cfi_id,
						cobz.doct_id,
						cobzi_id,
						cobz.cobz_id,

						isnull(cfi_fecha,cobz_fecha)			as Fecha,
						cobz_descrip    									as Descrip,

						case cobzi_otroTipo
							when 1 then isnull(cfi_importe,cobzi_importe)
							else        0
						end																			as Debe,
						case cobzi_otroTipo
							when 2 then isnull(cfi_importe,cobzi_importe)
							else        0
						end																			as Haber,
						isnull(cfi_importe,cobzi_importeOrigen)	as Origen,
						cobz.cli_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
            cobzi_importe,
            cobz_fecha,
						cobzi.cue_id

		from Cobranza cobz Inner join CobranzaItem cobzi on		cobz.cobz_id 		= cobzi.cobz_id
																											and cobzi_tipo 			= 4 -- Otros
																												
										 	 left  join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
																												and cfi.comp_id = cobzi.cobzi_id 
																												and cfi.doct_id = 13

											 left  join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																												and cfp.cli_id  = cobz.cli_id

		where isnull(cfi_fecha,cobz_fecha) between @@fDesde and @@fHasta
			and	est_id <> 7
			and ret_id is null -- Sin retenciones por que no es plata que entre en la empresa
												 -- se cancelan en el futuro del impuesto a las ganancias


		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cheq_id, cli_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  cfi_id,
						cobz.doct_id,
						cobzi_id,
						cobz.cobz_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,cobz_fecha)			
							else				isnull(cfi_fecha,cheq.cheq_fecha2)			
						end								as Fecha,

						cobz_descrip    	as Descrip,

						isnull(cfi_importe,cobzi_importe)				as Debe,
						0 																			as Haber,
						isnull(cfi_importe,cobzi_importeOrigen)	as Origen,
						cobzi.cheq_id,
						cobz.cli_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						cobzi_importe,
						case @@fechacheque
							when 0 then	cobz_fecha
							else				cheq.cheq_fecha2
						end,
						cobzi.cue_id

		from Cobranza cobz Inner join CobranzaItem cobzi on		cobz.cobz_id  = cobzi.cobz_id
											 Inner join Cheque cheq        on   cobzi.cheq_id = cheq.cheq_id 
																												
										 	 left  join CashFlowItem cfi 	 on 		cfi.cf_id 	= @@cf_id 
																												and cfi.comp_id = cobzi.cobzi_id 
																												and cfi.doct_id = 13

											 left  join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																												and cfp.cli_id  = cobz.cli_id

											 left  join CashFlowParam cfp2 on 		cfp2.cf_id  = @@cf_id
																												and cfp2.bco_id = cheq.bco_id


		where (			(isnull(cfi_fecha,cheq_fecha2) 	between @@fDesde and @@fHasta and @@fechacheque <> 0) 
						or 	(isnull(cfi_fecha,cobz_fecha) 	between @@fDesde and @@fHasta and @@fechacheque = 0 )
					)
			and	est_id <> 7

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, Fecha, Descrip, Debe, Haber, Origen, tjcc_id, cli_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  cfi_id,
						cobz.doct_id,
						cobzi_id,
						isnull(cfi_fecha,dateadd(d,20,cobz_fecha))	as Fecha,
						cobz_descrip    														as Descrip,

						isnull(cfi_importe,cobzi_importe)				as Debe,
						0 																			as Haber,
						isnull(cfi_importe,cobzi_importeOrigen)	as Origen,
						cobzi.tjcc_id,
						cobz.cli_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						cobzi_importe,
						dateadd(d,20,cobz_fecha),
						cobzi.cue_id

		from Cobranza cobz Inner join CobranzaItem cobzi 				on	 cobz.cobz_id  = cobzi.cobz_id
											 Inner join TarjetaCreditoCupon tjcc  on   cobzi.tjcc_id = tjcc.tjcc_id 

										 	 left  join CashFlowItem cfi 					on 		cfi.cf_id = @@cf_id 
																															and cfi.comp_id = cobzi.cobzi_id 
																															and cfi.doct_id = 13

											left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																											and cfp.cli_id  = cobz.cli_id

					-- Asumimos que todos los cupones son en una sola 
					-- cuota y se cobran a los 20 dias																												
					--
		where isnull(cfi_fecha,dateadd(d,20,cobz_fecha)) between @@fDesde and @@fHasta 
			and	est_id <> 7

--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			ORDENES DE PAGO
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, prov_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  cfi_id,
						opg.doct_id,
						opgi_id,
						opg.opg_id,

						isnull(cfi_fecha,opg_fecha)			as Fecha,
						opg_descrip    									as Descrip,

						0 																			as Debe,
						isnull(cfi_importe,opgi_importe)				as Haber,

						isnull(cfi_importe,opgi_importeOrigen)	as Origen,
						opg.prov_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						opgi_importe,
						opg_fecha,
						opgi.cue_id

		from OrdenPago opg Inner join OrdenPagoItem opgi on		opg.opg_id 	= opgi.opg_id
																											and opgi_tipo 	= 2 -- Efectivo
																												
										 	 left  join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
																												and cfi.comp_id = opgi.opgi_id 	
																												and cfi.doct_id = 16

											left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																											and cfp.prov_id = opg.prov_id

		where isnull(cfi_fecha,opg_fecha) between @@fDesde and @@fHasta
			and	est_id <> 7
	

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, prov_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  cfi_id,
						opg.doct_id,
						opgi_id,
						opg.opg_id,

						isnull(cfi_fecha,opg_fecha)			as Fecha,
						opg_descrip    									as Descrip,

						case opgi_otroTipo
							when 1 then isnull(cfi_importe,opgi_importe)
							else        0
						end																			as Debe,
						case opgi_otroTipo
							when 2 then isnull(cfi_importe,opgi_importe)
							else        0
						end																			as Haber,
						isnull(cfi_importe,opgi_importeOrigen)	as Origen,
						opg.prov_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						opgi_importe,
						opg_fecha,
						opgi.cue_id

		from OrdenPago opg Inner join OrdenPagoItem opgi on		opg.opg_id 		= opgi.opg_id
																											and opgi_tipo 		= 4 -- Otros
																												
										 	 left  join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
																											and cfi.comp_id = opgi.opgi_id 	
																											and cfi.doct_id = 16

											left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																											and cfp.prov_id = opg.prov_id

		where isnull(cfi_fecha,opg_fecha) between @@fDesde and @@fHasta
			and	est_id <> 7
			and ret_id is null -- Sin retenciones por que se pagan con otro movimiento


		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cheq_id, prov_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  cfi_id,
						opg.doct_id,
						opgi_id,
						opg.opg_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,opg_fecha)			
							else				isnull(cfi_fecha,cheq.cheq_fecha2)			
						end								as Fecha,

						opg_descrip    		as Descrip,

						0 																			as Debe,
						isnull(cfi_importe,opgi_importe)				as Haber,
						isnull(cfi_importe,opgi_importeOrigen)	as Origen,

						opgi.cheq_id,
						opg.prov_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						opgi_importe,
						case @@fechacheque
							when 0 then	opg_fecha
							else				cheq.cheq_fecha2
						end,
						opgi.cue_id					

		from OrdenPago opg Inner join OrdenPagoItem opgi on		opg.opg_id  = opgi.opg_id
											 Inner join Cheque cheq        on   opgi.cheq_id = cheq.cheq_id 
																												
										 	 left  join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
																											and cfi.comp_id = opgi.opgi_id 	
																											and cfi.doct_id = 16

											left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																											and cfp.prov_id = opg.prov_id

											left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
																											and cfp2.bco_id  = cheq.bco_id

		where (			(isnull(cfi_fecha,cheq_fecha2) 	between @@fDesde and @@fHasta and @@fechacheque <> 0) 
						or	(isnull(cfi_fecha,opg_fecha) 		between @@fDesde and @@fHasta and @@fechacheque = 0 )
					)
			and	est_id <> 7

		union all

		select  cfi_id,
						opg.doct_id,
						opgi_id,
						opg.opg_id,

						case @@fechacheque
							when 0 then	isnull(cfi_fecha,opg_fecha)			
							else				isnull(cfi_fecha,cheq.cheq_fecha2)			
						end								as Fecha,

						opg_descrip    		as Descrip,

						0 																			as Debe,
						isnull(cfi_importe,opgi_importe)				as Haber,
						isnull(cfi_importe,opgi_importeOrigen)	as Origen,

						opgi.cheq_id,
						opg.prov_id,
						isnull(cfi_excluir,0),
						isnull(cfp.cfp_id,0),
						opgi_importe,
						case @@fechacheque
							when 0 then	opg_fecha
							else				cheq.cheq_fecha2
						end,
						opgi.cue_id					

		from OrdenPago opg Inner join OrdenPagoItem opgi on		opg.opg_id  = opgi.opg_id
											 Inner join Cheque cheq        on   opgi.cheq_id = cheq.cheq_id 
																												
										 	 left  join CashFlowItem cfi 	 on 		cfi.cf_id = @@cf_id 
																											and cfi.comp_id = opgi.opgi_id 	
																											and cfi.doct_id = 16

											left join CashFlowParam cfp  on 		cfp.cf_id   = @@cf_id
																											and cfp.prov_id = opg.prov_id

											left join CashFlowParam cfp2 on 		cfp2.cf_id   = @@cf_id
																											and cfp2.bco_id  = cheq.bco_id

										  -- Tengo que ir hasta el asiento para ver que este conciliado
											-- sino esta conciliado lo presento en la grilla de movimientos
											-- y no lo tomo en cuenta en el saldo incial por que esta pendiente
											--
											inner join Chequera chq on cheq.chq_id = chq.chq_id
											inner join Cuenta cue on chq.cue_id = cue.cue_id
											inner join Asiento ast on opg.as_id = ast.as_id
											inner join AsientoItem asi on ast.as_id = asi.as_id
																									and asi.cheq_id = cheq.cheq_id
																									and (asi_conciliado <> 2 and cuec_id = 2)

		where (			(isnull(cfi_fecha,cheq_fecha2) 	< @@fDesde and @@fechacheque <> 0) 
						or 	(isnull(cfi_fecha,opg_fecha) 		< @@fDesde and @@fechacheque = 0)
					)
			and	est_id <> 7

--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			RECORDSET CON RESULTADOS
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

		update #t_cash_flow set Fecha = convert(varchar(12), Fecha, 112)

		if @@bIsForMatrix = 0 begin

			select  t.doct_id,
							t.comp_id,
	
							t.Excluir,
							t.Excluir2,
							t.importe_real,
							t.fecha_real,
	
							case 
								when t.doct_id in (35,36)  then 35
								when t.doct_id in (4,25) 	 then 4
								when t.doct_id in (5,22)   then 5
								when t.doct_id in (3,24) 	 then 3
								when t.doct_id in (2,8,10) then 1
								when t.doct_id in (1,7,9)  then 2
								when t.doct_id = 26  then 3
								when t.doct_id = 13  then 4
								when t.doct_id = 16  then 5
								when t.doct_id = 17  then 6
							end 		as orden_id,
	
							Fecha,
	
							case 
								when t.doct_id in (35,36)  then 'OC'
								when t.doct_id in (4,25) 	 then 'RC'
								when t.doct_id in (5,22)   then 'PV'
								when t.doct_id in (3,24) 	 then 'RV'
								when t.doct_id in (2,8,10) then 'FC'
								when t.doct_id in (1,7,9)  then 'FV'
								when t.doct_id = 15  then 'AS'
								when t.doct_id = 26  then 'MF'
								when t.doct_id = 13  then 'COBZ'
								when t.doct_id = 16  then 'OP'
								when t.doct_id = 17  then 'DBCO'
							end 		as [Tipo Doc.],
	
							case 
								when t.doct_id in (5,22) then pv_nrodoc
								when t.doct_id in (35,36) then oc_nrodoc
								when t.doct_id in (3,24) then rv_nrodoc
								when t.doct_id in (4,25) then rc_nrodoc
								when t.doct_id in (2,8,10) then fc_nrodoc
								when t.doct_id in (1,7,9)  then fv_nrodoc
								when t.doct_id = 15  then as_nrodoc
								when t.doct_id = 26  then mf_nrodoc
								when t.doct_id = 13  then cobz_nrodoc
								when t.doct_id = 16  then opg_nrodoc
								when t.doct_id = 17  then dbco_nrodoc
							end 		as [Comprobante],
							
	
							isnull(cli_nombre,prov_nombre) as Tercero,
	
							Descrip,
	            Debe,
	            Haber,
	            Origen,
							t.cheq_id,
							cfi_id,
							t.tjcc_id,
	
							cheq_importe,
							cheq_importeorigen,
							cheq_numero,
							cheq_numerodoc,
							cheq_fechacobro,
							cheq_fechaVto,
							cheq_descrip,
		
							mon_nombre,
	
							t.cli_id,
							t.prov_id,
							t.cue_id,
		
							cheq.cobz_id,
							cobz_nrodoc,
							cheq.opg_id,
							opg_nrodoc,
							cheq.cle_id,
							cle_nombre,
							cheq.chq_id,
							chq_codigo,					
							cheq.bco_id,
							bco_nombre,
							cli_nombre,
							prov_nombre,
							cheq.mf_id,
							mf_nrodoc,
							cheq.emp_id,
							emp_nombre,
							'' as ccos_nombre,
							cue_nombre,
	
							tjc_nombre,						
							tjcc_numero,
							tjcc_numerodoc,
							tjcc_descrip,
							tjcc_fechavto,
							tjcc_nroTarjeta,
							tjcc_nroAutorizacion,
							tjcc_titular
	
	
			from #t_cash_flow t left join FacturaCompra fc 		on t.comp_id2 = fc.fc_id 		and t.doct_id in (2,8,10)
													left join FacturaVenta fv  		on t.comp_id2 = fv.fv_id 		and t.doct_id in (1,7,9)
	
													left join RemitoVenta rv  		on t.comp_id = rv.rv_id 		and t.doct_id in (3,24)
													left join PedidoVenta pv  		on t.comp_id = pv.pv_id 		and t.doct_id in (5,22)
													left join RemitoCompra rc  		on t.comp_id = rc.rc_id 		and t.doct_id in (4,25)
													left join OrdenCompra oc  		on t.comp_id = oc.oc_id 		and t.doct_id in (35,36)
	
													left join Asiento ast 				on t.comp_id2 = ast.as_id 		and t.doct_id = 15
													left join MovimientoFondo mf  on t.comp_id2 = mf.mf_id 			and t.doct_id = 26
													left join Cobranza cobz  			on t.comp_id2 = cobz.cobz_id 	and t.doct_id = 13
													left join OrdenPago opg  			on t.comp_id2 = opg.opg_id 		and t.doct_id = 16
													left join DepositoBanco dbco	on t.comp_id2 = dbco.dbco_id 	and t.doct_id = 17
	
											 left join Cliente cli      		on t.cli_id  = cli.cli_id
											 left join Proveedor prov   		on t.prov_id = prov.prov_id
	
											 left join Cheque cheq      		on t.cheq_id  = cheq.cheq_id
	
											 left join Moneda mon           on cheq.mon_id  = mon.mon_id
											 left join Clearing cle         on cheq.cle_id  = cle.cle_id
											 left join Chequera chq         on cheq.chq_id  = chq.chq_id
		                   left join Empresa emp          on cheq.emp_id  = emp.emp_id
											 left join Banco bco            on cheq.bco_id  = bco.bco_id
											 left join Cuenta cue           on chq.cue_id   = cue.cue_id
	
											 left join TarjetaCreditoCupon tjcc on t.tjcc_id 		= tjcc.tjcc_id
											 left join TarjetaCredito tjc       on tjcc.tjc_id 	= tjc.tjc_id
	
			order by Fecha, orden_id

		end

--/////////////////////////////////////////////////////////////////////////////////////////
--
--
--			ANALISIS DE UNA CUENTA ESPECIFICA
--
--
--/////////////////////////////////////////////////////////////////////////////////////////

	end else begin

		select  sum(asi_debe)-sum(asi_haber) as saldo_inicial, 0 as saldo_ini_excluido
	
		from Asiento ast inner join AsientoItem asi on 		asi.cue_id = @@cue_id 
																									and ast.as_id  = asi.as_id
	
										 left join Cheque cheq      on asi.cheq_id  = cheq.cheq_id
	
		where isnull(cheq_fecha2,as_fecha) < @@fdesde
					
	
		select 	ast.doct_id,
						asi.as_id 	as comp_id,
						asi.as_id,
						asi.asi_id	as cfi_id,
						0						as Excluir,
						0						as Excluir2,
						0           as importe_real,
						as_fecha    as fecha_real,
						case 
							when isnull(doct_id_cliente,ast.doct_id) in (2,8,10) then 'FC'
							when isnull(doct_id_cliente,ast.doct_id) in (1,7,9)  then 'FV'
							when isnull(doct_id_cliente,ast.doct_id) = 15  then 'AS'
							when isnull(doct_id_cliente,ast.doct_id) = 26  then 'MF'
							when isnull(doct_id_cliente,ast.doct_id) = 13  then 'COBZ'
							when isnull(doct_id_cliente,ast.doct_id) = 16  then 'OP'
							when isnull(doct_id_cliente,ast.doct_id) = 17  then 'DBCO'
							else																								'AS'
						end 		as [Tipo Doc.],

						case 
							when as_doc_cliente <> '' then substring(as_doc_cliente,1,15)
							else 													 as_nrodoc
						end			as [Comprobante],

						isnull(cli_nombre,prov_nombre) as Tercero,
	
						isnull(cheq_fecha2,as_fecha) as Fecha,
	
						asi.asi_descrip			as Descrip,
						asi.asi_debe				as Debe,
						asi.asi_haber				as Haber,
						asi.asi_origen			as Origen,
	
						cheq_importe,
						cheq_importeorigen,
						cheq_numero,
						cheq_numerodoc,
						cheq_fechacobro,
						cheq_fechaVto,
						cheq_descrip,
	
						mon_nombre,
	
						cheq.cobz_id,
						cobz_nrodoc,
						cheq.opg_id,
						opg_nrodoc,
						cheq.cle_id,
						cle_nombre,
						cheq.chq_id,
						chq_codigo,					
						cheq.bco_id,
						bco_nombre,
						cheq.cli_id,
						cli_nombre,
						cheq.prov_id,
						prov_nombre,
						cheq.mf_id,
						mf_nrodoc,
						cheq.emp_id,
						emp_nombre,
						ccos_nombre,
						cue_nombre	
	
		from Asiento ast inner join AsientoItem asi on 		asi.cue_id = @@cue_id 
																									and ast.as_id  = asi.as_id
	
										 left join Cheque cheq      		on asi.cheq_id  = cheq.cheq_id
										 left join Cliente cli      		on cheq.cli_id  = cli.cli_id
										 left join Proveedor prov   		on cheq.prov_id = prov.prov_id
	                   left join Cobranza cobz    		on cheq.cobz_id = cobz.cobz_id
	                   left join OrdenPago opg    		on cheq.opg_id  = opg.opg_id
	                   left join MovimientoFondo mf		on cheq.mf_id   = mf.mf_id
										 left join Moneda mon           on cheq.mon_id  = mon.mon_id
										 left join Clearing cle         on cheq.cle_id  = cle.cle_id
										 left join Chequera chq         on cheq.chq_id  = chq.chq_id
	                   left join Empresa emp          on cheq.emp_id  = emp.emp_id
										 left join Banco bco            on cheq.bco_id  = bco.bco_id
										 left join CentroCosto ccos     on asi.ccos_id  = ccos.ccos_id
										 left join Cuenta cue           on chq.cue_id   = cue.cue_id
	
		where isnull(cheq_fecha2,as_fecha) between @@fdesde and @@fhasta
	
		order by Fecha, asi_debe desc

	end

end				