if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraSave]

/*

 sp_DocPedidoCompraSave 93

*/

go
create procedure sp_DocPedidoCompraSave (
  @@pcTMP_id int
)
as

begin

  set nocount on

  declare @pc_id          int
  declare @pci_id          int
  declare @IsNew          smallint
  declare @orden          smallint

  -- Si no existe chau
  if not exists (select pcTMP_id from PedidoCompraTMP where pcTMP_id = @@pcTMP_id)
    return

  declare  @doct_id    int

-- Talonario
  declare  @doc_id     int
  declare  @pc_nrodoc  varchar (50) 
  
  select @pc_id   = pc_id, 
         @doct_id = doct_id,

-- Talonario
         @pc_nrodoc  = pc_nrodoc,
         @doc_id    = PedidoCompraTMP.doc_id

  from 
        PedidoCompraTMP inner join Documento on PedidoCompraTMP.doc_id = Documento.doc_id
  where 
        pcTMP_id = @@pcTMP_id
  
  set @pc_id = isnull(@pc_id,0)
  

-- Campos de las tablas

declare  @pc_numero  int 
declare  @pc_descrip varchar (5000)
declare  @pc_fecha   datetime 
declare  @pc_fechaentrega datetime 
declare  @pc_neto      decimal(18, 6) 
declare  @pc_ivari     decimal(18, 6)
declare  @pc_ivarni    decimal(18, 6)
declare  @pc_total     decimal(18, 6)
declare  @pc_subtotal  decimal(18, 6)

declare @us_id      int
declare  @est_id     int
declare  @suc_id     int
declare @ta_id      int
declare  @lp_id      int 
declare  @ccos_id    int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 


