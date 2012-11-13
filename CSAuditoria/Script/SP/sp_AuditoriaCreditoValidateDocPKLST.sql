-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocPKLST]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocPKLST]

go

create procedure sp_AuditoriaCreditoValidateDocPKLST (

	@@pklst_id  int,
	@@aud_id 		int

)
as

begin

  set nocount on

	declare @audi_id 					int
	declare @doct_id      		int
	declare @pklst_nrodoc 		varchar(50) 
	declare @pklst_numero 		varchar(50) 
	declare @est_id       		int
	declare @pklst_pendiente	decimal(18,6)
	declare @pklst_total    	decimal(18,6)
	declare @aplicado     		decimal(18,6)
	declare @cli_id           int
  declare @doct_PackingList	int
	declare @emp_id						int

  set @doct_PackingList = 21

	select 
						@doct_id 		 			= pklst.doct_id,
						@pklst_nrodoc  		= pklst_nrodoc,
						@pklst_numero  		= convert(varchar,pklst_numero),
						@est_id      			= est_id,
						@pklst_pendiente	= pklst_pendiente,
						@pklst_total			= pklst_total,
						@cli_id       		= cli_id,
						@emp_id						= emp_id

	from PackingList pklst inner join Documento doc on pklst.doc_id = doc.doc_id
	where pklst_id = @@pklst_id


	if exists(select cli_id 
						from ClienteCacheCredito 
         		where cli_id  <> @cli_id 
           		and doct_id = @doct_PackingList 
           		and id      = @@pklst_id
						) begin


			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este packinglist esta afectando el cache de credito de otro cliente '
                                 + '(comp.:' + @pklst_nrodoc + ' nro.: '+ @pklst_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@pklst_id
																)

	end

	declare @pendiente decimal(18,6)
	declare @cache     decimal(18,6)

	select @pendiente = sum(pklsti_pendientefac * (pklsti_importe / pklsti_cantidad)) from PackingListItem where pklst_id = @@pklst_id

	set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 31 /*devolucion*/ set @pendiente = -@pendiente

	if @pendiente <> 0 begin

		if not exists(select id from ClienteCacheCredito 
			            where cli_id  = @cli_id 
			              and doct_id = @doct_PackingList 
			              and id      = @@pklst_id) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este packinglist tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @pklst_nrodoc + ' nro.: '+ @pklst_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@pklst_id
																)

		end else begin

			select @cache = sum(clicc_importe) 
			from ClienteCacheCredito 
			where cli_id 	= @cli_id
				and doct_id	= @doct_PackingList
				and id      = @@pklst_id
				and emp_id  = @emp_id

				set @cache = IsNull(@cache,0)

				if @pendiente <> @cache begin
	
				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'Este packinglist tiene un pendiente distinto al que figura en el cache de credito '
	                                 + '(comp.:' + @pklst_nrodoc + ' nro.: '+ @pklst_numero + ')',
																	 3,
																	 4,
																	 @doct_id,
																	 @@pklst_id
																	)

			end

		end

  end else begin

		if exists(select id from ClienteCacheCredito 
	            where cli_id  = @cli_id 
	              and doct_id = @doct_PackingList 
	              and id      = @@pklst_id) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este packinglist no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @pklst_nrodoc + ' nro.: '+ @pklst_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@pklst_id
																)

		end

	end

ControlError:

end
GO