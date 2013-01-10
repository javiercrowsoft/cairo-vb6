if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioSave]

/*

 sp_DocOrdenServicioSave 93

*/

go
create procedure sp_DocOrdenServicioSave (
  @@osTMP_id int,
  @@os_id    int = 0 out,
  @@bSelect  tinyint = 1
)
as

begin

  set nocount on

  declare @os_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @doct_id        int
  declare  @os_fecha       datetime
  declare @emp_id         int 

  -- Si no existe chau
  if not exists (select osTMP_id from OrdenServicioTMP where osTMP_id = @@osTMP_id)
    return

-- Talonario
  declare  @doc_id     int
  declare  @os_nrodoc  varchar (50) 
  
  select   @os_id    = os_id, 
          @doct_id  = doct_id,
          @os_fecha  = os_fecha,
          @emp_id   = emp_id,

-- Talonario
         @os_nrodoc  = os_nrodoc,
         @doc_id    = OrdenServicioTMP.doc_id

    from 
        OrdenServicioTMP inner join Documento on OrdenServicioTMP.doc_id = Documento.doc_id

    where osTMP_id = @@osTMP_id
  
  set @os_id = isnull(@os_id,0)
  

-- Campos de las tablas

declare  @os_numero  int 
declare  @os_descrip varchar (5000)
declare @os_hora    smallint
declare  @os_fechaentrega datetime 
declare  @os_neto      decimal(18, 6) 
declare  @os_ivari     decimal(18, 6)
declare  @os_ivarni    decimal(18, 6)
declare  @os_total     decimal(18, 6)
declare  @os_subtotal  decimal(18, 6)
declare  @os_pendiente decimal(18, 6)
declare  @os_descuento1    decimal(18, 6)
declare  @os_descuento2    decimal(18, 6)
declare  @os_importedesc1  decimal(18, 6)
declare  @os_importedesc2  decimal(18, 6)
declare  @os_cotizacion    decimal(18, 6)

declare  @est_id     int
declare  @suc_id     int
declare  @cli_id     int
declare @ta_id      int
declare  @lp_id      int 
declare  @ld_id      int 
declare  @cpg_id     int
declare  @ccos_id    int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare @clis_id    int
declare @proy_id    int
declare @prio_id    int
declare @inct_id    int
declare @inca_id    int

