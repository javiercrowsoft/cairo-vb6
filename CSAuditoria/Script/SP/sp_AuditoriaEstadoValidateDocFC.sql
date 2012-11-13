-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocFC]

go

create procedure sp_AuditoriaEstadoValidateDocFC (

	@@fc_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 			int
	declare @doct_id      int
	declare @fc_nrodoc 		varchar(50) 
	declare @fc_numero 		varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@fc_nrodoc  = fc_nrodoc,
						@fc_numero  = convert(varchar,fc_numero),
						@est_id     = est_id

	from FacturaCompra where fc_id = @@fc_id

	if exists(select * from FacturaCompraItem fci
						where (fci_pendiente + (		IsNull(
																					(select sum(rcfc_cantidad) from RemitoFacturaCompra 
																					 where fci_id = fci.fci_id),0)
																		) 
																 + (		IsNull(
																					(select sum(ocfc_cantidad) from OrdenFacturaCompra 
																					 where fci_id = fci.fci_id),0)
																		) 
									) <> fci_cantidadaremitir

							and fc_id = @@fc_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de esta factura no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@fc_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @fc_pendiente	decimal(18,6)

	  select 
						@fc_pendiente		= fc_pendiente

		from FacturaCompra where fc_id = @@fc_id

		if @fc_pendiente = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'La factura no tiene vencimientos pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@fc_id
																	)
		end

	end

ControlError:

end
GO