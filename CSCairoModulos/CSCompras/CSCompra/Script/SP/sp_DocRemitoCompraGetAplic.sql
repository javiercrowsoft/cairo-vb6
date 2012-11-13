if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraGetAplic]

go

/*

select * from remitoCompra

sp_DocRemitoCompraGetAplic 1,80,3

*/
create procedure sp_DocRemitoCompraGetAplic (
	@@emp_id      int,
	@@rc_id 			int,
	@@tipo        tinyint    /* 1: Items
														  2: Aplicaciones Facturas
															3: Aplicaciones Posibles Facturas
															4: Aplicaciones Ordenes de Compra
															5: Aplicaciones Posibles Ordenes de Compra
														*/
)
as
begin

	declare @prov_id 	int
  declare @doct_id  int

	select @prov_id = prov_id, @doct_id = doct_id from RemitoCompra where rc_id = @@rc_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
	if @@tipo = 1 begin

		select 	
						rci.rci_id, 
					 	rci.pr_id, 
						pr_nombreCompra, 
						rci_pendientefac, 
						rci_cantidadaremitir - rci_pendientefac  as AplicRemito,
						rci_pendiente, 
						rci_cantidad - rci_pendiente     as AplicOrden,
						rci_orden
	
	  from 
					RemitoCompraItem rci 	inner join Producto p on rci.pr_id  = p.pr_id
		where 
					rci.rc_id = @@rc_id
	
		order by 
						rci_orden

	end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Facturas
		if @@tipo = 2 begin


	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Devoluciones
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if @doct_id = 25 /* Devolucion */ begin

				-- Remitos
				select  
											rci.rci_id,																							-- Item
											rci.pr_id,																							-- Producto

											0											as fci_id,												-- Factura
											rcd.rci_id          	as rcd_id,												-- Remito de Compra
											rcdc_id								as vinc_id,												-- id Aplicacion

											rcdc_cantidad       	as Aplicado,											-- Aplicacion

											doc_nombre,																							-- Datos del item del remito de Compra
                      rc_nrodoc    					as nrodoc,												--
											rc_fecha            	as Fecha,													--
											rcd.rci_pendientefac	as Pendiente,											--

											rcd.rci_orden					as orden													--
											
				from 
							-- Items de la devolucion       tabal de vinculacion                               (es una devolucion)
							RemitoCompraItem rci  inner join RemitoDevolucionCompra rcdc 	on rci.rci_id   = rcdc.rci_id_devolucion

																					--  Items de remitos asociados con la devolucion       (es un remito)
                                   inner join RemitoCompraItem rcd  				on rcdc.rci_id_remito = rcd.rci_id

																							-- Datos del documento de los items de remito asociadso con la devolucion
																	 inner join RemitoCompra rc         		  on rcd.rc_id    = rc.rc_id
																	 inner join Documento doc           		  on rc.doc_id    = doc.doc_id
				where
										rci.rc_id = @@rc_id  	-- solo items de la devolucion solicitada

				order by rci.rci_orden

 			end else begin

	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Remitos
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					-- Devoluciones
							select  
														rci.rci_id,																	-- Item
														rci.pr_id,																	-- Producto

														0											as fci_id,						-- Factura
														rcd.rci_id          	as rcd_id,						-- Devolucion
														rcdc_id								as vinc_id,						-- Id Aplicacion

														rcdc_cantidad       	as Aplicado,					-- Aplicacion

														doc_nombre,																	-- Datos del item de la devolucion
                            rc_nrodoc    					as nrodoc,						--
														rc_fecha            	as Fecha,							--
														rcd.rci_pendientefac	as Pendiente,					--

														rcd.rci_orden					as orden							--
														
							from 

								-- Items del remito             tabla vinculacion                                  (es un remito)
								RemitoCompraItem rci  inner join RemitoDevolucionCompra rcdc 	on rci.rci_id   = rcdc.rci_id_remito

																						-- Items de Devolucion asociados con el remito         (es una devolucion)
                                     inner join RemitoCompraItem rcd  				on rcdc.rci_id_devolucion = rcd.rci_id

																						--
																		 inner join RemitoCompra rc         		  on rcd.rc_id    = rc.rc_id
																		 inner join Documento doc           		  on rc.doc_id    = doc.doc_id
							where
													rci.rc_id = @@rc_id 	-- solo items de la devolucion solicitada
				union

					-- Facturas
							select  
														rci.rci_id,																		-- Item
														rci.pr_id,																		-- Producto

														fci.fci_id,																		-- Factura
														0                   as rcd_id,								-- Devolucion
														rcfc_id							as vinc_id,								-- Id Aplicacion

														rcfc_cantidad       as Aplicado,							-- Aplicacion

														doc_nombre,																		--  Datos del item de la devolucion
                            fc_nrodoc    				as nrodoc,								--
														fc_fecha            as Fecha,									--
														fci_pendiente				as Pendiente,							--

														fci_orden						as orden									--
														
							from 

								-- Items del remito             tabla vinculacion                         
								RemitoCompraItem rci  inner join RemitoFacturaCompra rcfc on rci.rci_id   = rcfc.rci_id
                                      inner join FacturaCompraItem fci    on rcfc.fci_id  = fci.fci_id
																		  inner join FacturaCompra fc         on fci.fc_id    = fc.fc_id
																		  inner join Documento doc            on fc.doc_id    = doc.doc_id
							where
												rci.rc_id = @@rc_id		-- solo items de la devolucion solicitada
			
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
				if @doct_id = 25 /* Devolucion */ begin
	
							select  distinct
														0                     as rci_id,  			-- Item
														rci.pr_id,															-- Producto

														0											as fci_id,				-- Factura
														rcd.rci_id          	as rcd_id,				-- Remito de Compra
														0											as vinc_id,				-- Id Aplicacion


														0							      	as Aplicado,			-- Aplicacion

														doc_nombre,															-- Datos del item del remito
                            rd.rc_nrodoc    			as nrodoc,				--
														rd.rc_fecha         	as Fecha,					--
														rcd.rci_pendientefac	as Pendiente,			--

														rcd.rci_orden					as orden					--
														
							from 
										-- Items de la devolucion       ' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a otros remitos de Compra
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										RemitoCompraItem rci  inner join RemitoCompra rc 			on rci.rc_id = rc.rc_id

																									-- Vinculacion con el proveedor y contra remitos unicamente
																				 inner join RemitoCompra rd  			on 		rc.prov_id = rd.prov_id 
																																						and rd.doct_id = 4
																																						and	rd.est_id  <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id
			
																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
			                                   inner join RemitoCompraItem rcd   on 		rd.rc_id  = rcd.rc_id 
																																							and rci.pr_id = rcd.pr_id

							where
														rci.rc_id = @@rc_id

												-- Empresa
												and doc.emp_id  = @@emp_id
												and doc.doct_id = 4

												-- Tiene que haber pendiente en el item del remito
												and rcd.rci_pendientefac > 0  

												-- El 'remito Compra item' no tiene que estar vinculado 
												-- con ningun item de esta devolucion
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del remito
																					--
												and not exists(select * 													
																				from RemitoDevolucionCompra rcdc 	

                                          where 
																										-- Ahora vinculo este item con el item de la devolucion
																											rcdc.rci_id_devolucion = rci.rci_id 
																									and 
																										-- y con el item del remito
																											rcdc.rci_id_remito = rcd.rci_id)

				  order by nroDoc, fecha 

		    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				--
				--	 Remitos
				--
				--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				end else begin

								select  distinct
															0                       as rci_id,					-- Item
															rci.pr_id,																	-- Producto
	
															0												as fci_id,						-- Factura
															rcd.rci_id          		as rcd_id,						-- Devolucion
															0												as vinc_id,						-- Id Aplicacion
	
															0                   		as Aplicado,					-- Aplicacion
	
															doc_nombre,																		-- Datos del item de la devolucion
	                            rd.rc_nrodoc    				as nrodoc,						--
															rd.rc_fecha         		as Fecha,							--
															rcd.rci_pendientefac		as Pendiente,					--
	
															rcd.rci_orden						as orden							--
															
								from 
										-- Items del remito             ' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a otros remitos de Compra
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										RemitoCompraItem rci  inner join RemitoCompra rc 			  on rci.rc_id = rc.rc_id

																									-- Vinculacion con el proveedor y contra remitos unicamente
																				 inner join RemitoCompra rd  			on 		rc.prov_id = rd.prov_id 
																																						and rd.doct_id = 25
																																						and rd.est_id  <> 7

																				 inner join Documento doc         on rd.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join RemitoCompraItem rcd   on 		rd.rc_id  = rcd.rc_id 
																																							and rci.pr_id = rcd.pr_id
	
								where
														rci.rc_id = @@rc_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del remito
												and rcd.rci_pendientefac > 0		

												-- El 'remito Compra item' no tiene que estar vinculado 
												-- con ningun item de este remito
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del remito
																					--
												and not exists(select * 
																					from RemitoDevolucionCompra rcdc 

	                                          where 
																										-- Ahora vinculo este item con el item del remito
																										rcdc.rci_id_remito = rci.rci_id 
																								and 
																										-- y con el item de la devaluacion
																										rcdc.rci_id_devolucion = rcd.rci_id)

						union
	
								select  distinct
															0                   as rci_id,			    -- Item
															rci.pr_id,															-- Producto
	
															fci.fci_id					as fci_id,					-- Factura
															0             			as rcd_id,					-- Devolucion
															0                   as vinc_id,					-- Id Devolucion
	
															0						        as Aplicado,				-- Aplicacion
	
															doc_nombre,															-- Datos del item de la factura
	                            fc_nrodoc    				as nrodoc,					--
															fc_fecha            as Fecha,						--
															fci.fci_pendiente		as Pendiente,				--
	
															fci.fci_orden				as orden						--
															
								from 
										-- Items del remito       			' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a otros remitos de Compra
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										RemitoCompraItem rci  inner join RemitoCompra rc 			  on rci.rc_id = rc.rc_id

																									-- Vinculacion con el proveedor y contra remitos unicamente
																			   inner join FacturaCompra fc  			on 		rc.prov_id = fc.prov_id
																																							and fc.doct_id in (2,10)
																																							and	fc.est_id  <> 7

																				 inner join Documento doc           on fc.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join FacturaCompraItem fci  on 		fc.fc_id  = fci.fc_id 
																																							and rci.pr_id = fci.pr_id
	
								where
														rci.rc_id = @@rc_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del remito
												and fci.fci_pendiente > 0
	
												-- El 'remito Compra item' no tiene que estar vinculado 
												-- con ningun item de este remito
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del remito
																					--
												and not exists(select * 
																					from RemitoFacturaCompra rcfc 

	                                          where 
																										-- y con el item del remito
																										rcfc.rci_id = rci.rci_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										rcfc.fci_id = fci.fci_id)
					  order by nroDoc, fecha 

				end

			end else begin -- 3: if Aplicaciones Posibles Facturas

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Ordenes de Compra
				if @@tipo = 4 begin

						select  
													rci.rci_id,																		-- Item
													rci.pr_id,																		-- Producto

													oci.oci_id,																		-- Orden
													ocrc_id             as vinc_id,								-- Id Aplicacion

													ocrc_cantidad       as Aplicado,							-- Aplicacion

													doc_nombre,																		--  Datos del item de la devolucion
                          oc_nrodoc + ' ' + oc_ordencompra 
																							as nrodoc,								--
													oc_fecha            as Fecha,									--
													oci_pendientefac		as Pendiente,							--

													oci_orden						as orden									--
													
						from 

							-- Items del remito             tabla vinculacion                         
							RemitoCompraItem rci  inner join OrdenRemitoCompra ocrc   on rci.rci_id   = ocrc.rci_id
                                    inner join OrdenCompraItem oci      on ocrc.oci_id  = oci.oci_id
																	  inner join OrdenCompra oc           on oci.oc_id    = oc.oc_id
																	  inner join Documento doc            on oc.doc_id    = doc.doc_id
						where
											rci.rc_id = @@rc_id		-- solo items de la devolucion solicitada
		
									-- Empresa
									and doc.emp_id = @@emp_id
	
		  			order by nrodoc, fecha 

			
				end else begin -- 4: if Aplicaciones Ordenes de Compra

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Ordenes de Compra
					if @@tipo = 5 begin

								select  distinct
															0                   as rci_id,  		-- Item
															rci.pr_id,													-- Producto
	
															oci_id,															-- Ordenes de Compra
															0                   as vinc_id,			-- Id Aplicacion
	
															0       						as Aplicado,		-- Aplicacion
	
															doc_nombre,													-- Datos del documento
                          		oc_nrodoc + ' ' + oc_ordencompra 
	                            											as nrodoc,			--
															oc_fecha            	as Fecha,				--
															oci.oci_pendientefac	as Pendiente,		--
	
															oci.oci_orden				as orden				--
															
								from 
										-- Items del remito       			' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a otros remitos de Compra
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										RemitoCompraItem rci  inner join RemitoCompra rc 			  on rci.rc_id = rc.rc_id

																									-- Vinculacion con el proveedor y contra remitos unicamente
																			   inner join OrdenCompra oc  			on 		rc.prov_id = oc.prov_id
																																						and oc.doct_id = 35
																																						and oc.est_id  <> 7

																				 inner join Documento doc         on oc.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join OrdenCompraItem oci  on 			oc.oc_id  = oci.oc_id 
																																							and rci.pr_id = oci.pr_id
	
								where
														rci.rc_id = @@rc_id

												and @doct_id = 4 -- Solo remitos

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del remito
												and oci.oci_pendientefac > 0

												-- El 'Orden Compra item' no tiene que estar vinculado 
												-- con ningun item de este remito
												--
																					-- Busco que no exista en la tabla 
																					-- de vinculacion algun vinculo entre
																					-- el item de la devolucion y el del remito
																					--
												and not exists(select * 
																					from OrdenRemitoCompra ocrc 

	                                          where 
																										-- y con el item del remito
																										ocrc.rci_id = rci.rci_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										ocrc.oci_id = oci.oci_id)


					  		order by nroDoc, fecha 
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Ordenes de Compra
					end -- 5: Else Aplicaciones Posibles Ordenes de Compra
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Ordenes de Compra
				end -- 4: Else Aplicaciones Ordenes de Compra
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

