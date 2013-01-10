if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaSave]

/*

 exec sp_DocManifiestoCargaSave 2

*/

go
create procedure sp_DocManifiestoCargaSave (
  @@mfcTMP_id int
)
as

begin

  set nocount on

  declare @mfc_id          int
  declare @mfci_id        int
  declare @IsNew          smallint
  declare @orden          smallint

  -- Si no existe chau
  if not exists (select mfc_id from ManifiestoCargaTMP where mfcTMP_id = @@mfcTMP_id)
    return

-- Talonario
  declare  @doc_id       int
  declare  @mfc_nrodoc   varchar (50) 
  
  select @mfc_id = mfc_id,

-- Talonario
         @mfc_nrodoc  = mfc_nrodoc,
         @doc_id       = doc_id 
        
  from ManifiestoCargaTMP where mfcTMP_id = @@mfcTMP_id
  
  set @mfc_id = isnull(@mfc_id,0)

-- Campos de las tablas

declare  @mfc_numero    int 
declare  @mfc_descrip   varchar (5000)
declare  @mfc_fecha         datetime 
declare  @mfc_fechadoc      datetime 
declare @mfc_horapartida  datetime
declare  @mfc_pendiente decimal(18, 6)
declare @mfc_cantidad  decimal(18, 6)
declare @mfciTMP_id    int

declare  @est_id     int
declare  @suc_id     int
declare  @cli_id     int
declare @ta_id      int
declare  @doct_id    int
declare  @trans_id   int 
declare  @chof_id    int 
declare  @cmarc_id   int
declare  @ccos_id    int
declare  @pue_id_origen            int
declare  @pue_id_destino            int
declare  @depl_id_origen            int
declare  @depl_id_destino          int
declare  @barc_id                  int

declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @mfci_orden               smallint 
declare  @mfci_cantidad             decimal(18, 6) 
declare  @mfci_pendiente           decimal(18, 6) 
declare  @mfci_descrip             varchar (5000) 
declare  @mfci_pallets             decimal(18, 6) 
declare  @mfci_nropallet           varchar(100)
declare  @pr_id                     int


  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @mfc_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'ManifiestoCarga','mfc_id',@mfc_id out
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'ManifiestoCarga','mfc_numero',@mfc_numero out
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

              set @mfc_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into ManifiestoCarga (
                              mfc_id,
                              mfc_numero,
                              mfc_nrodoc,
                              mfc_descrip,
                              mfc_fecha,
                              mfc_fechadoc,
                              mfc_horapartida,
                              mfc_cantidad,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              doct_id,
                              trans_id,
                              chof_id,
                              cmarc_id,
                              pue_id_origen,
                              pue_id_destino,
                              depl_id_origen,
                              depl_id_destino,
                              barc_id,
                              ccos_id,
                              modifico
                            )
      select
                              @mfc_id,
                              @mfc_numero,
                              @mfc_nrodoc,
                              mfc_descrip,
                              mfc_fecha,
                              mfc_fechadoc,
                              mfc_horapartida,
                              mfc_cantidad,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              doct_id,
                              trans_id,
                              chof_id,
                              cmarc_id,
                              pue_id_origen,
                              pue_id_destino,
                              depl_id_origen,
                              depl_id_destino,
                              barc_id,
                              ccos_id,
                              modifico
      from ManifiestoCargaTMP
      where mfcTMP_id = @@mfcTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @mfc_nrodoc = mfc_nrodoc from ManifiestoCarga where mfc_id = @mfc_id
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
                              @mfc_id                   = mfc_id,
                              @mfc_nrodoc                = mfc_nrodoc,
                              @mfc_descrip              = mfc_descrip,
                              @mfc_fecha                = mfc_fecha,
                              @mfc_fechadoc              = mfc_fechadoc,
                              @mfc_horapartida          = mfc_horapartida,
                              @mfc_cantidad             = mfc_cantidad,
                              @est_id                    = est_id,
                              @suc_id                    = suc_id,
                              @cli_id                    = cli_id,
                              @doc_id                    = doc_id,
                              @doct_id                  = doct_id,
                              @trans_id                  = trans_id,
                              @chof_id                  = chof_id,
                              @cmarc_id                  = cmarc_id,

                              @pue_id_origen            = pue_id_origen,
                              @pue_id_destino            = pue_id_destino,
                              @depl_id_origen            = depl_id_origen,
                              @depl_id_destino          = depl_id_destino,
                              @barc_id                  = barc_id,

                              @ccos_id                  = ccos_id,
                              @modifico                  = modifico,
                              @modificado               = modificado
    from ManifiestoCargaTMP 
    where 
          mfcTMP_id = @@mfcTMP_id
  
    update ManifiestoCarga set 
                              mfc_nrodoc              = @mfc_nrodoc,
                              mfc_descrip              = @mfc_descrip,
                              mfc_fecha                = @mfc_fecha,
                              mfc_fechadoc            = @mfc_fechadoc,
                              mfc_horapartida         = @mfc_horapartida,
                              mfc_cantidad            = @mfc_cantidad,
                              est_id                  = @est_id,
                              suc_id                  = @suc_id,
                              cli_id                  = @cli_id,
                              doc_id                  = @doc_id,
                              doct_id                  = @doct_id,
                              trans_id                = @trans_id,
                              chof_id                  = @chof_id,
                              cmarc_id                = @cmarc_id,
                              pue_id_origen            = @pue_id_origen,
                              pue_id_destino          = @pue_id_destino,
                              depl_id_origen          = @depl_id_origen,
                              depl_id_destino          = @depl_id_destino,
                              barc_id                  = @barc_id,
                              ccos_id                  = @ccos_id,
                              modifico                = @modifico,
                              modificado              = @modificado
  
    where mfc_id = @mfc_id
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
  while exists(select mfci_orden from ManifiestoCargaItemTMP where mfcTMP_id = @@mfcTMP_id and mfci_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @mfci_id                    = mfci_id,
            @mfci_orden                  = mfci_orden,
            @mfci_cantidad              = mfci_cantidad,
            @mfci_pendiente              = mfci_pendiente,
            @mfci_descrip                = mfci_descrip,
            @mfci_pallets                = mfci_pallets,
            @mfci_nropallet              = mfci_nropallet,
            @pr_id                      = pr_id,
            @ccos_id                    = ccos_id,
            @mfciTMP_id                 = mfciTMP_id

    from ManifiestoCargaItemTMP where mfcTMP_id = @@mfcTMP_id and mfci_orden = @orden

    if @IsNew <> 0 or @mfci_id = 0 begin

        exec SP_DBGetNewId 'ManifiestoCargaItem','mfci_id',@mfci_id out
        if @@error <> 0 goto ControlError

        insert into ManifiestoCargaItem (
                                      mfc_id,
                                      mfci_id,
                                      mfci_orden,
                                      mfci_cantidad,
                                      mfci_pendiente,
                                      mfci_descrip,
                                      mfci_pallets,
                                      mfci_nropallet,
                                      pr_id,
                                      ccos_id
                                )
                            Values(
                                      @mfc_id,
                                      @mfci_id,
                                      @mfci_orden,
                                      @mfci_cantidad,
                                      @mfci_pendiente,
                                      @mfci_descrip,
                                      @mfci_pallets,
                                      @mfci_nropallet,
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

          update ManifiestoCargaItem set

                  mfc_id                      = @mfc_id,
                  mfci_orden                  = @mfci_orden,
                  mfci_cantidad                = @mfci_cantidad,
                  mfci_pendiente              = @mfci_pendiente,
                  mfci_descrip                = @mfci_descrip,
                  mfci_pallets                = @mfci_pallets,
                  mfci_nropallet              = @mfci_nropallet,
                  pr_id                        = @pr_id,
                  ccos_id                      = @ccos_id

        where mfc_id = @mfc_id and mfci_id = @mfci_id 
        if @@error <> 0 goto ControlError
    end -- Update

    update ManifiestoCargaItemTMP set mfci_id = @mfci_id where mfciTMP_id = @mfciTMP_id

    set @orden = @orden + 1
  end -- While

  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin
    
    delete ManifiestoCargaItem 
            where exists (select mfci_id 
                          from ManifiestoCargaItemBorradoTMP 
                          where mfc_id     = @mfc_id 
                            and mfcTMP_id  = @@mfcTMP_id
                            and mfci_id   = ManifiestoCargaItem.mfci_id
                          )
    if @@error <> 0 goto ControlError

    delete ManifiestoCargaItemBorradoTMP where mfc_id = @mfc_id and mfcTMP_id = @@mfcTMP_id

  end

  exec sp_DocManifiestoCargaUpdateEx @@mfcTMP_id, @mfc_id
  if @@error <> 0 goto ControlError

  delete ManifiestoCargaItemTMP where mfcTMP_id = @@mfcTMP_id
  delete ManifiestoCargaTMP where mfcTMP_id = @@mfcTMP_id

  select @mfc_pendiente = sum(mfci_pendiente) from ManifiestoCargaItem where mfc_id = @mfc_id

  update ManifiestoCarga set mfc_pendiente = IsNull(@mfc_pendiente,0) where mfc_id = @mfc_id
  if @@error <> 0 goto ControlError

  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@mfc_nrodoc
  if @@error <> 0 goto ControlError

  exec sp_DocManifiestoCargaSetEstado @mfc_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from ManifiestoCarga where mfc_id = @mfc_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 22006, @mfc_id, @modifico, 1
  else           exec sp_HistoriaUpdate 22006, @mfc_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  select @mfc_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar el manifiesto de carga. sp_DocManifiestoCargaSave.', 16, 1)
  rollback transaction  

end