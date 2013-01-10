if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaAsientoSave]

/*

  -- Tipos de items:
                      Cheques = 1
                      Efectivo = 2
                      Tarjeta = 3
                      Otros = 4
                      CtaCte = 5

  -- Tipos de otros en items:
                              Debe = 1
                              Haber = 2

 select * from Cobranza
 sp_DocCobranzaAsientoSave 26

*/

go
create procedure sp_DocCobranzaAsientoSave (
  @@cobz_id           int,
  @@bRaiseError     smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
  @@bSelect         smallint     = 0
)
as

begin

  set nocount on

  declare @IsNew          smallint

  declare @as_id           int
  declare  @cli_id          int
  declare @doc_id_cobranza int

  set @@bError = 0

  -- Si no existe chau
  if not exists (select cobz_id from Cobranza where cobz_id = @@cobz_id and est_id <> 7)
    return
  
  select 
          @as_id             = as_id, 
          @cli_id           = cli_id, 
          @doc_id_cobranza   = doc_id

  from Cobranza where cobz_id = @@cobz_id
  
  set @as_id = isnull(@as_id,0)

-- Campos de las tablas

declare  @as_numero    int 
declare  @as_nrodoc    varchar (50) 
declare  @as_descrip   varchar (5000)
declare  @as_fecha     datetime 
declare  @cobz_fecha   datetime 

declare  @doc_id     int
declare @ta_id      int
declare  @doct_id    int

declare @ccos_id_cliente   int
declare  @ccos_id          int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @asi_orden               smallint 
declare  @asi_debe               decimal(18, 6) 
declare  @asi_haber               decimal(18, 6)
declare  @asi_origen             decimal(18, 6)
declare @mon_id                 int

declare  @cobzi_orden            smallint 
declare @cobzi_importe           decimal(18, 6)
declare @cobzi_importeorigen    decimal(18, 6)

declare @cue_id                 int
declare @cheq_id                int
declare @doct_id_cobranza       int
declare @doc_id_cliente         int

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
         @doc_id               = doc_id_asiento, 
         @doct_id_cobranza    = Cobranza.doct_id, 
         @doc_id_cliente      = Documento.doc_id,
         @ccos_id_cliente     = ccos_id,
         @as_doc_cliente      = cobz_nrodoc + ' ' + cli_nombre

  from Cobranza     inner join Documento     on Cobranza.doc_id = Documento.doc_id
                    inner join Cliente       on Cobranza.cli_id = Cliente.cli_id
  where cobz_id = @@cobz_id

  if @as_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'Asiento','as_id',@as_id out, 0
    exec SP_DBGetNewId 'Asiento','as_numero',@as_numero out, 0

    -- Obtengo el as_nrodoc
    declare @ta_ultimonro  int 
    declare @ta_mascara   varchar(50) 

    select @ta_ultimonro=ta_ultimonro, @ta_mascara=ta_mascara, @doct_id=doct_id
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
                              cobz_descrip,
                              cobz_fecha,
                              @as_doc_cliente,
                              @doc_id,
                              @doct_id,
                              @doct_id_cobranza,
                              @doc_id_cliente,
                              @@cobz_id,
                              modifico
      from Cobranza
      where cobz_id = @@cobz_id  

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
                              @as_descrip              = cobz_descrip,
                              @as_fecha                = cobz_fecha,
                              @modifico                = modifico,
                              @modificado             = modificado
    from Cobranza 
    where 
          cobz_id = @@cobz_id

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
                              doct_id_cliente        = @doct_id_cobranza,
                              doc_id_cliente        =  @doc_id_cliente,
                              id_cliente            = @@cobz_id,
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

  declare c_CobranzaItemAsiento cursor for 

    select   cobzi_importe, 
            cobzi_importeorigen, 
            cue_id  = case
                        when cobzi_tipo = 3 and cobzi_tarjetaTipo = 1 then cue_id_presentado
                        when cobzi_tipo = 3 and cobzi_tarjetaTipo = 2 then cue_id_encartera
                        else                     cobzi.cue_id
                      end, 
            ccos_id,
            cobzi.cheq_id

    from CobranzaItem cobzi left join TarjetaCreditoCupon tc   on cobzi.tjcc_id = tc.tjcc_id
                            left join TarjetaCredito t         on tc.tjc_id     = t.tjc_id

    where cobzi.cobz_id = @@cobz_id 
      and (      cobzi_tipo = 1 -- Cheques 
            or  cobzi_tipo = 2 -- Efectivo
            or  cobzi_tipo = 3 -- Tarjeta
            or  (
                      cobzi_tipo = 4 -- Otros 
                  and cobzi_otroTipo = 1 -- Debe
                )
          )

  open c_CobranzaItemAsiento

  fetch next from c_CobranzaItemAsiento into @cobzi_importe, @cobzi_importeorigen, @cue_id, @ccos_id, @cheq_id
  while @@fetch_status = 0 
  begin

    select @mon_id = mon_id from cuenta where cue_id = @cue_id

    set @asi_debe   = @cobzi_importe
    set @asi_origen = @cobzi_importeorigen 

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            0,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id,
                                            @cheq_id,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_CobranzaItemAsiento into @cobzi_importe, @cobzi_importeorigen, @cue_id, @ccos_id, @cheq_id
  end -- While

  close c_CobranzaItemAsiento
  deallocate c_CobranzaItemAsiento

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        Hora la cuenta del Cliente                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare c_CobranzaItemAsiento cursor for 

    select   sum(cobzi_importe), 
            sum(cobzi_importeorigen), 
            cue_id,
            ccos_id
    from CobranzaItem 

    where cobz_id = @@cobz_id 
      and (      cobzi_tipo = 5 -- CtaCte 
            or  (
                      cobzi_tipo = 4 -- Otros 
                  and cobzi_otroTipo = 2 -- Haber
                )
          )
    group by    
            cue_id, ccos_id 

  open c_CobranzaItemAsiento

  fetch next from c_CobranzaItemAsiento into @cobzi_importe, @cobzi_importeorigen, @cue_id, @ccos_id
  while @@fetch_status = 0 
  begin

    select @mon_id = mon_id from cuenta where cue_id = @cue_id

    set @asi_haber  = @cobzi_importe
    set @asi_origen = @cobzi_importeorigen 

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            0,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_CobranzaItemAsiento into @cobzi_importe, @cobzi_importeorigen, @cue_id, @ccos_id
  end -- While

  close c_CobranzaItemAsiento
  deallocate c_CobranzaItemAsiento

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
//                                Vinculo la Cobranza con su asiento                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  update Cobranza set as_id = @as_id, cobz_grabarasiento = 0 where cobz_id = @@cobz_id

  commit transaction

  set @@bError = 0

  if @@bSelect <> 0 select @as_id

  return
ControlError:

  set @@bError = -1

  if @@MsgError is not null set @@MsgError = @@MsgError + ';;'

  set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la cobranza. sp_DocCobranzaAsientoSave.'

  if @@bRaiseError <> 0 begin
    raiserror (@@MsgError, 16, 1)
  end

  rollback transaction  

end