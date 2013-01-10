if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioSave]

/*

 sp_DocPresupuestoEnvioSave 1

*/

go
create procedure sp_DocPresupuestoEnvioSave (
  @@preeTMP_id int
)
as

begin

  set nocount on

  declare @pree_id          int
  declare @preei_id          int
  declare @preeg_id          int
  declare @IsNew          smallint
  declare @orden          smallint

  -- Si no existe chau
  if not exists (select preeTMP_id from PresupuestoEnvioTMP where preeTMP_id = @@preeTMP_id)
    return

-- Talonario
  declare  @doc_id       int
  declare  @pree_nrodoc  varchar (50) 
  
  select @pree_id = pree_id,

-- Talonario
         @pree_nrodoc = pree_nrodoc,
         @doc_id      = doc_id
 
  from PresupuestoEnvioTMP where preeTMP_id = @@preeTMP_id
  
  set @pree_id = isnull(@pree_id,0)
  

-- Campos de las tablas

declare  @pree_numero  int 
declare  @pree_descrip varchar (5000)
declare  @pree_fecha   datetime 
declare  @pree_fechaentrega datetime 
declare  @pree_neto      decimal(18, 6) 
declare  @pree_ivari     decimal(18, 6)
declare  @pree_ivarni    decimal(18, 6)
declare  @pree_total     decimal(18, 6)
declare  @pree_subtotal  decimal(18, 6)
declare  @pree_pendiente decimal(18, 6)
declare  @pree_descuento1    decimal(18, 6)
declare  @pree_descuento2    decimal(18, 6)
declare  @pree_importedesc1  decimal(18, 6)
declare  @pree_importedesc2  decimal(18, 6)

declare  @est_id     int
declare  @suc_id     int
declare  @cli_id     int
declare @ta_id      int
declare  @doct_id    int
declare  @cpg_id     int
declare  @ccos_id    int
declare @ven_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 


declare  @preei_orden               smallint 
declare  @preei_cantidad           decimal(18, 6) 
declare  @preei_pendiente           decimal(18, 0) 
declare  @preei_descrip             varchar (5000) 
declare  @preei_precio             decimal(18, 6) 
declare  @preei_neto               decimal(18, 6) 
declare  @preei_ivari               decimal(18, 6)
declare  @preei_ivarni             decimal(18, 6)
declare  @preei_ivariporc           decimal(18, 6)
declare  @preei_ivarniporc         decimal(18, 6)
declare @preei_importe             decimal(18, 6)
declare @preei_volumen            decimal(18, 6)
declare @preei_kilos              decimal(18, 6)
declare @preei_minimo             decimal(18, 6)
declare @preei_precioTarifa        decimal(18, 6)
declare @trfi_id                  int
declare @trans_id                 int
declare  @pr_id                     int
declare  @pue_id_origen            int
declare  @pue_id_destino           int

