if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CashFlowGetMatrix]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CashFlowGetMatrix]

go

/*

sp_CashFlowGetMatrix 3,0,'20090506 00:00:00','20100601 00:00:00',-1,-1,-1,-1,-1,-1,-1

*/
create procedure sp_CashFlowGetMatrix  (
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
	@@oc						smallint
)
as

begin

	set nocount on

	--//////////////////////////////////////////////////////////////////////////////////////////////
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
	--//////////////////////////////////////////////////////////////////////////////////////////////
	--
	-- Saldo inicial de disponibilidades
	--
		declare @fecha_desde_saldo datetime
		set @fecha_desde_saldo = @@fDesde

		create table #t_table ( cue_id 		int, 
														debe 			decimal(18,6), 
														haber 		decimal(18,6), 
														saldo 		decimal(18,6),
														debeex 		decimal(18,6), 
														haberex 	decimal(18,6), 
														saldoex 	decimal(18,6)
													)

		exec sp_CashFlowGetCuentaSaldo @@cf_id, @fecha_desde_saldo, 1, 0, 1 -- Para que no cree la temporal

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, comp_id2, Fecha, Descrip, Debe, Haber, Origen, cheq_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select  null 	as cfi_id,
						15 		as doct_id,
						0 as asi_id,
						0 as as_id,

						'19000102'	as Fecha,

						''    			as Descrip,

						debe				as Debe,
						haber				as Haber,

						saldoex			as Origen,

						null				as cheq_id,

						0,
						0 as cfp_id,
						debe - haber,
						@@fDesde,

						cue_id

		from #t_table

	--//////////////////////////////////////////////////////////////////////////////////////////////
	--
	-- Documentos pendientes
	--

		--set @fecha_desde_saldo = dateadd(d,-1,@@fDesde)

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
																						0,
																						1 -- Para que no cree la temporal

		insert into #t_cash_flow (cfi_id, doct_id, comp_id, Fecha, Descrip, Debe, Haber, Origen, cheq_id, cli_id, prov_id, Excluir, Excluir2, importe_real, fecha_real, cue_id)

		select 															
						t.cfi_id,
						t.doct_id,
						t.comp_id,
						'19000102',
						t.Descrip,
						t.Debe,
						t.Haber,
						t.Origen,
						t.cheq_id,
						t.cli_id,
						t.prov_id,
						t.Excluir,
						t.Excluir2,
						t.importe_real,
						t.fecha_real,
						null
						
		from #t_cash_flow_si t

	--//////////////////////////////////////////////////////////////////////////////////////////////

	exec sp_CashFlowGet
											@@cf_id         ,
											@@cue_id    		,
											@@fDesde 				,
											@@fHasta				,
										
											@@fechacheque		,
											@@fv						,
											@@rv						,
											@@pv						,
											@@fc						,
											@@rc						,
											@@oc						,
											1

--debug
--select * from #t_cash_flow where prov_id =7-- select * from proveedor where prov_nombre like '%autopista%'
--debug

	--///////////////////////////////////////////////////////////////////////////////////////////////
	--
	-- Pongo todos los saldos anteriores en al primera semana
	--
	update #t_cash_flow set fecha = @@fDesde where fecha < @@fDesde and fecha <> '19000102'

	declare @oldDateFirst int
	set @oldDateFirst = @@DATEFIRST 

	set datefirst 6

	--///////////////////////////////////////////////////////////////////////////////////////////////
	select 

					1 as aux_id,
					case when cue_codigorpt <> '' then 0 else t.cue_id end cue_id,
	
					  convert(varchar(4),fecha,111) 
					+ ' ' 
					+ convert(varchar,datepart(wk,fecha))	as Fecha,

					case doct_id
						when 1	/*Factura de Venta*/								then 'Clientes'
						when 3	/*Remito de Venta*/									then 'Clientes'
						when 5	/*Pedido de Venta*/									then 'Clientes'
						when 7	/*Nota de Credito Venta*/						then 'Clientes'
						when 9	/*Nota de Debito Venta*/						then 'Clientes'
						when 22	/*Devolucion Pedido Venta*/					then 'Clientes'
						when 24	/*Devolucion Remito Venta*/					then 'Clientes'

						when 13	/*Cobranza*/												then 'Cuentas'
						when 15	/*Asiento Contable*/								then 'Cuentas'
						when 16	/*Orden de Pago*/										then 'Cuentas'
						when 17	/*Deposito Banco*/									then 'Cuentas'
						when 26	/*Movimiento de Fondos*/						then 'Cuentas'

						when 2	/*Factura de Compra*/								then 'Proveedores'
						when 4	/*Remito de Compra*/								then 'Proveedores'
						when 8	/*Nota de Credito Compra*/					then 'Proveedores'
						when 10	/*Nota de Debito Compra*/						then 'Proveedores'
						when 25	/*Devolucion Remito Compra*/				then 'Proveedores'
						when 35	/*Orden de Compra*/									then 'Proveedores'
						when 36	/*Cancelacion de Orden de Compra*/	then 'Proveedores'

					end																			as Grupo,

					case doct_id

						when 1	/*Factura de Venta*/								then cli_nombre + ' ['+cli_codigo+']'
						when 3	/*Remito de Venta*/									then cli_nombre + ' ['+cli_codigo+']'
						when 5	/*Pedido de Venta*/									then cli_nombre + ' ['+cli_codigo+']'
						when 7	/*Nota de Credito Venta*/						then cli_nombre + ' ['+cli_codigo+']'
						when 9	/*Nota de Debito Venta*/						then cli_nombre + ' ['+cli_codigo+']'
						when 22	/*Devolucion Pedido Venta*/					then cli_nombre + ' ['+cli_codigo+']'
						when 24	/*Devolucion Remito Venta*/					then cli_nombre + ' ['+cli_codigo+']'

						when 13	/*Cobranza*/												then 
							case when t.cue_id is null then cli_nombre + ' ['+cli_codigo+']' 
									 else case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end 
							end

						when 15	/*Asiento Contable*/								then 
						case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end 

						when 16	/*Orden de Pago*/										then 
							case when t.cue_id is null then prov_nombre + ' ['+prov_codigo+']'
									 else	case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end 
							end

						when 17	/*Deposito Banco*/									then 
						case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end 

						when 26	/*Movimiento de Fondos*/						then 
						case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end 

						when 2	/*Factura de Compra*/								then prov_nombre + ' ['+prov_codigo+']'
						when 4	/*Remito de Compra*/								then prov_nombre + ' ['+prov_codigo+']'
						when 8	/*Nota de Credito Compra*/					then prov_nombre + ' ['+prov_codigo+']'
						when 10	/*Nota de Debito Compra*/						then prov_nombre + ' ['+prov_codigo+']'
						when 25	/*Devolucion Remito Compra*/				then prov_nombre + ' ['+prov_codigo+']'
						when 35	/*Orden de Compra*/									then prov_nombre + ' ['+prov_codigo+']'
						when 36	/*Cancelacion de Orden de Compra*/	then prov_nombre + ' ['+prov_codigo+']'

					end																			as Concepto,

					sum(debe-haber)													as Saldo

	from #t_cash_flow t

								left join Cliente cli 		on t.cli_id  = cli.cli_id
								left join Proveedor prov 	on t.prov_id = prov.prov_id
								left join Cuenta cue 			on t.cue_id  = cue.cue_id

	where (			t.cue_id in (select cue_id from CashFlowParam cfp where cf_id = @@cf_id)
					or	t.cue_id is null 
					or  (t.doct_id in (13,16))
				)

		and excluir = 0

