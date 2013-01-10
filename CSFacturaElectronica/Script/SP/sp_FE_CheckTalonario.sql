if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_CheckTalonario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_CheckTalonario]

/*

*/

go
create procedure [dbo].[sp_FE_CheckTalonario] (
  @@fv_id           int,
  @@ta_id_factura    int,
  @@bSuccess        tinyint out,
  @@bErrorMsg       varchar(5000) out
)

as

begin

  set @@bSuccess = 0
  set @@bErrorMsg = '@@ERROR_SP:'

  -- Si no esta pendiente de firma no hay que hacer nada
  --
  if not exists(select 1 from FacturaVenta where fv_id = @@fv_id and est_id = 4 /*pendiente de firma*/)
  begin
    set @@bSuccess = 1
    return
  end

  declare @es_facturaElectronica tinyint
  declare @cae varchar(50)
  declare @emp_id int

  select @es_facturaElectronica = doc_esfacturaelectronica,
         @cae = fv_cae,
         @emp_id = doc.emp_id
  from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id
  where fv.fv_id = @@fv_id
    and fv.fv_cae = ''

  -- Si ya tiene cae no hay que hacer nada
  --
  if @cae <> '' return

  -- Solo si es de tipo factura electronica
  --
  if isnull(@es_facturaElectronica,0) <> 0 begin
  
    -- obtengo el talonario para prefacturas por pendiente de firma
    --
    declare @cfg_valor varchar(5000) 
    exec sp_Cfg_GetValor  'Contabilidad-General',
                          'Talonario Pre-Factura - Factura Electronica',
                          @cfg_valor out,
                          0,
                          @emp_id

    set @cfg_valor = IsNull(@cfg_valor,0)

    declare @ta_id int
    set @ta_id = convert(int,@cfg_valor)
    if @ta_id = 0 begin

      set @@bErrorMsg = @@bErrorMsg + 'Debe configurar el talonario de pre-facturas para Facturas Electronicas que se generan pendientes de firma. Utilice la opcion Configuracion / Contabilidad / General.'
      set @@bSuccess = 0
      return

    end

    declare @ta_nrodoc varchar(100)

    exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
    if @@error <> 0 goto ControlError

    -- Con esto evitamos que dos tomen el mismo número
    --
    exec sp_TalonarioSet @ta_id, @ta_nrodoc
    if @@error <> 0 goto ControlError

    declare @letra varchar(1)
    select @letra = substring(fv_nrodoc,1,1) from FacturaVenta where fv_id = @@fv_id

    set @ta_nrodoc = @letra + substring(@ta_nrodoc,2,100)

    -- Modificamos el numero de comprobante de la factura
    --
    update FacturaVenta set fv_nrodoc = @ta_nrodoc where fv_id = @@fv_id
      
    -- Reestablecemos el talonario de factura de venta
    --    
    update Talonario set ta_ultimonro = ta_ultimonro -1 where ta_id = @@ta_id_factura

  end

  set @@bSuccess = 1

  return

ControlError:
  set @@bErrorMsg = @@bErrorMsg + 'sp_FE_CheckTalonario: Ocurrio un error al actualizar el talonario.'
  set @@bSuccess = 0
  return

end
