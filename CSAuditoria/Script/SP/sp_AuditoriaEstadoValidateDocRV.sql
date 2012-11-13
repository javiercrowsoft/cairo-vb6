-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocRV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocRV]

go

create procedure sp_AuditoriaEstadoValidateDocRV (

	@@rv_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 			int
	declare @doct_id      int
	declare @rv_nrodoc 		varchar(50) 
	declare @rv_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@rv_nrodoc  = rv_nrodoc,
						@rv_numero  = convert(varchar,rv_numero),
						@est_id     = est_id

	from RemitoVenta where rv_id = @@rv_id

	if exists(select * from RemitoVentaItem rvi
						where (rvi_pendientefac + (	IsNull(
																					(select sum(rvfv_cantidad) from RemitoFacturaVenta 
																					 where rvi_id = rvi.rvi_id),0)
																			+	IsNull(
																				  (select sum(rvdv_cantidad)   from RemitoDevolucionVenta 
                                           where 
                                                 (rvi_id_remito      = rvi.rvi_id and @doct_id = 3)
                                              or (rvi_id_devolucion  = rvi.rvi_id and @doct_id = 24)
                                          ),0)
																		) 
									) <> rvi_cantidadaremitir

							and rv_id = @@rv_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@rv_id
																)
	end

	if exists(select * from RemitoVentaItem rvi
						where (rvi_pendiente + (		IsNull(
																					(select sum(pvrv_cantidad) from PedidoRemitoVenta 
																					 where rvi_id = rvi.rvi_id),0)
																		) 
									) <> rvi_cantidad

							and rv_id = @@rv_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@rv_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @rv_pendiente	decimal(18,6)

	  select 
						@rv_pendiente		= sum(rvi_pendientefac)

		from RemitoVentaItem where rv_id = @@rv_id

		if @rv_pendiente = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El remito no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@rv_id
																	)
		end

	end

ControlError:

end
GO