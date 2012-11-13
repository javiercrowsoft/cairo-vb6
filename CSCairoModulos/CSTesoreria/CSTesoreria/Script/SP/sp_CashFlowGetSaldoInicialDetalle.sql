if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CashFlowGetSaldoInicialDetalle]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CashFlowGetSaldoInicialDetalle]

go

/*

sp_CashFlowGetMatrix 3,0,'20090428 00:00:00','20091231 00:00:00',-1,-1,-1,-1,-1,-1,-1

exec sp_CashFlowGetSaldoInicialDetalle 3,0,'20090428 00:00:00',-1,-1,-1,-1,-1,-1,-1

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
	@@oc						smallint,

	@@bNoSelect tinyint = 0,
	@@saldo_ini decimal(18,6) = 0 out,

	@@bNoCreateTable tinyint = 0
)
as

begin

	set nocount on

--//////////////////////////////////////////////////////////////
--
--	VALIDACIONES A CASHFLOWITEM	
--
--//////////////////////////////////////////////////////////////

	declare @cfi_id  	int
	declare @comp_id 	int
	declare @doct_id 	int
	declare @cfi_tipo tinyint

	declare c_cfi insensitive cursor for
	
		select comp_id, doct_id, cfi_tipo
		from CashFlowItem 
		group by comp_id, doct_id, cfi_tipo having count(*) > 1
	
	open c_cfi
	
	fetch next from c_cfi into @comp_id, @doct_id, @cfi_tipo
	while @@fetch_status=0
	begin
	
		select @cfi_id = max(cfi_id) 
		from CashFlowItem 
		where comp_id = @comp_id 
			and doct_id = @doct_id 
			and cfi_tipo = @cfi_tipo
	
		delete CashFlowItem where cfi_id = @cfi_id
	
		fetch next from c_cfi into @comp_id, @doct_id, @cfi_tipo
	end
	
	close c_cfi
	deallocate c_cfi

--//////////////////////////////////////////////////////////////

	if @@bNoCreateTable = 0 begin

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

	end

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
		--
		--			ORDENES DE COMPRA
		--
		--
		--/////////////////////////////////////////////////////////////////////////////////////////
		if @@oc <> 0 begin
		
				insert into #t_cash_flow_si (cfi_id, doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real, prov_id)
		
				select  cfi_id,
								oc.doct_id,
								oc.oc_id,
								doc_nombre    as Documento,
								prov_nombre   as Tercero,
								oc_nrodoc     as Comprobante,
								isnull(cfi_fecha,oc_fecha) as Fecha,
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

								0,@@fDesde, oc.prov_id
		
				from OrdenCompra oc left join CashFlowItem cfi on 		cfi.cf_id 	= @@cf_id 
																													and cfi.comp_id = oc.oc_id 		
																													and cfi.doct_id in (35,36)

														left join CashFlowParam cfp on 		cfp.cf_id   = @@cf_id
																													and cfp.prov_id = oc.prov_id

													left join Documento doc on oc.doc_id = doc.doc_id
													left join #t_cotizacion coti on	doc.mon_id = coti.mon_id

													left join Proveedor prov on oc.prov_id = prov.prov_id

				where 
							case 
									when isnull(cfi_fecha,oc_fecha) > '19000101' 
											then isnull(cfi_fecha,oc_fecha)
								  else     oc_fecha
						  end < @@fDesde

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
		
				insert into #t_cash_flow_si (cfi_id, doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real, prov_id)
		
				select  cfi_id,
								rc.doct_id,
								rc.rc_id,
								doc_nombre    as Documento,
								prov_nombre   as Tercero,
								rc_nrodoc     as Comprobante,
								isnull(cfi_fecha,rc_fecha) as Fecha,
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

								0,@@fDesde, rc.prov_id
		
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
		
				insert into #t_cash_flow_si (cfi_id, doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real, prov_id)
		
				select  cfi_id,
								fc.doct_id,
								fcd_id,
								doc_nombre    as Documento,
								prov_nombre   as Tercero,
								fc_nrodoc     as Comprobante,
								isnull(cfi_fecha,fcd_fecha2) as Fecha,
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

								0,@@fDesde, fc.prov_id
		
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
		
				insert into #t_cash_flow_si (cfi_id, doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real, cli_id)
		
				select  cfi_id,
								pv.doct_id,
								pv.pv_id,
								doc_nombre    as Documento,
								cli_nombre    as Tercero,
								pv_nrodoc     as Comprobante,
								isnull(cfi_fecha,pv_fecha) as Fecha,
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

								0,@@fDesde, pv.cli_id
		
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
		
				insert into #t_cash_flow_si (cfi_id, doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real, cli_id)
		
				select  cfi_id,
								rv.doct_id,
								rv.rv_id,
								doc_nombre    as Documento,
								cli_nombre    as Tercero,
								rv_nrodoc     as Comprobante,
								isnull(cfi_fecha,rv_fecha) as Fecha,
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

								0,@@fDesde, rv.cli_id
		
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
		
				insert into #t_cash_flow_si (cfi_id, doct_id, comp_id, Documento, Tercero, Comprobante, Fecha, Descrip, Debe, Haber, Origen, Excluir, Excluir2, importe_real, fecha_real, cli_id)
					
				select  cfi_id,
								fv.doct_id,
								fvd_id,
								doc_nombre    as Documento,
								cli_nombre    as Tercero,
								fv_nrodoc     as Comprobante,
								isnull(cfi_fecha,fvd_fecha2) as Fecha,
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

								0,@@fDesde, fv.cli_id
		
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

	end

	if @@bNoSelect = 0 begin

		select 															
						t.cfi_id,
						t.doct_id,
						t.comp_id,
						t.Documento,
						t.Tercero,
						t.Comprobante,
						t.Fecha,
						t.Descrip,
						t.Debe,
						t.Haber,
						t.Origen,
						t.cheq_id,
						t.tjcc_id,
						t.cli_id,
						t.prov_id,
						t.Excluir,
						t.Excluir2,
						t.importe_real,
						t.fecha_real,
						doct_codigo as [Tipo Doc.]
						
		from #t_cash_flow_si t left join DocumentoTipo doct on t.doct_id = doct.doct_id

		union all

		select 															
						null as cfi_id,
						null as doct_id,
						null as comp_id,
						null as Documento,
						'Saldo Pendiente' 		as Tercero,
						null as Comprobante,
						dateadd(d,1,@@fDesde) 	as Fecha,
						null as Descrip,
						
						case when sum(debe)-sum(haber)>0 then sum(debe)-sum(haber) else 0 end	as Debe,
						case when sum(debe)-sum(haber)<0 then abs(sum(debe)-sum(haber)) else 0 end as Haber,
						null as Origen,
						null as cheq_id,
						null as tjcc_id,
						null as cli_id,
						null as prov_id,
						null as Excluir,
						null as Excluir2,
						null as importe_real,
						null as fecha_real,
						'' as [Tipo Doc.]

		from #t_cash_flow_si t left join CashFlowItem cfi on t.cfi_id = cfi.cfi_id

		where isnull(cfi_excluir,0) = 0

		order by Fecha

	end else begin 

		select @@saldo_ini = sum(debe)-sum(haber)
		from #t_cash_flow_si
		where (excluir = 0 and excluir2 = 0)

	end

end				