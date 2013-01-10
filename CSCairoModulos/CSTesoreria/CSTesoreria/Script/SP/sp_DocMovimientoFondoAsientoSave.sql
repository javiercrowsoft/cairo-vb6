if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoAsientoSave]

/*
 select * from MovimientoFondo
 sp_DocMovimientoFondoAsientoSave 26

*/

go
create procedure sp_DocMovimientoFondoAsientoSave (
  @@mf_id           int,
  @@bRaiseError     smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
  @@bSelect         smallint     = 0
)
as

begin

  set nocount on

  declare @mfi_id          int
  declare @IsNew          smallint

  declare @as_id          int
  declare  @cli_id         int
  declare @doc_id_MovimientoFondo int

  set @@bError = 0

  -- Si no existe chau
  if not exists (select mf_id from MovimientoFondo where mf_id = @@mf_id and est_id <> 7)
    return

  select 
          @as_id                     = as_id, 
          @cli_id                   = cli_id, 
          @doc_id_MovimientoFondo   = doc_id

  from MovimientoFondo where mf_id = @@mf_id
  
  set @as_id = isnull(@as_id,0)
-- Campos de las tablas

declare  @as_numero  int 
declare  @as_nrodoc  varchar (50) 
declare  @as_descrip varchar (5000)
declare  @as_fecha   datetime 
declare  @mf_fecha   datetime 

declare  @doc_id     int
declare @ta_id      int
declare  @doct_id    int

declare @ccos_id_cliente int
declare  @ccos_id    int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @asi_orden               smallint 
declare  @asi_debe               decimal(18, 6) 
declare  @asi_haber               decimal(18, 6)
declare  @asi_origen             decimal(18, 6)
declare @mon_id                 int

declare  @mfi_orden               smallint 

declare @cue_id                          int
declare @cheq_id                        int
declare @doct_id_MovimientoFondo        int
declare @doc_id_cliente                 int

declare @as_doc_cliente         varchar(5000)

declare @bError      tinyint

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Obtengo el documento @doc_id
  select 
         @doc_id                   = doc_id_asiento, 
         @doct_id_MovimientoFondo = MovimientoFondo.doct_id, 
         @doc_id_cliente          = Documento.doc_id,
         @mon_id                   = Documento.mon_id,
         @ccos_id_cliente         = ccos_id,
         @as_doc_cliente          = mf_nrodoc + ' ' + IsNull(cli_nombre,'')

  from MovimientoFondo inner join Documento on MovimientoFondo.doc_id = Documento.doc_id
                       left  join Cliente   on MovimientoFondo.cli_id = Cliente.cli_id
  where mf_id = @@mf_id

  if @as_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'Asiento','as_id',@as_id out, 0
    exec SP_DBGetNewId 'Asiento','as_numero',@as_numero out, 0


    -- Obtengo el as_nrodoc
    declare @ta_ultimonro  int 
    declare @ta_mascara   varchar(50) 

    select @ta_ultimonro=ta_ultimonro, @ta_mascara=ta_mascara, @doct_id = doct_id
    from documento inner join talonario on documento.ta_id = talonario.ta_id 
    where doc_id = @doc_id

    set @ta_ultimonro = @ta_ultimonro + 1
    set @as_nrodoc = convert(varchar(50),@ta_ultimonro)
    set @as_nrodoc = substring(@ta_mascara,1,len(@ta_mascara) - len(@as_nrodoc)) + @as_nrodoc

    insert into Asiento (
                              as_id,
                              as_numero,
                              as_nrodoc,
                              as_descrip,
                              as_fecha,
                              as_doc_cliente,
                              doc_id,
                              doct_id,
                              doct_id_cliente,
                              doc_id_cliente,
                              id_cliente,
                              modifico
                            )
      select
                              @as_id,
                              @as_numero,
                              @as_nrodoc,
                              mf_descrip,
                              mf_fecha,
                              @as_doc_cliente,
                              @doc_id,
                              @doct_id,
                              @doct_id_MovimientoFondo,
                              @doc_id_cliente,
                              @@mf_id,
                              modifico
      from MovimientoFondo
      where mf_id = @@mf_id  

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
                              @as_descrip              = mf_descrip,
                              @as_fecha                = mf_fecha,
                              @modifico                = modifico,
                              @modificado             = modificado
    from MovimientoFondo 
    where 
          mf_id = @@mf_id

    select 
                              @doc_id                  = doc_id,
                              @doct_id                = doct_id
    from Asiento
    where 
          as_id = @as_id

    update Asiento set 
                              as_descrip            = @as_descrip,
                              as_fecha              = @as_fecha,
                              as_doc_cliente        = @as_doc_cliente,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              doct_id_cliente        = @doct_id_MovimientoFondo,
                              doc_id_cliente        =  @doc_id_cliente,
                              id_cliente            = @@mf_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where as_id = @as_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


  -- Borro todos los items y solo hago inserts que se mucho mas simple y rapido
  delete AsientoItem where as_id = @as_id

  set @asi_orden = 2

