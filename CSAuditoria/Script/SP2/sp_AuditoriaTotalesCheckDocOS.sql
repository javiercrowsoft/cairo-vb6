-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocOS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocOS]

go

create procedure sp_AuditoriaTotalesCheckDocOS (

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
  declare @os_neto          decimal(18,6)
  declare @os_ivari         decimal(18,6)
  declare @os_importedesc1  decimal(18,6)
  declare @os_importedesc2  decimal(18,6)
  declare @os_desc1          decimal(18,6)
  declare @os_desc2          decimal(18,6)
  declare @cli_catFiscal   smallint

  select 
            @doct_id        = doct_id,
            @os_nrodoc    = os_nrodoc,
            @os_numero    = convert(varchar,os_numero),
            @est_id        = est_id,
            @os_pendiente  = os_pendiente,
            @os_total      = os_total,
            @os_neto      = os_neto,
            @os_ivari      = os_ivari,

            @os_desc1          = os_descuento1,
            @os_desc2          = os_descuento2,

            @os_importedesc1  = os_importedesc1,
            @os_importedesc2  = os_importedesc2,
            @cli_catFiscal   = cli_catfiscal

  from OrdenServicio os inner join cliente cli on os.cli_id = cli.cli_id
  where os_id = @@os_id

  if exists(select os_id 
            from OrdenServicioItem
             where abs(round(osi_neto,2) - round(osi_precio * osi_cantidad,2))>=0.01
              and os_id = @@os_id
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta orden de servicio posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

  end

  if exists(select os_id 
            from OrdenServicioItem
             where abs(round(osi_neto * (osi_ivariporc / 100),2) - round(osi_ivari,2))>=0.01
              and os_id = @@os_id
              and @cli_catFiscal <> 5
            ) begin


      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta orden de servicio posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)

  end

  declare @osi_neto decimal(18,6)

  select @osi_neto = sum(osi_neto)
  from OrdenServicioItem
  where os_id = @@os_id
  group by os_id

  set @osi_neto = IsNull(@osi_neto,0) - (@osi_neto * @os_desc1/100) 
  set @osi_neto = IsNull(@osi_neto,0) - (@osi_neto * @os_desc2/100)

  if abs(round(@osi_neto,2) - round(@os_neto,2))>=0.01 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El neto de esta orden de servicio no coincide con la suma de los netos de sus items' + char(10)

  end

  declare @importe         decimal(18,6)

  select @importe = sum(osi_importe) from OrdenServicioItem where os_id = @@os_id group by os_id

  set @importe = isnull(@importe,0)

  declare @os_descivari decimal(18,6)
  declare @osi_ivari     decimal(18,6)

  select @osi_ivari = sum(osi_ivari)
            from OrdenServicioItem
            where os_id = @@os_id
            group by os_id

  set @osi_ivari = isnull(@osi_ivari,0)
  set @os_descivari = (@osi_ivari * @os_desc1/100) 
  set @os_descivari = @os_descivari + ((@osi_ivari - @os_descivari) * @os_desc2/100)
  set @os_total     = @os_total + @os_importedesc1 + @os_importedesc2 + @os_descivari

  if abs(round(@importe,2) - round(@os_total,2))>=0.01 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El total de esta orden de servicio no coincide con la suma de los totales de sus items' + char(10)
                                    + 'Total Items: ' + convert(varchar(50),round(@importe,2)) + char(13)
                                    + 'Total Orden: ' + convert(varchar(50),round(@os_total,2)) + char(13)

  end

  select @osi_ivari = sum(osi_ivari)
            from OrdenServicioItem
            where os_id = @@os_id
            group by os_id

  set @osi_ivari = isnull(@osi_ivari,0)
  set @osi_ivari = @osi_ivari - (@osi_ivari * @os_desc1/100) 
  set @osi_ivari = @osi_ivari - (@osi_ivari * @os_desc2/100)

  if abs(round(@osi_ivari,2) - round(@os_ivari,2))>=0.01 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El IVA de esta orden de servicio no coincide con la suma de los IVA de sus items' + char(10)

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO