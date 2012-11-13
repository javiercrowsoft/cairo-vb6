if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaGetAplic]

go

/*

select * from PedidoVenta

select * 
from PresupuestoPedidoVenta prvpv 
where pvi_id in (select pvi_id from pedidoventaitem where pv_id = 20)

exec sp_DocPedidoVentaGetAplic 1,20,7

*/
create procedure sp_DocPedidoVentaGetAplic (
	@@emp_id      int,
	@@pv_id 			int,
	@@tipo        tinyint    /* 1: Items
														  2: Aplicaciones Facturas
															3: Aplicaciones Posibles Facturas
															4: Aplicaciones Packing
															5: Aplicaciones Posibles Packing
															6: Aplicaciones Presupuesto
															7: Aplicaciones Posibles Presupuesto
														*/
)
as
begin

	declare @cli_id 	int
  declare @doct_id  int

	select @cli_id = cli_id, @doct_id = doct_id from PedidoVenta where pv_id = @@pv_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
	if @@tipo = 1 begin

		select 	
						pvi.pvi_id, 
					 	pvi.pr_id, 
						pr_nombreventa, 
						pvi_pendiente, 
						pvi_cantidadaremitir - pvi_pendiente  as AplicRemito,
						pvi_pendientepklst, 
						pvi_cantidad - pvi_pendientepklst     as AplicPacking,
						pvi_pendienteprv,
						pvi_cantidad - pvi_pendienteprv       as AplicPresu,
						pvi_orden
	
	  from 
					PedidoVentaItem pvi 	inner join Producto p on pvi.pr_id  = p.pr_id
		where 
					pvi.pv_id = @@pv_id
	
		order by 
						pvi_orden

	end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Facturas
		if @@tipo = 2 begin


	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Devoluciones
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if @doct_id = 22 /* Devolucion */ begin

				-- Pedidos
				select  
											pvi.pvi_id,																							-- Item
											pvi.pr_id,																							-- Producto

											0											as fvi_id,												-- Factura
											pvd.pvi_id          	as pvd_id,												-- Pedido de venta
											0                   	as rvi_id,												-- Remito
											pvdv_id								as vinc_id,												-- id Aplicacion

											pvdv_cantidad       	as Aplicado,											-- Aplicacion

											doc_nombre,																							-- Datos del item del pedido de venta
                      pv_nrodoc    					as nrodoc,												--
											pv_fecha            	as Fecha,													--
											pvd.pvi_pendiente	    as Pendiente,											--

											pvd.pvi_orden					as orden													--
											
				from 
							-- Items de la devolucion       tabal de vinculacion                               (es una devolucion)
							PedidoVentaItem pvi  inner join PedidoDevolucionVenta pvdv 	on pvi.pvi_id   = pvdv.pvi_id_devolucion

																					--  Items de pedidos asociados con la devolucion       (es un pedido)
                                   inner join PedidoVentaItem pvd  				on pvdv.pvi_id_pedido = pvd.pvi_id

																							-- Datos del documento de los items de pedido asociadso con la devolucion
																	 inner join PedidoVenta pv         		  on pvd.pv_id    = pv.pv_id
																	 inner join Documento doc           		on pv.doc_id    = doc.doc_id
				where
										pvi.pv_id = @@pv_id  	-- solo items de la devolucion solicitada

				order by pvi.pvi_orden

 			end else begin

	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Pedidos
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					-- Devoluciones
							select  
														pvi.pvi_id,																	-- Item
														pvi.pr_id,																	-- Producto

														0											as fvi_id,						-- Factura
														pvd.pvi_id          	as pvd_id,						-- Devolucion
														0                     as rvi_id,						-- Remito
														pvdv_id								as vinc_id,						-- Id Aplicacion

														pvdv_cantidad       	as Aplicado,					-- Aplicacion

														doc_nombre,																	-- Datos del item de la devolucion
                            pv_nrodoc    					as nrodoc,						--
														pv_fecha            	as Fecha,							--
														pvd.pvi_pendiente			as Pendiente,					--

														pvd.pvi_orden					as orden							--
														
							from 

								-- Items del pedido             tabla vinculacion                                  (es un pedido)
								PedidoVentaItem pvi  inner join PedidoDevolucionVenta pvdv 	on pvi.pvi_id   = pvdv.pvi_id_pedido

																						-- Items de Devolucion asociados con el pedido         (es una devolucion)
                                     inner join PedidoVentaItem pvd  				on pvdv.pvi_id_devolucion = pvd.pvi_id

																						--
																		 inner join PedidoVenta pv         		  on pvd.pv_id    = pv.pv_id
																		 inner join Documento doc           		on pv.doc_id    = doc.doc_id
							where
													pvi.pv_id = @@pv_id 	-- solo items de la devolucion solicitada
				union

					-- Facturas
							select  
														pvi.pvi_id,																		-- Item
														pvi.pr_id,																		-- Producto

														fvi.fvi_id,																		-- Factura
														0                   as pvd_id,								-- Devolucion
														0                   as rvi_id,								-- Remito
														pvfv_id							as vinc_id,								-- Id Aplicacion

														pvfv_cantidad       as Aplicado,							-- Aplicacion

														doc_nombre,																		--  Datos del item de la devolucion
                            fv_nrodoc    				as nrodoc,								--
														fv_fecha            as Fecha,									--
														fvi_pendiente				as Pendiente,							--

														fvi_orden						as orden									--
														
							from 

								-- Items del pedido             tabla vinculacion                         
								PedidoVentaItem pvi  inner join PedidoFacturaVenta pvfv on pvi.pvi_id   = pvfv.pvi_id
                                     inner join FacturaVentaItem fvi    on pvfv.fvi_id  = fvi.fvi_id
																		 inner join FacturaVenta fv         on fvi.fv_id    = fv.fv_id
																		 inner join Documento doc           on fv.doc_id    = doc.doc_id
							where
												pvi.pv_id = @@pv_id		-- solo items de la devolucion solicitada

			union

					-- Remitos
							select  
														pvi.pvi_id,																		-- Item
														pvi.pr_id,																		-- Producto

														0                   as fvi_id,								-- Factura
														0                   as pvd_id,								-- Devolucion
														rvi.rvi_id,        														-- Remito
														pvrv_id							as vinc_id,								-- Id Aplicacion

														pvrv_cantidad       as Aplicado,							-- Aplicacion

														doc_nombre,																		--  Datos del item de la devolucion
                            rv_nrodoc    				as nrodoc,								--
														rv_fecha            as Fecha,									--
														rvi_pendiente				as Pendiente,							--

														rvi_orden						as orden									--
														
							from 

								-- Items del pedido             tabla vinculacion                         
								PedidoVentaItem pvi  inner join PedidoRemitoVenta pvrv  on pvi.pvi_id   = pvrv.pvi_id
                                     inner join RemitoVentaItem rvi     on pvrv.rvi_id  = rvi.rvi_id
																		 inner join RemitoVenta rv          on rvi.rv_id    = rv.rv_id
																		 inner join Documento doc           on rv.doc_id    = doc.doc_id
							where
												pvi.pv_id = @@pv_id		-- solo items de la devolucion solicitada
			
			  order by nrodoc, fecha 
			
      end


		end else begin -- 2: if Aplicaciones Facturas
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Facturas
			if @@tipo = 3 begin

		    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				--
				--	 Devoluciones
				--
				--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				if @doct_id = 22 /* Devolucion */ begin
	
							select  
														pvi.pvi_id,															-- Item
														pvi.pr_id,															-- Producto

														0											as fvi_id,				-- Factura
														pvd.pvi_id          	as pvd_id,				-- Pedido de venta
														0                     as rvi_id,				-- Remito
														0											as vinc_id,				-- Id Aplicacion


														0							      	as Aplicado,			-- Aplicacion

														doc_nombre,															-- Datos del item del pedido
                            rd.pv_nrodoc    			as nrodoc,				--
														rd.pv_fecha         	as Fecha,					--
														pvd.pvi_pendiente			as Pendiente,			--

														pvd.pvi_orden					as orden					--
														
							from 
										-- Items de la devolucion       ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros pedidos de venta
                                                  --' de tipo pedido que puedan vincularce con esta devolucion 
										PedidoVentaItem pvi  inner join PedidoVenta pv 			  on pvi.pv_id = pv.pv_id

																									-- Vinculacion con el cliente y contra pedidos unicamente
																				 inner join PedidoVenta rd  			on 		pv.cli_id  = rd.cli_id 
																																						and rd.doct_id = 5
																																						and rd.est_id  <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id
			
																									-- Ahora vinculo con los items de dichos pedidos que posean el mismo
                                                  -- producto que el item de la devolucion
			                                   inner join PedidoVentaItem pvd   on 			pv.pv_id  = pvd.pv_id 
																																							and pvi.pr_id = pvd.pr_id

							where
														pvi.pv_id = @@pv_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del pedido
												and pvd.pvi_pendiente > 0  

												-- El 'pedido venta item' no tiene que estar vinculado 
												-- con ningun item de esta devolucion
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del pedido
																					--
												and not exists(select * 													
																				from PedidoDevolucionVenta pvdv 	

                                          where 
																										-- Ahora vinculo este item con el item de la devolucion
																											pvdv.pvi_id_devolucion = pvi.pvi_id 
																									and 
																										-- y con el item del pedido
																											pvdv.pvi_id_pedido = pvd.pvi_id)

				  order by nroDoc, fecha 

		    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				--
				--	 Pedidos
				--
				--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				end else begin

								select  
															pvi.pvi_id,																	-- Item
															pvi.pr_id,																	-- Producto
	
															0												as fvi_id,						-- Factura
															pvd.pvi_id          		as pvd_id,						-- Devolucion
  														0                   		as rvi_id,						-- Remito
															0												as vinc_id,						-- Id Aplicacion
	
															0                   		as Aplicado,					-- Aplicacion
	
															doc_nombre,																		-- Datos del item de la devolucion
	                            rd.pv_nrodoc    				as nrodoc,						--
															rd.pv_fecha         		as Fecha,							--
															pvd.pvi_pendiente		as Pendiente,					--
	
															pvd.pvi_orden						as orden							--
															
								from 
										-- Items del pedido       			' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a devoluciones
                                                  --' que puedan vincularce con este pedido
										PedidoVentaItem pvi  inner join PedidoVenta pv 			  on pvi.pv_id = pv.pv_id

																									-- Vinculacion con el cliente y contra devoluciones unicamente
																				 inner join PedidoVenta rd  			on 		pv.cli_id  = rd.cli_id 
																																						and rd.doct_id = 22
																																						and rd.est_id  <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichas devoluciones que posean el mismo
                                                  -- producto que el item del pedido
                                         inner join PedidoVentaItem pvd   on 			rd.pv_id  = pvd.pv_id 
																																							and pvi.pr_id = pvd.pr_id
	
								where
														pvi.pv_id = @@pv_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del pedido
												and pvd.pvi_pendiente > 0		

												-- El 'pedido venta item' no tiene que estar vinculado 
												-- con ningun item de este pedido
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del pedido
																					--
												and not exists(select * 
																					from PedidoDevolucionVenta pvdv 

	                                          where 
																										-- Ahora vinculo este item con el item del pedido
																										pvdv.pvi_id_pedido = pvi.pvi_id 
																								and 
																										-- y con el item de la devaluacion
																										pvdv.pvi_id_devolucion = pvd.pvi_id)

						union
	
								select  
															pvi.pvi_id,															-- Item
															pvi.pr_id,															-- Producto
	
															fvi.fvi_id					as fvi_id,					-- Factura
															0             			as pvd_id,					-- Devolucion
															0                   as rvi_id,					-- Remito
															0                   as vinc_id,					-- Id Devolucion
	
															0						        as Aplicado,				-- Aplicacion
	
															doc_nombre,															-- Datos del item de la factura
	                            fv_nrodoc    				as nrodoc,					--
															fv_fecha            as Fecha,						--
															fvi.fvi_pendiente		as Pendiente,				--
	
															fvi.fvi_orden				as orden						--
															
								from 
										-- Items del pedido       			' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otras facturas
                                                  --' que puedan vincularce con este pedido
										PedidoVentaItem pvi  inner join PedidoVenta pv 			  on pvi.pv_id = pv.pv_id

																									-- Vinculacion con el cliente y contra pedidos unicamente
																			   inner join FacturaVenta fv  			on 		pv.cli_id = fv.cli_id
																																						and fv.doct_id in (1,9)
																																						and fv.est_id <> 7

																				 inner join Documento doc         on fv.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichas facturas que posean el mismo
                                                  -- producto que el item del pedido
                                         inner join FacturaVentaItem fvi  on 			fv.fv_id  = fvi.fv_id 
																																							and pvi.pr_id = fvi.pr_id
	
								where
														pvi.pv_id = @@pv_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del pedido
												and fvi.fvi_pendiente > 0
	
												-- El 'pedido venta item' no tiene que estar vinculado 
												-- con ningun item de este pedido
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del pedido
																					--
												and not exists(select * 
																					from PedidoFacturaVenta pvfv 

	                                          where 
																										-- y con el item del pedido
																										pvfv.pvi_id = pvi.pvi_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										pvfv.fvi_id = fvi.fvi_id)

					union

								select  
															pvi.pvi_id,															-- Item
															pvi.pr_id,															-- Producto
	
															0										as fvi_id,					-- Factura
															0             			as pvd_id,					-- Devolucion
															rvi.rvi_id,															-- Remito
															0                   as vinc_id,					-- Id Devolucion
	
															0						        as Aplicado,				-- Aplicacion
	
															doc_nombre,															-- Datos del item de la factura
	                            rv_nrodoc    				as nrodoc,					--
															rv_fecha            as Fecha,						--
															rvi.rvi_pendiente		as Pendiente,				--
	
															rvi.rvi_orden				as orden						--
															
								from 
										-- Items del pedido       			' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros remitos
                                                  --' que puedan vincularce con este pedido
										PedidoVentaItem pvi  inner join PedidoVenta pv 			  on pvi.pv_id = pv.pv_id

																									-- Vinculacion con el cliente y contra pedidos unicamente
																			   inner join RemitoVenta rv  			on 		pv.cli_id  = rv.cli_id
																																						and rv.doct_id = 3
																																						and rv.est_id  <> 7

																				 inner join Documento doc         on rv.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item del pedido
                                         inner join RemitoVentaItem rvi   on 			rv.rv_id  = rvi.rv_id 
																																							and pvi.pr_id = rvi.pr_id
	
								where
														pvi.pv_id = @@pv_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del pedido
												and rvi.rvi_pendiente > 0
	
												-- El 'pedido venta item' no tiene que estar vinculado 
												-- con ningun item de este pedido
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del pedido
																					--
												and not exists(select * 
																					from PedidoRemitoVenta pvrv 

	                                          where 
																										-- y con el item del pedido
																										pvrv.pvi_id = pvi.pvi_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										pvrv.rvi_id = rvi.rvi_id)

					  order by nroDoc, fecha 

				end

			end else begin -- 3: if Aplicaciones Posibles Facturas

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Packing
				if @@tipo = 4 begin

						select  
													pvi.pvi_id,																		-- Item
													pvi.pr_id,																		-- Producto

													pklsti.pklsti_id,															-- Pedido
													pvpklst_id          as vinc_id,								-- Id Aplicacion

													pvpklst_cantidad    as Aplicado,							-- Aplicacion

													doc_nombre,																		--  Datos del item de la devolucion
                          pklst_nrodoc 				as nrodoc,								--
													pklst_fecha         as Fecha,									--
													pklsti_pendiente				as Pendiente,					--

													pklsti_orden						as orden							--
													
						from 

							-- Items del pedido             tabla vinculacion                         
							PedidoVentaItem pvi  inner join PedidoPackingList pvpk  on pvi.pvi_id   		= pvpk.pvi_id
                                   inner join PackingListItem pklsti  on pvpk.pklsti_id  	= pklsti.pklsti_id
																	 inner join PackingList pk          on pklsti.pklst_id 	= pk.pklst_id
																	 inner join Documento doc           on pk.doc_id    		= doc.doc_id
						where
											pvi.pv_id = @@pv_id		-- solo items de la devolucion solicitada
		
		  			order by nrodoc, fecha 
			
				end else begin -- 4: if Aplicaciones Packing

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Packing
					if @@tipo = 5 begin

								select  
															pvi.pvi_id,													-- Item
															pvi.pr_id,													-- Producto
	
															pklsti_id,															-- Pedidos
															0                   as vinc_id,			-- Id Aplicacion
	
															0       						as Aplicado,		-- Aplicacion
	
															doc_nombre,													-- Datos del documento
	                            pklst_nrodoc    					as nrodoc,			--
															pklst_fecha            		as Fecha,				--
															pklsti.pklsti_pendiente		as Pendiente,		--
	
															pklsti.pklsti_orden				as orden				--
															
								from 
										-- Items del pedido       			' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros pedidos de venta
                                                  --' de tipo pedido que puedan vincularce con esta devolucion 
										PedidoVentaItem pvi  inner join PedidoVenta pv 			  on pvi.pv_id = pv.pv_id

																									-- Vinculacion con el cliente y contra pedidos unicamente
																			   inner join PackingList pk  			on 		pv.cli_id  = pk.cli_id
																																						and pk.doct_id = 21
																																						and pk.est_id  <> 7

																				 inner join Documento doc         on pk.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos pedidos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join PackingListItem pklsti  on 		pk.pklst_id  = pklsti.pklst_id 
																																							and pvi.pr_id    = pklsti.pr_id
	
								where
														pvi.pv_id = @@pv_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del pedido
												and pklsti.pklsti_pendiente > 0

												-- El 'pedido venta item' no tiene que estar vinculado 
												-- con ningun item de este pedido
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del pedido
																					--
												and not exists(select * 
																					from PedidoPackingList pvpk 

	                                          where 
																										-- y con el item del pedido
																										pvpk.pvi_id = pvi.pvi_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										pvpk.pklsti_id = pklsti.pklsti_id)


					  		order by nroDoc, fecha 

					end else begin -- 5: if Aplicaciones Posibles Packing List

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 6: Aplicaciones Packing
						if @@tipo = 6 begin
		
								select  
															pvi.pvi_id,															-- Item
															pvi.pr_id,															-- Producto
		
															prvi.prvi_id,														-- Pedido
															prvpv_id          as vinc_id,						-- Id Aplicacion
		
															prvpv_cantidad    as Aplicado,					-- Aplicacion
		
															doc_nombre,															--  Datos del item de la devolucion
		                          prv_nrodoc 				as nrodoc,						--
															prv_fecha         as Fecha,							--
															prvi_pendiente		as Pendiente,					--
		
															prvi_orden				as orden							--
															
								from 
		
									-- Items del pedido             tabla vinculacion                         
									PedidoVentaItem pvi  inner join PresupuestoPedidoVenta prvpv  	on pvi.pvi_id   		= prvpv.pvi_id
		                                   inner join PresupuestoVentaItem prvi  			on prvpv.prvi_id  	= prvi.prvi_id
																			 inner join PresupuestoVenta prv          	on prvi.prv_id 			= prv.prv_id
																			 inner join Documento doc           				on prv.doc_id    		= doc.doc_id
								where
													pvi.pv_id = @@pv_id		-- solo items de la devolucion solicitada
				
				  			order by nrodoc, fecha 
					
						end else begin -- 6: if Aplicaciones Packing
		
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 7: Aplicaciones Posibles Packing
							if @@tipo = 7 begin
		
										select  distinct
																	0 										as pvi_id,			-- Item
																	pvi.pr_id,														-- Producto
			
																	prvi_id,															-- Pedidos
																	0                   	as vinc_id,			-- Id Aplicacion
			
																	0       							as Aplicado,		-- Aplicacion
			
																	doc_nombre,														-- Datos del documento
			                            prv_nrodoc    				as nrodoc,			--
																	prv_fecha            	as Fecha,				--
																	prvi.prvi_pendiente		as Pendiente,		--
			
																	prvi.prvi_orden				as orden				--
																	
										from 
												-- Items del pedido       			' Voy hasta el header para obtener el cliente
		                                                  --' y lo uso para hacer un join a otros pedidos de venta
		                                                  --' de tipo pedido que puedan vincularce con esta devolucion 
												PedidoVentaItem pvi  inner join PedidoVenta pv 			  on pvi.pv_id = pv.pv_id
		
																											-- Vinculacion con el cliente y contra pedidos unicamente
																					   inner join PresupuestoVenta prv  			on 		pv.cli_id  = prv.cli_id
																																								and prv.doct_id = 11
																																								and prv.est_id  <> 7
		
																						 inner join Documento doc         on prv.doc_id = doc.doc_id
		
																											-- Ahora vinculo con los items de dichos pedidos que posean el mismo
		                                                  -- producto que el item de la devolucion
		                                         inner join PresupuestoVentaItem prvi  on prv.prv_id  = prvi.prv_id 
																																									and pvi.pr_id   = prvi.pr_id
			
										where
																pvi.pv_id = @@pv_id
		
														-- Empresa
														and doc.emp_id = @@emp_id
		
														-- Tiene que haber pendiente en el item del pedido
														and prvi.prvi_pendiente > 0
		
														-- El 'pedido venta item' no tiene que estar vinculado 
														-- con ningun item de este pedido
														--
																							-- Busco que no exista en la tabla 
																							-- de vinculacion algun vinculo entre
																							-- el item de la devolucion y el del pedido
																							--
														and not exists(select * 
																							from PresupuestoPedidoVenta prvpv 
																										inner join PedidoVentaItem pvi2
																																		on 	prvpv.pvi_id = pvi2.pvi_id
																																		and pvi2.pv_id 	 = @@pv_id
		
			                                          where 
																												-- Ahora vinculo este item con el item de la factura
																												prvpv.prvi_id = prvi.prvi_id)
		
		
							  		order by nroDoc, fecha 
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 7: Aplicaciones Posibles Packing
							end -- 7: Else Aplicaciones Posibles Packing
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 6: Aplicaciones Packing
						end -- 6: Else Aplicaciones Packing
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Packing
					end -- 5: Else Aplicaciones Posibles Packing
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Packing
				end -- 4: Else Aplicaciones Packing
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Facturas
			end -- 3: Else Aplicaciones Posibles Facturas
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Facturas
		end -- 2: Else Aplicaciones Facturas
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
	end -- 1: Else Items
end

go

