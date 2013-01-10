if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaAsientoSaveItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaAsientoSaveItem]

/*

 select * from FacturaVenta
 select * from FacturaVentaItem

 sp_DocFacturaVentaAsientoSaveItem 93

*/

go
create procedure sp_DocFacturaVentaAsientoSaveItem (
  @@IsNew         smallint,
  @@asi_id        int,
  @@as_id          int,

  @@asi_orden             smallint, 
  @@asi_debe               decimal(18, 6),
  @@asi_haber             decimal(18, 6),
  @@asi_origen             decimal(18, 6),
  @@mon_id                int,

  @@cue_id                int,
  @@ccos_id                int,
  @@bError      tinyint out
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

  insert into AsientoItem (
                                as_id,
                                asi_id,
                                asi_orden,
                                asi_descrip,
                                asi_debe,
                                asi_haber,
                                asi_origen,
                                cue_id,
                                ccos_id,
                                mon_id
                          )
                      Values(
                                @@as_id,
                                @@asi_id,
                                @@asi_orden,
                                '',
                                @@asi_debe,
                                @@asi_haber,
                                @@asi_origen,
                                @@cue_id,
                                @@ccos_id,
                                @@mon_id
                          )

  if @@error <> 0 goto ControlError

  set @@bError = 0

  return
ControlError:

  set @@bError = 1

end
go