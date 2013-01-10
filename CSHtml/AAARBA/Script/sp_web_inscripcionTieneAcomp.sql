if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionTieneAcomp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionTieneAcomp]

/*

sp_web_inscripcionTieneAcomp 17

select * from aaarbaweb..inscripcion
*/

go
create procedure sp_web_inscripcionTieneAcomp (
  @@insc_id  int
)
as

begin

  set nocount on

  select AABAinsc_acompannantes from aaarbaweb..Inscripcion insc 
  where insc_id = @@insc_id 
    and AABAinsc_acompannantes > 0

end

go
