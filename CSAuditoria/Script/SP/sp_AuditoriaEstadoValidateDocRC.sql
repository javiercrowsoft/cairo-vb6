-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocRC]

go

create procedure sp_AuditoriaEstadoValidateDocRC (

	@@rc_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 			int
	declare @doct_id      int
	declare @rc_nrodoc 		varchar(50) 
	declare @rc_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@rc_nrodoc  = rc_nrodoc,
						@rc_numero  = convert(varchar,rc_numero),
						@est_id     = est_id

	from RemitoCompra where rc_id = @@rc_id

	if exists(select * from RemitoCompraItem rci
						where (rci_pendientefac + (	IsNull(
																					(select sum(rcfc_cantidad) from RemitoFacturaCompra 
																					 where rci_id = rci.rci_id),0)
																			+	IsNull(
																				  (select sum(rcdc_cantidad)   from RemitoDevolucionCompra 
                                           where 
                                                 (rci_id_remito      = rci.rci_id and @doct_id = 4)
                                              or (rci_id_devolucion  = rci.rci_id and @doct_id = 25)
                                          ),0)
																		) 
									) <> rci_cantidadaremitir

							and rc_id = @@rc_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@rc_id
																)
	end

	if exists(select * from RemitoCompraItem rci
						where (rci_pendiente + (		IsNull(
																					(select sum(ocrc_cantidad) from OrdenRemitoCompra 
																					 where rci_id = rci.rci_id),0)
																		) 
									) <> rci_cantidad

							and rc_id = @@rc_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@rc_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @rc_pendiente	decimal(18,6)

	  select 
						@rc_pendiente		= sum(rci_pendientefac)

		from RemitoCompraItem where rc_id = @@rc_id

		if @rc_pendiente = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El remito no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@rc_id
																	)
		end

	end

ControlError:

end
GO