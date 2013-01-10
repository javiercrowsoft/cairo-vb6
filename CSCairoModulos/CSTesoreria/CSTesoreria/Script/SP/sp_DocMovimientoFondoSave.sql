if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoSave]

/*

 sp_DocMovimientoFondoSave 124

*/

go
create procedure sp_DocMovimientoFondoSave (
  @@mfTMP_id       int,
  @@bSelect        tinyint = 1,
  @@mf_id          int     = 0 out,
  @@bSuccess      tinyint = 0 out
)
as

begin

  set nocount on

  -- Antes que nada valido que este el centro de costo
  --

  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'Exigir Centro Costo',
                        @cfg_valor out,
                        0
  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    if exists(select ccos_id  from MovimientoFondoTMP where ccos_id is null and mfTMP_id = @@mfTMP_id)
    begin

      if exists(select ccos_id from MovimientoFondoItemTMP where ccos_id is null and mfTMP_id = @@mfTMP_id and mfi_tipo in (1,2,3,4))
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

    end
    
  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @mf_id          int
  declare @mfi_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @doct_id        int
  declare  @mf_total       decimal(18, 6)
  declare  @mf_fecha       datetime 

  set @@bSuccess = 0

  -- Si no existe chau
  if not exists (select mfTMP_id from MovimientoFondoTMP where mfTMP_id = @@mfTMP_id)
    return
  
  select @mf_id = mf_id from MovimientoFondoTMP where mfTMP_id = @@mfTMP_id
  
  set @mf_id = isnull(@mf_id,0)
  

  -- La moneda y el talonario siempre salen del documento 
  declare @mon_id         int
  declare @ta_id          int
  declare @emp_id          int

-- Talonario
  declare  @doc_id     int
  declare  @mf_nrodoc  varchar (50) 

  select @mon_id           = mon_id,
         @ta_id           = Documento.ta_id,
         @doct_id         = Documento.doct_id,
         @emp_id          = Documento.emp_id,
         @mf_total        = MovimientoFondoTMP.mf_total,
         @mf_fecha        = MovimientoFondoTMP.mf_fecha,

-- Talonario
         @mf_nrodoc = mf_nrodoc,
         @doc_id      = MovimientoFondoTMP.doc_id


  from MovimientoFondoTMP inner join Documento on MovimientoFondoTMP.doc_id = Documento.doc_id
  where mfTMP_id = @@mfTMP_id

  if IsNull(@ta_id,0) = 0 begin
    select col1 = 'ERROR', col2 = 'El documento no tiene definido su talonario.'
    return
  end

-- Campos de las tablas

declare  @mf_numero  int 
declare  @mf_descrip varchar (5000)
declare  @mf_totalorigen   decimal(18, 6)
declare @mf_cotizacion    decimal(18, 6)

declare  @mf_pendiente     decimal(18, 6)
declare @mf_grabarasiento tinyint

declare  @est_id     int
declare  @suc_id     int
declare  @cli_id     int
declare  @ccos_id    int
declare @lgj_id     int
declare @us_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @mfi_orden               smallint 
declare  @mfi_descrip             varchar (5000) 
declare @mfi_importe             decimal(18, 6)
declare @mfi_importeorigen      decimal(18, 6)
declare @mfi_importeorigenhaber  decimal(18, 6)
declare @mfi_tipo               tinyint
declare @cue_id_debe            int
declare @cue_id_haber           int
declare @chq_id                 int
declare @cheq_id                int
declare @cheq_numerodoc         varchar(100)
declare @cheq_fechaCobro        datetime
declare @cheq_fechaVto          datetime
declare @cheq_fecha2              datetime
declare @cle_id                 int
declare @bco_id                 int

declare @bSuccess               int

declare @MsgError  varchar(5000) set @MsgError = ''

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @mf_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'MovimientoFondo','mf_id',@mf_id out,0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'MovimientoFondo','mf_numero',@mf_numero out,0
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

              set @mf_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into MovimientoFondo (
                              mf_id,
                              mf_numero,
                              mf_nrodoc,
                              mf_descrip,
                              mf_fecha,
                              mf_total,
                              mf_totalorigen,
                              mf_grabarasiento,
                              mf_cotizacion,
                              mon_id,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              doct_id,
                              ccos_id,
                              lgj_id,
                              us_id,
                              modifico
                            )
      select
                              @mf_id,
                              @mf_numero,
                              @mf_nrodoc,
                              mf_descrip,
                              mf_fecha,
                              mf_total,
                              mf_totalorigen,
                              mf_grabarasiento,
                              mf_cotizacion,
                              @mon_id,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              @doct_id,
                              ccos_id,
                              lgj_id,
                              us_id,
                              modifico
      from MovimientoFondoTMP
      where mfTMP_id = @@mfTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @mf_nrodoc = mf_nrodoc from MovimientoFondo where mf_id = @mf_id
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        UPDATE                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  else begin

    --------------------------------------------------------------------------------------------
    declare @Message        varchar(8000)
    declare @bChequeUsado    tinyint
    declare @bCanDelete     tinyint
  
    -- Controlo que ningun cheque eliminado de  
    -- este movimiento de fondos este utilizado
    -- por otro movimiento de fondos o por una 
    -- orden de pago ya que si es asi, no puedo
    -- vincular este cheque con la cuenta
    -- mencionada en la cobranza, sino que debo:
    --
    --  1-  dar un error si esta usado en una orden de pago, 
    --  2-  dar un error si esta usado en un movimiento
    --      de fondo posterior,
    --  3-  asociarlo al movimiento de fondos inmediato anterior
    --      al movimiento que estoy borrando
  
    exec sp_DocMovimientoFondoItemCanDelete @mf_id,
                                            @@mfTMP_id,
                                            0, -- bIsDelete = False
                                            @Message out,
                                            @bChequeUsado out,
                                            @bCanDelete out
    if @@error <> 0 goto ControlError
    
    if @bCanDelete = 0 goto ChequeUsado
    --------------------------------------------------------------------------------------------

    set @IsNew = 0

    select
                              @mf_nrodoc              = mf_nrodoc,
                              @mf_descrip              = mf_descrip,
                              @mf_totalorigen          = mf_totalorigen,
                              @mf_cotizacion          = mf_cotizacion,
                              @mf_grabarasiento       = mf_grabarasiento,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @cli_id                  = cli_id,
                              @doc_id                  = doc_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                 = lgj_id,
                              @us_id                  = us_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from MovimientoFondoTMP 
    where 
          mfTMP_id = @@mfTMP_id
  
    update MovimientoFondo set 
                              mf_nrodoc              = @mf_nrodoc,
                              mf_descrip            = @mf_descrip,
                              mf_fecha              = @mf_fecha,
                              mf_total              = @mf_total,
                              mf_totalorigen        = @mf_totalorigen,
                              mf_cotizacion         = @mf_cotizacion,
                              mf_grabarasiento      = @mf_grabarasiento,
                              mon_id                = @mon_id,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              cli_id                = @cli_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lgj_id                = @lgj_id,
                              us_id                 = @us_id,
                              ccos_id                = @ccos_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where mf_id = @mf_id
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
  while exists(select mfi_orden from MovimientoFondoItemTMP where mfTMP_id = @@mfTMP_id and mfi_orden = @orden) 
  begin

    -- Cargo todo el registro de movimiento de fondo item en variables
    --
    select
            @mfi_id                      = mfi_id,
            @mfi_orden                  = mfi_orden,
            @mfi_descrip                = mfi_descrip,
            @mfi_importe                = mfi_importe,
            @mfi_importeorigen          = mfi_importeorigen,
            @mfi_importeorigenhaber      = mfi_importeorigenhaber,
            @ccos_id                    = ccos_id,
            @cue_id_debe                 = cue_id_debe,
            @cue_id_haber                = cue_id_haber,
            @mfi_tipo                    = mfi_tipo,
            @chq_id                      = chq_id,
            @cheq_id                    = cheq_id,
            @cheq_numerodoc             = mfiTMP_cheque,
            @cheq_fechaCobro            = mfiTMP_fechaCobro,
            @cheq_fechaVto              = mfiTMP_fechaVto,
            @cle_id                     = cle_id,
            @bco_id                     = bco_id

    from MovimientoFondoItemTMP where mfTMP_id = @@mfTMP_id and mfi_orden = @orden

    declare @MfiTChequesI tinyint set @MfiTChequesI = 7
    declare @CheqTercero  tinyint set @CheqTercero    = 2
    declare @cheq_numero  int

    -- Si este renglon es un ingreso de cheque 
    -- de tercero lo doy de alta en la tabla Cheque
    --
    if @mfi_tipo = @MfiTChequesI begin

      -- Si es nuevo Insert
      --
      if @cheq_id is null begin

        exec SP_DBGetNewId 'Cheque','cheq_id',@cheq_id out,0
        if @@error <> 0 goto ControlError

        exec SP_DBGetNewId 'Cheque','cheq_numero',@cheq_numero out,0
        if @@error <> 0 goto ControlError

        exec sp_DocGetFecha2 @cheq_fechaCobro,@cheq_fecha2 out, 1, @cle_id
        if @@error <> 0 goto ControlError

        insert into Cheque (
                              cheq_id,
                              cheq_numero,
                              cheq_numerodoc,
                              cheq_importe,
                              cheq_importeOrigen,
                              cheq_tipo,
                              cheq_fechaCobro,
                              cheq_fechaVto,
                              cheq_fecha2,
                              cheq_descrip,
                              mf_id,
                              cle_id,
                              bco_id,
                              cli_id,
                              cue_id,
                              mon_id,
                              emp_id
                            )
                    values  (
                              @cheq_id,
                              @cheq_numero,
                              @cheq_numerodoc,
                              @mfi_importe,
                              @mfi_importeOrigen,
                              @CheqTercero,
                              @cheq_fechaCobro,
                              @cheq_fechaVto,
                              @cheq_fecha2,
                              @mfi_descrip,
                              @mf_id,
                              @cle_id,
                              @bco_id,
                              @cli_id,
                              @cue_id_debe,
                              @mon_id,
                              @emp_id
                            )
      end else begin

        exec sp_DocGetFecha2 @cheq_fechaCobro,@cheq_fecha2 out, 1, @cle_id
        if @@error <> 0 goto ControlError

        -- Sino Update
        --
        update Cheque set 
                            cheq_numerodoc          = @cheq_numerodoc,
                            cheq_importe            = @mfi_importe,
                            cheq_importeOrigen      = @mfi_importeOrigen,
                            cheq_tipo                = @CheqTercero,
                            cheq_fechaCobro          = @cheq_fechaCobro,
                            cheq_fechaVto            = @cheq_fechaVto,
                            cheq_fecha2              = @cheq_fecha2,
                            cheq_descrip            = @mfi_descrip,
                            mf_id                    = @mf_id,
                            cle_id                  = @cle_id,
                            bco_id                  = @bco_id,
                            cli_id                  = @cli_id,
                            mon_id                  = @mon_id

        where cheq_id = @cheq_id

      end
    end

    -- Cheques
    --
    exec sp_DocOPMFChequeSave   @bSuccess out,
                                @mfi_tipo,
                                @cheq_id out,
                                @cheq_numerodoc,
                                @mfi_importe,
                                @mfi_importeOrigen,
                                @cheq_fechaCobro,
                                @cheq_fechaVto,
                                @mfi_descrip,
                                @chq_id,
                                null,
                                @mf_id,
                                null,
                                @cle_id,
                                @mon_id,
                                null,
                                @cue_id_debe

    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    if @IsNew <> 0 or @mfi_id = 0 begin

        exec SP_DBGetNewId 'MovimientoFondoItem','mfi_id',@mfi_id out,0
        if @@error <> 0 goto ControlError

        insert into MovimientoFondoItem (
                                      mf_id,
                                      mfi_id,
                                      mfi_orden,
                                      mfi_descrip,
                                      mfi_importe,
                                      mfi_importeorigen,
                                      mfi_importeorigenhaber,
                                      ccos_id,
                                      cue_id_debe,
                                      cue_id_haber,
                                      mfi_tipo,
                                      cheq_id,
                                      chq_id

                                )
                            Values(
                                      @mf_id,
                                      @mfi_id,
                                      @mfi_orden,
                                      @mfi_descrip,
                                      @mfi_importe,
                                      @mfi_importeorigen,
                                      @mfi_importeorigenhaber,
                                      @ccos_id,
                                      @cue_id_debe,
                                      @cue_id_haber,
                                      @mfi_tipo,
                                      @cheq_id,
                                      @chq_id
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

          update MovimientoFondoItem set

                  mf_id                      = @mf_id,
                  mfi_orden                  = @mfi_orden,
                  mfi_descrip                = @mfi_descrip,
                  mfi_importe                = @mfi_importe,
                  mfi_importeorigen          = @mfi_importeorigen,
                  mfi_importeorigenhaber    = @mfi_importeorigenhaber,
                  ccos_id                    = @ccos_id,
                  cue_id_debe                = @cue_id_debe,
                  cue_id_haber               = @cue_id_haber,
                  mfi_tipo                  = @mfi_tipo,
                  chq_id                    = @chq_id,
                  cheq_id                    = @cheq_id

        where mf_id = @mf_id and mfi_id = @mfi_id 
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
  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin

    exec sp_DocMovimientoFondoItemDelete   @mf_id,
                                          @@mfTMP_id,
                                          0, -- bIsDelete = False
                                          @bChequeUsado
    if @@error <> 0 goto ControlError

    delete MovimientoFondoItemBorradoTMP where mf_id = @mf_id and mfTMP_id = @@mfTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete MovimientoFondoItemTMP where mfTMP_id = @@mfTMP_id
  delete MovimientoFondoTMP where mfTMP_id = @@mfTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_TalonarioSet @ta_id,@mf_nrodoc
  if @@error <> 0 goto ControlError

  exec sp_DocMovimientoFondoSetEstado @mf_id
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
  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'MovimientoFondo-Grabar Asiento',
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    exec sp_DocMovimientoFondoAsientoSave @mf_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

  end else begin

    if not exists (select mf_id from MovimientoFondoAsiento where mf_id = @mf_id) begin
      insert into MovimientoFondoAsiento (mf_id,mf_fecha) 
             select mf_id,mf_fecha from MovimientoFondo 
              where mf_grabarAsiento <> 0 and mf_id = @mf_id
    end
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from MovimientoFondo where mf_id = @mf_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 18006, @mf_id, @modifico, 1
  else           exec sp_HistoriaUpdate 18006, @mf_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  set @@mf_id = @mf_id
  set @@bSuccess = 1

  if @@bSelect <> 0 select @mf_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar el movimiento de fondos. sp_DocMovimientoFondoSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

  return

ChequeUsado:
  
  raiserror (@Message, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

  return

end