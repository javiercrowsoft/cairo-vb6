if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraSave]

/*

 sp_DocFacturaCompraSave 124

*/

go
create procedure sp_DocFacturaCompraSave (
  @@fcTMP_id       int,
  @@bSelect        tinyint = 1,
  @@fc_id          int = 0 out,
  @@bSuccess      tinyint = 0 out
)
as

begin

  set nocount on

  -- Antes que nada valido que este el centro de costo
  --

  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Compras-General',
                        'Exigir Centro Costo',
                        @cfg_valor out,
                        0
  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    if exists(select ccos_id  from FacturaCompraTMP where ccos_id is null and fcTMP_id = @@fcTMP_id)
    begin

      if exists(select ccos_id from FacturaCompraItemTMP where ccos_id is null and fcTMP_id = @@fcTMP_id)
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

      if exists(select ccos_id from FacturaCompraOtroTMP where ccos_id is null and fcTMP_id = @@fcTMP_id)
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item de la solapa "Otros" o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

      if exists(select ccos_id from FacturaCompraPercepcionTMP where ccos_id is null and fcTMP_id = @@fcTMP_id)
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item de percepciones o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

    end
    
  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


  declare @fc_id          int
  declare @fci_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @doct_id        int
  declare  @cpg_id         int
  declare  @fc_total       decimal(18, 6)
  declare  @fc_fecha       datetime 
  declare  @fc_fechaVto     datetime 
  declare @fc_fechaiva    datetime
  declare @doc_mueveStock tinyint
  declare @depl_id        int

-- TO
  declare  @fc_descuento1    decimal(18, 6)
  declare  @fc_descuento2    decimal(18, 6)

  declare  @fc_totalotros            decimal(18, 6)
  declare  @fc_totalpercepciones     decimal(18, 6)

  set @@bSuccess = 0

  -- Si no existe chau
  if not exists (select fcTMP_id from FacturaCompraTMP where fcTMP_id = @@fcTMP_id)
    return

  declare @bSuccess  tinyint
  declare @MsgError  varchar(5000) set @MsgError = ''

  exec sp_DocFacturaCompraValidateDeposito @@fcTMP_id,
                                           @bSuccess out,
                                           @MsgError out
  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  --/////////////////////////////////////////////////////////////////////////////////
  
  select @fc_id = fc_id from FacturaCompraTMP where fcTMP_id = @@fcTMP_id
  
  set @fc_id = isnull(@fc_id,0)
  

  -- La moneda y el talonario siempre salen del documento 
  declare @mon_id         int
  declare @ta_id          int

-- Talonario
  declare  @doc_id         int
  declare  @fc_nrodoc      varchar (50) 
  declare  @prov_id        int

--
  declare  @est_id         int

  select @mon_id           = mon_id,
         @ta_id           = case prov_catfiscal
                              when 1  then ta_id_inscripto   --'Inscripto'
                              when 2  then ta_id_final       --'Exento'
                              when 3  then ta_id_final       --'No inscripto'
                              when 4  then ta_id_final       --'Consumidor Final'
                              when 5  then ta_id_externo     --'Extranjero'
                              when 6  then ta_id_final       --'Mono Tributo'
                              when 7  then ta_id_externo     --'Extranjero Iva'
                              when 8  then ta_id_final       --'No responsable'
                              when 9  then ta_id_final       --'No Responsable exento'
                              when 10 then ta_id_final       --'No categorizado'
                              when 11 then ta_id_inscriptoM  --'Inscripto M'
                              else         -1                --'Sin categorizar'
                           end,
         @doct_id         = Documento.doct_id,
         @cpg_id          = FacturaCompraTMP.cpg_id,
         @fc_total        = FacturaCompraTMP.fc_total,
         @fc_fecha        = FacturaCompraTMP.fc_fecha,
         @fc_fechaVto     = FacturaCompraTMP.fc_fechaVto,
         @fc_fechaiva      = FacturaCompraTMP.fc_fechaiva,
         @depl_id         = FacturaCompraTMP.depl_id,
         @doc_mueveStock  = Documento.doc_muevestock,
-- TO
         @fc_descuento1          = FacturaCompraTMP.fc_descuento1,
         @fc_descuento2          = FacturaCompraTMP.fc_descuento2,
         @fc_totalotros          = fc_totalotros,
         @fc_totalpercepciones   = fc_totalpercepciones,

