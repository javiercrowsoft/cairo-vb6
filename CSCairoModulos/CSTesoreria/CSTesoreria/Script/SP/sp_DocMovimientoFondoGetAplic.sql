if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoGetAplic]

go

/*

select mf_id,mf_numero from MovimientoFondo

sp_DocMovimientoFondoGetAplic 17,2

*/
create procedure sp_DocMovimientoFondoGetAplic (
	@@emp_id      int,
	@@mf_id 			int,
	@@tipo        tinyint    /* 1: Vencimientos 
														  2: Aplicaciones Cobranzas y Notas de credito 
															3: Aplicaciones posibles (Cobranzas y Notas de credito) 
															4: Pendientes Items (Articulos)
															5: Aplicaciones Pedidos y Remitos
															6: Aplicaciones posibles (Pedidos y Remitos)
														*/
)
as
begin

	declare @cli_id 	int
  declare @doct_id  int

	select @cli_id = cli_id, @doct_id = doct_id from MovimientoFondo where mf_id = @@mf_id

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Vencimientos
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if @@tipo = 1  begin

			select 
							fvd.fvd_id,
							0                 		as fvp_id,
							fvd.fvd_fecha   			as fecha,
							isnull(sum(fvcobz_importe),0)
            + isnull(sum(fvcn1.fvnc_importe),0)
            + isnull(sum(fvcn2.fvnc_importe),0)
												        		as importe,
							fvd.fvd_pendiente			as pendiente
		
			from MovimientoFondoDeuda fvd left join MovimientoFondoCobranza fvc      on fvd.fvd_id = fvc.fvd_id
																 left join MovimientoFondoNotaCredito fvcn1 on fvd.fvd_id = fvcn1.fvd_id_factura
																 left join MovimientoFondoNotaCredito fvcn2 on fvd.fvd_id = fvcn2.fvd_id_notacredito
			where fvd.mf_id = @@mf_id
      group by fvd.fvd_id, fvd.fvd_fecha, fvd.fvd_pendiente

		union

			select 
							0                 as fvd_id,
							fvp_id,
							fvp_fecha   			as fecha,
							fvp_importe       as importe,
							0			            as pendiente
		
			from MovimientoFondoPago
			where mf_id = @@mf_id

	  order by fvd_fecha

	end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones Cobranzas y Notas de credito 
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if @@tipo = 2 begin	


	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Notas de credito 
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if @doct_id = 7 /*Nota de Credito Venta*/ begin

				select 
								fvnc_id,
								fvnc_importe              as Aplicado,

								fvd_id_factura            as fvd_id2,
								fvd_id_notacredito        as fvd_id,

								fvp_id_factura            as fvp_id2,
								fvp_id_notacredito        as fvp_id,

                fvdfv.fvd_pendiente				as pendiente,
								mf_id_factura 						as mf_id,
								mf_nrodoc									as nrodoc,
								doc_nombre,

								/* para el union */
								0 													as cobz_id,
								0 													as fvcobz_id,
								0 													as fvcobz_importeOrigen,
								0 													as fvcobz_cotizacion,
                0                           as cobz_pendiente,
  						  ''                          as cobz_nroDoc,
								convert(datetime,'19000101')
													  								as cobz_fecha
								/* fin para el union */
			
				from MovimientoFondoNotaCredito fvnc   
																			inner join MovimientoFondo fv 					on fvnc.mf_id_factura   		= fv.mf_id

			                                left  join MovimientoFondoPago  fvpnc 	on fvnc.fvp_id_notacredito 	= fvpnc.fvp_id
			                                left  join MovimientoFondoDeuda fvdnc 	on fvnc.fvd_id_notacredito 	= fvdnc.fvd_id
	
			                                left  join MovimientoFondoPago  fvpfv 	on fvnc.fvp_id_factura 			= fvpfv.fvp_id
			                                left  join MovimientoFondoDeuda fvdfv 	on fvnc.fvd_id_factura 			= fvdfv.fvd_id
	
			                                left  join Documento d     					on fv.doc_id 	= d.doc_id
				where fvnc.mf_id_notacredito = @@mf_id

			  order by mf_nrodoc

 			end else begin

	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Factura y Nota de debito 
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					select 
								  fvnc_id,
									fvnc_importe                as Aplicado,

									fvd_id_factura            	as fvd_id,
									fvd_id_notacredito        	as fvd_id2,
	
									fvp_id_factura            	as fvp_id,
									fvp_id_notacredito        	as fvp_id2,

									fvdnc.fvd_pendiente         as pendiente,
									mf_id_factura 							as mf_id,
									mf_nrodoc									  as nrodoc,
									doc_nombre,

									/* para el union */
									0 													as cobz_id,
									0 													as fvcobz_id,
									0 													as fvcobz_importeOrigen,
									0 													as fvcobz_cotizacion,
								convert(datetime,'19000101')
									            								as cobz_fecha
									/* fin para el union */
					
					from MovimientoFondoNotaCredito fvnc   
																				inner join MovimientoFondo fv 					on fvnc.mf_id_notacredito		= fv.mf_id
		
				                                left  join MovimientoFondoPago  fvpnc 	on fvnc.fvp_id_notacredito 	= fvpnc.fvp_id
				                                left  join MovimientoFondoDeuda fvdnc 	on fvnc.fvd_id_notacredito 	= fvdnc.fvd_id
	
				                                left  join MovimientoFondoPago  fvpfv 	on fvnc.fvp_id_factura 	= fvpfv.fvp_id
				                                left  join MovimientoFondoDeuda fvdfv 	on fvnc.fvd_id_factura 	= fvdfv.fvd_id
		
				                                left  join Documento d     					on fv.doc_id 	= d.doc_id
					where fvnc.mf_id_factura = @@mf_id
			
				union

					select  
									/* para el union */
									0                           as fvnc_id,
									fvcobz_importe							as Aplicado,
									fvc.fvd_id									as fvd_id,
									0 													as fvd_id2,
									fvc.fvp_id									as fvp_id,
									0 													as fvp_id2,
									cobz_pendiente  						as pendiente,
									0 													as mf_id,
									cobz_nroDoc									as nrodoc,
									doc_nombre,
									/* fin para el union */
					
									cobz.cobz_id,
									fvcobz_id,
									fvcobz_importeOrigen,
									fvcobz_cotizacion,
									cobz_fecha

				
					from MovimientoFondoCobranza fvc  inner join MovimientoFondo fv 			on fvc.mf_id 		= fv.mf_id
									                       inner join Cobranza cobz 				on fvc.cobz_id 	= cobz.cobz_id 
				                                 left  join MovimientoFondoDeuda fvd on fvc.fvd_id 	= fvd.fvd_id
				                                 left  join MovimientoFondoPago  fvp on fvc.fvp_id 	= fvp.fvp_id
				                                 left  join Documento d     			on cobz.doc_id 	= d.doc_id
					where fv.mf_id = @@mf_id
			
			  order by mf_nrodoc,cobz_fecha 
			
      end

		end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones posibles (Cobranzas y Notas de credito) 
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			if @@tipo = 3 begin	
	
	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Notas de credito 
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				if @doct_id = 7 /*Nota de Credito Venta*/ begin
	
						select 
									  0										as cobz_id,
									  fv.mf_id,
									  fvd_id,
									  fvd_fecha           as Fecha,
									  doc_nombre,
									  mf_nrodoc           as nroDoc,
									  fvd_pendiente       as Pendiente
					
						from MovimientoFondo fv 					inner join MovimientoFondoDeuda fvd  	on fv.mf_id   = fvd.mf_id
					                                		inner join Documento d     						on fv.doc_id 	= d.doc_id
						where fv.cli_id = @cli_id

							-- Empresa
							and d.emp_id = @@emp_id

							and fv.doct_id <> 7 /* Facturas y Notas de debito */
							and not exists(select fvd_id from MovimientoFondoNotaCredito
	                                          where fvd_id            = fvd.fvd_id 
	                                            and mf_id_notacredito = @@mf_id)
				
					union 
				
						select 
									  cobz_id,
									  0                   as mf_id,
									  0                   as fvd_id,
									  cobz_fecha          as Fecha,
									  doc_nombre,
									  cobz_nrodoc         as nroDoc,
									  cobz_pendiente      as Pendiente
					
						from Cobranza cobz 					inner join Documento d     					on cobz.doc_id = d.doc_id
						where cli_id = @cli_id

							-- Empresa
							and d.emp_id = @@emp_id

							and not exists(select cobz_id from MovimientoFondoCobranza 
	                                          where cobz_id = cobz.cobz_id 
	                                            and mf_id   = @@mf_id)
				  order by nroDoc, fecha 
	
	 			end else begin
	
	    --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			--
			--	 Factura y Nota de debito 
			--
			--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
							select 
										  0										as cobz_id,
										  fv.mf_id,
										  fvd_id,
										  fvd_fecha           as Fecha,
										  doc_nombre,
										  mf_nrodoc           as nroDoc,
										  fvd_pendiente       as Pendiente
						
							from MovimientoFondo fv 					inner join MovimientoFondoDeuda fvd  	on fv.mf_id   = fvd.mf_id
						                                		inner join Documento d     						on fv.doc_id 	= d.doc_id
							where fv.cli_id = @cli_id

								-- Empresa
								and d.emp_id = @@emp_id

								and fv.doct_id = 7 /* Notas de credito */
								and not exists(select fvd_id from MovimientoFondoNotaCredito
		                                          where fvd_id            = fvd.fvd_id 
		                                            and mf_id_factura     = @@mf_id)
					
						union 
					
							select 
										  cobz_id,
										  0                   as mf_id,
										  0                   as fvd_id,
										  cobz_fecha          as Fecha,
										  doc_nombre,
										  cobz_nrodoc         as nroDoc,
										  cobz_pendiente      as Pendiente
						
							from Cobranza cobz 					inner join Documento d     					on cobz.doc_id = d.doc_id
							where cli_id = @cli_id

								-- Empresa
								and d.emp_id = @@emp_id

								and not exists(select cobz_id from MovimientoFondoCobranza 
		                                          where cobz_id = cobz.cobz_id 
		                                            and mf_id   = @@mf_id)
					  order by nroDoc, fecha 

	      end
			end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- REMITOS
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				if @@tipo = 4 begin	
					select * from MovimientoFondoDeuda where 1=2 -- pa que no falle
				end else begin
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- PEDIDOS
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					if @@tipo = 4 begin	
						select * from MovimientoFondoDeuda where 1=2 -- pa que no falle
					end
				end
			end
		end
	end
end

go

-- 
-- 
-- 		select cobz.cobz_id,
-- 					 fvcobz_id,
-- 					 fvcobz_importe,
-- 					 fvcobz_importeOrigen,
-- 					 fvcobz_cotizacion,
-- 					 fvd.fvd_id,
-- 					 fvp.fvp_id,
-- 					 fv.mf_id,
-- 	         mf_nrodoc,
-- 	         doc_nombre,
-- 	         fvd_fecha,
-- 	         fvd_pendiente,
-- 	         fvp_fecha,
-- 	         0 as orden
-- 	
-- 		from MovimientoFondoCobranza fvc  inner join MovimientoFondo fv 			on fvc.mf_id 		= fv.mf_id
-- 	                                 left  join MovimientoFondoDeuda fvd on fvc.fvd_id 	= fvd.fvd_id
-- 	                                 left  join MovimientoFondoPago  fvp on fvc.fvp_id 	= fvp.fvp_id
-- 						                       left  join Cobranza cobz 				on fv.cli_id 	 	= cobz.cli_id 
-- 	                                 left  join Documento d     			on cobz.doc_id 	= d.doc_id
-- 		where fv.mf_id = @@mf_id
-- 	
-- 	  order by orden,mf_nrodoc,fvd_fecha 
