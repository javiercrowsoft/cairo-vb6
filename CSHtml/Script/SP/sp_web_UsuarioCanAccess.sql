if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_UsuarioCanAccess]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_UsuarioCanAccess]

/*

update contacto set cont_tipo=1 where us_id = 1

select * from contacto

sp_web_UsuarioCanAccess 
																  1,
																  -21

*/

go
create procedure sp_web_UsuarioCanAccess (
	@@us_id										int,
	@@pre_id			 						int
)
as

begin

	set nocount on

	declare @brslt  tinyint

	exec SP_SecGetPermisoXUsuario @@us_id, @@pre_id, @brslt out

	select 	@brslt as CanAccess

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  exec sp_HistoriaUpdate 1, @@pre_id, @@us_id, 1, @brslt


end
go