if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoSave]

/*

 sp_DocDepositoBancoSave 124

*/

go
create procedure sp_DocDepositoBancoSave (
  @@dbcoTMP_id       int,
  @@bSelect          tinyint = 1,
  @@dbco_id          int     = 0 out,
  @@bSuccess        tinyint = 0 out
)
as

begin

  set nocount on

  declare @dbco_id          int
  declare @dbcoi_id          int
  declare @IsNew            smallint
  declare @orden            smallint
  declare  @doct_id          int
  declare  @dbco_total       decimal(18, 6)
  declare  @dbco_fecha       datetime 
  declare  @cue_id_banco     int

  set @@bSuccess = 0

  -- Si no existe chau
  if not exists (select dbcoTMP_id from DepositoBancoTMP where dbcoTMP_id = @@dbcoTMP_id)
    return
  
  select @dbco_id = dbco_id from DepositoBancoTMP where dbcoTMP_id = @@dbcoTMP_id
  
  set @dbco_id = isnull(@dbco_id,0)
  

  -- La moneda y el talonario siempre salen del documento 
  declare @ta_id          int

-- Talonario
  declare  @doc_id     int
  declare  @dbco_nrodoc  varchar (50) 

  select @ta_id             = Documento.ta_id,
         @doct_id           = Documento.doct_id,
         @dbco_total        = DepositoBancoTMP.dbco_total,
         @dbco_fecha        = DepositoBancoTMP.dbco_fecha,
         @cue_id_banco      = DepositoBancoTMP.cue_id,

-- Talonario
         @dbco_nrodoc = dbco_nrodoc,
         @doc_id      = DepositoBancoTMP.doc_id

  from DepositoBancoTMP inner join Documento on DepositoBancoTMP.doc_id = Documento.doc_id
  where dbcoTMP_id = @@dbcoTMP_id

  if IsNull(@ta_id,0) = 0 begin
    select col1 = 'ERROR', col2 = 'El documento no tiene definido su talonario.'
    return
  end

declare @bSuccess  int

-- Campos de las tablas

declare  @dbco_numero  int 
declare  @dbco_descrip varchar (5000)
declare  @dbco_totalorigen   decimal(18, 6)
declare @dbco_cotizacion    decimal(18, 6)

declare @dbco_grabarasiento tinyint

declare  @est_id     int
declare  @suc_id     int
declare  @bco_id     int
declare  @cue_id     int
declare @lgj_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare @chq_id                 int
declare @cheq_id                int
declare @cheq_numerodoc         varchar(100)
declare @cheq_fechaCobro        datetime
declare @cheq_fechaVto          datetime
declare @cheq_fecha2              datetime
declare @cle_id                 int
declare @mon_id                  int

declare @dbcoi_tipo             tinyint
declare  @dbcoi_orden             smallint 
declare  @dbcoi_descrip           varchar (5000) 
declare @dbcoi_importe           decimal(18, 6)
declare @dbcoi_importeorigen    decimal(18, 6)

