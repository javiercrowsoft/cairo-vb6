-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocPRV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocPRV]

go

create procedure sp_AuditoriaTotalesCheckDocPRV (

  @@prv_id       int,
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

  declare @doct_id            int
  declare @prv_nrodoc         varchar(50) 
  declare @prv_numero         varchar(50) 
  declare @est_id             int
  declare @prv_pendiente      decimal(18,6)
  declare @prv_total          decimal(18,6)
  declare @prv_neto            decimal(18,6)
  declare @prv_ivari           decimal(18,6)
  declare @prv_importedesc1    decimal(18,6)
  declare @prv_importedesc2    decimal(18,6)
  declare @prv_desc1          decimal(18,6)
  declare @prv_desc2          decimal(18,6)

  select 
            @doct_id            = doct_id,
            @prv_nrodoc        = prv_nrodoc,
            @prv_numero        = convert(varchar,prv_numero),
            @est_id            = est_id,
            @prv_pendiente    = prv_pendiente,
            @prv_total        = prv_total,
            @prv_neto          = prv_neto,
            @prv_ivari        = prv_ivari,

            @prv_desc1        = prv_descuento1,
            @prv_desc2        = prv_descuento2,

            @prv_importedesc1  = prv_importedesc1,
            @prv_importedesc2  = prv_importedesc2

  from PresupuestoVenta where prv_id = @@prv_id

  if exists(select prv_id 
            from PresupuestoVentaItem
             where round(prvi_neto,2) <> round(prvi_precio * prvi_cantidad,2)
              and prv_id = @@prv_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este presupuesto posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

  end

  if exists(select prv_id 
            from PresupuestoVentaItem
             where round(prvi_neto * (prvi_ivariporc / 100),2) <> round(prvi_ivari,2)
              and prv_id = @@prv_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este presupuesto posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)

  end

  declare @prvi_neto decimal(18,6)

  select @prvi_neto = sum(prvi_neto)
  from PresupuestoVentaItem
  where prv_id = @@prv_id
  group by prv_id

  set @prvi_neto = IsNull(@prvi_neto,0) - (@prvi_neto * @prv_desc1/100) 
  set @prvi_neto = IsNull(@prvi_neto,0) - (@prvi_neto * @prv_desc2/100)

  if  round(@prvi_neto,2) <> round(@prv_neto,2) begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El neto de este presupuesto no coincide con la suma de los netos de sus items' + char(10)

  end

  declare @prv_descivari   decimal(18,6)
  declare @prvi_ivari     decimal(18,6)
  declare @importe        decimal(18,6)

  select @prvi_ivari = sum(prvi_ivari)
            from PresupuestoVentaItem
            where prv_id = @@prv_id
            group by prv_id

  set @prvi_ivari = isnull(@prvi_ivari,0)
  set @prv_descivari = (@prvi_ivari * @prv_desc1/100) 
  set @prv_descivari = @prv_descivari + ((@prvi_ivari - @prv_descivari) * @prv_desc2/100)
  set @prv_total     = @prv_total + @prv_importedesc1 + @prv_importedesc2 + @prv_descivari

  select @importe = sum(prvi_importe)
            from PresupuestoVentaItem
            where prv_id = @@prv_id

  set @importe = isnull(@importe,0)

  if round(@importe,2) <> round(@prv_total,2)  begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El total de este presupuesto no coincide con la suma de los totales de sus items' + char(10)

  end

  select @prvi_ivari = sum(prvi_ivari)
            from PresupuestoVentaItem
            where prv_id = @@prv_id
            group by prv_id

  set @prvi_ivari = isnull(@prvi_ivari,0)
  set @prvi_ivari = @prvi_ivari - (@prvi_ivari * @prv_desc1/100) 
  set @prvi_ivari = @prvi_ivari - (@prvi_ivari * @prv_desc2/100)

  if round(@prvi_ivari,2) <> round(@prv_ivari,2) begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El IVA de este presupuesto no coincide con la suma de los IVA de sus items' + char(10)

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO