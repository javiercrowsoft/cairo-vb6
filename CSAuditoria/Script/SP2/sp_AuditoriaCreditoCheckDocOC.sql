-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoCheckDocOC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoCheckDocOC]

go

create procedure sp_AuditoriaCreditoCheckDocOC (

  @@oc_id       int,
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
  declare @oc_nrodoc         varchar(50) 
  declare @oc_numero         varchar(50) 
  declare @est_id           int
  declare @oc_pendiente      decimal(18,6)
  declare @oc_total          decimal(18,6)
  declare @aplicado         decimal(18,6)
  declare @prov_id          int
  declare @doct_OrdenCpra    int
  declare @emp_id            int

  set @doct_OrdenCpra = 35

  select 
            @doct_id        = doct_id,
            @oc_nrodoc    = oc_nrodoc,
            @oc_numero    = convert(varchar,oc_numero),
            @est_id        = est_id,
            @oc_pendiente  = oc_pendiente,
            @oc_total      = oc_total,
            @prov_id      = prov_id,
            @emp_id        = emp_id

  from OrdenCompra where oc_id = @@oc_id


  if exists(select prov_id 
            from ProveedorCacheCredito 
             where prov_id <> @prov_id 
               and doct_id = @doct_OrdenCpra 
               and id      = @@oc_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta orden de compra esta afectando el cache de credito de otro proveedor' + char(10)

  end

  declare @desc1      decimal(18,6)
  declare @desc2      decimal(18,6)
  declare @pendiente decimal(18,6)
  declare @cache     decimal(18,6)
  declare @cotiz     decimal(18,6)
  declare @mon_id    int

  select
          @desc1      = oc_descuento1,
          @desc2      = oc_descuento2,
          @mon_id     = mon_id

  from OrdenCompra oc inner join Documento doc on oc.doc_id = doc.doc_id
  where oc_id = @@oc_id

  select @pendiente = sum(oci_pendientefac * (oci_importe / oci_cantidad)) 
  from OrdenCompraItem where oc_id = @@oc_id

  declare @fecha      datetime

  set @fecha = getdate()
  exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotiz out

  if not exists(select * from Moneda where mon_id = @mon_id and mon_legal <> 0) begin
    if @cotiz > 0 set @pendiente = @pendiente * @cotiz
  end

  if @doct_id = 36 /*cancelacion*/ set @pendiente = -@pendiente

  if abs(@pendiente) >= 0.01 begin

    if not exists(select id from ProveedorCacheCredito 
                  where prov_id = @prov_id 
                    and doct_id = @doct_OrdenCpra 
                    and id      = @@oc_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta orden de compra tiene pendiente y no hay registro en el cache de credito' + char(10)

    end else begin

      select @cache = sum(provcc_importe) 
      from ProveedorCacheCredito 
      where prov_id = @prov_id
        and doct_id  = @doct_OrdenCpra
        and id      = @@oc_id
        and emp_id  = @emp_id

      set @cache = IsNull(@cache,0)

      if abs(@pendiente - @cache) >= 0.015 begin
  
        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'Esta orden de compra tiene un pendiente distinto al que figura en el cache de credito' + char(10)
                                      + 'Pendiente: ' + convert(varchar,@pendiente) + char(10)
                                      + 'Cache: '     + convert(varchar,@cache) + char(10)
                                      + 'Dif: '        + convert(varchar,abs(@pendiente - @cache))
      end

    end

  end else begin

    if exists(select id from ProveedorCacheCredito 
              where prov_id = @prov_id 
                and doct_id = @doct_OrdenCpra 
                and id      = @@oc_id) begin
  
      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta orden de compra no tiene pendiente y tiene registro en el cache de credito' + char(10)

    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO