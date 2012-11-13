-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocCOBZ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocCOBZ]

go

create procedure sp_AuditoriaCreditoValidateDocCOBZ (

	@@cobz_id   int,
	@@aud_id 		int

)
as

begin

  set nocount on

	declare @audi_id 					int
	declare @doct_id      		int
	declare @cobz_nrodoc 			varchar(50) 
	declare @cobz_numero 			varchar(50) 
	declare @est_id       		int
	declare @cobz_pendiente		decimal(18,6)
	declare @cobz_total    		decimal(18,6)
	declare @aplicado     		decimal(18,6)
	declare @cli_id           int
  declare @doct_Cobranza	  int
	declare @emp_id						int

  set @doct_Cobranza = 13

	select 
						@doct_id 		 		= doct_id,
						@cobz_nrodoc  	= cobz_nrodoc,
						@cobz_numero  	= convert(varchar,cobz_numero),
						@est_id      		= est_id,
						@cobz_pendiente	= cobz_pendiente,
						@cobz_total			= cobz_total,
						@cli_id       	= cli_id,
						@emp_id					= emp_id

	from Cobranza where cobz_id = @@cobz_id


	if exists(select cli_id 
						from ClienteCacheCredito 
         		where cli_id  <> @cli_id 
           		and doct_id = @doct_Cobranza 
           		and id      = @@cobz_id
						) begin


			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Esta cobranza esta afectando el cache de credito de otro cliente '
                                 + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@cobz_id
																)

	end

	declare @pendiente decimal(18,6)
	declare @cache     decimal(18,6)

	select @pendiente = round(@cobz_pendiente,2)

	if @pendiente <> 0 begin

		if not exists(select id from ClienteCacheCredito 
			            where cli_id  = @cli_id 
			              and doct_id = @doct_Cobranza 
			              and id      = @@cobz_id) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Esta cobranza tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@cobz_id
																)

		end else begin

			select @cache = sum(clicc_importe) 
			from ClienteCacheCredito 
			where cli_id 	= @cli_id
				and doct_id	= @doct_Cobranza
				and id      = @@cobz_id
				and emp_id  = @emp_id

			set @cache = IsNull(@cache,0)

			if @pendiente <> @cache begin
	
				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'Esta cobranza tiene un pendiente distinto al que figura en el cache de credito '
	                                 + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
																	 3,
																	 4,
																	 @doct_id,
																	 @@cobz_id
																	)

			end

		end

  end else begin

		if exists(select id from ClienteCacheCredito 
	            where cli_id  = @cli_id 
	              and doct_id = @doct_Cobranza 
	              and id      = @@cobz_id) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Esta cobranza no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@cobz_id
																)

		end

	end

ControlError:

end
GO