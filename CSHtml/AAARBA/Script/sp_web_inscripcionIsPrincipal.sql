if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionIsPrincipal]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionIsPrincipal]

/*

sp_web_inscripcionIsPrincipal 0

sp_col inscripcion
*/

go
create procedure sp_web_inscripcionIsPrincipal (
  @@insc_id  int
)
as

begin

  set nocount on

  if exists(select * from aaarbaweb..Inscripcion insc where insc_id = @@insc_id and insc_id_padre is null)
    select 1
  else
    select 0

end

go
