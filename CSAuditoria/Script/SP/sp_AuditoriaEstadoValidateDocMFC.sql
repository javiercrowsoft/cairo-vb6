-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocMFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocMFC]

go

create procedure sp_AuditoriaEstadoValidateDocMFC (

	@@mfc_id      int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 			int
	declare @doct_id      int
	declare @mfc_nrodoc 	varchar(50) 
	declare @mfc_numero 	varchar(50) 
	declare @est_id       int

	select 
						@doct_id 		= doct_id,
						@mfc_nrodoc  = mfc_nrodoc,
						@mfc_numero  = convert(varchar,mfc_numero),
						@est_id     = est_id

	from ManifiestoCarga where mfc_id = @@mfc_id

	if exists(select * from ManifiestoCargaItem mfci
						where (mfci_pendiente
																+ 	(	  IsNull(
																					(select sum(mfcpklst_cantidad) from ManifiestoCargaPackingList 
																					 where mfci_id = mfci.mfci_id),0)
																		) 
									) <> mfci_cantidad

							and mfc_id = @@mfc_id
						)
	begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este manifiesto no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @mfc_nrodoc + ' nro.: '+ @mfc_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@mfc_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		declare @mfc_pendiente	decimal(18,6)

	  select 
						@mfc_pendiente		= sum(mfci_pendiente)

		from ManifiestoCargaItem where mfc_id = @@mfc_id

		if @mfc_pendiente = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El manifiesto no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @mfc_nrodoc + ' nro.: '+ @mfc_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@mfc_id
																	)
		end

	end

ControlError:

end
GO