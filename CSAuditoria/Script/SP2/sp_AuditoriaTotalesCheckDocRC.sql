-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocRC]

go

create procedure sp_AuditoriaTotalesCheckDocRC (

  @@rc_id       int,
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
  declare @rc_neto          decimal(18,6)
  declare @rc_ivari         decimal(18,6)
  declare @rc_importedesc1  decimal(18,6)
  declare @rc_importedesc2  decimal(18,6)
  declare @rc_desc1          decimal(18,6)
  declare @rc_desc2          decimal(18,6)
  declare @prov_catFiscal   smallint

  declare @dif decimal(18,6)

  select 
            @doct_id        = doct_id,
            @rc_nrodoc    = rc_nrodoc,
            @rc_numero    = convert(varchar,rc_numero),
            @est_id        = est_id,
            @rc_pendiente  = rc_pendiente,
            @rc_total      = rc_total,
            @rc_neto      = rc_neto,
            @rc_ivari      = rc_ivari,

            @rc_desc1          = rc_descuento1,
            @rc_desc2          = rc_descuento2,

            @rc_importedesc1  = rc_importedesc1,
            @rc_importedesc2  = rc_importedesc2,
            @prov_catFiscal   = prov_catfiscal

  from RemitoCompra rc inner join Proveedor prov on rc.prov_id = prov.prov_id
  where rc_id = @@rc_id

  if exists(select rc_id 
            from RemitoCompraItem
             where abs(round(rci_neto,2) - round(rci_precio * rci_cantidad,2))>=0.01
              and rc_id = @@rc_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

  end

  if exists(select rc_id 
            from RemitoCompraItem
             where abs(round(rci_neto * (rci_ivariporc / 100),2) - round(rci_ivari,2))>=0.01
              and rc_id = @@rc_id
              and @prov_catFiscal <> 5
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Este remito posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)

  end

  declare @rci_neto decimal(18,6)

  select @rci_neto = sum(rci_neto)
  from RemitoCompraItem
  where rc_id = @@rc_id
  group by rc_id

  set @rci_neto = IsNull(@rci_neto,0) - (@rci_neto * @rc_desc1/100) 
  set @rci_neto = IsNull(@rci_neto,0) - (@rci_neto * @rc_desc2/100)

  if abs(round(@rci_neto,2) - round(@rc_neto,2))>=0.01 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El neto de este remito no coincide con la suma de los netos de sus items' + char(10)

  end

  declare @importe         decimal(18,6)

  select @importe = sum(rci_importe) from RemitoCompraItem where rc_id = @@rc_id group by rc_id

  set @importe = isnull(@importe,0)

  declare @rc_descivari decimal(18,6)
  declare @rci_ivari     decimal(18,6)

  select @rci_ivari = sum(rci_ivari)
            from RemitoCompraItem
            where rc_id = @@rc_id
            group by rc_id

  set @rci_ivari     = isnull(@rci_ivari,0)
  set @rc_descivari = (@rci_ivari * @rc_desc1/100) 
  set @rc_descivari = @rc_descivari + ((@rci_ivari - @rc_descivari) * @rc_desc2/100)
  set @rc_total     = @rc_total + @rc_importedesc1 + @rc_importedesc2 + @rc_descivari

  if abs(round(@importe,2) - round(@rc_total,2))>=0.01 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El total de este remito no coincide con la suma de los totales de sus items' + char(10)
                                    + 'Total Items: ' + convert(varchar(50),round(@importe,2)) + char(13)
                                    + 'Total Remito: ' + convert(varchar(50),round(@rc_total,2)) + char(13)

  end

  select @rci_ivari = sum(rci_ivari)
            from RemitoCompraItem
            where rc_id = @@rc_id
            group by rc_id

  set @rci_ivari = isnull(@rci_ivari,0)
  set @rci_ivari = @rci_ivari - (@rci_ivari * @rc_desc1/100) 
  set @rci_ivari = @rci_ivari - (@rci_ivari * @rc_desc2/100)

  if abs(round(@rci_ivari,2) - round(@rc_ivari,2))>=0.01 begin

      set @dif = abs(round(@rci_ivari,2) - round(@rc_ivari,2))

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El IVA de este remito no coincide con la suma de los IVA de sus items' + char(10)
                                     + 'Diferencia ' + convert(varchar,@dif)

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO