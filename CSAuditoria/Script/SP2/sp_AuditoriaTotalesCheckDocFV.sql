-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesCheckDocFV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesCheckDocFV]

go

create procedure sp_AuditoriaTotalesCheckDocFV (

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
  declare @fv_percepciones  decimal(18,6)
  declare @fv_neto          decimal(18,6)
  declare @fv_ivari         decimal(18,6)
  declare @fv_importedesc1  decimal(18,6)
  declare @fv_importedesc2  decimal(18,6)
  declare @fv_desc1          decimal(18,6)
  declare @fv_desc2          decimal(18,6)

  select 
            @doct_id            = doct_id,
            @fv_nrodoc        = fv_nrodoc,
            @fv_numero        = convert(varchar,fv_numero),
            @est_id            = est_id,
            @fv_pendiente      = fv_pendiente,
            @fv_total          = fv_total,
            @fv_neto          = fv_neto,
            @fv_ivari          = fv_ivari,

            @fv_percepciones  = fv_totalpercepciones,

            @fv_desc1          = fv_descuento1,
            @fv_desc2          = fv_descuento2,

            @fv_importedesc1  = fv_importedesc1,
            @fv_importedesc2  = fv_importedesc2

  from FacturaVenta where fv_id = @@fv_id

  if exists(select fv_id 
            from FacturaVentaItem
             where abs(round(fvi_neto,2) - round(fvi_precio * fvi_cantidad,2))>0.01
              and fv_id = @@fv_id
            ) begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta factura posee items cuyo neto no coincide con el precio por la cantidad' + char(10)

  end

  if exists(select fv_id 
            from FacturaVentaItem
             where abs(round(fvi_neto * (fvi_ivariporc / 100),2) - round(fvi_ivari,2))>0.01
              and fv_id = @@fv_id
            ) begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'Esta factura posee items cuyo iva no coincide con el neto por el porcentaje de la tasa' + char(10)

  end

  declare @fvi_neto decimal(18,6)

  select @fvi_neto = sum(fvi_neto)
  from FacturaVentaItem
  where fv_id = @@fv_id
  group by fv_id

  set @fvi_neto = IsNull(@fvi_neto,0) - (@fvi_neto * @fv_desc1/100) 
  set @fvi_neto = IsNull(@fvi_neto,0) - (@fvi_neto * @fv_desc2/100)

  if  round(@fvi_neto,2) <> round(@fv_neto,2) begin

      set @bError = 1
      set @@bErrorMsg =  @@bErrorMsg + 'El neto de esta factura no coincide con la suma de los netos de sus items' + char(10)

  end

  declare @fv_descivari   decimal(18,6)
  declare @fvi_ivari       decimal(18,6)
  declare @importe        decimal(18,6)
  declare @percepciones    decimal(18,6)

  select @fvi_ivari = sum(fvi_ivari)
            from FacturaVentaItem
            where fv_id = @@fv_id
            group by fv_id

  set @fvi_ivari     = isnull(@fvi_ivari,0)
  set @fv_descivari = (@fvi_ivari * @fv_desc1/100) 
  set @fv_descivari = @fv_descivari + ((@fvi_ivari - @fv_descivari) * @fv_desc2/100)
  set @fv_total     = @fv_total + @fv_importedesc1 + @fv_importedesc2 + @fv_descivari

  select @importe       = sum(fvi_importe) from FacturaVentaItem where fv_id = @@fv_id
  select @percepciones   = sum(fvperc_importe) from FacturaVentaPercepcion where fv_id = @@fv_id 

  set @importe       = isnull(@importe,0)
  set @percepciones = isnull(@percepciones,0)

  if round(@importe + @percepciones,2) <> round(@fv_total,2)  begin

      set @bError = 1
      set @@bErrorMsg =  @@bErrorMsg + 'El total de esta factura no coincide con la suma de los totales de sus items' + char(10)
                                     + 'Importe + Percepciones: ' + convert(varchar,convert(decimal(18,2),round(@importe + @percepciones,2))) + char(10)
                                     + 'Total : ' + convert(varchar,convert(decimal(18,2),round(@fv_total,2))) + char(10)
                                     + 'Diferencia: ' + convert(varchar,convert(decimal(18,2),round(round(@importe + @percepciones,2) - round(@fv_total,2),2))) + char(10)

  end

  select @fvi_ivari = sum(fvi_ivari)
            from FacturaVentaItem
            where fv_id = @@fv_id
            group by fv_id

  set @fvi_ivari = isnull(@fvi_ivari,0)
  set @fvi_ivari = @fvi_ivari - (@fvi_ivari * @fv_desc1/100) 
  set @fvi_ivari = @fvi_ivari - (@fvi_ivari * @fv_desc2/100)

  if round(@fvi_ivari,2) <> round(@fv_ivari,2) begin

      set @bError = 1
      set @@bErrorMsg =  @@bErrorMsg + 'El IVA de esta factura no coincide con la suma de los IVA de sus items' + char(10)

  end

  if abs(round(@percepciones,2) - round(@fv_percepciones,2))>0.01 begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El total de percepcioens de esta factura no coincide con la suma de los totales de sus items de tipo percepcion' + char(10)
                                     + 'Suma de Items: ' + convert(varchar,convert(decimal(18,2),round(@percepciones,2))) + char(10)
                                     + 'Total de Percepciones : ' + convert(varchar,convert(decimal(18,2),round(@fv_percepciones,2))) + char(10)
                                     + 'Diferencia: ' + convert(varchar,convert(decimal(18,2),round(round(@percepciones,2) - round(@fv_percepciones,2),2))) + char(10)

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO