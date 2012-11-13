if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioGetAplic]

go

/*

select * from OrdenServicio

sp_DocOrdenServicioGetAplic 2,1091,2

*/
create procedure sp_DocOrdenServicioGetAplic (
	@@emp_id      int,
	@@os_id 			int,
	@@tipo        tinyint    /* 1: Items
														  2: Aplicaciones Remitos
															3: Aplicaciones Posibles Remitos
														*/
)
as
begin

	declare @cli_id 	int
  declare @doct_id  int

	select @cli_id = cli_id, @doct_id = doct_id from OrdenServicio where os_id = @@os_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
	if @@tipo = 1 begin

		select 	
						osi.osi_id, 
					 	osi.pr_id, 
						pr_nombreventa, 
						osi_pendiente, 
						osi_cantidadaremitir - osi_pendiente  as AplicRemito,
						osi_orden
	
	  from 
					OrdenServicioItem osi 	inner join Producto p on osi.pr_id  = p.pr_id
		where 
					osi.os_id = @@os_id
	
		order by 
						osi_orden

	end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Remitos
		if @@tipo = 2 begin

	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Remitos
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					-- Remitos
							select  
														osi.osi_id,																		-- Item
														osi.pr_id,																		-- Producto

														rvi.rvi_id,																		-- Factura
														osrv_id							as vinc_id,								-- Id Aplicacion

														osrv_cantidad       as Aplicado,							-- Aplicacion

														doc_nombre,																		--  Datos del item de la devolucion
                            rv_nrodoc    				as nrodoc,								--
														rv_fecha            as Fecha,									--
														rvi_pendiente				as Pendiente,							--

														rvi_orden						as orden									--
														
							from 

								-- Items del remito             tabla vinculacion                         
								OrdenServicioItem osi  inner join OrdenRemitoVenta osrv 	on osi.osi_id   = osrv.osi_id
                                       inner join RemitoVentaItem rvi    	on osrv.rvi_id  = rvi.rvi_id
																		   inner join RemitoVenta rv         	on rvi.rv_id    = rv.rv_id
																		   inner join Documento doc           on rv.doc_id    = doc.doc_id
							where
												osi.os_id = @@os_id		-- solo items de la devolucion solicitada
			
			  order by nrodoc, fecha 

		end else begin -- 2: if Aplicaciones Remitos
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Remitos
			if @@tipo = 3 begin

		    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				--
				--	 Remitos
				--
				--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
								select  distinct
															0                   as osi_id,			    -- Item
															osi.pr_id,															-- Producto
	
															rvi.rvi_id					as rvi_id,					-- Factura
															0                   as vinc_id,					-- Id Devolucion
	
															0						        as Aplicado,				-- Aplicacion
	
															doc_nombre,															-- Datos del item de la factura
	                            rv_nrodoc    				as nrodoc,					--
															rv_fecha            as Fecha,						--
															rvi.rvi_pendiente		as Pendiente,				--
	
															rvi.rvi_orden				as orden						--
															
								from 
										-- Items del remito       			' Voy hasta el header para obtener el Cliente
                                                  --' y lo uso para hacer un join a otros ordenes de servicio
                                                  --' de tipo remito que puedan vincularce con esta devolucion 
										OrdenServicioItem osi  inner join OrdenServicio os 			on osi.os_id = os.os_id

																									-- Vinculacion con el Cliente y contra remitos unicamente
																			   inner join RemitoVenta rv  				on 		os.cli_id = rv.cli_id
																																							and rv.doct_id in (2,10)
																																							and	rv.est_id  <> 7

																				 inner join Documento doc           on rv.doc_id = doc.doc_id

																									-- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join RemitoVentaItem rvi  		on 		rv.rv_id  = rvi.rv_id 
																																							and osi.pr_id = rvi.pr_id
	
								where
														osi.os_id = @@os_id

												-- Empresa
												and doc.emp_id = @@emp_id

												-- Tiene que haber pendiente en el item del remito
												and rvi.rvi_pendiente > 0
	
												-- El 'remito Compra item' no tiene que estar vinculado 
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
																										osrv.osi_id = osi.osi_id
																								and 
																										-- Ahora vinculo este item con el item de la factura
																										osrv.rvi_id = rvi.rvi_id)
					  order by nroDoc, fecha 

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Remitos
			end -- 3: End Aplicaciones Posibles Remitos
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Remitos
		end -- 2: Else Aplicaciones Remitos
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
	end -- 1: Else Items
end

go

