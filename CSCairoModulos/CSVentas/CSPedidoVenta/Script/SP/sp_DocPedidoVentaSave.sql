if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSave]

/*

begin tran
exec  sp_DocPedidoVentaSave 16
rollback tran

*/

go
create procedure sp_DocPedidoVentaSave (
  @@pvTMP_id       int,
  @@bSelect        tinyint = 1,
  @@pv_id          int     = 0 out,
  @@bSuccess      tinyint = 0 out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  declare @pv_id          int
  declare @pvi_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare @emp_id         int

  -- Si no existe chau
  if not exists (select pvTMP_id from PedidoVentaTMP where pvTMP_id = @@pvTMP_id)
    return

  declare  @doct_id    int
  declare  @doc_id     int
  declare  @pv_nrodoc  varchar (50) 
  
  select   @pv_id         = pv_id, 
          @doct_id       = doct_id, 
          @doc_id       = Documento.doc_id, 
          @pv_nrodoc     = pv_nrodoc,
          @emp_id        = emp_id
  from 
        PedidoVentaTMP inner join Documento on PedidoVentaTMP.doc_id = Documento.doc_id
  where 
        pvTMP_id = @@pvTMP_id
  
  set @pv_id = isnull(@pv_id,0)
  

-- Campos de las tablas

declare  @pv_numero  int 
declare  @pv_descrip varchar (5000)
declare  @pv_fecha   datetime 
declare  @pv_fechaentrega datetime 
declare  @pv_neto      decimal(18, 6) 
declare  @pv_ivari     decimal(18, 6)
declare  @pv_ivarni    decimal(18, 6)
declare  @pv_total     decimal(18, 6)
declare  @pv_subtotal  decimal(18, 6)
declare  @pv_descuento1    decimal(18, 6)
declare  @pv_descuento2    decimal(18, 6)
declare  @pv_importedesc1  decimal(18, 6)
declare  @pv_importedesc2  decimal(18, 6)
declare @pv_destinatario  varchar (1000)
declare @pv_ordencompra   varchar (255)

declare  @est_id     int
declare  @suc_id     int
declare  @cli_id     int
declare @ta_id      int
declare  @lp_id      int 
declare  @ld_id      int 
declare  @cpg_id     int
declare  @ccos_id    int
declare @lgj_id     int
declare @ven_id     int
declare @pro_id_origen       int
declare @pro_id_destino      int
declare @trans_id           int
declare @chof_id            int
declare @cam_id              int
declare @cam_id_semi        int
declare @clis_id    int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico     int 
declare @ram_id_stock varchar(50)

declare  @pvi_orden               smallint 
declare  @pvi_cantidad           decimal(18, 6) 
declare  @pvi_cantidadaremitir   decimal(18, 6) 
declare  @pvi_pendiente           decimal(18, 6) 
declare  @pvi_pendientepklst      decimal(18, 6) 
declare  @pvi_descrip             varchar (5000) 
declare  @pvi_precio             decimal(18, 6) 
declare  @pvi_precioUsr           decimal(18, 6)
declare  @pvi_precioLista         decimal(18, 6)
declare  @pvi_descuento           varchar (100) 
declare  @pvi_neto               decimal(18, 6) 
declare  @pvi_ivari               decimal(18, 6)
declare  @pvi_ivarni             decimal(18, 6)
declare  @pvi_ivariporc           decimal(18, 6)
declare  @pvi_ivarniporc         decimal(18, 6)
declare @pvi_importe             decimal(18, 6)
declare  @pr_id                   int

declare @bSuccess tinyint

declare @MsgError  varchar(5000) set @MsgError = ''

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @pv_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'PedidoVenta','pv_id',@pv_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'PedidoVenta','pv_numero',@pv_numero out, 0
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

              set @pv_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into pedidoventa (
                              pv_id,
                              pv_numero,
                              pv_nrodoc,
                              pv_descrip,
                              pv_fecha,
                              pv_fechaentrega,
                              pv_neto,
                              pv_ivari,
                              pv_ivarni,
                              pv_total,
                              pv_subtotal,
                              pv_descuento1,
                              pv_descuento2,
                              pv_importedesc1,
                              pv_importedesc2,
                              pv_destinatario,
                              pv_ordencompra,
                              est_id,
                              suc_id,
                              cli_id,
                              emp_id,
                              doc_id,
                              doct_id,
                              ram_id_stock,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              ven_id,
                              pro_id_origen,
                              pro_id_destino,
                              trans_id,
                              chof_id,
                              cam_id,
                              cam_id_semi,
                              clis_id,
                              modifico
                            )
      select
                              @pv_id,
                              @pv_numero,
                              @pv_nrodoc,
                              pv_descrip,
                              pv_fecha,
                              pv_fechaentrega,
                              pv_neto,
                              pv_ivari,
                              pv_ivarni,
                              pv_total,
                              pv_subtotal,
                              pv_descuento1,
                              pv_descuento2,
                              pv_importedesc1,
                              pv_importedesc2,
                              pv_destinatario,
                              pv_ordencompra,
                              est_id,
                              suc_id,
                              cli_id,
                              @emp_id,
                              doc_id,
                              @doct_id,
                              ram_id_stock,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              ven_id,
                              pro_id_origen,
                              pro_id_destino,
                              trans_id,
                              chof_id,
                              cam_id,
                              cam_id_semi,
                              clis_id,
                              modifico
      from PedidoVentaTMP
      where pvTMP_id = @@pvTMP_id  

      if @@error <> 0 goto ControlError
    
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
                              @pv_id                   = pv_id,
                              @pv_nrodoc              = pv_nrodoc,
                              @pv_descrip              = pv_descrip,
                              @pv_fecha                = pv_fecha,
                              @pv_fechaentrega        = pv_fechaentrega,
                              @pv_neto                = pv_neto,
                              @pv_ivari                = pv_ivari,
                              @pv_ivarni              = pv_ivarni,
                              @pv_total                = pv_total,
                              @pv_descuento1          = pv_descuento1,
                              @pv_descuento2          = pv_descuento2,
                              @pv_subtotal            = pv_subtotal,
                              @pv_importedesc1        = pv_importedesc1,
                              @pv_importedesc2        = pv_importedesc2,
                              @pv_destinatario        = pv_destinatario,
                              @pv_ordencompra          = pv_ordencompra,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @cli_id                  = cli_id,
                              @doc_id                  = doc_id,
                              @ram_id_stock            =  ram_id_stock,
                              @lp_id                  = lp_id,
                              @ld_id                  = ld_id,
                              @cpg_id                  = cpg_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                 = lgj_id,
                              @ven_id                 = ven_id,
                              @pro_id_origen          = pro_id_origen,
                              @pro_id_destino          = pro_id_destino,
                              @trans_id                = trans_id,
                              @chof_id                = chof_id,
                              @cam_id                  = cam_id,
                              @cam_id_semi            = cam_id_semi,
                              @clis_id                = clis_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from PedidoVentaTMP 
    where 
          pvTMP_id = @@pvTMP_id
  
    update PedidoVenta set 
                              pv_nrodoc              = @pv_nrodoc,
                              pv_descrip            = @pv_descrip,
                              pv_fecha              = @pv_fecha,
                              pv_fechaentrega        = @pv_fechaentrega,
                              pv_neto                = @pv_neto,
                              pv_ivari              = @pv_ivari,
                              pv_ivarni              = @pv_ivarni,
                              pv_total              = @pv_total,
                              pv_descuento1         = @pv_descuento1,
                              pv_descuento2         = @pv_descuento2,
                              pv_subtotal            = @pv_subtotal,
                              pv_importedesc1       = @pv_importedesc1,
                              pv_importedesc2       = @pv_importedesc2,
                              pv_destinatario        = @pv_destinatario,
                              pv_ordencompra        = @pv_ordencompra,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              cli_id                = @cli_id,
                              emp_id                = @emp_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              ram_id_stock          = @ram_id_stock,
                              lp_id                  = @lp_id,
                              ld_id                  = @ld_id,
                              cpg_id                = @cpg_id,
                              ccos_id                = @ccos_id,
                              lgj_id                = @lgj_id,
                              ven_id                = @ven_id,
                              pro_id_origen          = @pro_id_origen,
                              pro_id_destino        = @pro_id_destino,
                              trans_id              = @trans_id,
                              chof_id                = @chof_id,
                              cam_id                = @cam_id,
                              cam_id_semi            = @cam_id_semi,
                              clis_id               = @clis_id,
                              modifico              = @modifico,
                              modificado            = @modificado

                              -- Firma (cuando se modifica se elimina la firma)
                              --
                              ,pv_firmado = 0
  
    where pv_id = @pv_id
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
  while exists(select pvi_orden from PedidoVentaItemTMP where pvTMP_id = @@pvTMP_id and pvi_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @pvi_id                      = pvi_id,
            @pvi_orden                  = pvi_orden,
            @pvi_cantidad                = pvi_cantidad,
            @pvi_cantidadaremitir        = pvi_cantidadaremitir,
            @pvi_descrip                = pvi_descrip,
            @pvi_precio                  = pvi_precio,
            @pvi_precioUsr              = pvi_precioUsr,
            @pvi_precioLista            = pvi_precioLista,
            @pvi_descuento              = pvi_descuento,
            @pvi_neto                    = pvi_neto,
            @pvi_ivari                  = pvi_ivari,
            @pvi_ivarni                  = pvi_ivarni,
            @pvi_ivariporc              = pvi_ivariporc,
            @pvi_ivarniporc              = pvi_ivarniporc,
            @pvi_importe                = pvi_importe,
            @pr_id                      = pr_id,
            @ccos_id                    = ccos_id

    from PedidoVentaItemTMP where pvTMP_id = @@pvTMP_id and pvi_orden = @orden

    -- Cuando se inserta se indica 
    -- como cantidad a remitir la cantidad (Por ahora)
    set @pvi_cantidadaremitir = @pvi_cantidad

    if @IsNew <> 0 or @pvi_id = 0 begin

        -- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
        set @pvi_pendiente         = @pvi_cantidadaremitir     
        set @pvi_pendientepklst    = @pvi_cantidadaremitir     

        exec SP_DBGetNewId 'PedidoVentaItem','pvi_id',@pvi_id out, 0 
        if @@error <> 0 goto ControlError
    
        insert into pedidoventaItem (
                                      pv_id,
                                      pvi_id,
                                      pvi_orden,
                                      pvi_cantidad,
                                      pvi_cantidadaremitir,
                                      pvi_pendiente,
                                      pvi_pendientepklst,
                                      pvi_descrip,
                                      pvi_precio,
                                      pvi_precioUsr,
                                      pvi_precioLista,
                                      pvi_descuento,
                                      pvi_neto,
                                      pvi_ivari,
                                      pvi_ivarni,
                                      pvi_ivariporc,
                                      pvi_ivarniporc,
                                      pvi_importe,
                                      pr_id,
                                      ccos_id
                                )
                            Values(
                                      @pv_id,
                                      @pvi_id,
                                      @pvi_orden,
                                      @pvi_cantidad,
                                      @pvi_cantidadaremitir, 
                                      @pvi_pendiente, 
                                      @pvi_pendientepklst,
                                      @pvi_descrip,
                                      @pvi_precio,
                                      @pvi_precioUsr,
                                      @pvi_precioLista,
                                      @pvi_descuento,
                                      @pvi_neto,
                                      @pvi_ivari,
                                      @pvi_ivarni,
                                      @pvi_ivariporc,
                                      @pvi_ivarniporc,
                                      @pvi_importe,
                                      @pr_id,
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

          -- Cuando se actualiza se encarga el sp sp_DocPedidoVentaSetPendiente de actulizar
          -- pvi_pendiente, pvi_pendientepklst, y pv_pendiente

          update PedidoVentaItem set

                  pv_id                      = @pv_id,
                  pvi_orden                  = @pvi_orden,
                  pvi_cantidad              = @pvi_cantidad,
                  pvi_cantidadaremitir      = @pvi_cantidadaremitir,
                  pvi_descrip                = @pvi_descrip,
                  pvi_precio                = @pvi_precio,
                  pvi_precioUsr              = @pvi_precioUsr,
                  pvi_precioLista            = @pvi_precioLista,
                  pvi_descuento              = @pvi_descuento,
                  pvi_neto                  = @pvi_neto,
                  pvi_ivari                  = @pvi_ivari,
                  pvi_ivarni                = @pvi_ivarni,
                  pvi_ivariporc              = @pvi_ivariporc,
                  pvi_ivarniporc            = @pvi_ivarniporc,
                  pvi_importe                = @pvi_importe,
                  pr_id                      = @pr_id,
                  ccos_id                    = @ccos_id

        where pv_id = @pv_id and pvi_id = @pvi_id 
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

  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin
    
    delete PedidoVentaItem 
            where exists (select pvi_id 
                          from PedidoVentaItemBorradoTMP 
                          where pv_id     = @pv_id 
                            and pvTMP_id  = @@pvTMP_id
                            and pvi_id     = PedidoVentaItem.pvi_id
                          )
    if @@error <> 0 goto ControlError

    delete PedidoVentaItemBorradoTMP where pv_id = @pv_id and pvTMP_id = @@pvTMP_id

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                             APLICACION PRESUPUESTO - PEDIDO                                                   //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocPedidoVtaSaveAplic @pv_id, @@pvTMP_id, 0, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@pv_nrodoc
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     CREDITO Y ESTADO                                                               //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Cada vez que se modifica un pedido se borra la firma
  --
  declare @cfg_valor varchar(5000) 
  declare @cfg_clave varchar(255) 
  set @cfg_clave = 'Borrar firma al modificar el pedido' -- + convert(varchar(15),@modifico)

  set @cfg_valor = 0
  exec sp_Cfg_GetValor  'Ventas-Config',
                        @cfg_clave,
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError
  
  set @cfg_valor = IsNull(@cfg_valor,0)
  if isnumeric(@cfg_valor)=0 set @cfg_valor = 0

  if convert(int,@cfg_valor) <> 0 begin
    update PedidoVenta set pv_firmado = 0 where pv_id = @pv_id
    if @@error <> 0 goto ControlError
  end

  -- Actualizo la deuda de la Pedido
  exec sp_DocPedidoVentaSetPendiente @pv_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  exec sp_DocPedidoVentaSetCredito @pv_id
  if @@error <> 0 goto ControlError

  exec sp_DocPedidoVentaSetEstado @pv_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocPV    @pv_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocPV  @pv_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
  exec sp_AuditoriaCreditoCheckDocPV  @pv_id,
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

  delete PedidoVentaItemTMP where pvTMP_ID = @@pvTMP_id
  delete PedidoVentaTMP where pvTMP_ID = @@pvTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

/*
 select * from HistoriaOperacion where tbl_id = 0
 select * from tabla where tbl_nombrefisico = 'pedidoventa'
*/

  select @modifico = modifico from PedidoVenta where pv_id = @pv_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 16003, @pv_id, @modifico, 1
  else           exec sp_HistoriaUpdate 16003, @pv_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  commit transaction

---------------------------------------------------------------------------------------------
--
--  MENSAJES
--
---------------------------------------------------------------------------------------------

  set @cfg_clave = 'Informar Pedido sin Precio Vta' -- + convert(varchar(15),@modifico)

  set @cfg_valor = 0
  exec sp_Cfg_GetValor  'Ventas-Config',
                        @cfg_clave,
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)

  if convert(int,@cfg_valor) <> 0 begin

    if exists(select * from PedidoVentaItem
              where round(pvi_importe,2) = 0
                and pv_id = @pv_id
              )
    begin

      select 'INFO', 'Este pedido posee items sin precio.'

    end
  end  

  set @cfg_clave = 'Informar Pedido sin Firma' -- + convert(varchar(15),@modifico)

  -- sp_Cfg_SetValor 'Ventas-Config', 'Informar Pedido sin Firma', 1
  set @cfg_valor = 0
  exec sp_Cfg_GetValor  'Ventas-Config',
                        @cfg_clave,
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)

  declare @doc_llevafirmacredito tinyint

  select @doc_llevafirmacredito = doc_llevafirmacredito from Documento where doc_id = @doc_id

  if convert(int,@cfg_valor) <> 0 and @doc_llevafirmacredito <> 0 begin

    select @est_id = est_id from PedidoVenta where pv_id = @pv_id
    if @est_id = 4 /*Pendiente de Firma*/
    begin

      select 'INFO', 'Este pedido esta pendiente de firma y no puede ser despachado hasta que no lo apruebe un supervisor.'

    end
  end  

---------------------------------------------------------------------------------------------
--
--  FIN
--
---------------------------------------------------------------------------------------------
  set @@pv_id = @pv_id
  set @@bSuccess = 1

  if @@bSelect <> 0 select @pv_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar el pedido de venta. sp_DocPedidoVentaSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end