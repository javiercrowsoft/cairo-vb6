-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocPV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocPV]

go

create procedure sp_AuditoriaTotalesCheckDocPV (

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
	declare @pv_neto          decimal(18,6)
	declare @pv_ivari         decimal(18,6)
	declare @pv_importedesc1  decimal(18,6)
	declare @pv_importedesc2  decimal(18,6)
	declare @pv_desc1  				decimal(18,6)
	declare @pv_desc2  				decimal(18,6)
	declare @cli_catFiscal    smallint

	select 
						@doct_id 		 			= doct_id,
						@pv_nrodoc  			= pv_nrodoc,
						@pv_numero  			= convert(varchar,pv_numero),
						@est_id      			= est_id,
						@pv_pendiente			= pv_pendiente,
						@pv_total					= pv_total,
						@pv_neto					= pv_neto,
						@pv_ivari					= pv_ivari,

						@pv_desc1					= pv_descuento1,
						@pv_desc2					= pv_descuento2,

						@pv_importedesc1	= pv_importedesc1,
						@pv_importedesc2	= pv_importedesc2,
						@cli_catFiscal    = cli_catfiscal

	from PedidoVenta pv inner join Cliente cli on pv.cli_id = cli.cli_id
	where pv_id = @@pv_id

	if exists(select pv_id 
						from PedidoVentaItem
         		where abs(round(pvi_neto,2) - round(pvi_precio * pvi_cantidad,2))>=0.01
							and pv_id = @@pv_id
						) begin


			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Este pedido posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

	end

	if exists(select pv_id 
						from PedidoVentaItem
         		where abs(round(pvi_neto * (pvi_ivariporc / 100),2) - round(pvi_ivari,2))>=0.01
							and pv_id = @@pv_id
							and @cli_catFiscal <> 5
						) begin


			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'Este pedido posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)

	end

	declare @pvi_neto decimal(18,6)

	select @pvi_neto = sum(pvi_neto)
	from PedidoVentaItem
	where pv_id = @@pv_id
	group by pv_id

	set @pvi_neto = IsNull(@pvi_neto,0) - (@pvi_neto * @pv_desc1/100) 
	set @pvi_neto = IsNull(@pvi_neto,0) - (@pvi_neto * @pv_desc2/100)

	if  abs(round(@pvi_neto,2) - round(@pv_neto,2))>=0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El neto de este pedido no coincide con la suma de los netos de sus items' + char(10)

	end

	declare @pv_descivari decimal(18,6)
	declare @pvi_ivari 		decimal(18,6)
	declare @importe      decimal(18,6)

	select @pvi_ivari = sum(pvi_ivari)
						from PedidoVentaItem
						where pv_id = @@pv_id
						group by pv_id

	set @pvi_ivari = isnull(@pvi_ivari,0)
	set @pv_descivari = (@pvi_ivari * @pv_desc1/100) 
	set @pv_descivari = @pv_descivari + ((@pvi_ivari - @pv_descivari) * @pv_desc2/100)
	set @pv_total 		= @pv_total + @pv_importedesc1 + @pv_importedesc2 + @pv_descivari

	select @importe = sum(pvi_importe)
						from PedidoVentaItem
						where pv_id = @@pv_id

	set @importe = isnull(@importe,0)

	if abs(round(@importe,2) - round(@pv_total,2))>=0.01  begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El total de este pedido no coincide con la suma de los totales de sus items' + char(10)

	end

	select @pvi_ivari = sum(pvi_ivari)
						from PedidoVentaItem
						where pv_id = @@pv_id
						group by pv_id

	set @pvi_ivari = isnull(@pvi_ivari,0)
	set @pvi_ivari = @pvi_ivari - (@pvi_ivari * @pv_desc1/100) 
	set @pvi_ivari = @pvi_ivari - (@pvi_ivari * @pv_desc2/100)

	if abs(round(@pvi_ivari,2) - round(@pv_ivari,2))>=0.01 begin

			set @bError = 1
			set @@bErrorMsg = @@bErrorMsg + 'El IVA de este pedido no coincide con la suma de los IVA de sus items' + char(10)

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO