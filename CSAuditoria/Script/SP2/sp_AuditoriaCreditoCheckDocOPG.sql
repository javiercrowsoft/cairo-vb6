-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocOPG]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocOPG]

go

create procedure sp_AuditoriaCreditoCheckDocOPG (
	@@opg_id   		int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	declare @bError tinyint

	set @bError     = 0
	set @@bSuccess 	= 0
	set @@bErrorMsg = '@@ERROR_SP:'

	declare @doct_id      		int
	declare @opg_nrodoc 			varchar(50) 
	declare @opg_numero 			varchar(50) 
	declare @est_id       		int
	declare @opg_pendiente		decimal(18,6)
	declare @opg_total    		decimal(18,6)
	declare @aplicado     		decimal(18,6)
	declare @prov_id          int
  declare @doct_OrdenPago	  int
	declare @emp_id						int

  set @doct_OrdenPago = 16

	select 
						@doct_id 		 		= doct_id,
						@opg_nrodoc  	  = opg_nrodoc,
						@opg_numero  	  = convert(varchar,opg_numero),
						@est_id      		= est_id,
						@opg_pendiente	= opg_pendiente,
						@opg_total			= opg_total,
						@prov_id       	= prov_id,
						@emp_id					= emp_id

	from OrdenPago where opg_id = @@opg_id


	if exists(select prov_id 
						from ProveedorCacheCredito 
         		where prov_id <> @prov_id 
           		and doct_id = @doct_OrdenPago 
           		and id      = @@opg_id
						) begin


		set @bError = 1
		set @@bErrorMsg = @@bErrorMsg + 'Esta orden de pago esta afectando el cache de credito de otro proveedor' + char(10)

	end

	declare @pendiente decimal(18,6)
	declare @cache     decimal(18,6)

	select @pendiente = round(@opg_pendiente,2)

	if abs(@pendiente)>=0.01 begin

		if not exists(select id from ProveedorCacheCredito 
			            where prov_id = @prov_id 
			              and doct_id = @doct_OrdenPago 
			              and id      = @@opg_id) begin
	
			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta orden de pago tiene pendiente y no hay registro en el cache de credito' + char(10)

		end else begin

			select @cache = sum(provcc_importe) 
			from ProveedorCacheCredito 
			where prov_id = @prov_id
				and doct_id	= @doct_OrdenPago
				and id      = @@opg_id
				and emp_id  = @emp_id

			set @cache = IsNull(@cache,0)

			if abs(@pendiente - @cache)>0.01 begin
	
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'Esta orden de pago tiene un pendiente distinto al que figura en el cache de credito' + char(10)

			end

		end

  end else begin

		if exists(select id from ProveedorCacheCredito 
	            where prov_id = @prov_id 
	              and doct_id = @doct_OrdenPago 
	              and id      = @@opg_id) begin
	
			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta orden de pago no tiene pendiente y tiene registro en el cache de credito' + char(10)

		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO