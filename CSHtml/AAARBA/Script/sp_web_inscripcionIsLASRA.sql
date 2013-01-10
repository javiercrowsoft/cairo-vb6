if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionIsLASRA]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionIsLASRA]

/*

sp_web_inscripcionIsLASRA 15

select * from aaarbaweb..inscripcion
*/

go
create procedure sp_web_inscripcionIsLASRA (
  @@insc_id  int
)
as

begin

  set nocount on

  if exists(select * from aaarbaweb..Inscripcion insc where insc_id = @@insc_id and AABAinsc_lasra <> 0)
    select 1
  else
    select 0

end

go