declare @osi_id                  int
declare @osiTMP_id              int
declare  @osi_orden               smallint 
declare  @osi_cantidad           decimal(18, 6) 
declare  @osi_cantidadaremitir   decimal(18, 6) 
declare @osi_pendiente          decimal(18, 6)
declare  @osi_descrip             varchar (5000) 
declare  @osi_precio             decimal(18, 6) 
declare  @osi_precioUsr           decimal(18, 6)
declare  @osi_precioLista         decimal(18, 6)
declare  @osi_descuento           varchar (100) 
declare  @osi_neto               decimal(18, 6) 
declare  @osi_ivari               decimal(18, 6)
declare  @osi_ivarni             decimal(18, 6)
declare  @osi_ivariporc           decimal(18, 6)
declare  @osi_ivarniporc         decimal(18, 6)
declare @osi_importe             decimal(18, 6)
declare  @pr_id                   int
declare @stl_id                 int
declare @tar_id                 int
declare @cont_id                int
declare @zon_id                 int
declare @us_id_tecnico          int
declare @etf_id                 int

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @os_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'OrdenServicio','os_id',@os_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'OrdenServicio','os_numero',@os_numero out, 0
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

              set @os_nrodoc = @ta_nrodoc

            end

          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into OrdenServicio (
                              os_id,
                              os_numero,
                              os_nrodoc,
                              os_descrip,
                              os_fecha,
                              os_hora,
                              os_fechaentrega,
                              os_neto,
                              os_ivari,
                              os_ivarni,
                              os_total,
                              os_subtotal,
                              os_descuento1,
                              os_descuento2,
                              os_importedesc1,
                              os_importedesc2,
                              os_cotizacion,
                              est_id,
                              emp_id,
                              suc_id,
                              cli_id,
                              cont_id,
                              clis_id,
                              proy_id,
                              prio_id,
                              inct_id,
                              inca_id,
                              doc_id,
                              doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              zon_id,
                              us_id_tecnico,
                              modifico
                            )
      select
                              @os_id,
                              @os_numero,
                              @os_nrodoc,
                              os_descrip,
                              os_fecha,
                              os_hora,
                              os_fechaentrega,
                              os_neto,
                              os_ivari,
                              os_ivarni,
                              os_total,
                              os_subtotal,
                              os_descuento1,
                              os_descuento2,
                              os_importedesc1,
                              os_importedesc2,
                              os_cotizacion,
                              est_id,
                              @emp_id,
                              suc_id,
                              cli_id,
                              cont_id,
                              clis_id,
                              proy_id,
                              prio_id,
                              inct_id,
                              inca_id,
                              doc_id,
                              @doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              zon_id,
                              us_id_tecnico,
                              modifico
      from OrdenServicioTMP
      where osTMP_id = @@osTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @os_nrodoc = os_nrodoc from OrdenServicio where os_id = @os_id
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
                              @os_id                   = os_id,
                              @os_nrodoc              = os_nrodoc,
                              @os_descrip              = os_descrip,
                              @os_hora                = os_hora,
                              @os_fechaentrega        = os_fechaentrega,
                              @os_neto                = os_neto,
                              @os_ivari                = os_ivari,
                              @os_ivarni              = os_ivarni,
                              @os_total                = os_total,
                              @os_descuento1          = os_descuento1,
                              @os_descuento2          = os_descuento2,
                              @os_subtotal            = os_subtotal,
                              @os_importedesc1        = os_importedesc1,
                              @os_importedesc2        = os_importedesc2,
                              @os_cotizacion          = os_cotizacion,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @cli_id                  = cli_id,

                              @cont_id                = cont_id,
                              @clis_id                = clis_id,
                              @proy_id                = proy_id,
                              @prio_id                = prio_id,
                              @inct_id                = inct_id,
                              @inca_id                = inca_id,

                              @doc_id                  = doc_id,
                              @lp_id                  = lp_id,
                              @ld_id                  = ld_id,
                              @cpg_id                  = cpg_id,
                              @ccos_id                = ccos_id,
                              @zon_id                 = zon_id,
                              @us_id_tecnico          = us_id_tecnico,
                              @modifico                = modifico,
                              @modificado             = modificado
    from OrdenServicioTMP 
    where 
          osTMP_id = @@osTMP_id
  
    update OrdenServicio set 
                              os_nrodoc              = @os_nrodoc,
                              os_descrip            = @os_descrip,
                              os_fecha              = @os_fecha,
                              os_hora               = @os_hora,
                              os_fechaentrega        = @os_fechaentrega,
                              os_neto                = @os_neto,
                              os_ivari              = @os_ivari,
                              os_ivarni              = @os_ivarni,
                              os_total              = @os_total,
                              os_descuento1         = @os_descuento1,
                              os_descuento2         = @os_descuento2,
                              os_subtotal            = @os_subtotal,
                              os_importedesc1       = @os_importedesc1,
                              os_importedesc2       = @os_importedesc2,
                              os_cotizacion          = @os_cotizacion,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              emp_id                = @emp_id,
                              cli_id                = @cli_id,

                              cont_id               = @cont_id,
                              clis_id                = @clis_id,
                              proy_id                = @proy_id,
                              prio_id                = @prio_id,
                              inct_id                = @inct_id,
                              inca_id                = @inca_id,
                              zon_id                = @zon_id,
                              us_id_tecnico         = @us_id_tecnico,

                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lp_id                  = @lp_id,
                              ld_id                  = @ld_id,
                              cpg_id                = @cpg_id,
                              ccos_id                = @ccos_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where os_id = @os_id
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
  while exists(select osi_orden from OrdenServicioItemTMP where osTMP_id = @@osTMP_id and osi_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @osiTMP_id                  = osiTMP_id,
            @osi_id                      = osi_id,
            @osi_orden                  = osi_orden,
            @osi_cantidad                = osi_cantidad,
            @osi_cantidadaremitir        = osi_cantidadaremitir,
            @osi_pendiente              = osi_pendiente,
            @osi_descrip                = osi_descrip,
            @osi_precio                  = osi_precio,
            @osi_precioUsr              = osi_precioUsr,
            @osi_precioLista            = osi_precioLista,
            @osi_descuento              = osi_descuento,
            @osi_neto                    = osi_neto,
            @osi_ivari                  = osi_ivari,
            @osi_ivarni                  = osi_ivarni,
            @osi_ivariporc              = osi_ivariporc,
            @osi_ivarniporc              = osi_ivarniporc,
            @osi_importe                = osi_importe,
            @pr_id                      = pr_id,
            @ccos_id                    = ccos_id,
            @stl_id                      = stl_id,
            @tar_id                     = tar_id,
            @cont_id                    = cont_id,
            @etf_id                     = etf_id

    from OrdenServicioItemTMP where osTMP_id = @@osTMP_id and osi_orden = @orden

    -- Cuando se inserta se indica 
    -- como cantidad a remitir la cantidad (Por ahora)
    set @osi_cantidadaremitir = @osi_cantidad

    if @IsNew <> 0 or @osi_id = 0 begin

        -- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
        set @osi_pendiente = @osi_cantidadaremitir

        exec SP_DBGetNewId 'OrdenServicioItem','osi_id',@osi_id out, 0
        if @@error <> 0 goto ControlError

        insert into OrdenServicioItem (
                                      os_id,
                                      osi_id,
                                      osi_orden,
                                      osi_cantidad,
                                      osi_cantidadaremitir,
                                      osi_pendiente,
                                      osi_descrip,
                                      osi_precio,
                                      osi_precioUsr,
                                      osi_precioLista,
                                      osi_descuento,
                                      osi_neto,
                                      osi_ivari,
                                      osi_ivarni,
                                      osi_ivariporc,
                                      osi_ivarniporc,
                                      osi_importe,
                                      pr_id,
                                      ccos_id,
                                      stl_id,
                                      tar_id,
                                      cont_id,
                                      etf_id
                                )
                            Values(
                                      @os_id,
                                      @osi_id,
                                      @osi_orden,
                                      @osi_cantidad,
                                      @osi_cantidadaremitir,
                                      @osi_pendiente,
                                      @osi_descrip,
                                      @osi_precio,
                                      @osi_precioUsr,
                                      @osi_precioLista,
                                      @osi_descuento,
                                      @osi_neto,
                                      @osi_ivari,
                                      @osi_ivarni,
                                      @osi_ivariporc,
                                      @osi_ivarniporc,
                                      @osi_importe,
                                      @pr_id,
                                      @ccos_id,
                                      @stl_id,
                                      @tar_id,
                                      @cont_id,
                                      @etf_id
                                )

        if @@error <> 0 goto ControlError

        update OrdenServicioItemTMP set osi_id = @osi_id where osiTMP_id = @osiTMP_id and osi_orden = @orden
        if @@error <> 0 goto ControlError

        update OrdenServicioItemSerieTMP set osi_id = @osi_id where osiTMP_id = @osiTMP_id 
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
          select @osi_pendiente = sum(osrv_cantidad) from OrdenRemitoVenta where osi_id = @osi_id
          set @osi_pendiente = @osi_cantidadaremitir - isnull(@osi_pendiente,0)

          update OrdenServicioItem set

                  os_id                      = @os_id,
                  osi_orden                  = @osi_orden,
                  osi_cantidad              = @osi_cantidad,
                  osi_cantidadaremitir      = @osi_cantidadaremitir,
                  osi_pendiente              = @osi_pendiente,
                  osi_descrip                = @osi_descrip,
                  osi_precio                = @osi_precio,
                  osi_precioUsr              = @osi_precioUsr,
                  osi_precioLista            = @osi_precioLista,
                  osi_descuento              = @osi_descuento,
                  osi_neto                  = @osi_neto,
                  osi_ivari                  = @osi_ivari,
                  osi_ivarni                = @osi_ivarni,
                  osi_ivariporc              = @osi_ivariporc,
                  osi_ivarniporc            = @osi_ivarniporc,
                  osi_importe                = @osi_importe,
                  pr_id                      = @pr_id,
                  ccos_id                    = @ccos_id,
                  stl_id                    = @stl_id,
                  tar_id                    = @tar_id,
                  cont_id                   = @cont_id,
                  etf_id                    = @etf_id

        where os_id = @os_id and osi_id = @osi_id 
        if @@error <> 0 goto ControlError

        update OrdenServicioItemTMP set osi_id = @osi_id where osiTMP_id = @osiTMP_id and osi_orden = @orden
        if @@error <> 0 goto ControlError

        update OrdenServicioItemSerieTMP set osi_id = @osi_id where osiTMP_id = @osiTMP_id 
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
    
    delete OrdenServicioItem 
            where exists (select osi_id 
                          from OrdenServicioItemBorradoTMP 
                          where os_id     = @os_id 
                            and osTMP_id   = @@osTMP_id
                            and osi_id     = OrdenServicioItem.osi_id
                          )
    if @@error <> 0 goto ControlError

  end


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                             APLICACION                                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bSuccess  tinyint

  exec sp_DocOrdenSrvSaveAplic @os_id, @@osTMP_id, 0, @bSuccess out

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
          @depl_id          = OrdenServicioTMP.depl_id,
          @doc_mueveStock   = Documento.doc_muevestock

  from OrdenServicioTMP inner join documento on OrdenServicioTMP.doc_id = documento.doc_id
  where osTMP_id = @@osTMP_id


  exec sp_TalonarioSet @ta_id,@os_nrodoc
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
  exec sp_DocOrdenServicioSetPendiente @os_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  exec sp_DocOrdenServicioSetCredito @os_id
  if @@error <> 0 goto ControlError

  exec sp_DocOrdenServicioSetEstado @os_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     STOCK                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  declare @MsgError  varchar(5000) set @MsgError = ''

  if IsNull(@doc_mueveStock,0) <> 0 begin

    exec sp_DocOrdenServicioStockSave @@osTMP_id, @os_id, @depl_id, 0, @bError out, @MsgError out

    -- Si fallo al guardar
    if @bError <> 0 goto ControlError

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 TAREAS                                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocOrdenServicioTareaSave   @@osTMP_id,
                                      @os_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 EQUIPOS                                                                       //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Por ahora solo si es insert
  -- para que no se vuelva muy lenta la transaccion
  --
  if @IsNew <> 0 begin
    
    exec sp_DocOrdenServicioUpdateProductoSerie @os_id

  end

  exec sp_DocOrdenServicioUpdateProductoSerieH @os_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocOS    @os_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- STOCK
  exec sp_AuditoriaStockCheckDocOS    @os_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocOS  @os_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
  exec sp_AuditoriaCreditoCheckDocOS  @os_id,
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
  delete OrdenServicioSerieTMP where osTMP_ID = @@osTMP_ID
  delete OrdenRemitoVentaTMP where osTMP_ID = @@osTMP_ID
  delete OrdenServicioItemSerieTMP where osTMP_id = @@osTMP_ID
  delete OrdenServicioItemTMP where osTMP_id = @@osTMP_id
  delete OrdenServicioItemSerieBTMP where osTMP_id = @@osTMP_id

  /*OJO: Esta aca y no en el if (if @IsNew = 0 begin)
         como estaba antes, por que necesito usar
         los registros de esta tabla en 
         sp_DocOrdenServicioStockSave para borrar los 
         numeros de serie asociados al rénglon
  */
  delete OrdenServicioItemBorradoTMP where os_id = @os_id   
                                      and osTMP_id   = @@osTMP_id
  delete OrdenServicioTMP where osTMP_id = @@osTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from OrdenServicio where os_id = @os_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 28008, @os_id, @modifico, 1
  else           exec sp_HistoriaUpdate 28008, @os_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  set @@os_id = @os_id

  if @@bSelect <> 0 select @os_id

  exec sp_ListaPrecioSaveAuto @os_id, @doct_id, @IsNew, @os_fecha

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar de la orden de servicio. sp_DocOrdenServicioSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end