/*
///////////////////////////////////////////////////////////////
//
//           DEBE
//
///////////////////////////////////////////////////////////////
*/

  declare c_MovimientoFondoItemAsiento cursor for 

    select mfi_importe, mfi_importeorigen, cue_id_debe, ccos_id, cheq_id
    from MovimientoFondoItem 
    where mf_id = @@mf_id

  open c_MovimientoFondoItemAsiento

  fetch next from c_MovimientoFondoItemAsiento into @asi_debe, @asi_origen, @cue_id, @ccos_id, @cheq_id
  while @@fetch_status = 0 
  begin

    set  @asi_haber = 0

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,

                                            @cue_id,
                                            @ccos_id,
                                            @cheq_id,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_MovimientoFondoItemAsiento into @asi_debe, @asi_origen, @cue_id, @ccos_id, @cheq_id
  end -- While

  close c_MovimientoFondoItemAsiento
  deallocate c_MovimientoFondoItemAsiento

/*
///////////////////////////////////////////////////////////////
//
//           HABER
//
///////////////////////////////////////////////////////////////
*/

  declare c_MovimientoFondoItemAsiento cursor for 

    select mfi_importe, 
           case 
            when mfi_tipo = 2 then   mfi_importeorigenhaber 
            else                     mfi_importeorigen 
           end, 
           cue_id_haber, 
           ccos_id, 
           cheq_id
    from MovimientoFondoItem 
    where mf_id = @@mf_id

  open c_MovimientoFondoItemAsiento

  fetch next from c_MovimientoFondoItemAsiento into @asi_haber, @asi_origen, @cue_id, @ccos_id, @cheq_id
  while @@fetch_status = 0 
  begin

    set  @asi_debe = 0

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,

                                            @cue_id,
                                            @ccos_id,
                                            @cheq_id,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_MovimientoFondoItemAsiento into @asi_haber, @asi_origen, @cue_id, @ccos_id, @cheq_id
  end -- While

  close c_MovimientoFondoItemAsiento
  deallocate c_MovimientoFondoItemAsiento

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Valido el Asiento                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocAsientoValidate @as_id, @bError out, @@MsgError out
  if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Talonario                                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@as_nrodoc

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo el movimiento fondos con su asiento                                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  update MovimientoFondo set as_id = @as_id, mf_grabarasiento = 0 where mf_id = @@mf_id

  commit transaction

  set @@bError = 0

  if @@bSelect <> 0 select @as_id

  return
ControlError:

  set @@bError = -1

  if @@MsgError is not null set @@MsgError = @@MsgError + ';'

  set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar el movimiento de fondos. sp_DocMovimientoFondoAsientoSave.'

  if @@bRaiseError <> 0 begin
    raiserror (@@MsgError, 16, 1)
  end

  rollback transaction  

end