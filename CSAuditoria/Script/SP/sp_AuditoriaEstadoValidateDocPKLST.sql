-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocPKLST]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocPKLST]

go

create procedure sp_AuditoriaEstadoValidateDocPKLST (

	@@pklst_id    int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 					int
	declare @doct_id      		int
	declare @pklst_nrodoc 		varchar(50) 
	declare @pklst_numero 		varchar(50) 
	declare @est_id       		int

	select 
						@doct_id 		= doct_id,
						@pklst_nrodoc  = pklst_nrodoc,
						@pklst_numero  = convert(varchar,pklst_numero),
						@est_id     = est_id

	from PackingList where pklst_id = @@pklst_id

	if exists(select * from PackingListItem pklsti
						where (pklsti_pendientefac 
																		+ (	IsNull(
																					(select sum(pklstfv_cantidad) from PackingListFacturaVenta 
																					 where pklsti_id = pklsti.pklsti_id),0)
																			+	IsNull(
																				  (select sum(pklstdv_cantidad)   from PackingListDevolucion 
                                           where 
                                                 (pklsti_id_pklst       = pklsti.pklsti_id and @doct_id = 21)
                                              or (pklsti_id_devolucion  = pklsti.pklsti_id and @doct_id = 31)
                                          ),0)
																		) 
									) <> pklsti_cantidad

							and pklst_id = @@pklst_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este packinglist no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @pklst_nrodoc + ' nro.: '+ @pklst_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@pklst_id
																)
	end

	if exists(select * from PackingListItem pklsti
						where (pklsti_pendiente + (		IsNull(
																					(select sum(pvpklst_cantidad) from PedidoPackingList 
																					 where pklsti_id = pklsti.pklsti_id),0)
																			+	IsNull(
																					(select sum(mfcpklst_cantidad) from ManifiestoPackingList
																					 where pklsti_id = pklsti.pklsti_id),0)
																		) 
									) <> pklsti_cantidad

							and pklst_id = @@pklst_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este packinglist no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @pklst_nrodoc + ' nro.: '+ @pklst_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@pklst_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @pklst_pendiente	decimal(18,6)

	  select 
						@pklst_pendiente		= sum(pklsti_pendientefac)

		from PackingListItem where pklst_id = @@pklst_id

		if @pklst_pendiente = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El packinglist no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @pklst_nrodoc + ' nro.: '+ @pklst_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@pklst_id
																	)
		end

	end

ControlError:

end
GO