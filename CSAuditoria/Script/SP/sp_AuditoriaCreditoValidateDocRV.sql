-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateDocRV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateDocRV]

go

create procedure sp_AuditoriaCreditoValidateDocRV (

	@@rv_id     int,
	@@aud_id 		int

)
as

begin

  set nocount on

	declare @audi_id 					int
	declare @doct_id      		int
	declare @rv_nrodoc 				varchar(50) 
	declare @rv_numero 				varchar(50) 
	declare @est_id       		int
	declare @rv_pendiente			decimal(18,6)
	declare @rv_total    			decimal(18,6)
	declare @aplicado     		decimal(18,6)
	declare @cli_id           int
  declare @doct_RemitoVta	  int
	declare @emp_id						int

  set @doct_RemitoVta = 3

	select 
						@doct_id 		 	= doct_id,
						@rv_nrodoc  	= rv_nrodoc,
						@rv_numero  	= convert(varchar,rv_numero),
						@est_id      	= est_id,
						@rv_pendiente	= rv_pendiente,
						@rv_total			= rv_total,
						@cli_id       = cli_id,
						@emp_id				= emp_id

	from RemitoVenta where rv_id = @@rv_id


	if exists(select cli_id 
						from ClienteCacheCredito 
         		where cli_id  <> @cli_id 
           		and doct_id = @doct_RemitoVta 
           		and id      = @@rv_id
						) begin


			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este remito esta afectando el cache de credito de otro cliente '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rv_id
																)

	end

	declare @pendiente decimal(18,6)
	declare @cache     decimal(18,6)

	select @pendiente = sum(rvi_pendientefac * (rvi_importe / rvi_cantidad)) from RemitoVentaItem where rv_id = @@rv_id

	set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 24 /*devolucion*/ set @pendiente = -@pendiente

	if @pendiente <> 0 begin

		if not exists(select id from ClienteCacheCredito 
			            where cli_id  = @cli_id 
			              and doct_id = @doct_RemitoVta 
			              and id      = @@rv_id) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este remito tiene pendiente y no hay registro en el cache de credito '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rv_id
																)

		end else begin

			select @cache = sum(clicc_importe) 
			from ClienteCacheCredito 
			where cli_id 	= @cli_id
				and doct_id	= @doct_RemitoVta
				and id      = @@rv_id
				and emp_id  = @emp_id

				set @cache = IsNull(@cache,0)

				if @pendiente <> @cache begin
	
				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'Este remito tiene un pendiente distinto al que figura en el cache de credito '
	                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
																	 3,
																	 4,
																	 @doct_id,
																	 @@rv_id
																	)

			end

		end

  end else begin

		if exists(select id from ClienteCacheCredito 
	            where cli_id  = @cli_id 
	              and doct_id = @doct_RemitoVta 
	              and id      = @@rv_id) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este remito no tiene pendiente y tiene registro en el cache de credito '
                                 + '(comp.:' + @rv_nrodoc + ' nro.: '+ @rv_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rv_id
																)

		end

	end

ControlError:

end
GO