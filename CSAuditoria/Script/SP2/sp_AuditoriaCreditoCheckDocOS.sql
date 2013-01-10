-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocOS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocOS]

go

create procedure sp_AuditoriaCreditoCheckDocOS (

  @@os_id       int,
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
  declare @os_nrodoc         varchar(50) 
  declare @os_numero         varchar(50) 
  declare @est_id           int
  declare @os_pendiente      decimal(18,6)
  declare @os_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @cli_id           int
  declare @doct_OrdenServ    int
  declare @emp_id            int

  set @doct_OrdenServ = 42

  select 
            @doct_id        = os.doct_id,
            @os_nrodoc    = os_nrodoc,
            @os_numero    = convert(varchar,os_numero),
            @est_id        = est_id,
            @os_pendiente  = os_pendiente,
            @os_total      = os_total,
            @cli_id       = cli_id,
            @emp_id        = os.emp_id

  from OrdenServicio os Inner join Documento doc on os.doc_id = doc.doc_id 
  where os_id = @@os_id


  if exists(select cli_id 
            from clienteCacheCredito 
             where cli_id <> @cli_id 
               and doct_id = @doct_OrdenServ 
               and id      = @@os_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'esta orden de servicio esta afectando el cache de credito de otro cliente' + char(10)

  end

  declare @desc1      decimal(18,6)
  declare @desc2      decimal(18,6)
  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)
  declare @cotiz     decimal(18,6)

  select
          @desc1      = os_descuento1,
          @desc2      = os_descuento2,
          @cotiz     = os_cotizacion

  from OrdenServicio where os_id = @@os_id

  select @pendiente = sum(osi_pendiente * (osi_importe / osi_cantidad)) 
  from OrdenServicioItem where os_id = @@os_id

  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc1/100)
  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc2/100)

  if @cotiz > 0 set @pendiente = @pendiente * @cotiz

  if abs(@pendiente) >= 0.01 begin

    if not exists(select id from clienteCacheCredito 
                  where cli_id  = @cli_id 
                    and doct_id = @doct_OrdenServ 
                    and id      = @@os_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta orden de servicio tiene pendiente y no hay registro en el cache de credito' + char(10)

    end else begin

      select @cache = sum(clicc_importe) 
      from clienteCacheCredito 
      where cli_id  = @cli_id
        and doct_id  = @doct_OrdenServ
        and id      = @@os_id
        and emp_id  = @emp_id

      set @cache = IsNull(@cache,0)

      if abs(@pendiente - @cache) >= 0.015 begin
  
        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'Esta orden de servicio tiene un pendiente distinto al que figura en el cache de credito' + char(10)
                                      + 'Pendiente: ' + convert(varchar,@pendiente) + char(10)
                                      + 'Cache: '     + convert(varchar,@cache) + char(10)
                                      + 'Dif: '        + convert(varchar,abs(@pendiente - @cache))
      end

    end

  end else begin

    if exists(select id from clienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_OrdenServ 
                and id      = @@os_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta orden de servicio no tiene pendiente y tiene registro en el cache de credito' + char(10)

    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO