-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocFVCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocFVCliente]

go

create procedure sp_AuditoriaCreditoCheckDocFVCliente (

  @@fv_id       int,
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
  declare @fv_nrodoc         varchar(50) 
  declare @fv_numero         varchar(50) 
  declare @est_id           int
  declare @fv_pendiente      decimal(18,6)
  declare @fv_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @cli_id           int
  declare @doct_facturaVta  int
  declare @emp_id            int

  set @doct_facturaVta = 1

  select 
            @doct_id        = doct_id,
            @fv_nrodoc    = fv_nrodoc,
            @fv_numero    = convert(varchar,fv_numero),
            @est_id        = est_id,
            @fv_pendiente  = fv_pendiente,
            @fv_total      = fv_total,
            @cli_id       = cli_id,
            @emp_id        = emp_id

  from FacturaVenta where fv_id = @@fv_id


  if exists(select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_facturaVta 
               and id      = @@fv_id
            ) begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta factura esta afectando el cache de credito de otro cliente' + char(10)
                  
  end

  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)

  select @pendiente = sum(fvd_pendiente) from FacturaVentaDeuda where fv_id = @@fv_id

  set @pendiente = IsNull(@pendiente,0)

  if @doct_id = 7 /*nota de credito*/ set @pendiente = -@pendiente

  if abs(@pendiente) >= 0.01 begin

    if not exists(select id from ClienteCacheCredito 
                  where cli_id  = @cli_id 
                    and doct_id = @doct_facturaVta 
                    and id      = @@fv_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta factura tiene pendiente y no hay registro en el cache de credito' + char(10)

    end else begin

      select @cache = sum(clicc_importe) 
      from ClienteCacheCredito 
      where cli_id   = @cli_id
        and doct_id  = @doct_facturaVta
        and id      = @@fv_id
        and emp_id  = @emp_id

      set @cache = IsNull(@cache,0)

      if abs(@pendiente - @cache) >= 0.02 begin
  
        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'Esta factura tiene un pendiente distinto al que figura en el cache de credito' + char(10)
                                      + 'Pendiente: ' + convert(varchar(50),@pendiente) + char(10)
                                      + 'Cache: ' + convert(varchar(50),@cache) + char(10)
                                      + 'Dif: '        + convert(varchar,abs(@pendiente - @cache))

      end

    end

  end else begin

    if exists(select id from ClienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_facturaVta 
                and id      = @@fv_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta factura no tiene pendiente y tiene registro en el cache de credito' + char(10)

    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO