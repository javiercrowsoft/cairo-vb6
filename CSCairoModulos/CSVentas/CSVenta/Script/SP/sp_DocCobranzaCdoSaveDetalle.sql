if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaCdoSaveDetalle]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaCdoSaveDetalle]

go

/*

select max(fv_id) from facturaventa
sp_DocCobranzaCdoSaveDetalle  29183

*/

create procedure sp_DocCobranzaCdoSaveDetalle (
  @@fv_id       int,
  @@cobz_id     int,
  @@pagocvxi    decimal(18,6),
  @@hojaRuta    tinyint
)
as

begin

  select 1

end