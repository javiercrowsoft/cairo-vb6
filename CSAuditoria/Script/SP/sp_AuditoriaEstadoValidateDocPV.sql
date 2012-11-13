-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocPV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocPV]

go

create procedure sp_AuditoriaEstadoValidateDocPV (

	@@pv_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 			int
	declare @doct_id      int
	declare @pv_nrodoc 		varchar(50) 
	declare @pv_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@pv_nrodoc  = pv_nrodoc,
						@pv_numero  = convert(varchar,pv_numero),
						@est_id     = est_id

	from PedidoVenta where pv_id = @@pv_id

	if exists(select * from PedidoVentaItem pvi
						where (pvi_pendiente +  (	  IsNull(
																					(select sum(pvfv_cantidad) from PedidoFacturaVenta 
																					 where pvi_id = pvi.pvi_id),0)
																			+	IsNull(
																				  (select sum(pvdv_cantidad)   from PedidoDevolucionVenta 
                                           where 
                                                 (pvi_id_pedido      = pvi.pvi_id and @doct_id = 5)
                                              or (pvi_id_devolucion  = pvi.pvi_id and @doct_id = 22)
                                          ),0)
																			+ IsNull(
																					(select sum(pvrv_cantidad) from PedidoRemitoVenta 
																					 where pvi_id = pvi.pvi_id),0)
																		) 
									) <> pvi_cantidadaremitir

							and pv_id = @@pv_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este pedido no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @pv_nrodoc + ' nro.: '+ @pv_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@pv_id
																)
	end

	if exists(select * from PedidoVentaItem pvi
						where (pvi_pendientepklst 
																+ 	(	  IsNull(
																					(select sum(pvpklst_cantidad) from PedidoPackingList 
																					 where pvi_id = pvi.pvi_id),0)
																		) 
									) <> pvi_cantidadaremitir

							and pv_id = @@pv_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este pedido no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @pv_nrodoc + ' nro.: '+ @pv_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@pv_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @pv_pendiente	decimal(18,6)

	  select 
						@pv_pendiente		= sum(pvi_pendiente)

		from PedidoVentaItem where pv_id = @@pv_id

		if @pv_pendiente = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El pedido no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @pv_nrodoc + ' nro.: '+ @pv_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@pv_id
																	)
		end

	end

ControlError:

end
GO