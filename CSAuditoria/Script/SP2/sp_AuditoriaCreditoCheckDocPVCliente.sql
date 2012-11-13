-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocPVCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocPVCliente]

go

create procedure sp_AuditoriaCreditoCheckDocPVCliente (

	@@pv_id     	int,
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
	declare @pv_nrodoc 				varchar(50) 
	declare @pv_numero 				varchar(50) 
	declare @est_id       		int
	declare @pv_pendiente			decimal(18,6)
	declare @pv_total    			decimal(18,6)
	declare @aplicado     		decimal(18,6)
	declare @cli_id           int
  declare @doct_PedidoVta	  int
	declare @emp_id						int

  set @doct_PedidoVta = 5

	select 
						@doct_id 		 	= doct_id,
						@pv_nrodoc  	= pv_nrodoc,
						@pv_numero  	= convert(varchar,pv_numero),
						@est_id      	= est_id,
						@pv_pendiente	= pv_pendiente,
						@pv_total			= pv_total,
						@cli_id       = cli_id,
						@emp_id				= emp_id

	from PedidoVenta where pv_id = @@pv_id


	if exists(select cli_id 
						from ClienteCacheCredito 
         		where cli_id  <> @cli_id 
           		and doct_id = @doct_PedidoVta 
           		and id      = @@pv_id
						) begin


			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Este pedido esta afectando el cache de credito de otro cliente' + char(10)

	end

	declare @desc1 		 decimal(18,6)
	declare @desc2 		 decimal(18,6)
	declare @pendiente decimal(18,6)
	declare @cache     decimal(18,6)
	declare @cotiz     decimal(18,6)
	declare @mon_id    int

	select
					@desc1 		 = pv_descuento1,
					@desc2 		 = pv_descuento2,
					@mon_id		 = mon_id

	from PedidoVenta pv inner join Documento doc on pv.doc_id = doc.doc_id
	where pv_id = @@pv_id

	select @pendiente = sum(pvi_pendiente * (pvi_importe / pvi_cantidad)) 
	from PedidoVentaItem where pv_id = @@pv_id

	set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc1/100)
	set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc2/100)

	declare @fecha      datetime

	set @fecha = getdate()
	exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotiz out

	if not exists(select * from Moneda where mon_id = @mon_id and mon_legal <> 0) begin
		if @cotiz > 0 set @pendiente = @pendiente * @cotiz
	end

  if @doct_id = 22 /*devolucion*/ set @pendiente = -@pendiente

	if abs(@pendiente) >= 0.01 begin

		if not exists(select id from ClienteCacheCredito 
			            where cli_id  = @cli_id 
			              and doct_id = @doct_PedidoVta 
			              and id      = @@pv_id) begin
	
			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Este pedido tiene pendiente y no hay registro en el cache de credito' + char(10)

		end else begin

			select @cache = sum(clicc_importe) 
			from ClienteCacheCredito 
			where cli_id 	= @cli_id
				and doct_id	= @doct_PedidoVta
				and id      = @@pv_id
				and emp_id  = @emp_id

			set @cache = IsNull(@cache,0)

			if abs(@pendiente - @cache) >= 0.015 begin
	
				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'Este pedido tiene un pendiente distinto al que figura en el cache de credito' + char(10)
																			+ 'Pendiente: ' + convert(varchar,@pendiente) + char(10)
																			+ 'Cache: ' 		+ convert(varchar,@cache) + char(10)
																			+ 'Dif: '				+ convert(varchar,abs(@pendiente - @cache))
			end

		end

  end else begin

		if exists(select id from ClienteCacheCredito 
	            where cli_id  = @cli_id 
	              and doct_id = @doct_PedidoVta 
	              and id      = @@pv_id) begin
	
			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Este pedido no tiene pendiente y tiene registro en el cache de credito' + char(10)

		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO