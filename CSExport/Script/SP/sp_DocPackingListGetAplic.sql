if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListGetAplic]

go

/*

select * from PackingList

sp_DocPackingListGetAplic 24,4

*/
create procedure sp_DocPackingListGetAplic (
	@@emp_id      int,
	@@pklst_id 		int,
	@@tipo        tinyint    /* 1: Items
														  2: Aplicaciones Facturas
															3: Aplicaciones Posibles Facturas
															4: Aplicaciones Pedidos
															5: Aplicaciones Posibles Pedidos
														*/
)
as
begin

	declare @cli_id 	int
  declare @doct_id  int

	select @cli_id = cli_id, @doct_id = doct_id from PackingList where pklst_id = @@pklst_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
	if @@tipo = 1 begin

		select 	
						pklsti.pklsti_id, 
					 	pklsti.pr_id, 
						pr_nombreventa, 
						pklsti_pendientefac, 
						pklsti_cantidad - pklsti_pendientefac  	        as AplicPackingList,
						pklsti_pendiente, 
						pklsti_cantidad - pklsti_pendiente     					as AplicPedido,
						pklsti_orden
	
	  from 
					PackingListItem pklsti 	inner join Producto p on pklsti.pr_id  = p.pr_id
		where 
					pklsti.pklst_id = @@pklst_id
	
		order by 
						pklsti_orden

	end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Facturas
		if @@tipo = 2 begin


	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Devoluciones
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if @doct_id = 31 /* Devolucion */ begin

				-- packing list
				select  
											pklsti.pklsti_id,																							-- Item
											pklsti.pr_id,																									-- Producto

											0														as fvi_id,												-- Factura
											pklstd.pklsti_id          	as pklstd_id,											-- Packing List
											pklstdv_id									as vinc_id,												-- id Aplicacion

											pklstdv_cantidad       			as Aplicado,											-- Aplicacion

											doc_nombre,																										-- Datos del item del Packing List
                      pklst_nrodoc    						as nrodoc,												--
											pklst_fecha            			as Fecha,													--
											pklstd.pklsti_pendientefac	as Pendiente,											--

											pklstd.pklsti_orden					as orden													--
											
				from 
							-- Items de la devolucion       tabal de vinculacion                               (es una devolucion)
							PackingListItem pklsti  inner join PackingListDevolucion pklstdv 	on pklsti.pklsti_id   = pklstdv.pklsti_id_devolucion

																					--  Items de packing list asociados con la devolucion       (es un packing list)
                                   inner join PackingListItem pklstd  						on pklstdv.pklsti_id_pklst = pklstd.pklsti_id

																							-- Datos del documento de los items de packing list asociadso con la devolucion
																	 inner join PackingList pklst         	on pklstd.pklst_id    = pklst.pklst_id
																	 inner join Documento doc           		on pklst.doc_id    		= doc.doc_id
				where
										pklsti.pklst_id = @@pklst_id  	-- solo items de la devolucion solicitada

				order by pklsti.pklsti_orden

 			end else begin

	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 packing list
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					-- Devoluciones
							select  
														pklsti.pklsti_id,																	-- Item
														pklsti.pr_id,																			-- Producto

														0														as fvi_id,						-- Factura
														pklstd.pklsti_id          	as pklstd_id,					-- Devolucion
														pklstdv_id									as vinc_id,						-- Id Aplicacion

														pklstdv_cantidad       			as Aplicado,					-- Aplicacion

														doc_nombre,																				-- Datos del item de la devolucion
                            pklst_nrodoc    						as nrodoc,						--
														pklst_fecha            			as Fecha,							--
														pklstd.pklsti_pendientefac	as Pendiente,					--

														pklstd.pklsti_orden					as orden							--
														
							from 

								-- Items packing list             tabla vinculacion                                  (es un packing list)
								PackingListItem pklsti  inner join PackingListDevolucion pklstdv 	on pklsti.pklsti_id   = pklstdv.pklsti_id_pklst

																						-- Items de Devolucion asociados con el packing list         (es una devolucion)
                                     inner join PackingListItem pklstd  						on pklstdv.pklsti_id_devolucion = pklstd.pklsti_id

																						--
																		 inner join PackingList pklst         		  on pklstd.pklst_id    = pklst.pklst_id
																		 inner join Documento doc           		on pklst.doc_id    		= doc.doc_id
							where
													pklsti.pklst_id = @@pklst_id 	-- solo items de la devolucion solicitada
				union

					-- Facturas
							select  
														pklsti.pklsti_id,																		-- Item
														pklsti.pr_id,																				-- Producto

														fvi.fvi_id,																				-- Factura
														0                   		as pklstd_id,							-- Devolucion
														pklstfv_id							as vinc_id,								-- Id Aplicacion

														pklstfv_cantidad       	as Aplicado,							-- Aplicacion

														doc_nombre,																		--  Datos del item de la devolucion
                            fv_nrodoc    				as nrodoc,								--
														fv_fecha            as Fecha,									--
														fvi_pendientepklst	as Pendiente,							--

														fvi_orden						as orden									--
														
							from 

								-- Items packing list             tabla vinculacion                         
								PackingListItem pklsti  inner join PackingListFacturaVenta pklstfv on pklsti.pklsti_id   = pklstfv.pklsti_id
                                     inner join FacturaVentaItem fvi    on pklstfv.fvi_id  	= fvi.fvi_id
																		 inner join FacturaVenta fv         on fvi.fv_id    		= fv.fv_id
																		 inner join Documento doc           on fv.doc_id    		= doc.doc_id
							where
												pklsti.pklst_id = @@pklst_id		-- solo items de la devolucion solicitada
			
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
				if @doct_id = 31 /* Devolucion */ begin
	
							select  
														pklsti.pklsti_id,															-- Item
														pklsti.pr_id,																	-- Producto

														0														as fvi_id,				-- Factura
														pklstd.pklsti_id          	as pklstd_id,			-- Packing List de venta
														0														as vinc_id,				-- Id Aplicacion


														0							      				as Aplicado,			-- Aplicacion

														doc_nombre,																		-- Datos del item packing list
                            rd.pklst_nrodoc    					as nrodoc,				--
														rd.pklst_fecha         			as Fecha,					--
														pklstd.pklsti_pendientefac	as Pendiente,			--

														pklstd.pklsti_orden					as orden					--
														
							from 
										-- Items de la devolucion       ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros packing list de venta
                                                  --' de tipo packing list que puedan vincularce con esta devolucion 
										PackingListItem pklsti  inner join PackingList pklst 			  on pklsti.pklst_id = pklst.pklst_id

																									-- Vinculacion con el cliente y contra packing list unicamente
																				 inner join PackingList rd  			on 		pklst.cli_id = rd.cli_id 
																																						and rd.doct_id 	 = 31
																																						and rd.est_id 	 <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id
			
																									-- Ahora vinculo con los items de dichos packing list que posean el mismo
                                                  -- producto que el item de la devolucion
			                                   inner join PackingListItem pklstd   on 	pklst.pklst_id  = pklstd.pklst_id 
																																							and pklsti.pr_id 		= pklstd.pr_id

							where
														pklsti.pklst_id = @@pklst_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item packing list
												and pklstd.pklsti_pendientefac > 0  

												-- El 'packing list item' no tiene que estar vinculado 
												-- con ningun item de esta devolucion
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el packing list
																					--
												and not exists(select * 													
																				from PackingListDevolucion pklstdv 	

                                          where 
																										-- Ahora vinculo este item con el item de la devolucion
																											pklstdv.pklsti_id_devolucion = pklsti.pklsti_id 
																									and 
																										-- y con el item packing list
																											pklstdv.pklsti_id_pklst = pklstd.pklsti_id)

				  order by nroDoc, fecha 

		    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				--
				--	 packing list
				--
				--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				end else begin

								select  
															pklsti.pklsti_id,																	-- Item
															pklsti.pr_id,																			-- Producto
	
															0															as fvi_id,						-- Factura
															pklstd.pklsti_id          		as pklstd_id,					-- Devolucion
															0															as vinc_id,						-- Id Aplicacion
	
															0                   					as Aplicado,					-- Aplicacion
	
															doc_nombre,																					-- Datos del item de la devolucion
	                            rd.pklst_nrodoc    						as nrodoc,						--
															rd.pklst_fecha         				as Fecha,							--
															pklstd.pklsti_pendientefac		as Pendiente,					--
	
															pklstd.pklsti_orden						as orden							--
															
								from 
										-- Items packing list             ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros packing list de venta
                                                  --' de tipo packing list que puedan vincularce con esta devolucion 
										PackingListItem pklsti  inner join PackingList pklst 			  on pklsti.pklst_id = pklst.pklst_id

																									-- Vinculacion con el cliente y contra packing list unicamente
																				 inner join PackingList rd  			on 		pklst.cli_id = rd.cli_id 
																																						and rd.doct_id 	 = 21
																																						and rd.est_id 	 <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos packing list que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join PackingListItem pklstd   on 			rd.pklst_id  = pklstd.pklst_id 
																																							and pklsti.pr_id = pklstd.pr_id
	
								where
														pklsti.pklst_id = @@pklst_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item packing list
												and pklstd.pklsti_pendientefac > 0		

												-- El 'packing list item' no tiene que estar vinculado 
												-- con ningun item de este packing list
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el packing list
																					--
												and not exists(select * 
																					from PackingListDevolucion pklstdv 

	                                          where 
																										-- Ahora vinculo este item con el item packing list
																										pklstdv.pklsti_id_pklst = pklsti.pklsti_id 
																								and 
																										-- y con el item de la devaluacion
																										pklstdv.pklsti_id_devolucion = pklstd.pklsti_id)

						union
	
								select  
															pklsti.pklsti_id,												-- Item
															pklsti.pr_id,														-- Producto
	
															fvi.fvi_id					as fvi_id,					-- Factura
															0             			as pklstd_id,					-- Devolucion
															0                   as vinc_id,					-- Id Devolucion
	
															0						        as Aplicado,				-- Aplicacion
	
															doc_nombre,															-- Datos del item de la factura
	                            fv_nrodoc    				      as nrodoc,					--
															fv_fecha                  as Fecha,						--
															fvi.fvi_pendientepklst		as Pendiente,				--
	
															fvi.fvi_orden				as orden						--
															
								from 
										-- Items packing list       		' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros packing list de venta
                                                  --' de tipo packing list que puedan vincularce con esta devolucion 
										PackingListItem pklsti  inner join PackingList pklst 			  on pklsti.pklst_id = pklst.pklst_id

																									-- Vinculacion con el cliente y contra packing list unicamente
																			   inner join FacturaVenta fv  			on 		pklst.cli_id = fv.cli_id
																																						and fv.doct_id 	 in (1,9)
																																						and fv.est_id  	 <> 7

																				 inner join Documento doc         on fv.doc_id 		= doc.doc_id

																									-- Ahora vinculo con los items de dichos packing list que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join FacturaVentaItem fvi  on 			fv.fv_id  	 = fvi.fv_id 
																																							and pklsti.pr_id = fvi.pr_id
	
								where
														pklsti.pklst_id = @@pklst_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item packing list
												and fvi.fvi_pendientepklst > 0
	
												-- El 'packing list item' no tiene que estar vinculado 
												-- con ningun item de este packing list
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el packing list
																					--
												and not exists(select * 
																					from PackingListFacturaVenta pklstfv 

	                                          where 
																										-- y con el item packing list
																										pklstfv.pklsti_id = pklsti.pklsti_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										pklstfv.fvi_id = fvi.fvi_id)
					  order by nroDoc, fecha 

				end

			end else begin -- 3: if Aplicaciones Posibles Facturas

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Pedidos
				if @@tipo = 4 begin

						select  
													pklsti.pklsti_id,																		-- Item
													pklsti.pr_id,																				-- Producto

													pvi.pvi_id,																				-- Pedido
													0                      as mfci_id,								-- ManifiestoCarga
													pvpklst_id             as vinc_id,								-- Id Aplicacion

													pvpklst_cantidad       as Aplicado,							-- Aplicacion

													doc_nombre,																		--  Datos del item de la devolucion
                          pv_nrodoc    				as nrodoc,								--
													pv_fecha            as Fecha,									--
													pvi_pendientepklst	as Pendiente,							--

													pvi_orden						as orden									--
													
						from 

							-- Items packing list             tabla vinculacion                         
							PackingListItem pklsti  inner join PedidoPackingList pvpklst  	on pklsti.pklsti_id   = pvpklst.pklsti_id
                                   inner join PedidoVentaItem pvi     				on pvpklst.pvi_id  		= pvi.pvi_id
																	 inner join PedidoVenta pv         		 			on pvi.pv_id    			= pv.pv_id
																	 inner join Documento doc           				on pv.doc_id    			= doc.doc_id
						where
											pklsti.pklst_id = @@pklst_id		-- solo items de la devolucion solicitada

					union
		
						select  
													pklsti.pklsti_id,																		-- Item
													pklsti.pr_id,																				-- Producto

													0 										 as pvi_id,									-- Pedido
													mfci.mfci_id,																			-- ManifiestoCarga
													mfcpklst_id            as vinc_id,								-- Id Aplicacion

													mfcpklst_cantidad      as Aplicado,							-- Aplicacion

													doc_nombre,																		  --  Datos del item de la devolucion
                          mfc_nrodoc    				as nrodoc,								--
													mfc_fecha             as Fecha,									--
													mfci_pendiente				as Pendiente,							--

													mfci_orden						as orden									--
													
						from 

							-- Items packing list             tabla vinculacion                         
							PackingListItem pklsti  inner join ManifiestoPackingList mfcpklst on pklsti.pklsti_id   = mfcpklst.pklsti_id
                                   		inner join ManifiestoCargaItem mfci				on mfcpklst.mfci_id		= mfci.mfci_id
																	 		inner join ManifiestoCarga mfc     		 		on mfci.mfc_id   			= mfc.mfc_id
																	 		inner join Documento doc           				on mfc.doc_id    			= doc.doc_id
						where
											pklsti.pklst_id = @@pklst_id		-- solo items de la devolucion solicitada

		  			order by nrodoc, fecha 

			
				end else begin -- 4: if Aplicaciones Pedidos

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Pedidos
					if @@tipo = 5 begin

								select  
															pklsti.pklsti_id,													-- Item
															pklsti.pr_id,															-- Producto
	
															pvi_id,															-- Pedidos
                              0                   as mfci_id,     -- Manifiesto
															0                   as vinc_id,			-- Id Aplicacion
	
															0       						as Aplicado,		-- Aplicacion
	
															doc_nombre,													-- Datos del documento
	                            pv_nrodoc    				as nrodoc,			--
															pv_fecha            as Fecha,				--
															pvi.pvi_pendientepklst		as Pendiente,		--
	
															pvi.pvi_orden				as orden				--
															
								from 
										-- Items packing list       		' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros packing list de venta
                                                  --' de tipo packing list que puedan vincularce con esta devolucion 
										PackingListItem pklsti  inner join PackingList pklst 			  on pklsti.pklst_id = pklst.pklst_id

																									-- Vinculacion con el cliente y contra packing list unicamente
																			   inner join PedidoVenta pv  			on 		pklst.cli_id = pv.cli_id
																																						and pv.doct_id   = 5
																																						and	pv.est_id    <> 7

																				 inner join Documento doc         on pv.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos packing list que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join PedidoVentaItem pvi  on 			pv.pv_id  = pvi.pv_id 
																																							and pklsti.pr_id = pvi.pr_id
	
								where
														pklsti.pklst_id = @@pklst_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item packing list
												and pvi.pvi_pendientepklst > 0

												-- El 'pedido venta item' no tiene que estar vinculado 
												-- con ningun item de este packing list
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el packing list
																					--
												and not exists(select * 
																					from PedidoPackingList pvpklst 

	                                          where 
																										-- y con el item packing list
																										pvpklst.pklsti_id = pklsti.pklsti_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										pvpklst.pvi_id = pvi.pvi_id)
							union

								select  
															pklsti.pklsti_id,													-- Item
															pklsti.pr_id,															-- Producto
	
															0                   as pvi_id,  					-- Pedidos
                              mfci_id,                            -- Manifiesto
															0                   as vinc_id,			-- Id Aplicacion
	
															0       						as Aplicado,		-- Aplicacion
	
															doc_nombre,													-- Datos del documento
	                            mfc_nrodoc    				as nrodoc,			--
															mfc_fecha             as Fecha,				--
															mfci.mfci_pendiente		as Pendiente,		--
	
															mfci.mfci_orden				as orden				--
															
								from 
										-- Items packing list       		' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros packing list de venta
                                                  --' de tipo packing list que puedan vincularce con esta devolucion 
										PackingListItem pklsti  inner join PackingList pklst 			  on pklsti.pklst_id = pklst.pklst_id

																									-- Vinculacion con el cliente y contra packing list unicamente
																			   inner join ManifiestoCarga mfc  			on 		pklst.cli_id = mfc.cli_id
																																								and mfc.doct_id  = 20
																																								and mfc.est_id   <> 7

																				 inner join Documento doc         on mfc.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos packing list que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join ManifiestoCargaItem mfci  on 	mfc.mfc_id   = mfci.mfc_id 
																																							and pklsti.pr_id = mfci.pr_id
	
								where
														pklsti.pklst_id = @@pklst_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item packing list
												and mfci.mfci_pendiente > 0

												-- El 'pedido venta item' no tiene que estar vinculado 
												-- con ningun item de este packing list
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el packing list
																					--
												and not exists(select * 
																					from ManifiestoPackingList mfcpklst 

	                                          where 
																										-- y con el item packing list
																										mfcpklst.pklsti_id = pklsti.pklsti_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										mfcpklst.mfci_id = mfci.mfci_id)
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