--debug
--and t.prov_id = 7
--debug

	group by

					case when cue_codigorpt <> '' then 0 else t.cue_id end,

					case doct_id
						when 1	/*Factura de Venta*/								then 'Clientes'
						when 3	/*Remito de Venta*/									then 'Clientes'
						when 5	/*Pedido de Venta*/									then 'Clientes'
						when 7	/*Nota de Credito Venta*/						then 'Clientes'
						when 9	/*Nota de Debito Venta*/						then 'Clientes'
						when 22	/*Devolucion Pedido Venta*/					then 'Clientes'
						when 24	/*Devolucion Remito Venta*/					then 'Clientes'

						when 13	/*Cobranza*/												then 'Cuentas'
						when 15	/*Asiento Contable*/								then 'Cuentas'
						when 16	/*Orden de Pago*/										then 'Cuentas'
						when 17	/*Deposito Banco*/									then 'Cuentas'
						when 26	/*Movimiento de Fondos*/						then 'Cuentas'

						when 2	/*Factura de Compra*/								then 'Proveedores'
						when 4	/*Remito de Compra*/								then 'Proveedores'
						when 8	/*Nota de Credito Compra*/					then 'Proveedores'
						when 10	/*Nota de Debito Compra*/						then 'Proveedores'
						when 25	/*Devolucion Remito Compra*/				then 'Proveedores'
						when 35	/*Orden de Compra*/									then 'Proveedores'
						when 36	/*Cancelacion de Orden de Compra*/	then 'Proveedores'

					end,

					case doct_id

						when 1	/*Factura de Venta*/								then cli_nombre + ' ['+cli_codigo+']'
						when 3	/*Remito de Venta*/									then cli_nombre + ' ['+cli_codigo+']'
						when 5	/*Pedido de Venta*/									then cli_nombre + ' ['+cli_codigo+']'
						when 7	/*Nota de Credito Venta*/						then cli_nombre + ' ['+cli_codigo+']'
						when 9	/*Nota de Debito Venta*/						then cli_nombre + ' ['+cli_codigo+']'
						when 22	/*Devolucion Pedido Venta*/					then cli_nombre + ' ['+cli_codigo+']'
						when 24	/*Devolucion Remito Venta*/					then cli_nombre + ' ['+cli_codigo+']'

						when 13	/*Cobranza*/												then 
							case when t.cue_id is null then cli_nombre + ' ['+cli_codigo+']' 
									 else case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end 
							end

						when 15	/*Asiento Contable*/								then 
						case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end  

						when 16	/*Orden de Pago*/										then 
							case when t.cue_id is null then prov_nombre + ' ['+prov_codigo+']'
									 else	case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end 
							end

						when 17	/*Deposito Banco*/									then 
						case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end  

						when 26	/*Movimiento de Fondos*/						then 
						case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre + ' ['+cue_codigo+']' end

						when 2	/*Factura de Compra*/								then prov_nombre + ' ['+prov_codigo+']'
						when 4	/*Remito de Compra*/								then prov_nombre + ' ['+prov_codigo+']'
						when 8	/*Nota de Credito Compra*/					then prov_nombre + ' ['+prov_codigo+']'
						when 10	/*Nota de Debito Compra*/						then prov_nombre + ' ['+prov_codigo+']'
						when 25	/*Devolucion Remito Compra*/				then prov_nombre + ' ['+prov_codigo+']'
						when 35	/*Orden de Compra*/									then prov_nombre + ' ['+prov_codigo+']'
						when 36	/*Cancelacion de Orden de Compra*/	then prov_nombre + ' ['+prov_codigo+']'

					end,

					  convert(varchar(4),fecha,111) 
					+ ' ' 
					+ convert(varchar,datepart(wk,fecha))

	order by aux_id, Fecha, Grupo, Concepto

	set datefirst @oldDateFirst

end
go