declare  @preeg_orden               smallint 
declare  @preeg_cantidad           decimal(18, 6) 
declare  @preeg_pendiente           decimal(18, 6) 
declare  @preeg_descrip             varchar (5000) 
declare  @preeg_precio             decimal(18, 6) 
declare  @preeg_neto               decimal(18, 6) 
declare  @preeg_ivari               decimal(18, 6)
declare  @preeg_ivarni             decimal(18, 6)
declare  @preeg_ivariporc           decimal(18, 6)
declare  @preeg_ivarniporc         decimal(18, 6)
declare @preeg_importe             decimal(18, 6)
declare @preeg_precioTarifa        decimal(18, 6)
declare @trfg_id                  int
declare @gto_id                   int


  begin transaction

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @pree_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'PresupuestoEnvio','pree_id',@pree_id out
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'PresupuestoEnvio','pree_numero',@pree_numero out
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

              set @pree_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into PresupuestoEnvio (
                              pree_id,
                              pree_numero,
                              pree_nrodoc,
                              pree_descrip,
                              pree_fecha,
                              pree_fechaentrega,
                              pree_neto,
                              pree_ivari,
                              pree_ivarni,
                              pree_total,
                              pree_subtotal,
                              pree_descuento1,
                              pree_descuento2,
                              pree_importedesc1,
                              pree_importedesc2,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              doct_id,
                              ven_id,
                              cpg_id,
                              ccos_id,
                              modifico
                            )
      select
                              @pree_id,
                              @pree_numero,
                              @pree_nrodoc,
                              pree_descrip,
                              pree_fecha,
                              pree_fechaentrega,
                              pree_neto,
                              pree_ivari,
                              pree_ivarni,
                              pree_total,
                              pree_subtotal,
                              pree_descuento1,
                              pree_descuento2,
                              pree_importedesc1,
                              pree_importedesc2,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              doct_id,
                              ven_id,
                              cpg_id,
                              ccos_id,
                              modifico
      from PresupuestoEnvioTMP
      where preeTMP_id = @@preeTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @pree_nrodoc = pree_nrodoc from PresupuestoEnvio where pree_id = @pree_id
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
                              @pree_id                   = pree_id,
                              @pree_nrodoc              = pree_nrodoc,
                              @pree_descrip              = pree_descrip,
                              @pree_fecha                = pree_fecha,
                              @pree_fechaentrega        = pree_fechaentrega,
                              @pree_neto                = pree_neto,
                              @pree_ivari                = pree_ivari,
                              @pree_ivarni              = pree_ivarni,
                              @pree_total                = pree_total,
                              @pree_descuento1          = pree_descuento1,
                              @pree_descuento2          = pree_descuento2,
                              @pree_subtotal            = pree_subtotal,
                              @pree_importedesc1        = pree_importedesc1,
                              @pree_importedesc2        = pree_importedesc2,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @cli_id                  = cli_id,
                              @doc_id                  = doc_id,
                              @doct_id                = doct_id,
                              @ven_id                  = ven_id,
                              @cpg_id                  = cpg_id,
                              @ccos_id                = ccos_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from PresupuestoEnvioTMP 
    where 
          preeTMP_id = @@preeTMP_id
  
    update PresupuestoEnvio set 
                              pree_nrodoc              = @pree_nrodoc,
                              pree_descrip            = @pree_descrip,
                              pree_fecha              = @pree_fecha,
                              pree_fechaentrega        = @pree_fechaentrega,
                              pree_neto                = @pree_neto,
                              pree_ivari              = @pree_ivari,
                              pree_ivarni              = @pree_ivarni,
                              pree_total              = @pree_total,
                              pree_descuento1         = @pree_descuento1,
                              pree_descuento2         = @pree_descuento2,
                              pree_subtotal            = @pree_subtotal,
                              pree_importedesc1       = @pree_importedesc1,
                              pree_importedesc2       = @pree_importedesc2,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              cli_id                = @cli_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              ven_id                = @ven_id,
                              cpg_id                = @cpg_id,
                              ccos_id                = @ccos_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where pree_id = @pree_id
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
  while exists(select preei_orden from PresupuestoEnvioItemTMP where preeTMP_id = @@preeTMP_id and preei_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    select
            @preei_id                      = preei_id,
            @preei_orden                  = preei_orden,
            @preei_cantidad                = preei_cantidad,
            @preei_volumen                = preei_volumen,
            @preei_kilos                  = preei_kilos,
            @preei_minimo                 = preei_minimo,
            @preei_pendiente              = preei_pendiente,
            @preei_descrip                = preei_descrip,
            @preei_precio                  = preei_precio,
            @preei_precioTarifa            = preei_precioTarifa,
            @preei_neto                    = preei_neto,
            @preei_ivari                  = preei_ivari,
            @preei_ivarni                  = preei_ivarni,
            @preei_ivariporc              = preei_ivariporc,
            @preei_ivarniporc              = preei_ivarniporc,
            @preei_importe                = preei_importe,
            @pr_id                        = pr_id,
            @ccos_id                      = ccos_id,
            @trfi_id                      = trfi_id,
            @trans_id                      = trans_id,
            @pue_id_origen                = pue_id_origen,
            @pue_id_destino               = pue_id_destino

    from PresupuestoEnvioItemTMP where preeTMP_id = @@preeTMP_id and preei_orden = @orden

    if @IsNew <> 0 or @preei_id = 0 begin

        exec SP_DBGetNewId 'PresupuestoEnvioItem','preei_id',@preei_id out
        if @@error <> 0 goto ControlError

        insert into PresupuestoEnvioItem (
                                      pree_id,
                                      preei_id,
                                      preei_orden,
                                      preei_cantidad,
                                      preei_volumen,
                                      preei_kilos,
                                      preei_minimo,
                                      preei_pendiente,
                                      preei_descrip,
                                      preei_precio,
                                      preei_precioTarifa,
                                      preei_neto,
                                      preei_ivari,
                                      preei_ivarni,
                                      preei_ivariporc,
                                      preei_ivarniporc,
                                      preei_importe,
                                      pr_id,
                                      ccos_id,
                                      trfi_id,
                                      pue_id_origen,
                                      pue_id_destino,
                                      trans_id
                                )
                            Values(
                                      @pree_id,
                                      @preei_id,
                                      @preei_orden,
                                      @preei_cantidad,
                                      @preei_volumen,
                                      @preei_kilos,
                                      @preei_minimo,
                                      @preei_pendiente,
                                      @preei_descrip,
                                      @preei_precio,
                                      @preei_precioTarifa,
                                      @preei_neto,
                                      @preei_ivari,
                                      @preei_ivarni,
                                      @preei_ivariporc,
                                      @preei_ivarniporc,
                                      @preei_importe,
                                      @pr_id,
                                      @ccos_id,
                                      @trfi_id,
                                      @pue_id_origen,
                                      @pue_id_destino,
                                      @trans_id
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

          update PresupuestoEnvioItem set

                  pree_id                      = @pree_id,
                  preei_orden                  = @preei_orden,
                  preei_cantidad              = @preei_cantidad,
                  preei_volumen                = @preei_volumen,
                  preei_kilos                  = @preei_kilos,
                  preei_minimo                 = @preei_minimo,
                  preei_pendiente              = @preei_pendiente,
                  preei_descrip                = @preei_descrip,
                  preei_precio                = @preei_precio,
                  preei_precioTarifa          = @preei_precioTarifa,
                  preei_neto                  = @preei_neto,
                  preei_ivari                  = @preei_ivari,
                  preei_ivarni                = @preei_ivarni,
                  preei_ivariporc              = @preei_ivariporc,
                  preei_ivarniporc            = @preei_ivarniporc,
                  preei_importe                = @preei_importe,
                  pr_id                        = @pr_id,
                  ccos_id                      = @ccos_id,
                  trfi_id                     = @trfi_id,
                  pue_id_origen                = @pue_id_origen,
                  pue_id_destino              = @pue_id_destino,
                  trans_id                    = @trans_id

        where pree_id = @pree_id and preei_id = @preei_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin
    
    delete PresupuestoEnvioItem 
            where exists (select preei_id 
                          from PresupuestoEnvioItemBorradoTMP 
                          where pree_id     = @pree_id 
                            and preeTMP_id  = @@preeTMP_id
                            and preei_id     = PresupuestoEnvioItem.preei_id
                          )
    if @@error <> 0 goto ControlError

    delete PresupuestoEnvioItemBorradoTMP where pree_id = @pree_id and preeTMP_id  = @@preeTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        GASTOS                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  set @orden = 1
  while exists(select preeg_orden from PresupuestoEnvioGastoTMP where preeTMP_id = @@preeTMP_id and preeg_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @preeg_id                      = preeg_id,
            @preeg_orden                  = preeg_orden,
            @preeg_cantidad                = preeg_cantidad,
            @preeg_pendiente              = preeg_pendiente,
            @preeg_descrip                = preeg_descrip,
            @preeg_precio                  = preeg_precio,
            @preeg_precioTarifa            = preeg_precioTarifa,
            @preeg_neto                    = preeg_neto,
            @preeg_ivari                  = preeg_ivari,
            @preeg_ivarni                  = preeg_ivarni,
            @preeg_ivariporc              = preeg_ivariporc,
            @preeg_ivarniporc              = preeg_ivarniporc,
            @preeg_importe                = preeg_importe,
            @pr_id                        = pr_id,
            @ccos_id                      = ccos_id,
            @trfg_id                      = trfg_id,
            @trans_id                      = trans_id,
            @gto_id                        = gto_id

    from PresupuestoEnvioGastoTMP where preeTMP_id = @@preeTMP_id and preeg_orden = @orden

    if @IsNew <> 0 or @preeg_id = 0 begin

        exec SP_DBGetNewId 'PresupuestoEnvioGasto','preeg_id',@preeg_id out
        if @@error <> 0 goto ControlError

        insert into PresupuestoEnvioGasto (
                                      pree_id,
                                      preeg_id,
                                      preeg_orden,
                                      preeg_cantidad,
                                      preeg_pendiente,
                                      preeg_descrip,
                                      preeg_precio,
                                      preeg_precioTarifa,
                                      preeg_neto,
                                      preeg_ivari,
                                      preeg_ivarni,
                                      preeg_ivariporc,
                                      preeg_ivarniporc,
                                      preeg_importe,
                                      pr_id,
                                      ccos_id,
                                      trfg_id,
                                      trans_id,
                                      gto_id
                                )
                            Values(
                                      @pree_id,
                                      @preeg_id,
                                      @preeg_orden,
                                      @preeg_cantidad,
                                      @preeg_pendiente,
                                      @preeg_descrip,
                                      @preeg_precio,
                                      @preeg_precioTarifa,
                                      @preeg_neto,
                                      @preeg_ivari,
                                      @preeg_ivarni,
                                      @preeg_ivariporc,
                                      @preeg_ivarniporc,
                                      @preeg_importe,
                                      @pr_id,
                                      @ccos_id,
                                      @trfg_id,
                                      @trans_id,
                                      @gto_id
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

          update PresupuestoEnvioGasto set

                  pree_id                      = @pree_id,
                  preeg_orden                  = @preeg_orden,
                  preeg_cantidad              = @preeg_cantidad,
                  preeg_pendiente              = @preeg_pendiente,
                  preeg_descrip                = @preeg_descrip,
                  preeg_precio                = @preeg_precio,
                  preeg_precioTarifa          = @preeg_precioTarifa,
                  preeg_neto                  = @preeg_neto,
                  preeg_ivari                  = @preeg_ivari,
                  preeg_ivarni                = @preeg_ivarni,
                  preeg_ivariporc              = @preeg_ivariporc,
                  preeg_ivarniporc            = @preeg_ivarniporc,
                  preeg_importe                = @preeg_importe,
                  pr_id                        = @pr_id,
                  ccos_id                      = @ccos_id,
                  trfg_id                     = @trfg_id,
                  trans_id                    = @trans_id,
                  gto_id                      = @gto_id

        where pree_id = @pree_id and preeg_id = @preeg_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

  -- Hay que borrar los Gastos borrados del pedido
  if @IsNew = 0 begin
    
    delete PresupuestoEnvioGasto 
            where exists (select preeg_id 
                          from PresupuestoEnvioGastoBorradoTMP 
                          where pree_id     = @pree_id 
                            and preeTMP_id  = @@preeTMP_id
                            and preeg_id     = PresupuestoEnvioGasto.preeg_id
                          )
    if @@error <> 0 goto ControlError

    delete PresupuestoEnvioGastoBorradoTMP where pree_id = @pree_id and preeTMP_id = @@preeTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        TEMPORALES                                                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete PresupuestoEnvioItemTMP where preeTMP_id = @@preeTMP_id
  delete PresupuestoEnvioGastoTMP where preeTMP_id = @@preeTMP_id
  delete PresupuestoEnvioTMP where preeTMP_id = @@preeTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        CREDITO                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @pree_pendiente = sum(preei_pendiente) from PresupuestoEnvioItem where pree_id = @pree_id
  select @pree_pendiente = pree_total - @pree_pendiente from PresupuestoEnvio where pree_id = @pree_id

  update PresupuestoEnvio set pree_pendiente = @pree_pendiente where pree_id = @pree_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        TALONARIOS                                                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@pree_nrodoc
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ESTADO                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  exec sp_DocPresupuestoEnvioSetEstado @pree_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from PresupuestoEnvio where pree_id = @pree_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 15009, @pree_id, @modifico, 1
  else           exec sp_HistoriaUpdate 15009, @pree_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  select @pree_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar el presupuesto. sp_DocPresupuestoEnvioSave.', 16, 1)
  rollback transaction  

end