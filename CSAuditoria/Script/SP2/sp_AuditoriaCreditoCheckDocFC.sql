-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocFC]

go

create procedure sp_AuditoriaCreditoCheckDocFC (

	@@fc_id     	int,
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
	declare @fc_nrodoc 				varchar(50) 
	declare @fc_numero 				varchar(50) 
	declare @est_id       		int
	declare @fc_pendiente			decimal(18,6)
	declare @fc_total    			decimal(18,6)
	declare @aplicado     		decimal(18,6)
	declare @prov_id          int
  declare @doct_facturaCpra	int
	declare @emp_id						int

  set @doct_facturaCpra = 2

	select 
						@doct_id 		 	= fc.doct_id,
						@fc_nrodoc  	= fc_nrodoc,
						@fc_numero  	= convert(varchar,fc_numero),
						@est_id      	= est_id,
						@fc_pendiente	= fc_pendiente,
						@fc_total			= fc_total,
						@prov_id      = prov_id,
						@emp_id				= emp_id

	from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id 
	where fc_id = @@fc_id


	if exists(select prov_id 
						from ProveedorCacheCredito 
         		where prov_id <> @prov_id 
           		and doct_id = @doct_facturaCpra 
           		and id      = @@fc_id
						) begin


			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta factura esta afectando el cache de credito de otro Proveedor' + char(10)

	end

	declare @pendiente decimal(18,6)
	declare @cache     decimal(18,6)

	select @pendiente = sum(fcd_pendiente) from FacturaCompraDeuda where fc_id = @@fc_id

	set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 8 /*nota de credito*/ set @pendiente = -@pendiente

	if abs(@pendiente) >= 0.01 begin

		if not exists(select id from ProveedorCacheCredito 
			            where prov_id = @prov_id 
			              and doct_id = @doct_facturaCpra 
			              and id      = @@fc_id) begin
	
			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta factura tiene pendiente y no hay registro en el cache de credito' + char(10)

		end else begin

			select @cache = sum(provcc_importe) 
			from ProveedorCacheCredito 
			where prov_id = @prov_id
				and doct_id	= @doct_facturaCpra
				and id      = @@fc_id
				and emp_id  = @emp_id

			set @cache = IsNull(@cache,0)

			if abs(@pendiente - @cache) >= 0.01 begin
	
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'Esta factura tiene un pendiente distinto al que figura en el cache de credito' + char(10)

			end

		end

  end else begin

		if exists(select id from ProveedorCacheCredito 
	            where prov_id = @prov_id 
	              and doct_id = @doct_facturaCpra 
	              and id      = @@fc_id) begin
	
			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Esta factura no tiene pendiente y tiene registro en el cache de credito' + char(10)
									
		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO