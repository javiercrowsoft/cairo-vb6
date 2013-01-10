-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocRV2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocRV2]

go

create procedure sp_AuditoriaTotalesCheckDocRV2 (

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

  declare @audi_id           int
  declare @doct_id          int
  declare @rv_nrodoc         varchar(50) 
  declare @rv_numero         varchar(50) 
  declare @est_id           int
  declare @rv_pendiente      decimal(18,6)
  declare @rv_total          decimal(18,6)
  declare @rv_neto          decimal(18,6)
  declare @rv_ivari         decimal(18,6)
  declare @rv_importedesc1  decimal(18,6)
  declare @rv_importedesc2  decimal(18,6)
  declare @rv_desc1          decimal(18,6)
  declare @rv_desc2          decimal(18,6)
  declare @cli_catFiscal    smallint

  declare @dif decimal(18,6)

  select 
            @doct_id            = doct_id,
            @rv_nrodoc        = rv_nrodoc,
            @rv_numero        = convert(varchar,rv_numero),
            @est_id            = est_id,
            @rv_pendiente      = rv_pendiente,
            @rv_total          = rv_total,
            @rv_neto          = rv_neto,
            @rv_ivari          = rv_ivari,

            @rv_desc1          = rv_descuento1,
            @rv_desc2          = rv_descuento2,

            @rv_importedesc1  = rv_importedesc1,
            @rv_importedesc2  = rv_importedesc2,
            @cli_catFiscal    = cli_catfiscal

  from RemitoVenta rv inner join Cliente cli on rv.cli_id = cli.cli_id
  where rv_id = @@rv_id

  if exists(select rv_id 
            from RemitoVentaItem
             where abs(round(rvi_neto,2) - round(rvi_precio * rvi_cantidad,2))>=0.02
              and rv_id = @@rv_id
            ) begin


      set @bError = 1
      set @@bErrorMsg =  @@bErrorMsg + 'Este remito posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

  end

  if exists(select rv_id 
            from RemitoVentaItem
             where abs(round(rvi_neto * (rvi_ivariporc / 100),2) - round(rvi_ivari,2))>=0.02
              and rv_id = @@rv_id
              and @cli_catFiscal <> 5
            ) begin

      select @dif = abs(round(rvi_neto * (rvi_ivariporc / 100),2) - round(rvi_ivari,2))
            from RemitoVentaItem
             where abs(round(rvi_neto * (rvi_ivariporc / 100),2) - round(rvi_ivari,2))>=0.02
              and rv_id = @@rv_id
              and @cli_catFiscal <> 5
    

      set @bError = 1
      set @@bErrorMsg =  @@bErrorMsg + 'Este remito posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10) +
                                     + 'Diferencia ' + convert(varchar, @dif)
                  
  end

  declare @rvi_neto decimal(18,6)

  select @rvi_neto = sum(rvi_neto)
  from RemitoVentaItem
  where rv_id = @@rv_id
  group by rv_id

  set @rvi_neto = IsNull(@rvi_neto,0) - (@rvi_neto * @rv_desc1/100) 
  set @rvi_neto = IsNull(@rvi_neto,0) - (@rvi_neto * @rv_desc2/100)

  if  abs(round(@rvi_neto,2) - round(@rv_neto,2))>=0.01 begin

      set @bError = 1
      set @@bErrorMsg =  @@bErrorMsg + 'El neto de este remito no coincide con la suma de los netos de sus items' + char(10)
                  
  end

  declare @rv_descivari decimal(18,6)
  declare @rvi_ivari     decimal(18,6)
  declare @importe      decimal(18,6)

  select @rvi_ivari = sum(rvi_ivari)
            from RemitoVentaItem
            where rv_id = @@rv_id
            group by rv_id

  set @rvi_ivari     = isnull(@rvi_ivari,0)
  set @rv_descivari = (@rvi_ivari * @rv_desc1/100) 
  set @rv_descivari = @rv_descivari + ((@rvi_ivari - @rv_descivari) * @rv_desc2/100)
  set @rv_total     = @rv_total + @rv_importedesc1 + @rv_importedesc2 + @rv_descivari

  select @importe = sum(rvi_importe)
            from RemitoVentaItem
            where rv_id = @@rv_id

  set @importe = isnull(@importe,0)

  if abs(round(@importe,2) - round(@rv_total,2))>=0.01  begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El total de este remito no coincide con la suma de los totales de sus items' + char(10)
                                    + 'Total Items: ' + convert(varchar(50),round(@importe,2)) + char(13)
                                    + 'Total Remito: ' + convert(varchar(50),round(@rv_total,2)) + char(13)
                  
  end

  select @rvi_ivari = sum(rvi_ivari)
            from RemitoVentaItem
            where rv_id = @@rv_id
            group by rv_id

  set @rvi_ivari = isnull(@rvi_ivari,0)
  set @rvi_ivari = @rvi_ivari - (@rvi_ivari * @rv_desc1/100) 
  set @rvi_ivari = @rvi_ivari - (@rvi_ivari * @rv_desc2/100)

  if abs(round(@rvi_ivari,2) - round(@rv_ivari,2))>=0.01 begin

      set @dif = abs(round(@rvi_ivari,2) - round(@rv_ivari,2))

      set @bError = 1
      set @@bErrorMsg =  @@bErrorMsg + 'El IVA de este remito no coincide con la suma de los IVA de sus items' + char(10)
                                     + 'Diferencia ' + convert(varchar,@dif)

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO
