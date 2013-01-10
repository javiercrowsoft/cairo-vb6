-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocRC]

go

create procedure sp_AuditoriaCreditoCheckDocRC (

  @@rc_id     int,
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
  declare @rc_nrodoc         varchar(50) 
  declare @rc_numero         varchar(50) 
  declare @est_id           int
  declare @rc_pendiente      decimal(18,6)
  declare @rc_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @prov_id          int
  declare @doct_RemitoCpra  int
  declare @emp_id            int

  set @doct_RemitoCpra = 4

  select 
            @doct_id        = rc.doct_id,
            @rc_nrodoc    = rc_nrodoc,
            @rc_numero    = convert(varchar,rc_numero),
            @est_id        = est_id,
            @rc_pendiente  = rc_pendiente,
            @rc_total      = rc_total,
            @prov_id      = prov_id,
            @emp_id        = emp_id

  from RemitoCompra rc Inner join Documento doc on rc.doc_id = doc.doc_id 
  where rc_id = @@rc_id


  if exists(select prov_id 
            from ProveedorCacheCredito 
             where prov_id <> @prov_id 
               and doct_id = @doct_RemitoCpra 
               and id      = @@rc_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito esta afectando el cache de credito de otro proveedor' + char(10)

  end

  declare @desc1      decimal(18,6)
  declare @desc2      decimal(18,6)
  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)
  declare @cotiz     decimal(18,6)

  select
          @desc1      = rc_descuento1,
          @desc2      = rc_descuento2,
          @cotiz     = rc_cotizacion

  from RemitoCompra where rc_id = @@rc_id

  select @pendiente = sum(rci_pendientefac * (rci_importe / rci_cantidad)) 
  from RemitoCompraItem where rc_id = @@rc_id

  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc1/100)
  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc2/100)

  if @cotiz > 0 set @pendiente = @pendiente * @cotiz

  if @doct_id = 25 /*devolucion*/ set @pendiente = -@pendiente

  if abs(@pendiente) >= 0.01 begin

    if not exists(select id from ProveedorCacheCredito 
                  where prov_id = @prov_id 
                    and doct_id = @doct_RemitoCpra 
                    and id      = @@rc_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito tiene pendiente y no hay registro en el cache de credito' + char(10)

    end else begin

      select @cache = sum(provcc_importe) 
      from ProveedorCacheCredito 
      where prov_id = @prov_id
        and doct_id  = @doct_RemitoCpra
        and id      = @@rc_id
        and emp_id  = @emp_id

      set @cache = IsNull(@cache,0)

      if abs(@pendiente - @cache) >= 0.03 begin
  
        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'Este remito tiene un pendiente distinto al que figura en el cache de credito' + char(10)
                                      + 'Pendiente: ' + convert(varchar,@pendiente) + char(10)
                                      + 'Cache: '     + convert(varchar,@cache) + char(10)
                                      + 'Dif: '        + convert(varchar,abs(@pendiente - @cache))
      end

    end

  end else begin

    if exists(select id from ProveedorCacheCredito 
              where prov_id = @prov_id 
                and doct_id = @doct_RemitoCpra 
                and id      = @@rc_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito no tiene pendiente y tiene registro en el cache de credito' + char(10)

    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO