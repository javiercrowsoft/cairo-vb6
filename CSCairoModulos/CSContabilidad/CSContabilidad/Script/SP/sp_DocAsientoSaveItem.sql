if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoSaveItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoSaveItem]

/*

 select * from 
 select * from Item

 sp_DocAsientoSaveItem 93

*/

go
create procedure sp_DocAsientoSaveItem (
  @@IsNew         smallint,
  @@asi_id        int,
  @@as_id          int,

  @@asi_orden             smallint, 
  @@asi_debe               decimal(18, 6),
  @@asi_haber             decimal(18, 6),
  @@asi_origen             decimal(18, 6),
  @@asi_tipo              tinyint,
  @@mon_id                int,

  @@cue_id                int,
  @@ccos_id                int,
  @@cheq_id               int,

  @@bError                tinyint out,

  @@asi_descrip           varchar(5000)=''
)
as

begin

  set nocount on

  /*
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                                                                                               //
  //                                        INSERT                                                                 //
  //                                                                                                               //
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  */
  exec SP_DBGetNewId 'AsientoItem','asi_id',@@asi_id out, 0

  if @@asi_haber < 0 begin
    set @@asi_debe  = abs(@@asi_haber)
    set @@asi_haber = 0
  end

  if @@asi_debe  < 0 begin
    set @@asi_haber = abs(@@asi_debe)
    set @@asi_debe  = 0
  end

  insert into AsientoItem (
                                as_id,
                                asi_id,
                                asi_orden,
                                asi_descrip,
                                asi_debe,
                                asi_haber,
                                asi_origen,
                                asi_tipo,
                                cue_id,
                                ccos_id,
                                cheq_id,
                                mon_id
                          )
                      Values(
                                @@as_id,
                                @@asi_id,
                                @@asi_orden,
                                @@asi_descrip,
                                @@asi_debe,
                                @@asi_haber,
                                @@asi_origen,
                                @@asi_tipo,
                                @@cue_id,
                                @@ccos_id,
                                @@cheq_id,
                                @@mon_id
                          )

  if @@error <> 0 goto ControlError

  set @@bError = 0

  return
ControlError:

  set @@bError = 1

end
go