-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocRVCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocRVCliente]

go

create procedure sp_AuditoriaCreditoCheckDocRVCliente (

  @@rv_id       int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  declare @bError tinyint

  set @bError     = 0
  set @@bSuccess   = 0
  set @@bErrorMsg = '@@ERROR_SP:'

  declare @doct_id          int
  declare @rv_nrodoc         varchar(50) 
  declare @rv_numero         varchar(50) 
  declare @est_id           int
  declare @rv_pendiente      decimal(18,6)
  declare @rv_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @cli_id           int
  declare @doct_RemitoVta    int
  declare @emp_id            int

  set @doct_RemitoVta = 3

  select 
            @doct_id        = doct_id,
            @rv_nrodoc    = rv_nrodoc,
            @rv_numero    = convert(varchar,rv_numero),
            @est_id        = est_id,
            @rv_pendiente  = rv_pendiente,
            @rv_total      = rv_total,
            @cli_id       = cli_id,
            @emp_id        = emp_id

  from RemitoVenta where rv_id = @@rv_id


  if exists(select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_RemitoVta 
               and id      = @@rv_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito esta afectando el cache de credito de otro cliente' + char(10)

  end

  declare @desc1      decimal(18,6)
  declare @desc2      decimal(18,6)
  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)
  declare @cotiz     decimal(18,6)

  select
          @desc1      = rv_descuento1,
          @desc2      = rv_descuento2,
          @cotiz     = rv_cotizacion

  from RemitoVenta where rv_id = @@rv_id

  select   @pendiente = sum(rvi_pendientefac * (rvi_importe / rvi_cantidad))
  from RemitoVentaItem where rv_id = @@rv_id

  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc1/100)
  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc2/100)

  if @cotiz > 0 set @pendiente = @pendiente * @cotiz

  if @doct_id = 24 /*devolucion*/ set @pendiente = -@pendiente

  if abs(@pendiente) >= 0.01 begin

    if not exists(select id from ClienteCacheCredito 
                  where cli_id  = @cli_id 
                    and doct_id = @doct_RemitoVta 
                    and id      = @@rv_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito tiene pendiente y no hay registro en el cache de credito' + char(10)

    end else begin

      select @cache = sum(clicc_importe) 
      from ClienteCacheCredito 
      where cli_id   = @cli_id
        and doct_id  = @doct_RemitoVta
        and id      = @@rv_id
        and emp_id  = @emp_id

      set @cache = IsNull(@cache,0)
  
      if abs(@pendiente - @cache) >= 0.05 begin
  
        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'Este remito tiene un pendiente distinto al que figura en el cache de credito' + char(10)
                                      + 'Pendiente: ' + convert(varchar,@pendiente) + char(10)
                                      + 'Cache: '     + convert(varchar,@cache) + char(10)
                                      + 'Dif: '        + convert(varchar,abs(@pendiente - @cache))

      end

    end

  end else begin

    if exists(select id from ClienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_RemitoVta 
                and id      = @@rv_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito no tiene pendiente y tiene registro en el cache de credito' + char(10)

    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO