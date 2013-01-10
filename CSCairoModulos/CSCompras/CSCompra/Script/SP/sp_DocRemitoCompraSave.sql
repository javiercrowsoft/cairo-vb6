if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraSave]

/*

 sp_DocRemitoCompraSave 93

*/

go
create procedure sp_DocRemitoCompraSave (
  @@rcTMP_id           int,
  @@bSelect            tinyint = 1,
  @@rc_id              int     = 0 out,
  @@bSuccess          tinyint = 0 out,
  @@bDontRaiseError    tinyint = 0,
  @@MsgError          varchar(5000) = '' out
)
as

begin

  set nocount on

  declare @rc_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @doct_id        int
  declare  @rc_fecha       datetime 

  set @@bSuccess = 0

  -- Si no existe chau
  if not exists (select rcTMP_id from RemitoCompraTMP where rcTMP_id = @@rcTMP_id)
    return

  declare @bSuccess  tinyint
  declare @MsgError  varchar(5000) set @MsgError = ''

  exec sp_DocRemitoCompraValidateDeposito @@rcTMP_id,
                                          @bSuccess  out,
                                          @MsgError out
  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- Talonario
  declare  @doc_id     int
  declare  @rc_nrodoc  varchar (50) 
  
  select   @rc_id    = rc_id, 
          @doct_id  = doct_id,
          @rc_fecha  = rc_fecha,

-- Talonario
         @rc_nrodoc  = rc_nrodoc,
         @doc_id    = RemitoCompraTMP.doc_id

    from 
        RemitoCompraTMP inner join Documento on RemitoCompraTMP.doc_id = Documento.doc_id

    where rcTMP_id = @@rcTMP_id
  
  set @rc_id = isnull(@rc_id,0)
  

-- Campos de las tablas

declare  @rc_numero  int 
declare  @rc_descrip varchar (5000)
declare  @rc_fechaentrega datetime 
declare  @rc_neto      decimal(18, 6) 
declare  @rc_ivari     decimal(18, 6)
declare  @rc_ivarni    decimal(18, 6)
declare  @rc_total     decimal(18, 6)
declare  @rc_subtotal  decimal(18, 6)
declare  @rc_pendiente decimal(18, 6)
declare  @rc_descuento1    decimal(18, 6)
declare  @rc_descuento2    decimal(18, 6)
declare  @rc_importedesc1  decimal(18, 6)
declare  @rc_importedesc2  decimal(18, 6)
declare  @rc_cotizacion    decimal(18, 6)

declare  @est_id     int
declare  @suc_id     int
declare  @prov_id    int
declare @ta_id      int
declare  @lp_id      int 
declare  @ld_id      int 
declare  @cpg_id     int
declare  @ccos_id    int
declare @lgj_id     int
declare  @modificado datetime 
declare  @modifico   int 

declare @rci_id                  int
declare @rciTMP_id              int
declare  @rci_orden               smallint 
declare  @rci_cantidad           decimal(18, 6) 
declare  @rci_cantidadaremitir   decimal(18, 6) 
declare  @rci_pendiente           decimal(18, 6) 
declare @rci_pendientefac        decimal(18, 6)
declare  @rci_descrip             varchar (5000) 
declare  @rci_precio             decimal(18, 6) 
declare  @rci_precioUsr           decimal(18, 6)
declare  @rci_precioLista         decimal(18, 6)
declare  @rci_descuento           varchar (100) 
declare  @rci_neto               decimal(18, 6) 
declare  @rci_ivari               decimal(18, 6)
declare  @rci_ivarni             decimal(18, 6)
declare  @rci_ivariporc           decimal(18, 6)
declare  @rci_ivarniporc         decimal(18, 6)
declare @rci_importe             decimal(18, 6)
declare  @pr_id                   int
declare @stl_id                 int

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @rc_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'RemitoCompra','rc_id',@rc_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'RemitoCompra','rc_numero',@rc_numero out, 0
    if @@error <> 0 goto ControlError

    -- //////////////////////////////////////////////////////////////////////////////////
    --
    -- Talonario
    --
          declare @ta_propuesto tinyint
          declare @ta_tipo      smallint
      
          exec sp_talonarioGetPropuesto @doc_id, 0, @ta_propuesto out, 0, 0, @ta_id out, @ta_tipo out
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

              set @rc_nrodoc = @ta_nrodoc

            end

          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into RemitoCompra (
                              rc_id,
                              rc_numero,
                              rc_nrodoc,
                              rc_descrip,
                              rc_fecha,
                              rc_fechaentrega,
                              rc_neto,
                              rc_ivari,
                              rc_ivarni,
                              rc_total,
                              rc_subtotal,
                              rc_descuento1,
                              rc_descuento2,
                              rc_importedesc1,
                              rc_importedesc2,
                              rc_cotizacion,
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
                              modifico
                            )
      select
                              @rc_id,
                              @rc_numero,
                              @rc_nrodoc,
                              rc_descrip,
                              rc_fecha,
                              rc_fechaentrega,
                              rc_neto,
                              rc_ivari,
                              rc_ivarni,
                              rc_total,
                              rc_subtotal,
                              rc_descuento1,
                              rc_descuento2,
                              rc_importedesc1,
                              rc_importedesc2,
                              rc_cotizacion,
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
                              modifico
      from RemitoCompraTMP
      where rcTMP_id = @@rcTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @rc_nrodoc = rc_nrodoc from RemitoCompra where rc_id = @rc_id
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
                              @rc_id                   = rc_id,
                              @rc_nrodoc              = rc_nrodoc,
                              @rc_descrip              = rc_descrip,
                              @rc_fechaentrega        = rc_fechaentrega,
                              @rc_neto                = rc_neto,
                              @rc_ivari                = rc_ivari,
                              @rc_ivarni              = rc_ivarni,
                              @rc_total                = rc_total,
                              @rc_descuento1          = rc_descuento1,
                              @rc_descuento2          = rc_descuento2,
                              @rc_subtotal            = rc_subtotal,
                              @rc_importedesc1        = rc_importedesc1,
                              @rc_importedesc2        = rc_importedesc2,
                              @rc_cotizacion          = rc_cotizacion,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @prov_id                = prov_id,
                              @doc_id                  = doc_id,
                              @lp_id                  = lp_id,
                              @ld_id                  = ld_id,
                              @cpg_id                  = cpg_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                  = lgj_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from RemitoCompraTMP 
    where 
          rcTMP_id = @@rcTMP_id
  
    update RemitoCompra set 
                              rc_nrodoc              = @rc_nrodoc,
                              rc_descrip            = @rc_descrip,
                              rc_fecha              = @rc_fecha,
                              rc_fechaentrega        = @rc_fechaentrega,
                              rc_neto                = @rc_neto,
                              rc_ivari              = @rc_ivari,
                              rc_ivarni              = @rc_ivarni,
                              rc_total              = @rc_total,
                              rc_descuento1         = @rc_descuento1,
                              rc_descuento2         = @rc_descuento2,
                              rc_subtotal            = @rc_subtotal,
                              rc_importedesc1       = @rc_importedesc1,
                              rc_importedesc2       = @rc_importedesc2,
                              rc_cotizacion          = @rc_cotizacion,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              prov_id                = @prov_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lp_id                  = @lp_id,
                              ld_id                  = @ld_id,
                              cpg_id                = @cpg_id,
                              ccos_id                = @ccos_id,
                              lgj_id                = @lgj_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where rc_id = @rc_id
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
  while exists(select rci_orden from RemitoCompraItemTMP where rcTMP_id = @@rcTMP_id and rci_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @rciTMP_id                  = rciTMP_id,
            @rci_id                      = rci_id,
            @rci_orden                  = rci_orden,
            @rci_cantidad                = rci_cantidad,
            @rci_cantidadaremitir        = rci_cantidadaremitir,
            @rci_pendiente              = rci_pendiente,
            @rci_pendientefac            = rci_pendientefac,
            @rci_descrip                = rci_descrip,
            @rci_precio                  = rci_precio,
            @rci_precioUsr              = rci_precioUsr,
            @rci_precioLista            = rci_precioLista,
            @rci_descuento              = rci_descuento,
            @rci_neto                    = rci_neto,
            @rci_ivari                  = rci_ivari,
            @rci_ivarni                  = rci_ivarni,
            @rci_ivariporc              = rci_ivariporc,
            @rci_ivarniporc              = rci_ivarniporc,
            @rci_importe                = rci_importe,
            @pr_id                      = pr_id,
            @ccos_id                    = ccos_id,
            @stl_id                      = stl_id

    from RemitoCompraItemTMP where rcTMP_id = @@rcTMP_id and rci_orden = @orden

    -- Cuando se inserta se indica 
    -- como cantidad a remitir la cantidad (Por ahora)
    set @rci_cantidadaremitir = @rci_cantidad

    if @IsNew <> 0 or @rci_id = 0 begin

        -- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
        set @rci_pendiente     = @rci_cantidadaremitir
        set @rci_pendientefac = @rci_cantidadaremitir

        exec SP_DBGetNewId 'RemitoCompraItem','rci_id',@rci_id out, 0
        if @@error <> 0 goto ControlError

        insert into RemitoCompraItem (
                                      rc_id,
                                      rci_id,
                                      rci_orden,
                                      rci_cantidad,
                                      rci_cantidadaremitir,
                                      rci_pendiente,
                                      rci_pendientefac,
                                      rci_descrip,
                                      rci_precio,
                                      rci_precioUsr,
                                      rci_precioLista,
                                      rci_descuento,
                                      rci_neto,
                                      rci_ivari,
                                      rci_ivarni,
                                      rci_ivariporc,
                                      rci_ivarniporc,
                                      rci_importe,
                                      pr_id,
                                      ccos_id,
                                      stl_id
                                )
                            Values(
                                      @rc_id,
                                      @rci_id,
                                      @rci_orden,
                                      @rci_cantidad,
                                      @rci_cantidadaremitir,
                                      @rci_pendiente,
                                      @rci_pendientefac,
                                      @rci_descrip,
                                      @rci_precio,
                                      @rci_precioUsr,
                                      @rci_precioLista,
                                      @rci_descuento,
                                      @rci_neto,
                                      @rci_ivari,
                                      @rci_ivarni,
                                      @rci_ivariporc,
                                      @rci_ivarniporc,
                                      @rci_importe,
                                      @pr_id,
                                      @ccos_id,
                                      @stl_id
                                )

        if @@error <> 0 goto ControlError

        update RemitoCompraItemTMP set rci_id = @rci_id where rciTMP_id = @rciTMP_id and rci_orden = @orden
        if @@error <> 0 goto ControlError

        update RemitoCompraItemSerieTMP set rci_id = @rci_id where rciTMP_id = @rciTMP_id 
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
          select @rci_pendiente = sum(ocrc_cantidad) from OrdenRemitoCompra where rci_id = @rci_id
          set @rci_pendiente = @rci_cantidadaremitir - isnull(@rci_pendiente,0)

          -- Cuando se actualiza se indica 
          -- como pendiente la cantidad a remitir menos lo aplicado
          select @rci_pendientefac = sum(rcfc_cantidad) from RemitoFacturaCompra where rci_id = @rci_id
          set @rci_pendientefac = @rci_cantidadaremitir - isnull(@rci_pendientefac,0)

          update RemitoCompraItem set

                  rc_id                      = @rc_id,
                  rci_orden                  = @rci_orden,
                  rci_cantidad              = @rci_cantidad,
                  rci_cantidadaremitir      = @rci_cantidadaremitir,
                  rci_pendiente              = @rci_pendiente,
                  rci_pendientefac          = @rci_pendientefac,
                  rci_descrip                = @rci_descrip,
                  rci_precio                = @rci_precio,
                  rci_precioUsr              = @rci_precioUsr,
                  rci_precioLista            = @rci_precioLista,
                  rci_descuento              = @rci_descuento,
                  rci_neto                  = @rci_neto,
                  rci_ivari                  = @rci_ivari,
                  rci_ivarni                = @rci_ivarni,
                  rci_ivariporc              = @rci_ivariporc,
                  rci_ivarniporc            = @rci_ivarniporc,
                  rci_importe                = @rci_importe,
                  pr_id                      = @pr_id,
                  ccos_id                    = @ccos_id,
                  stl_id                    = @stl_id

        where rc_id = @rc_id and rci_id = @rci_id 
        if @@error <> 0 goto ControlError

        update RemitoCompraItemTMP set rci_id = @rci_id where rciTMP_id = @rciTMP_id and rci_orden = @orden
        if @@error <> 0 goto ControlError

        update RemitoCompraItemSerieTMP set rci_id = @rci_id where rciTMP_id = @rciTMP_id 
        if @@error <> 0 goto ControlError

    end -- Update

    set @orden = @orden + 1
  end -- While

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ITEM'S BORRADOS                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados de la orden
  if @IsNew = 0 begin
    
    delete RemitoCompraItem 
            where exists (select rci_id 
                          from RemitoCompraItemBorradoTMP 
                          where rc_id     = @rc_id 
                            and rcTMP_id   = @@rcTMP_id
                            and rci_id     = RemitoCompraItem.rci_id
                          )
    if @@error <> 0 goto ControlError

  end


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                             APLICACION ORDEN DE COMPRA - REMITO                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocRemitoCpraSaveAplic @rc_id, @@rcTMP_id, 0, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                TALONARIOS                                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  declare @bError          smallint
  declare @doc_mueveStock tinyint
  declare @depl_id        int

  select 
          @ta_id             = ta_id,
          @depl_id          = RemitoCompraTMP.depl_id,
          @doc_mueveStock   = Documento.doc_muevestock

  from RemitoCompraTMP inner join documento on RemitoCompraTMP.doc_id = documento.doc_id
  where rcTMP_id = @@rcTMP_id


  exec sp_TalonarioSet @ta_id,@rc_nrodoc
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- PENDIENTE

  -- Actualizo la deuda de la Orden
  exec sp_DocRemitoCompraSetPendiente @rc_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  exec sp_DocRemitoCompraSetCredito @rc_id
  if @@error <> 0 goto ControlError

  exec sp_DocRemitoCompraSetEstado @rc_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     STOCK                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if IsNull(@doc_mueveStock,0) <> 0 begin

    exec sp_DocRemitoCompraStockSave @@rcTMP_id, @rc_id, @depl_id, 0, @bError out, @MsgError out

    -- Si fallo al guardar
    if @bError <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocRC    @rc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- STOCK
  exec sp_AuditoriaStockCheckDocRC    @rc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocRC  @rc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
  exec sp_AuditoriaCreditoCheckDocRC  @rc_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 BORRAR TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  delete OrdenRemitoCompraTMP where rcTMP_ID = @@rcTMP_ID
  delete RemitoCompraItemSerieTMP where rcTMP_id = @@rcTMP_ID
  delete RemitoCompraItemTMP where rcTMP_id = @@rcTMP_id
  delete RemitoCompraItemSerieBTMP where rcTMP_id = @@rcTMP_id

  /*OJO: Esta aca y no en el if (if @IsNew = 0 begin)
         como estaba antes, por que necesito usar
         los registros de esta tabla en 
         sp_DocRemitoCompraStockSave para borrar los 
         numeros de serie asociados al rénglon
  */
  delete RemitoCompraItemBorradoTMP where rc_id = @rc_id   
                                      and rcTMP_id   = @@rcTMP_id
  delete RemitoCompraTMP where rcTMP_id = @@rcTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from RemitoCompra where rc_id = @rc_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 17003, @rc_id, @modifico, 1
  else           exec sp_HistoriaUpdate 17003, @rc_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  set @@bSuccess = 1
  set @@rc_id = @rc_id
  if @@bSelect <> 0 select @rc_id

  exec sp_ListaPrecioSaveAuto @rc_id, @doct_id, @IsNew, @rc_fecha

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar del remito de compra. sp_DocRemitoCompraSave. ' + IsNull(@MsgError,'')

  if @@bDontRaiseError = 0 begin

    raiserror (@MsgError, 16, 1)

  end else begin

    set @@MsgError = @MsgError

  end

  if @@trancount > 0 begin
    rollback transaction  
  end

end