-- Talonario
         @fc_nrodoc               = fc_nrodoc,
         @doc_id                 = FacturaCompraTMP.doc_id,
         @prov_id                 = FacturaCompraTMP.prov_id,

         @est_id                 = FacturaCompraTMP.est_id

  from FacturaCompraTMP inner join Documento on FacturaCompraTMP.doc_id = Documento.doc_id
                        inner join Proveedor on FacturaCompraTMP.prov_id = Proveedor.prov_id
  where fcTMP_id = @@fcTMP_id

  if @ta_id = -1 begin
    select col1 = 'ERROR', col2 = 'El proveedor no esta categorizado. Debe indicar en que categoria fiscal se encuentra el proveedor.'
    return
  end

-- Campos de las tablas

declare  @fc_numero          int 
declare  @fc_descrip         varchar (5000)
declare  @fc_fechaentrega     datetime 
declare  @fc_neto            decimal(18, 6) 
declare  @fc_ivari           decimal(18, 6)
declare  @fc_ivarni          decimal(18, 6)
declare @fc_internos        decimal(18, 6)
declare  @fc_subtotal        decimal(18, 6)
declare  @fc_totalorigen     decimal(18, 6)
declare @fc_cotizacion      decimal(18, 6)
declare @fc_cotizacionProv  decimal(18, 6)

declare  @fc_pendiente       decimal(18, 6)
declare  @fc_importedesc1    decimal(18, 6)
declare  @fc_importedesc2    decimal(18, 6)
declare @fc_grabarasiento   tinyint
declare @fc_cai             varchar(100)
declare @fc_tipoComprobante tinyint

declare  @suc_id     int
declare  @lp_id      int 
declare  @ld_id      int 
declare  @ccos_id    int
declare @lgj_id     int
declare @pro_id_origen     int
declare @pro_id_destino    int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare @fciTMP_id              int
declare  @fci_orden               smallint 
declare  @fci_cantidad           decimal(18, 6) 
declare  @fci_cantidadaremitir   decimal(18, 6) 
declare  @fci_pendiente           decimal(18, 6) 
declare  @fci_descrip             varchar (5000) 
declare  @fci_precio             decimal(18, 6) 
declare  @fci_precioUsr           decimal(18, 6)
declare  @fci_precioLista         decimal(18, 6)
declare  @fci_descuento           varchar (100) 
declare  @fci_neto               decimal(18, 6) 
declare  @fci_ivari               decimal(18, 6)
declare  @fci_ivarni             decimal(18, 6)
declare  @fci_ivariporc           decimal(18, 6)
declare  @fci_ivarniporc         decimal(18, 6)
declare @fci_internos           decimal(18, 6)
declare @fci_internosporc       decimal(18, 6)
declare @fci_importe             decimal(18, 6)
declare @fci_importeorigen      decimal(18, 6)
declare  @pr_id                   int
declare @stl_id                 int
declare @to_id                  int  -- TO
declare @cue_id                 int
declare @cue_id_ivari           int
declare @cue_id_ivarni          int

--// Condiciones de Pago que generan op automaticamente
--   (Debito Automatico y Fondo Fijo)
--
declare @opg_id       int

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @fc_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'FacturaCompra','fc_id',@fc_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'FacturaCompra','fc_numero',@fc_numero out, 0
    if @@error <> 0 goto ControlError

    -- //////////////////////////////////////////////////////////////////////////////////
    --
    -- Talonario
    --
          declare @ta_propuesto tinyint
          declare @ta_tipo      smallint
      
          exec sp_talonarioGetPropuesto @doc_id, 0, @ta_propuesto out, 0, @prov_id, @ta_id out, @ta_tipo out
          if @@error <> 0 goto ControlError
      
          if @ta_propuesto = 0 begin
      
            if @ta_tipo = 3 /*Auto Impresor*/ begin

              declare @ta_nrodoc varchar(100)

              exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
              if @@error <> 0 goto ControlError

              -- Con esto evitamos que dos tomen el mismo número
              --
              exec sp_TalonarioSet @ta_id, @ta_nrodoc
              if @@error <> 0 goto ControlError

              set @fc_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into FacturaCompra (
                              fc_id,
                              fc_numero,
                              fc_nrodoc,
                              fc_descrip,
                              fc_fecha,
                              fc_fechaentrega,
                              fc_fechaVto,
                              fc_fechaiva,
                              fc_neto,
                              fc_ivari,
                              fc_ivarni,
                              fc_internos,
                              fc_total,
                              fc_totalorigen,
                              fc_subtotal,
                              fc_totalotros,
                              fc_totalpercepciones,
                              fc_descuento1,
                              fc_descuento2,
                              fc_importedesc1,
                              fc_importedesc2,
                              fc_grabarasiento,
                              fc_cotizacion,
                              fc_cotizacionprov,
                              fc_cai,
                              fc_tipocomprobante,
                              mon_id,
                              est_id,
                              suc_id,
                              prov_id,
                              doc_id,
                              doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              pro_id_origen,
                              pro_id_destino,
                              modifico
                            )
      select
                              @fc_id,
                              @fc_numero,
                              @fc_nrodoc,
                              fc_descrip,
                              fc_fecha,
                              fc_fechaentrega,
                              fc_fechaVto,
                              fc_fechaiva,
                              fc_neto,
                              fc_ivari,
                              fc_ivarni,
                              fc_internos,
                              fc_total,
                              fc_totalorigen,
                              fc_subtotal,
                              fc_totalotros,
                              fc_totalpercepciones,
                              fc_descuento1,
                              fc_descuento2,
                              fc_importedesc1,
                              fc_importedesc2,
                              fc_grabarasiento,
                              fc_cotizacion,
                              fc_cotizacionProv,
                              fc_cai,
                              fc_tipocomprobante,
                              @mon_id,
                              est_id,
                              suc_id,
                              prov_id,
                              doc_id,
                              @doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              pro_id_origen,
                              pro_id_destino,
                              modifico
      from FacturaCompraTMP
      where fcTMP_id = @@fcTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @fc_nrodoc = fc_nrodoc from FacturaCompra where fc_id = @fc_id
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        UPDATE                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  else begin

    set @IsNew = 0

    select
                              @fc_id                   = fc_id,
                              @fc_nrodoc              = fc_nrodoc,
                              @fc_descrip              = fc_descrip,
                              @fc_fechaentrega        = fc_fechaentrega,
                              @fc_neto                = fc_neto,
                              @fc_ivari                = fc_ivari,
                              @fc_ivarni              = fc_ivarni,
                              @fc_internos            = fc_internos,
                              @fc_totalorigen          = fc_totalorigen,
                              @fc_cotizacion          = fc_cotizacion,
                              @fc_cotizacionProv      = fc_cotizacionProv,
                              @fc_descuento1          = fc_descuento1,
                              @fc_descuento2          = fc_descuento2,
                              @fc_subtotal            = fc_subtotal,
                              @fc_importedesc1        = fc_importedesc1,
                              @fc_importedesc2        = fc_importedesc2,
                              @fc_grabarasiento       = fc_grabarasiento,
                              @fc_cai                  = fc_cai,
                              @fc_tipocomprobante     = fc_tipocomprobante,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @prov_id                = prov_id,
                              @doc_id                  = doc_id,
                              @lp_id                  = lp_id,
                              @ld_id                  = ld_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                 = lgj_id,
                              @pro_id_origen          = pro_id_origen,
                              @pro_id_destino          = pro_id_destino,
                              @modifico                = modifico,
                              @modificado             = modificado
    from FacturaCompraTMP 
    where 
          fcTMP_id = @@fcTMP_id

    /*
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                                    //
    //                          GENERACION AUTOMATICA DE ORDEN DE PAGO                                                    //
    //                                                                                                                    //
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    
        /*
            Si la condicion de pago de la factura es de tipo [Debito Automatico] o [Fondo Fijo]
            debo generar una orden de pago automaticamente.
            Para esto tengo que sacar de la condicion de pago el documento y la cuenta contable
            de los fondos pasando por la cuenta grupo asociada a dicha condicion de pago.
        */

        -- tengo que desaplicar la orden de pago para poder regenerar la deuda

        select @opg_id = opg_id from FacturaCompra where fc_id = @fc_id

        if @opg_id is not null begin

          delete FacturaCompraOrdenPago where fc_id = @fc_id
          if @@error <> 0 goto ControlError

          update FacturaCompra set opg_id = null where fc_id = @fc_id
          if @@error <> 0 goto ControlError

          update OrdenPago set fc_id = null where fc_id = @fc_id
          if @@error <> 0 goto ControlError

          declare @emp_id int

          select @emp_id = emp_id from OrdenPago where opg_id = @opg_id

          exec sp_DocOrdenPagoDelete    @opg_id,
                                        @emp_id,
                                        @modifico,
                                        @@bSuccess out,
                                        @MsgError out
          if @@bSuccess = 0 goto ControlError

          delete FacturaCompraDeuda where fc_id = @fc_id
          if @@error <> 0 goto ControlError

          delete FacturaCompraPago where fc_id = @fc_id
          if @@error <> 0 goto ControlError

        end

    --///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
    update FacturaCompra set 
                              fc_nrodoc              = @fc_nrodoc,
                              fc_descrip            = @fc_descrip,
                              fc_fecha              = @fc_fecha,
                              fc_fechaentrega        = @fc_fechaentrega,
                              fc_fechaVto            = @fc_fechaVto,
                              fc_fechaiva            = @fc_fechaiva,
                              fc_neto                = @fc_neto,
                              fc_ivari              = @fc_ivari,
                              fc_ivarni              = @fc_ivarni,
                              fc_internos            = @fc_internos,
                              fc_total              = @fc_total,
                              fc_totalorigen        = @fc_totalorigen,
                              fc_totalotros          = @fc_totalotros,
                              fc_totalpercepciones  = @fc_totalpercepciones,
                              fc_cotizacion         = @fc_cotizacion,
                              fc_cotizacionprov     = @fc_cotizacionprov,
                              fc_descuento1         = @fc_descuento1,
                              fc_descuento2         = @fc_descuento2,
                              fc_subtotal            = @fc_subtotal,
                              fc_importedesc1       = @fc_importedesc1,
                              fc_importedesc2       = @fc_importedesc2,
                              fc_grabarasiento      = @fc_grabarasiento,
                              fc_cai                = @fc_cai,
                              fc_tipocomprobante    = @fc_tipocomprobante,
                              mon_id                = @mon_id,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              prov_id                = @prov_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lp_id                  = @lp_id,
                              ld_id                  = @ld_id,
                              cpg_id                = @cpg_id,
                              lgj_id                = @lgj_id,
                              pro_id_origen          = @pro_id_origen,
                              pro_id_destino        = @pro_id_destino,
                              ccos_id                = @ccos_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where fc_id = @fc_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  set @orden = 1
  while exists(select fci_orden from FacturaCompraItemTMP where fcTMP_id = @@fcTMP_id and fci_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @fciTMP_id                  = fciTMP_id,
            @fci_id                      = fci_id,
            @fci_orden                  = fci_orden,
            @fci_cantidad                = fci_cantidad,
            @fci_cantidadaremitir        = fci_cantidadaremitir,
            @fci_pendiente              = fci_pendiente,
            @fci_descrip                = fci_descrip,
            @fci_precio                  = fci_precio,
            @fci_precioUsr              = fci_precioUsr,
            @fci_precioLista            = fci_precioLista,
            @fci_descuento              = fci_descuento,
            @fci_neto                    = fci_neto,
            @fci_ivari                  = fci_ivari,
            @fci_ivarni                  = fci_ivarni,
            @fci_ivariporc              = fci_ivariporc,
            @fci_ivarniporc              = fci_ivarniporc,
            @fci_internos               = fci_internos,
            @fci_internosporc           = fci_internosporc,
            @fci_importe                = fci_importe,
            @fci_importeorigen          = fci_importeorigen,
            @pr_id                      = pr_id,
            @to_id                      = to_id, -- TO
            @ccos_id                    = ccos_id,
            @cue_id                     = cue_id,
            @cue_id_ivari               = cue_id_ivari,
            @cue_id_ivarni              = cue_id_ivarni,
            @stl_id                      = stl_id

    from FacturaCompraItemTMP where fcTMP_id = @@fcTMP_id and fci_orden = @orden

    -- Cuando se inserta se indica 
    -- como cantidad a remitir la cantidad (Por ahora)
    set @fci_cantidadaremitir = @fci_cantidad

    if @IsNew <> 0 or @fci_id = 0 begin

        -- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
        set @fci_pendiente           = @fci_cantidadaremitir

        exec SP_DBGetNewId 'FacturaCompraItem','fci_id',@fci_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into FacturaCompraItem (
                                      fc_id,
                                      fci_id,
                                      fci_orden,
                                      fci_cantidad,
                                      fci_cantidadaremitir,
                                      fci_descrip,
                                      fci_pendiente,
                                      fci_precio,
                                      fci_precioUsr,
                                      fci_precioLista,
                                      fci_descuento,
                                      fci_neto,
                                      fci_ivari,
                                      fci_ivarni,
                                      fci_ivariporc,
                                      fci_ivarniporc,
                                      fci_internos,
                                      fci_internosporc,
                                      fci_importe,
                                      fci_importeorigen,
                                      pr_id,
                                      to_id, -- TO
                                      ccos_id,
                                      cue_id,
                                      cue_id_ivari,
                                      cue_id_ivarni,
                                      stl_id
                                )
                            Values(
                                      @fc_id,
                                      @fci_id,
                                      @fci_orden,
                                      @fci_cantidad,
                                      @fci_cantidadaremitir,
                                      @fci_descrip,
                                      @fci_pendiente,
                                      @fci_precio,
                                      @fci_precioUsr,
                                      @fci_precioLista,
                                      @fci_descuento,
                                      @fci_neto,
                                      @fci_ivari,
                                      @fci_ivarni,
                                      @fci_ivariporc,
                                      @fci_ivarniporc,
                                      @fci_internos,
                                      @fci_internosporc,
                                      @fci_importe,
                                      @fci_importeorigen,
                                      @pr_id,
                                      @to_id, -- TO
                                      @ccos_id,
                                      @cue_id,
                                      @cue_id_ivari,
                                      @cue_id_ivarni,
                                      @stl_id
                                )

        if @@error <> 0 goto ControlError

        update FacturaCompraItemTMP set fci_id = @fci_id where fcTMP_id = @@fcTMP_id and fciTMP_id = @fciTMP_id and fci_orden = @orden
        if @@error <> 0 goto ControlError

        update FacturaCompraItemSerieTMP set fci_id = @fci_id where fcTMP_id = @@fcTMP_id and fciTMP_id = @fciTMP_id 
        if @@error <> 0 goto ControlError

    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

          -- Cuando se actualiza se indica 
          -- como pendiente la cantidad a remitir menos lo aplicado
          select @fci_pendiente = sum(ocfc_cantidad) from OrdenFacturaCompra where fci_id = @fci_id
          set @fci_pendiente = @fci_cantidadaremitir - isnull(@fci_pendiente,0)

          update FacturaCompraItem set

                  fc_id                      = @fc_id,
                  fci_orden                  = @fci_orden,
                  fci_cantidad              = @fci_cantidad,
                  fci_cantidadaremitir      = @fci_cantidadaremitir,
                  fci_pendiente              = @fci_pendiente,
                  fci_descrip                = @fci_descrip,
                  fci_precio                = @fci_precio,
                  fci_precioUsr              = @fci_precioUsr,
                  fci_precioLista            = @fci_precioLista,
                  fci_descuento              = @fci_descuento,
                  fci_neto                  = @fci_neto,
                  fci_ivari                  = @fci_ivari,
                  fci_ivarni                = @fci_ivarni,
                  fci_ivariporc              = @fci_ivariporc,
                  fci_ivarniporc            = @fci_ivarniporc,
                  fci_internos              = @fci_internos,
                  fci_internosporc          = @fci_internosporc,
                  fci_importe                = @fci_importe,
                  fci_importeorigen          = @fci_importeorigen,
                  pr_id                      = @pr_id,
                  to_id                      = @to_id, -- TO
                  ccos_id                    = @ccos_id,
                  cue_id                    = @cue_id,
                  cue_id_ivari              = @cue_id_ivari,
                  cue_id_ivarni             = @cue_id_ivarni,
                  stl_id                    = @stl_id

        where fc_id = @fc_id and fci_id = @fci_id 
        if @@error <> 0 goto ControlError

        update FacturaCompraItemTMP set fci_id = @fci_id where fcTMP_id = @@fcTMP_id and fciTMP_id = @fciTMP_id and fci_orden = @orden
        if @@error <> 0 goto ControlError

        update FacturaCompraItemSerieTMP set fci_id = @fci_id where fcTMP_id = @@fcTMP_id and fciTMP_id = @fciTMP_id 
        if @@error <> 0 goto ControlError

    end -- Update

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        OTROS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @fcot_id           int
  declare @fcot_orden        smallint
  declare @fcot_debe         decimal(18,6)
   declare @fcot_haber        decimal(18,6)
  declare @fcot_origen      decimal(18,6)
  declare @fcot_descrip     varchar(255)

  set @orden = 1
  while exists(select fcot_orden from FacturaCompraOtroTMP where fcTMP_id = @@fcTMP_id and fcot_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @fcot_id                      = fcot_id,
            @fcot_orden                    = fcot_orden,
            @fcot_debe                    = fcot_debe,
            @fcot_haber                    = fcot_haber,
            @fcot_origen                  = fcot_origen,
            @fcot_descrip                  = fcot_descrip,
            @cue_id                       = cue_id,
            @ccos_id                      = ccos_id

    from FacturaCompraOtroTMP where fcTMP_id = @@fcTMP_id and fcot_orden = @orden

    if @IsNew <> 0 or @fcot_id = 0 begin

        exec SP_DBGetNewId 'FacturaCompraOtro','fcot_id',@fcot_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into FacturaCompraOtro (
                                      fc_id,
                                      fcot_id,
                                      fcot_orden,
                                      fcot_debe,
                                      fcot_haber,
                                      fcot_origen,
                                      fcot_descrip,
                                      cue_id,
                                      ccos_id
                                )
                            Values(
                                      @fc_id,
                                      @fcot_id,
                                      @fcot_orden,
                                      @fcot_debe,
                                      @fcot_haber,
                                      @fcot_origen,
                                      @fcot_descrip,
                                      @cue_id,
                                      @ccos_id
                                )

        if @@error <> 0 goto ControlError
    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

          update FacturaCompraOtro set

                  fc_id                          = @fc_id,
                  fcot_orden                    = @fcot_orden,
                  fcot_debe                      = @fcot_debe,
                  fcot_haber                    = @fcot_haber,
                  fcot_origen                   = @fcot_origen,
                  fcot_descrip                  = @fcot_descrip,
                  cue_id                         = @cue_id,
                  ccos_id                        = @ccos_id

        where fc_id = @fc_id and fcot_id = @fcot_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        PERCEPCIONES                                                                //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @fcperc_id           int
  declare @fcperc_orden        smallint
  declare @fcperc_base         decimal(18,6)
   declare @fcperc_porcentaje  decimal(18,6)
   declare @fcperc_importe      decimal(18,6)
  declare @fcperc_origen      decimal(18,6)
  declare @fcperc_descrip     varchar(255)
  declare @perc_id            int

  set @orden = 1
  while exists(select fcperc_orden from FacturaCompraPercepcionTMP where fcTMP_id = @@fcTMP_id and fcperc_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @fcperc_id                      = fcperc_id,
            @fcperc_orden                    = fcperc_orden,
            @fcperc_base                    = fcperc_base,
            @fcperc_porcentaje              = fcperc_porcentaje,
            @fcperc_importe                 = fcperc_importe,
            @fcperc_origen                  = fcperc_origen,
            @fcperc_descrip                  = fcperc_descrip,
            @perc_id                         = perc_id,
            @ccos_id                        = ccos_id

    from FacturaCompraPercepcionTMP where fcTMP_id = @@fcTMP_id and fcperc_orden = @orden

    if @IsNew <> 0 or @fcperc_id = 0 begin

        exec SP_DBGetNewId 'FacturaCompraPercepcion','fcperc_id',@fcperc_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into FacturaCompraPercepcion (
                                      fc_id,
                                      fcperc_id,
                                      fcperc_orden,
                                      fcperc_base,
                                      fcperc_porcentaje,
                                      fcperc_importe,
                                      fcperc_origen,
                                      fcperc_descrip,
                                      perc_id,
                                      ccos_id
                                )
                            Values(
                                      @fc_id,
                                      @fcperc_id,
                                      @fcperc_orden,
                                      @fcperc_base,
                                      @fcperc_porcentaje,
                                      @fcperc_importe,
                                      @fcperc_origen,
                                      @fcperc_descrip,
                                      @perc_id,
                                      @ccos_id
                                )

        if @@error <> 0 goto ControlError
    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

          update FacturaCompraPercepcion set

                  fc_id                            = @fc_id,
                  fcperc_orden                    = @fcperc_orden,
                  fcperc_base                      = @fcperc_base,
                  fcperc_porcentaje                = @fcperc_porcentaje,
                  fcperc_importe                  = @fcperc_importe,
                  fcperc_origen                   = @fcperc_origen,
                  fcperc_descrip                  = @fcperc_descrip,
                  perc_id                         = @perc_id,
                  ccos_id                          = @ccos_id

        where fc_id = @fc_id and fcperc_id = @fcperc_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        LEGAJOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @fclgj_id              int
  declare @fclgj_orden           smallint
  declare @fclgj_importe         decimal(18,6)
  declare @fclgj_importeorigen  decimal(18,6)
  declare @fclgj_descrip         varchar(255)

  set @orden = 1
  while exists(select fclgj_orden from FacturaCompraLegajoTMP where fcTMP_id = @@fcTMP_id and fclgj_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @fclgj_id                      = fclgj_id,
            @fclgj_orden                  = fclgj_orden,
            @fclgj_importe                = fclgj_importe,
            @fclgj_importeorigen          = fclgj_importeorigen,
            @fclgj_descrip                = fclgj_descrip,
            @lgj_id                       = lgj_id

    from FacturaCompraLegajoTMP where fcTMP_id = @@fcTMP_id and fclgj_orden = @orden

    if @IsNew <> 0 or @fclgj_id = 0 begin

        exec SP_DBGetNewId 'FacturaCompraLegajo','fclgj_id',@fclgj_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into FacturaCompraLegajo (
                                      fc_id,
                                      fclgj_id,
                                      fclgj_orden,
                                      fclgj_importe,
                                      fclgj_importeorigen,
                                      fclgj_descrip,
                                      lgj_id
                                )
                            Values(
                                      @fc_id,
                                      @fclgj_id,
                                      @fclgj_orden,
                                      @fclgj_importe,
                                      @fclgj_importeorigen,
                                      @fclgj_descrip,
                                      @lgj_id
                                )

        if @@error <> 0 goto ControlError
    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

          update FacturaCompraLegajo set

                  fc_id                          = @fc_id,
                  fclgj_orden                    = @fclgj_orden,
                  fclgj_importe                 = @fclgj_importe,
                  fclgj_importeorigen            = @fclgj_importeorigen,
                  fclgj_descrip                 = @fclgj_descrip,
                  lgj_id                         = @lgj_id

        where fc_id = @fc_id and fclgj_id = @fclgj_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ITEMS BORRADOS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar los items borrados del orden
  if @IsNew = 0 begin
    
    delete FacturaCompraItem 
            where exists (select fci_id 
                          from FacturaCompraItemBorradoTMP 
                          where fc_id = @fc_id 
                            and fci_id = FacturaCompraItem.fci_id
                            and fcTMP_id = @@fcTMP_id)
    if @@error <> 0 goto ControlError

    -----------------------------------------------------------------------------------------
    delete FacturaCompraOtro
            where exists (select fcot_id 
                          from FacturaCompraOtroBorradoTMP 
                          where fc_id = @fc_id 
                            and fcot_id = FacturaCompraOtro.fcot_id
                            and fcTMP_id = @@fcTMP_id)
    if @@error <> 0 goto ControlError

    delete FacturaCompraOtroBorradoTMP where fc_id = @fc_id and fcTMP_id = @@fcTMP_id

    -----------------------------------------------------------------------------------------
    delete FacturaCompraPercepcion
            where exists (select fcperc_id 
                          from FacturaCompraPercepcionBorradoTMP 
                          where fc_id = @fc_id 
                            and fcperc_id = FacturaCompraPercepcion.fcperc_id
                            and fcTMP_id = @@fcTMP_id)
    if @@error <> 0 goto ControlError

    delete FacturaCompraPercepcionBorradoTMP where fc_id = @fc_id and fcTMP_id = @@fcTMP_id

    -----------------------------------------------------------------------------------------
    delete FacturaCompraLegajo
            where exists (select fclgj_id 
                          from FacturaCompraLegajoBorradoTMP 
                          where fc_id = @fc_id 
                            and fclgj_id = FacturaCompraLegajo.fclgj_id
                            and fcTMP_id = @@fcTMP_id)
    if @@error <> 0 goto ControlError

    delete FacturaCompraLegajoBorradoTMP where fc_id = @fc_id and fcTMP_id = @@fcTMP_id
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     PAGO EN CTA CTE Y CONTADO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- TO
  declare @fc_totaldeuda decimal(18,6)

  select @fc_totaldeuda = sum(fci_importe) 
  from FacturaCompraItem fci inner join TipoOperacion t on fci.to_id = t.to_id
  where fc_id = @fc_id 
    and to_generadeuda <> 0

  if @fc_totaldeuda is null begin

    set @fc_totaldeuda = 0

  end else begin

    set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento1) / 100)
    set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento2) / 100)
    set @fc_totaldeuda = @fc_totaldeuda + @fc_totalotros + @fc_totalpercepciones

  end

  exec sp_DocFacturaCompraSaveDeuda       
                                    @fc_id,
                                    @cpg_id,
                                    @fc_fecha,
                                    @fc_fechaVto,
                                    @fc_totaldeuda,
                                    @est_id,
                                    @bSuccess  out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION ORDEN - REMITO                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaCpraOrdenRemitoSaveAplic @fc_id, @@fcTMP_id, 0, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_TalonarioSet @ta_id,@fc_nrodoc
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     CREDITO Y ESTADO                                                               //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaCompraSetPendiente @fc_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  exec sp_DocFacturaCompraSetCredito @fc_id
  if @@error <> 0 goto ControlError

  exec sp_DocFacturaCompraSetEstado @fc_id
  if @@error <> 0 goto ControlError
  
  declare @bError    smallint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  set @cfg_valor = null
  exec sp_Cfg_GetValor  'Compras-General',
                        'Grabar Asiento',
                        @cfg_valor out,
                        0
  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    exec sp_DocFacturaCompraAsientoSave @fc_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

  end else begin

    if not exists (select fc_id from FacturaCompraAsiento where fc_id = @fc_id) begin
      insert into FacturaCompraAsiento (fc_id,fc_fecha) 
             select fc_id,fc_fecha from FacturaCompra 
              where fc_grabarAsiento <> 0 and fc_id = @fc_id
    end
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     STOCK                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if IsNull(@doc_mueveStock,0) <> 0 begin

    exec sp_DocFacturaCompraStockSave @@fcTMP_id, @fc_id, @depl_id, 0, @bError out, @MsgError out

    -- Si fallo al guardar
    if @bError <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                          TOTAL COMERCIAL - NECESARIO PARA LOS REPORTES DE CTA CTE                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
    update facturacompra 
    set fc_totalcomercial = IsNull(@fc_totaldeuda,0)
    where fc_id = @fc_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                          GENERACION AUTOMATICA DE ORDEN DE PAGO                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
    exec sp_DocFacturaCompraOrdenPagoSave @fc_id,   
                                          @@bSuccess out,
                                          @MsgError out
    -- Si fallo al guardar
    if @@bSuccess = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocFC    @fc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- STOCK
  exec sp_AuditoriaStockCheckDocFC    @fc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocFC  @fc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- VTOS
  exec sp_AuditoriaVtoCheckDocFC      @fc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
  exec sp_AuditoriaCreditoCheckDocFC  @fc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete RemitoFacturaCompraTMP where fcTMP_ID = @@fcTMP_ID
  delete OrdenFacturaCompraTMP where fcTMP_ID = @@fcTMP_ID
  delete FacturaCompraItemSerieTMP where fcTMP_id = @@fcTMP_id
  delete FacturaCompraPercepcionTMP where fcTMP_id = @@fcTMP_id
  delete FacturaCompraLegajoTMP where fcTMP_id = @@fcTMP_id
  delete FacturaCompraOtroTMP where fcTMP_id = @@fcTMP_id
  delete FacturaCompraItemTMP where fcTMP_id = @@fcTMP_id
  delete FacturaCompraItemSerieBTMP where fcTMP_id = @@fcTMP_id

  /*OJO: Esta aca y no en el if (if @IsNew = 0 begin)
         como estaba antes, por que necesito usar
         los registros de esta tabla en 
         sp_DocRemitoCompraStockSave para borrar los 
         numeros de serie asociados al rénglon
  */
  delete FacturaCompraItemBorradoTMP where fc_id = @fc_id 
                                       and fcTMP_id = @@fcTMP_id
  delete FacturaCompraTMP where fcTMP_id = @@fcTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from FacturaCompra where fc_id = @fc_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 17001, @fc_id, @modifico, 1
  else           exec sp_HistoriaUpdate 17001, @fc_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  commit transaction

  set @@fc_id = @fc_id
  set @@bSuccess = 1

  if @@bSelect <> 0 select @fc_id

  exec sp_ListaPrecioSaveAuto @fc_id, @doct_id, @IsNew, @fc_fecha

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la factura de compra. sp_DocFacturaCompraSave. ' + @MsgError
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end
