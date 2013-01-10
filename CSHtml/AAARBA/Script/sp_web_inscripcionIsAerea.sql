if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionIsAerea]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionIsAerea]

/*

sp_web_inscripcionIsAerea 19

sp_col inscripcion
*/

go
create procedure sp_web_inscripcionIsAerea (
  @@insc_id  int
)
as

begin

  set nocount on

  if exists(select * from aaarbaweb..Inscripcion insc where insc_id = @@insc_id and AABAinsc_aerea <> 0)
    select 1
  else
    select 0


end

go
