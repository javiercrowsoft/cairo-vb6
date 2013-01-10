if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponAsientoSave]

/*
 select * from DepositoCupon
 sp_DocDepositoCuponAsientoSave 1

*/

go
create procedure sp_DocDepositoCuponAsientoSave (
  @@dcup_id           int,
  @@bRaiseError     smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
  @@bSelect         smallint     = 0
)
as

begin

  set nocount on

  declare @dcupi_id              int
  declare @IsNew                smallint

  declare @as_id                int
  declare @doc_id_DepositoCupon int

  set @@bError = 0

  -- Si no existe chau
  if not exists (select dcup_id from DepositoCupon where dcup_id = @@dcup_id and est_id <> 7)
    return

  select 
          @as_id                     = as_id, 
          @doc_id_DepositoCupon     = doc_id

  from DepositoCupon where dcup_id = @@dcup_id
  
  set @as_id = isnull(@as_id,0)
-- Campos de las tablas

declare  @as_numero    int 
declare  @as_nrodoc    varchar (50) 
declare  @as_descrip   varchar (5000)
declare  @as_fecha     datetime 
declare  @dcup_fecha   datetime 

declare  @doc_id     int
declare @ta_id      int
declare  @doct_id    int

declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @asi_orden               smallint 
declare  @asi_debe               decimal(18, 6) 
declare  @asi_haber               decimal(18, 6)
declare  @asi_origen             decimal(18, 6)
declare @mon_id                 int

declare  @dcupi_orden               smallint 

declare @cue_id                        int
declare @doct_id_DepositoCupon        int
declare @doc_id_cliente               int

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
         @doct_id_DepositoCupon   = DepositoCupon.doct_id, 
         @doc_id_cliente          = Documento.doc_id,
         @as_doc_cliente          = dcup_nrodoc

  from DepositoCupon inner join Documento on DepositoCupon.doc_id = Documento.doc_id
  where dcup_id = @@dcup_id

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
                              dcup_descrip,
                              dcup_fecha,
                              @as_doc_cliente,
                              @doc_id,
                              @doct_id,
                              @doct_id_DepositoCupon,
                              @doc_id_cliente,
                              @@dcup_id,
                              modifico
      from DepositoCupon
      where dcup_id = @@dcup_id  

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
                              @as_descrip              = dcup_descrip,
                              @as_fecha                = dcup_fecha,
                              @modifico                = modifico,
                              @modificado             = modificado
    from DepositoCupon 
    where 
          dcup_id = @@dcup_id

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
                              doct_id_cliente        = @doct_id_DepositoCupon,
                              doc_id_cliente        =  @doc_id_cliente,
                              id_cliente            = @@dcup_id,
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

  set @asi_orden = 1

/*
///////////////////////////////////////////////////////////////
//
//           DEBE
//
///////////////////////////////////////////////////////////////
*/

  declare c_DepositoCuponItemAsiento cursor for 

    select sum(dcupi_importe), sum(dcupi_importeorigen), DepositoCuponItem.cue_id, mon_id
    from DepositoCuponItem inner join Cuenta on DepositoCuponItem.cue_id = Cuenta.cue_id

    where dcup_id = @@dcup_id
    group by    
            DepositoCuponItem.cue_id, mon_id

  open c_DepositoCuponItemAsiento

  set  @asi_haber = 0

  fetch next from c_DepositoCuponItemAsiento into @asi_debe, @asi_origen, @cue_id, @mon_id
  while @@fetch_status = 0 
  begin

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
                                            null,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_DepositoCuponItemAsiento into @asi_debe, @asi_origen, @cue_id, @mon_id
  end -- While

  close c_DepositoCuponItemAsiento
  deallocate c_DepositoCuponItemAsiento

/*
///////////////////////////////////////////////////////////////
//
//           HABER
//
///////////////////////////////////////////////////////////////
*/

  declare c_DepositoCuponItemAsiento cursor for 

    select sum(dcupi_importe), sum(dcupi_importeorigen), c.cue_id, mon_id
    from DepositoCuponItem d inner join TarjetaCreditoCupon t on d.tjcc_id = t.tjcc_id
                             inner join CobranzaItem c        on t.tjcc_id = c.tjcc_id

    where dcup_id = @@dcup_id
    group by    
            c.cue_id, mon_id

  open c_DepositoCuponItemAsiento

  set  @asi_debe = 0

  fetch next from c_DepositoCuponItemAsiento into @asi_haber, @asi_origen, @cue_id, @mon_id
  while @@fetch_status = 0 
  begin
  
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
                                            null,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError
  
    set @asi_orden = @asi_orden + 1
    fetch next from c_DepositoCuponItemAsiento into @asi_haber, @asi_origen, @cue_id, @mon_id
  end -- While

  close c_DepositoCuponItemAsiento
  deallocate c_DepositoCuponItemAsiento

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
//                                Vinculo la presentacion de cupones con su asiento                                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  update DepositoCupon set as_id = @as_id, dcup_grabarasiento = 0 where dcup_id = @@dcup_id

  commit transaction

  set @@bError = 0

  if @@bSelect <> 0 select @as_id

  return
ControlError:

  set @@bError = -1

  if @@MsgError is not null set @@MsgError = @@MsgError + ';;'

  set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la presentacion de cupones. sp_DocDepositoCuponAsientoSave.'

  if @@bRaiseError <> 0 begin
    raiserror (@@MsgError, 16, 1)
  end

  rollback transaction  

end