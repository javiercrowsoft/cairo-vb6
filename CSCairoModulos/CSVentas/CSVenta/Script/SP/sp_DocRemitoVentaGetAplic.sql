if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetAplic]

go

/*

sp_DocRemitoVentaGetAplic 1,47,4

*/
create procedure sp_DocRemitoVentaGetAplic (
	@@emp_id      int,
	@@rv_id 			int,
	@@tipo        tinyint    /* 1: Items
														  2: Aplicaciones Facturas
															3: Aplicaciones Posibles Facturas
															4: Aplicaciones Pedidos y Ordenes
															5: Aplicaciones Posibles Pedidos y Ordenes
														*/
)
as
begin

	declare @cli_id 	int
  declare @doct_id  int

	select @cli_id = cli_id, @doct_id = doct_id from RemitoVenta where rv_id = @@rv_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
	if @@tipo = 1 begin

		select 	
						rvi.rvi_id, 
					 	rvi.pr_id, 
						case pr_sevende
							when 0 then pr_nombrecompra
							else        pr_nombreventa
						end as pr_nombreventa, 
						rvi_pendientefac, 
						rvi_cantidadaremitir - rvi_pendientefac  as AplicRemito,
						rvi_pendiente, 
						rvi_cantidad - rvi_pendiente     as AplicPedido,
						rvi_orden,
						pr_esrepuesto
	
	  from 
					RemitoVentaItem rvi 	inner join Producto p on rvi.pr_id  = p.pr_id
		where 
					rvi.rv_id = @@rv_id
	
		order by 
						rvi_orden

	end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Facturas
		if @@tipo = 2 begin


	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Devoluciones
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if @doct_id = 24 /* Devolucion */ begin

				-- Remitos
				select  
											rvi.rvi_id,																							-- Item
											rvi.pr_id,																							-- Producto

											0											as fvi_id,												-- Factura
											rvd.rvi_id          	as rvd_id,												-- Remito de venta
											rvdv_id								as rvfvdv_id, 										-- id Aplicacion

											rvdv_cantidad       	as Aplicado,											-- Aplicacion

											doc_nombre,																							-- Datos del item del remito de venta
                      rv_nrodoc    					as nrodoc,												--
											rv_fecha            	as Fecha,													--
											rvd.rvi_pendientefac	as Pendiente,											--

											rvd.rvi_orden					as orden													--
											
				from 
							-- Items de la devolucion       tabal de vinculacion                               (es una devolucion)
							RemitoVentaItem rvi  inner join RemitoDevolucionVenta rvdv 	on rvi.rvi_id   = rvdv.rvi_id_devolucion

																					--  Items de remitos asociados con la devolucion       (es un remito)
                                   inner join RemitoVentaItem rvd  				on rvdv.rvi_id_remito = rvd.rvi_id

																							-- Datos del documento de los items de remito asociadso con la devolucion
																	 inner join RemitoVenta rv         		  on rvd.rv_id    = rv.rv_id
																	 inner join Documento doc           		on rv.doc_id    = doc.doc_id
				where
										rvi.rv_id = @@rv_id  	-- solo items de la devolucion solicitada

				order by rvi.rvi_orden

 			end else begin

	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Remitos
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					-- Devoluciones
							select  
														rvi.rvi_id,																	-- Item
														rvi.pr_id,																	-- Producto

														0											as fvi_id,						-- Factura
														rvd.rvi_id          	as rvd_id,						-- Devolucion
														rvdv_id								as rvfvdv_id,					-- Id Aplicacion

														rvdv_cantidad       	as Aplicado,					-- Aplicacion

														doc_nombre,																	-- Datos del item de la devolucion
                            rv_nrodoc    					as nrodoc,						--
														rv_fecha            	as Fecha,							--
														rvd.rvi_pendientefac	as Pendiente,					--

														rvd.rvi_orden					as orden							--
														
							from 

								-- Items del remito             tabla vinculacion                                  (es un remito)
								RemitoVentaItem rvi  inner join RemitoDevolucionVenta rvdv 	on rvi.rvi_id   = rvdv.rvi_id_remito

																						-- Items de Devolucion asociados con el remito         (es una devolucion)
                                     inner join RemitoVentaItem rvd  				on rvdv.rvi_id_devolucion = rvd.rvi_id

																						--
																		 inner join RemitoVenta rv         		  on rvd.rv_id    = rv.rv_id
																		 inner join Documento doc           		on rv.doc_id    = doc.doc_id
							where
													rvi.rv_id = @@rv_id 	-- solo items de la devolucion solicitada
				union

					-- Facturas
							select  
														rvi.rvi_id,																		-- Item
														rvi.pr_id,																		-- Producto

														fvi.fvi_id,																		-- Factura
														0                   as rvd_id,								-- Devolucion
														rvfv_id							as rvfvdv_id,							-- Id Aplicacion

														rvfv_cantidad       as Aplicado,							-- Aplicacion

														doc_nombre,																		--  Datos del item de la devolucion
                            fv_nrodoc    				as nrodoc,								--
														fv_fecha            as Fecha,									--
														fvi_pendiente				as Pendiente,							--

														fvi_orden						as orden									--
														
							from 

								-- Items del remito             tabla vinculacion                         
								RemitoVentaItem rvi  inner join RemitoFacturaVenta rvfv on rvi.rvi_id   = rvfv.rvi_id
                                     inner join FacturaVentaItem fvi    on rvfv.fvi_id  = fvi.fvi_id
																		 inner join FacturaVenta fv         on fvi.fv_id    = fv.fv_id
																		 inner join Documento doc           on fv.doc_id    = doc.doc_id
							where
												rvi.rv_id = @@rv_id		-- solo items de la devolucion solicitada
			
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
				if @doct_id = 24 /* Devolucion */ begin
	
							select distinct 
														0                     as rvi_id,				-- Item
														rvi.pr_id,															-- Producto

														0											as fvi_id,				-- Factura
														rvd.rvi_id          	as rvd_id,				-- Remito de venta
														0											as rvfvdv_id,			-- Id Aplicacion


														0							      	as Aplicado,			-- Aplicacion

														doc_nombre,															-- Datos del item del remito
                            rd.rv_nrodoc    			as nrodoc,				--
														rd.rv_fecha         	as Fecha,					--
														rvd.rvi_pendientefac	as Pendiente,			--

														rvd.rvi_orden					as orden					--
														
							from 
										-- Items de la devolucion       ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros remitos de venta
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										RemitoVentaItem rvi  inner join RemitoVenta rv 			  on rvi.rv_id = rv.rv_id

																									-- Vinculacion con el cliente y contra remitos unicamente
																				 inner join RemitoVenta rd  			on 		rv.cli_id  = rd.cli_id 
																																						and rd.doct_id = 3
																																						and rd.est_id  <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id
			
																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
			                                   inner join RemitoVentaItem rvd   on 			rd.rv_id  = rvd.rv_id 
																																							and rvi.pr_id = rvd.pr_id

							where
														rvi.rv_id = @@rv_id

												-- Empresa
												and doc.emp_id 	= @@emp_id
												and doc.doct_id = 3

												-- Tiene que haber pendiente en el item del remito
												and rvd.rvi_pendientefac > 0  

												-- El 'remito venta item' no tiene que estar vinculado 
												-- con ningun item de esta devolucion
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del remito
																					--
												and not exists(select * 													
																				from RemitoDevolucionVenta rvdv 	

                                          where 
																										-- Ahora vinculo este item con el item de la devolucion
																											rvdv.rvi_id_devolucion = rvi.rvi_id 
																									and 
																										-- y con el item del remito
																											rvdv.rvi_id_remito = rvd.rvi_id)

				  order by nroDoc, fecha 

		    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				--
				--	 Remitos
				--
				--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				end else begin

								select distinct top 100
															0                       as rvi_id,  					-- Item
															rvi.pr_id,													  				-- Producto
	
															0												as fvi_id,						-- Factura
															rvd.rvi_id          		as rvd_id,						-- Devolucion
															0												as rvfvdv_id,					-- Id Aplicacion
	
															0                   		as Aplicado,					-- Aplicacion
	
															doc_nombre,																		-- Datos del item de la devolucion
	                            rd.rv_nrodoc    				as nrodoc,						--
															rd.rv_fecha         		as Fecha,							--
															rvd.rvi_pendientefac		as Pendiente,					--
	
															rvd.rvi_orden						as orden							--
															
								from 
										-- Items del remito             ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros remitos de venta
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										RemitoVentaItem rvi  inner join RemitoVenta rv 			  on rvi.rv_id = rv.rv_id

																									-- Vinculacion con el cliente y contra remitos unicamente
																				 inner join RemitoVenta rd  			on 		rv.cli_id  = rd.cli_id 
																																						and rd.doct_id = 24
																																						and rd.est_id  <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join RemitoVentaItem rvd   on 			rd.rv_id  = rvd.rv_id 
																																							and rvi.pr_id = rvd.pr_id
	
								where
														rvi.rv_id = @@rv_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del remito
												and rvd.rvi_pendientefac > 0		

												-- El 'remito venta item' no tiene que estar vinculado 
												-- con ningun item de este remito
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del remito
																					--
												and not exists(select * 
																					from RemitoDevolucionVenta rvdv 

	                                          where 
																										-- Ahora vinculo este item con el item del remito
																										rvdv.rvi_id_remito = rvi.rvi_id 
																								and 
																										-- y con el item de la devaluacion
																										rvdv.rvi_id_devolucion = rvd.rvi_id)

						union
	
								select distinct top 100
															0                   as rvi_id,					-- Item
															rvi.pr_id,															-- Producto
	
															fvi.fvi_id					as fvi_id,					-- Factura
															0             			as rvd_id,					-- Devolucion
															0                   as rvfvdv_id,				-- Id Devolucion
	
															0						        as Aplicado,				-- Aplicacion
	
															doc_nombre,															-- Datos del item de la factura
	                            fv_nrodoc    				as nrodoc,					--
															fv_fecha            as Fecha,						--
															fvi.fvi_pendiente		as Pendiente,				--
	
															fvi.fvi_orden				as orden						--
															
								from 
										-- Items del remito       			' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros remitos de venta
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										RemitoVentaItem rvi  inner join RemitoVenta rv 			  on rvi.rv_id = rv.rv_id

																									-- Vinculacion con el cliente y contra remitos unicamente
																			   inner join FacturaVenta fv  			on 	rv.cli_id  = fv.cli_id
																																					and fv.doct_id in (1,9)
																																					and fv.est_id  <> 7

																				 inner join Documento doc         on fv.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join FacturaVentaItem fvi  on 			fv.fv_id  = fvi.fv_id 
																																							and rvi.pr_id = fvi.pr_id
	
								where
														rvi.rv_id = @@rv_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del remito
												and fvi.fvi_pendiente > 0
	
												-- El 'remito venta item' no tiene que estar vinculado 
												-- con ningun item de este remito
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del remito
																					--
												and not exists(select * 
																					from RemitoFacturaVenta rvfv 

	                                          where 
																										-- y con el item del remito
																										rvfv.rvi_id = rvi.rvi_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										rvfv.fvi_id = fvi.fvi_id)
					  order by nroDoc, fecha 

				end

			end else begin -- 3: if Aplicaciones Posibles Facturas

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Pedidos
				if @@tipo = 4 begin

							select  
														rvi.rvi_id,																		-- Item
														rvi.pr_id,																		-- Producto
	
														pvi.pvi_id,																		-- Pedido
														0                   as osi_id,                
														pvrv_id,																			-- Id Aplicacion
														0                   as osrv_id,
	
														pvrv_cantidad       as Aplicado,							-- Aplicacion
	
														doc_nombre,																		--  Datos del item de la devolucion
	                          pv_nrodoc    				as nrodoc,								--
														pv_fecha            as Fecha,									--
														pvi_pendiente				as Pendiente,							--
	
														pvi_orden						as orden									--
														
							from 
	
								-- Items del remito             tabla vinculacion                         
								RemitoVentaItem rvi  inner join PedidoRemitoVenta pvrv  on rvi.rvi_id   = pvrv.rvi_id
	                                   inner join PedidoVentaItem pvi     on pvrv.pvi_id  = pvi.pvi_id
																		 inner join PedidoVenta pv          on pvi.pv_id    = pv.pv_id
																		 inner join Documento doc           on pv.doc_id    = doc.doc_id
							where
												rvi.rv_id = @@rv_id		-- solo items de la devolucion solicitada
						union

							select  
														rvi.rvi_id,																		-- Item
														rvi.pr_id,																		-- Producto
	
														0                   as pvi_id,                
														osi.osi_id,																		-- Orden
														0                   as pvrv_id,
														osrv_id,																			-- Id Aplicacion
	
														osrv_cantidad       as Aplicado,							-- Aplicacion
	
														doc_nombre,																		--  Datos del item de la devolucion
	                          os_nrodoc    				as nrodoc,								--
														os_fecha            as Fecha,									--
														osi_pendiente				as Pendiente,							--
	
														osi_orden						as orden									--
														
							from 
	
								-- Items del remito             tabla vinculacion                         
								RemitoVentaItem rvi  inner join OrdenRemitoVenta osrv  on rvi.rvi_id   = osrv.rvi_id
	                                   inner join OrdenServicioItem osi  on osrv.osi_id  = osi.osi_id
																		 inner join OrdenServicio os       on osi.os_id    = os.os_id
																		 inner join Documento doc          on os.doc_id    = doc.doc_id
							where
												rvi.rv_id = @@rv_id		-- solo items de la devolucion solicitada

		  			order by nrodoc, fecha 

			
				end else begin -- 4: if Aplicaciones Pedidos

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Pedidos
					if @@tipo = 5 begin

									select top 100
																rvi.rvi_id,													-- Item
																rvi.pr_id,													-- Producto
		
																pvi_id,															-- Pedidos
																0                   as osi_id,                
																0                   as pvrv_id,			-- Id Aplicacion
																0                   as osrv_id,
		
																0       						as Aplicado,		-- Aplicacion
		
																doc_nombre,													-- Datos del documento
		                            pv_nrodoc    				as nrodoc,			--
																pv_fecha            as Fecha,				--
																pvi.pvi_pendiente		as Pendiente,		--
		
																pvi.pvi_orden				as orden				--
																
									from 
											-- Items del remito       			' Voy hasta el header para obtener el cliente
	                                                  --' y lo uso para hacer un join a otros remitos de venta
	                                                  --' de tipo remito que puedan vincularce con esta devolucion 
											RemitoVentaItem rvi  inner join RemitoVenta rv 			  on rvi.rv_id = rv.rv_id
	
																										-- Vinculacion con el cliente y contra remitos unicamente
																				   inner join PedidoVenta pv  			on 		rv.cli_id  = pv.cli_id
																																							and pv.doct_id = 5
																																							and pv.est_id  <> 7
	
																					 inner join Documento doc         on pv.doc_id = doc.doc_id
	
																										-- Ahora vinculo con los items de dichos remitos que posean el mismo
	                                                  -- producto que el item de la devolucion
	                                         inner join PedidoVentaItem pvi  on 			pv.pv_id  = pvi.pv_id 
																																								and rvi.pr_id = pvi.pr_id
		
									where
															rvi.rv_id = @@rv_id
	
													and @doct_id = 3 -- Solo remitos

													-- Empresa
													and doc.emp_id = @@emp_id
	
													-- Tiene que haber pendiente en el item del remito
													and pvi.pvi_pendiente > 0
	
													-- El 'pedido venta item' no tiene que estar vinculado 
													-- con ningun item de este remito
													--
																						-- Busco que no exista en la tabla 
																						-- de vinculacion algun vinculo entre
																						-- el item de la devolucion y el del remito
																						--
													and not exists(select * 
																						from PedidoRemitoVenta pvrv 
	
		                                          where 
																											-- y con el item del remito
																											pvrv.rvi_id = rvi.rvi_id
																									and 
																											-- Ahora vinculo este item con el item de la factura
																											pvrv.pvi_id = pvi.pvi_id)

					  		union

									select top 100
																rvi.rvi_id,													-- Item
																rvi.pr_id,													-- Producto
		
																0                   as pvi_id,                
																osi_id,															-- Ordenes
																0                   as pvrv_id,			-- Id Aplicacion
																0                   as osrv_id,
		
																0       						as Aplicado,		-- Aplicacion
		
																doc_nombre,													-- Datos del documento
		                            os_nrodoc    				as nrodoc,			--
																os_fecha            as Fecha,				--
																osi.osi_pendiente		as Pendiente,		--
		
																osi.osi_orden				as orden				--
																
									from 
											-- Items del remito       			' Voy hasta el header para obtener el cliente
	                                                  --' y lo uso para hacer un join a otros remitos de venta
	                                                  --' de tipo remito que puedan vincularce con esta devolucion 
											RemitoVentaItem rvi  inner join RemitoVenta rv 			  on rvi.rv_id = rv.rv_id
	
																										-- Vinculacion con el cliente y contra remitos unicamente
																				   inner join OrdenServicio os  		on 		rv.cli_id  = os.cli_id
																																							and os.doct_id = 42
																																							and os.est_id  <> 7
	
																					 inner join Documento doc         on os.doc_id = doc.doc_id
	
																										-- Ahora vinculo con los items de dichos remitos que posean el mismo
	                                                  -- producto que el item de la devolucion
	                                         inner join OrdenServicioItem osi on 			os.os_id  = osi.os_id 
																																								and rvi.pr_id = osi.pr_id
		
									where
															rvi.rv_id = @@rv_id
	
													-- Empresa
													and doc.emp_id = @@emp_id
	
													-- Tiene que haber pendiente en el item del remito
													and osi.osi_pendiente > 0
	
													-- El 'pedido venta item' no tiene que estar vinculado 
													-- con ningun item de este remito
													--
																						-- Busco que no exista en la tabla 
																						-- de vinculacion algun vinculo entre
																						-- el item de la devolucion y el del remito
																						--
													and not exists(select * 
																						from OrdenRemitoVenta osrv 
	
		                                          where 
																											-- y con el item del remito
																											osrv.rvi_id = rvi.rvi_id
																									and 
																											-- Ahora vinculo este item con el item de la factura
																											osrv.osi_id = osi.osi_id)

								order by nroDoc, fecha 
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Pedidos
					end -- 5: Else Aplicaciones Posibles Pedidos
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Pedidos
				end -- 4: Else Aplicaciones Pedidos
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