declare  @pci_orden               smallint 
declare  @pci_cantidad           decimal(18, 6) 
declare  @pci_cantidadaremitir   decimal(18, 6) 
declare  @pci_pendiente           decimal(18, 6) 
declare  @pci_descrip             varchar (5000) 
declare  @pci_precio             decimal(18, 6) 
declare  @pci_precioUsr           decimal(18, 6)
declare  @pci_precioLista         decimal(18, 6)
declare  @pci_neto               decimal(18, 6) 
declare  @pci_ivari               decimal(18, 6)
declare  @pci_ivarni             decimal(18, 6)
declare  @pci_ivariporc           decimal(18, 6)
declare  @pci_ivarniporc         decimal(18, 6)
declare @pci_importe             decimal(18, 6)
declare  @pr_id                   int


  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @pc_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'PedidoCompra','pc_id',@pc_id out
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'PedidoCompra','pc_numero',@pc_numero out
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

              set @pc_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into pedidoCompra (
                              pc_id,
                              pc_numero,
                              pc_nrodoc,
                              pc_descrip,
                              pc_fecha,
                              pc_fechaentrega,
                              pc_neto,
                              pc_ivari,
                              pc_ivarni,
                              pc_total,
                              pc_subtotal,
                              us_id,
                              est_id,
                              suc_id,
                              doc_id,
                              doct_id,
                              lp_id,
                              ccos_id,
                              modifico
                            )
      select
                              @pc_id,
                              @pc_numero,
                              @pc_nrodoc,
                              pc_descrip,
                              pc_fecha,
                              pc_fechaentrega,
                              pc_neto,
                              pc_ivari,
                              pc_ivarni,
                              pc_total,
                              pc_subtotal,
                              us_id,
                              est_id,
                              suc_id,
                              doc_id,
                              @doct_id,
                              lp_id,
                              ccos_id,
                              modifico
      from PedidoCompraTMP
      where pcTMP_id = @@pcTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @pc_nrodoc = pc_nrodoc from PedidoCompra where pc_id = @pc_id
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
                              @pc_id                   = pc_id,
                              @pc_nrodoc              = pc_nrodoc,
                              @pc_descrip              = pc_descrip,
                              @pc_fecha                = pc_fecha,
                              @pc_fechaentrega        = pc_fechaentrega,
                              @pc_neto                = pc_neto,
                              @pc_ivari                = pc_ivari,
                              @pc_ivarni              = pc_ivarni,
                              @pc_total                = pc_total,
                              @pc_subtotal            = pc_subtotal,
                              @est_id                  = est_id,
                              @us_id                  = us_id,
                              @suc_id                  = suc_id,
                              @doc_id                  = doc_id,
                              @lp_id                  = lp_id,
                              @ccos_id                = ccos_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from PedidoCompraTMP 
    where 
          pcTMP_id = @@pcTMP_id
  
    update PedidoCompra set 
                              pc_nrodoc              = @pc_nrodoc,
                              pc_descrip            = @pc_descrip,
                              pc_fecha              = @pc_fecha,
                              pc_fechaentrega        = @pc_fechaentrega,
                              pc_neto                = @pc_neto,
                              pc_ivari              = @pc_ivari,
                              pc_ivarni              = @pc_ivarni,
                              pc_total              = @pc_total,
                              pc_subtotal            = @pc_subtotal,
                              est_id                = @est_id,
                              us_id                 = @us_id,
                              suc_id                = @suc_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lp_id                  = @lp_id,
                              ccos_id                = @ccos_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where pc_id = @pc_id
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
  while exists(select pci_orden from PedidoCompraItemTMP where pcTMP_id = @@pcTMP_id and pci_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @pci_id                      = pci_id,
            @pci_orden                  = pci_orden,
            @pci_cantidad                = pci_cantidad,
            @pci_cantidadaremitir        = pci_cantidadaremitir,
            @pci_descrip                = pci_descrip,
            @pci_precio                  = pci_precio,
            @pci_precioUsr              = pci_precioUsr,
            @pci_precioLista            = pci_precioLista,
            @pci_neto                    = pci_neto,
            @pci_ivari                  = pci_ivari,
            @pci_ivarni                  = pci_ivarni,
            @pci_ivariporc              = pci_ivariporc,
            @pci_ivarniporc              = pci_ivarniporc,
            @pci_importe                = pci_importe,
            @pr_id                      = pr_id,
            @ccos_id                    = ccos_id

    from PedidoCompraItemTMP where pcTMP_id = @@pcTMP_id and pci_orden = @orden

    -- Cuando se inserta se indica 
    -- como cantidad a remitir la cantidad (Por ahora)
    set @pci_cantidadaremitir = @pci_cantidad

    if @IsNew <> 0 or @pci_id = 0 begin

        -- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
        set @pci_pendiente         = @pci_cantidadaremitir     
        exec SP_DBGetNewId 'PedidoCompraItem','pci_id',@pci_id out
        if @@error <> 0 goto ControlError

        insert into pedidoCompraItem (
                                      pc_id,
                                      pci_id,
                                      pci_orden,
                                      pci_cantidad,
                                      pci_cantidadaremitir,
                                      pci_pendiente,
                                      pci_descrip,
                                      pci_precio,
                                      pci_precioUsr,
                                      pci_precioLista,
                                      pci_neto,
                                      pci_ivari,
                                      pci_ivarni,
                                      pci_ivariporc,
                                      pci_ivarniporc,
                                      pci_importe,
                                      pr_id,
                                      ccos_id
                                )
                            Values(
                                      @pc_id,
                                      @pci_id,
                                      @pci_orden,
                                      @pci_cantidad,
                                      @pci_cantidadaremitir, 
                                      @pci_pendiente, 
                                      @pci_descrip,
                                      @pci_precio,
                                      @pci_precioUsr,
                                      @pci_precioLista,
                                      @pci_neto,
                                      @pci_ivari,
                                      @pci_ivarni,
                                      @pci_ivariporc,
                                      @pci_ivarniporc,
                                      @pci_importe,
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

          -- Cuando se actualiza se encarga el sp sp_DocPedidoCompraSetPendiente de actulizar
          -- pci_pendiente y pc_pendiente

          update PedidoCompraItem set

                  pc_id                      = @pc_id,
                  pci_orden                  = @pci_orden,
                  pci_cantidad              = @pci_cantidad,
                  pci_cantidadaremitir      = @pci_cantidadaremitir,
                  pci_descrip                = @pci_descrip,
                  pci_precio                = @pci_precio,
                  pci_precioUsr              = @pci_precioUsr,
                  pci_precioLista            = @pci_precioLista,
                  pci_neto                  = @pci_neto,
                  pci_ivari                  = @pci_ivari,
                  pci_ivarni                = @pci_ivarni,
                  pci_ivariporc              = @pci_ivariporc,
                  pci_ivarniporc            = @pci_ivarniporc,
                  pci_importe                = @pci_importe,
                  pr_id                      = @pr_id,
                  ccos_id                    = @ccos_id

        where pc_id = @pc_id and pci_id = @pci_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin
    
    delete PedidoCompraItem 
            where exists (select pci_id 
                          from PedidoCompraItemBorradoTMP 
                          where pc_id     = @pc_id 
                            and pcTMP_id  = @@pcTMP_id
                            and pci_id     = PedidoCompraItem.pci_id
                          )
    if @@error <> 0 goto ControlError

    delete PedidoCompraItemBorradoTMP where pc_id = @pc_id and pcTMP_id = @@pcTMP_id

  end

  delete PedidoCompraItemTMP where pcTMP_ID = @@pcTMP_id
  delete PedidoCompraTMP where pcTMP_ID = @@pcTMP_id

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- PENDIENTE

  declare @bSuccess tinyint
  
  -- Actualizo la deuda de la Pedido
  exec sp_DocPedidoCompraSetPendiente @pc_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@pc_nrodoc
  if @@error <> 0 goto ControlError

  exec sp_DocPedidoCompraSetEstado @pc_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from PedidoCompra where pc_id = @pc_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 17005, @pc_id, @modifico, 1
  else           exec sp_HistoriaUpdate 17005, @pc_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  select @pc_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar el pedido de compra. sp_DocPedidoCompraSave.', 16, 1)
  rollback transaction  

end