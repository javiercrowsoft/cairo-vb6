if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponAsientoSave]

/*
 select * from ResolucionCupon
 sp_DocResolucionCuponAsientoSave 1

*/

go
create procedure sp_DocResolucionCuponAsientoSave (
  @@rcup_id         int,
  @@bRaiseError     smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
  @@bSelect         smallint     = 0
)
as

begin

  set nocount on

  declare @rcupi_id              int
  declare @IsNew                smallint

  declare @as_id                int
  declare @doc_id_ResolucionCupon int

  set @@bError = 0

  -- Si no existe chau
  if not exists (select rcup_id from ResolucionCupon where rcup_id = @@rcup_id and est_id <> 7)
    return

  select 
          @as_id                     = as_id, 
          @doc_id_ResolucionCupon     = doc_id

  from ResolucionCupon where rcup_id = @@rcup_id
  
  set @as_id = isnull(@as_id,0)
-- Campos de las tablas

declare  @as_numero    int 
declare  @as_nrodoc    varchar (50) 
declare  @as_descrip   varchar (5000)
declare  @as_fecha     datetime 
declare  @rcup_fecha   datetime 

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

declare  @rcupi_orden               smallint 

declare @cue_id                      int
declare @doct_id_ResolucionCupon    int
declare @doc_id_cliente             int

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
         @doct_id_ResolucionCupon = ResolucionCupon.doct_id, 
         @doc_id_cliente          = Documento.doc_id,
         @as_doc_cliente          = rcup_nrodoc

  from ResolucionCupon inner join Documento on ResolucionCupon.doc_id = Documento.doc_id
  where rcup_id = @@rcup_id

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
                              rcup_descrip,
                              rcup_fecha,
                              @as_doc_cliente,
                              @doc_id,
                              @doct_id,
                              @doct_id_ResolucionCupon,
                              @doc_id_cliente,
                              @@rcup_id,
                              modifico
      from ResolucionCupon
      where rcup_id = @@rcup_id  

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
                              @as_descrip              = rcup_descrip,
                              @as_fecha                = rcup_fecha,
                              @modifico                = modifico,
                              @modificado             = modificado
    from ResolucionCupon 
    where 
          rcup_id = @@rcup_id

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
                              doct_id_cliente        = @doct_id_ResolucionCupon,
                              doc_id_cliente        =  @doc_id_cliente,
                              id_cliente            = @@rcup_id,
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

  --////////////////////////////////////////////////////////////
  -- Comision
  --
  declare c_ResolucionCuponItemAsiento cursor for 

      select sum(rcupi_comision), 
             sum(rcupi_comision / (rcupi_importe / rcupi_importeorigen)),
             rci.cue_id, 
             mon_id
      from ResolucionCuponItem rci inner join TarjetaCreditoCupon tjcc on rci.tjcc_id   = tjcc.tjcc_id
                                   inner join TarjetaCredito tjc       on tjcc.tjc_id   = tjc.tjc_id
  
      where rcup_id = @@rcup_id and rcupi_importeorigen <> 0
      group by    
              rci.cue_id, mon_id
    union
      select sum(rcupi_importe) - sum(rcupi_comision), 
             0,
             rci.cue_id, 
             mon_id
      from ResolucionCuponItem rci inner join TarjetaCreditoCupon tjcc on rci.tjcc_id   = tjcc.tjcc_id
                                   inner join TarjetaCredito tjc       on tjcc.tjc_id   = tjc.tjc_id
  
      where rcup_id = @@rcup_id and rcupi_importeorigen = 0
      group by    
              rci.cue_id, mon_id

  open c_ResolucionCuponItemAsiento

  set  @asi_haber = 0

  fetch next from c_ResolucionCuponItemAsiento into @asi_debe, @asi_origen, @cue_id, @mon_id
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
    fetch next from c_ResolucionCuponItemAsiento into @asi_debe, @asi_origen, @cue_id, @mon_id
  end -- While

  close c_ResolucionCuponItemAsiento
  deallocate c_ResolucionCuponItemAsiento


  --////////////////////////////////////////////////////////////
  -- Cobranza
  --
  declare c_ResolucionCuponItemAsiento cursor for 

      select sum(rcupi_importe) - sum(rcupi_comision), 
             sum(rcupi_importeorigen) - (sum(rcupi_comision / (rcupi_importe / rcupi_importeorigen))),
             ResolucionCuponItem.cue_id, 
             mon_id
      from ResolucionCuponItem inner join Cuenta on ResolucionCuponItem.cue_id = Cuenta.cue_id
  
      where rcup_id = @@rcup_id and rcupi_importeorigen <> 0
      group by    
              ResolucionCuponItem.cue_id, mon_id

    union

      select sum(rcupi_importe) - sum(rcupi_comision), 
             0,
             ResolucionCuponItem.cue_id, 
             mon_id
      from ResolucionCuponItem inner join Cuenta on ResolucionCuponItem.cue_id = Cuenta.cue_id
  
      where rcup_id = @@rcup_id and rcupi_importeorigen = 0
      group by    
              ResolucionCuponItem.cue_id, mon_id

  open c_ResolucionCuponItemAsiento

  set  @asi_haber = 0

  fetch next from c_ResolucionCuponItemAsiento into @asi_debe, @asi_origen, @cue_id, @mon_id
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
    fetch next from c_ResolucionCuponItemAsiento into @asi_debe, @asi_origen, @cue_id, @mon_id
  end -- While

  close c_ResolucionCuponItemAsiento
  deallocate c_ResolucionCuponItemAsiento

/*
///////////////////////////////////////////////////////////////
//
//           HABER
//
///////////////////////////////////////////////////////////////
*/

  declare c_ResolucionCuponItemAsiento cursor for 

    select sum(rcupi_importe), sum(rcupi_importeorigen), c.cue_id, mon_id
    from ResolucionCuponItem d inner join TarjetaCreditoCupon t on d.tjcc_id = t.tjcc_id
                             inner join CobranzaItem c        on t.tjcc_id = c.tjcc_id

    where rcup_id = @@rcup_id
    group by    
            c.cue_id, mon_id

  open c_ResolucionCuponItemAsiento

  set  @asi_debe = 0

  fetch next from c_ResolucionCuponItemAsiento into @asi_haber, @asi_origen, @cue_id, @mon_id
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
    fetch next from c_ResolucionCuponItemAsiento into @asi_haber, @asi_origen, @cue_id, @mon_id
  end -- While

  close c_ResolucionCuponItemAsiento
  deallocate c_ResolucionCuponItemAsiento

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
//                                Vinculo la resolucion de cupones con su asiento                                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  update ResolucionCupon set as_id = @as_id, rcup_grabarasiento = 0 where rcup_id = @@rcup_id

  commit transaction

  set @@bError = 0

  if @@bSelect <> 0 select @as_id

  return
ControlError:

  set @@bError = -1

  if @@MsgError is not null set @@MsgError = @@MsgError + ';'

  set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la resolucion de cupones. sp_DocResolucionCuponAsientoSave.'

  if @@bRaiseError <> 0 begin
    raiserror (@@MsgError, 16, 1)
  end

  rollback transaction  

end