declare @MsgError  varchar(5000) set @MsgError = ''

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @dbco_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'DepositoBanco','dbco_id',@dbco_id out, 0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'DepositoBanco','dbco_numero',@dbco_numero out, 0
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

              set @dbco_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into DepositoBanco (
                              dbco_id,
                              dbco_numero,
                              dbco_nrodoc,
                              dbco_descrip,
                              dbco_fecha,
                              dbco_total,
                              dbco_totalorigen,
                              dbco_grabarasiento,
                              dbco_cotizacion,
                              est_id,
                              suc_id,
                              bco_id,
                              doc_id,
                              doct_id,
                              cue_id,
                              lgj_id,
                              modifico
                            )
      select
                              @dbco_id,
                              @dbco_numero,
                              @dbco_nrodoc,
                              dbco_descrip,
                              dbco_fecha,
                              dbco_total,
                              dbco_totalorigen,
                              dbco_grabarasiento,
                              dbco_cotizacion,
                              est_id,
                              suc_id,
                              bco_id,
                              doc_id,
                              @doct_id,
                              @cue_id_banco,
                              lgj_id,
                              modifico
      from DepositoBancoTMP
      where dbcoTMP_id = @@dbcoTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @dbco_nrodoc = dbco_nrodoc from DepositoBanco where dbco_id = @dbco_id
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
                              @dbco_id                   = dbco_id,
                              @dbco_nrodoc              = dbco_nrodoc,
                              @dbco_descrip              = dbco_descrip,
                              @dbco_totalorigen          = dbco_totalorigen,
                              @dbco_cotizacion          = dbco_cotizacion,
                              @dbco_grabarasiento       = dbco_grabarasiento,
                              @est_id                    = est_id,
                              @suc_id                    = suc_id,
                              @bco_id                    = bco_id,
                              @doc_id                    = doc_id,
                              @lgj_id                   = lgj_id,
                              @modifico                  =  modifico,
                              @modificado               = modificado
    from DepositoBancoTMP 
    where 
          dbcoTMP_id = @@dbcoTMP_id
  
    update DepositoBanco set 
                              dbco_nrodoc              = @dbco_nrodoc,
                              dbco_descrip            = @dbco_descrip,
                              dbco_fecha              = @dbco_fecha,
                              dbco_total              = @dbco_total,
                              dbco_totalorigen        = @dbco_totalorigen,
                              dbco_cotizacion         = @dbco_cotizacion,
                              dbco_grabarasiento      = @dbco_grabarasiento,
                              est_id                  =  @est_id,
                              suc_id                  = @suc_id,
                              bco_id                  = @bco_id,
                              doc_id                  = @doc_id,
                              doct_id                  = @doct_id,
                              lgj_id                  = @lgj_id,
                              cue_id                  = @cue_id_banco,
                              modifico                = @modifico,
                              modificado              = @modificado
  
    where dbco_id = @dbco_id
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
  while exists(select dbcoi_orden from DepositoBancoItemTMP where dbcoTMP_id = @@dbcoTMP_id and dbcoi_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @dbcoi_id                      = dbcoi_id,
            @dbcoi_orden                  = dbcoi_orden,
            @dbcoi_descrip                = dbcoi_descrip,
            @dbcoi_importe                = dbcoi_importe,
            @dbcoi_importeorigen          = dbcoi_importeorigen,
            @cue_id                       = cue_id,
            @dbcoi_tipo                    = dbcoi_tipo,

            @chq_id                      = chq_id,
            @cheq_id                    = cheq_id,
            @cheq_numerodoc             = dbcoiTMP_cheque,
            @cheq_fechaCobro            = dbcoiTMP_fechaCobro,
            @cheq_fechaVto              = dbcoiTMP_fechaVto,
            @cle_id                     = cle_id

    from DepositoBancoItemTMP where dbcoTMP_id = @@dbcoTMP_id and dbcoi_orden = @orden

    if not exists (select * from DepositoBancoItem dbcoi 
                                inner join DepositoBanco dbco 
                                        on dbcoi.dbco_id = dbco.dbco_id
                    where cheq_id = @cheq_id 
                      and dbco.dbco_id <> @dbco_id 
                      and dbco.est_id <>7) 
    begin

      if @dbcoi_tipo = 1 begin

        select @mon_id = mon_id from Cuenta where cue_id = @cue_id
  
        -- Cheques
        --
        exec sp_DocOPMFChequeSave   @bSuccess out,
                                    @dbcoi_tipo,
                                    @cheq_id out,
                                    @cheq_numerodoc,
                                    @dbcoi_importe,
                                    @dbcoi_importeOrigen,
                                    @cheq_fechaCobro,
                                    @cheq_fechaVto,
                                    @dbcoi_descrip,
                                    @chq_id,
                                    null,
                                    null,
                                    @dbco_id,
                                    @cle_id,
                                    @mon_id,
                                    null,
                                    @cue_id
  
        -- Si fallo al guardar
        if IsNull(@bSuccess,0) = 0 goto ControlError

      end

      if @IsNew <> 0 or @dbcoi_id = 0 begin

          exec SP_DBGetNewId 'DepositoBancoItem','dbcoi_id',@dbcoi_id out, 0
          if @@error <> 0 goto ControlError

          insert into DepositoBancoItem (
                                        dbco_id,
                                        dbcoi_id,
                                        dbcoi_orden,
                                        dbcoi_descrip,
                                        dbcoi_importe,
                                        dbcoi_importeorigen,
                                        dbcoi_tipo,
                                        cheq_id,
                                        cue_id,
                                        chq_id
                                  )
                              Values(
                                        @dbco_id,
                                        @dbcoi_id,
                                        @dbcoi_orden,
                                        @dbcoi_descrip,
                                        @dbcoi_importe,
                                        @dbcoi_importeorigen,
                                        @dbcoi_tipo,
                                        @cheq_id,
                                        @cue_id,
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
  
            update DepositoBancoItem set
  
                    dbco_id                      = @dbco_id,
                    dbcoi_orden                  = @dbcoi_orden,
                    dbcoi_descrip                = @dbcoi_descrip,
                    dbcoi_importe                = @dbcoi_importe,
                    dbcoi_importeorigen          = @dbcoi_importeorigen,
                    dbcoi_tipo                  = @dbcoi_tipo,
                    cheq_id                      = @cheq_id,
                    cue_id                      = @cue_id,
                    chq_id                      = @chq_id
  
          where dbco_id = @dbco_id and dbcoi_id = @dbcoi_id 
          if @@error <> 0 goto ControlError
      end -- Update

    end

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     CHEQUE                                                                         //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  update cheque set cue_id = @cue_id_banco 
    where cheq_id in (select cheq_id from DepositoBancoItem where dbco_id = @dbco_id)

  if @@error <> 0 goto ControlError
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ITEMS BORRADOS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar los items borrados del deposito bancario
  if @IsNew = 0 begin
    
    -- Hay dos situaciones a resolver con los cheques
    --
    -- 1- Devolver a la cuenta mencionada en el ultimo 
    --    movimiento de fondos que menciono al cheque
    --
    -- 2- Devolver a documentos en cartera los cheques
    --    ingresados por una cobranza
  
    -- Devuelvo a documentos en cartera los cheques de tercero
    update Cheque set cue_id = mfi.cue_id_debe
    from MovimientoFondoItem mfi
    where Cheque.cheq_id = mfi.cheq_id
      and Cheque.mf_id   = mfi.mf_id
      and exists(select cheq_id 
                 from DepositoBancoItemBorradoTMP dbcoit  
                        inner join DepositoBancoItem dbcoi on dbcoit.dbcoi_id = dbcoi.dbcoi_id
                 where dbcoi.dbco_id = @@dbco_id
                   and dbcoTMP_id    = @@dbcoTMP_id
                   and dbcoi.cheq_id = Cheque.cheq_id 
                )
    if @@error <> 0 goto ControlError
  
    -- Devuelvo a documentos en cartera los cheques de tercero
    update Cheque set cue_id = cobzi.cue_id
    from CobranzaItem cobzi
    where cobzi.cheq_id = Cheque.cheq_id 
      and Cheque.mf_id  is null
      and exists(select cheq_id 
                 from DepositoBancoItemBorradoTMP dbcoit  
                        inner join DepositoBancoItem dbcoi on dbcoit.dbcoi_id = dbcoi.dbcoi_id
                 where dbcoi.dbco_id = @@dbco_id
                   and dbcoTMP_id    = @@dbcoTMP_id
                   and dbcoi.cheq_id = Cheque.cheq_id 
                )
    if @@error <> 0 goto ControlError


    -- Por ultimo borro los cheques que se crearon en este deposito
    --    
    update DepositoBancoItem set cheq_id = null 
    where cheq_id in (select cheq_id from cheque where dbco_id = @dbco_id)
      and exists (select dbcoi_id 
                  from DepositoBancoItemBorradoTMP 
                  where dbco_id     = @dbco_id 
                    and dbcoTMP_id  = @@dbcoTMP_id
                    and dbcoi_id     = DepositoBancoItem.dbcoi_id
                  )
    if @@error <> 0 goto ControlError
  
    delete Cheque 
    where dbco_id = @dbco_id 
      and not exists(select * from DepositoBancoItem 
                     where dbco_id = @dbco_id 
                      and cheq_id = Cheque.cheq_id
                    )
    if @@error <> 0 goto ControlError
    -----------------------------------------------------------------------------------------------------------------

    -- Finalmente borro los items
    --    
    delete DepositoBancoItem 
            where exists (select dbcoi_id 
                          from DepositoBancoItemBorradoTMP 
                          where dbco_id     = @dbco_id 
                            and dbcoTMP_id  = @@dbcoTMP_id
                            and dbcoi_id     = DepositoBancoItem.dbcoi_id
                          )
    if @@error <> 0 goto ControlError

    -- Chau temporal
    delete DepositoBancoItemBorradoTMP where dbco_id = @dbco_id and dbcoTMP_id = @@dbcoTMP_id
    if @@error <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete DepositoBancoItemTMP where dbcoTMP_id = @@dbcoTMP_id
  delete DepositoBancoTMP where dbcoTMP_id = @@dbcoTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_TalonarioSet @ta_id,@dbco_nrodoc
  if @@error <> 0 goto ControlError

  exec sp_DocDepositoBancoSetEstado @dbco_id
  if @@error <> 0 goto ControlError

  declare @cfg_valor varchar(5000) 
  declare @bError    smallint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'DepositoBanco-Grabar Asiento',
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    exec sp_DocDepositoBancoAsientoSave @dbco_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

  end else begin

    if not exists (select dbco_id from DepositoBancoAsiento where dbco_id = @dbco_id) begin
      insert into DepositoBancoAsiento (dbco_id,dbco_fecha) 
             select dbco_id,dbco_fecha from DepositoBanco 
              where dbco_grabarAsiento <> 0 and dbco_id = @dbco_id
    end
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from DepositoBanco where dbco_id = @dbco_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 18007, @dbco_id, @modifico, 1
  else           exec sp_HistoriaUpdate 18007, @dbco_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  set @@dbco_id = @dbco_id
  set @@bSuccess = 1

  if @@bSelect <> 0 select @dbco_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar el deposito bancario. sp_DocDepositoBancoSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end