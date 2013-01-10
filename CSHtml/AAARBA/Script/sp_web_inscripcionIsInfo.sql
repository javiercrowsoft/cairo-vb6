if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionIsInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionIsInfo]

/*

sp_web_inscripcionIsInfo 12

select * from aaarbaweb..inscripcion

*/

go
create procedure sp_web_inscripcionIsInfo (
  @@insc_id  int
)
as

begin

  set nocount on

  if exists(select * from aaarbaweb..Inscripcion insc where insc_id = @@insc_id and AABAinsc_info <> 0)
    select 1
  else
    select 0

end

go
