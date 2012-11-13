if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_SecGetPermisoXUsuario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetPermisoXUsuario]

go

/*

declare @rslt tinyint
exec SP_SecGetPermisoXUsuario 7,1,@rslt out
select @rslt

*/

create procedure SP_SecGetPermisoXUsuario(
	@@us_id 		int,
	@@pre_id 		int,
  @@bGranted  tinyint out
)
as 

begin

	set nocount on
	
	set @@bGranted = 0

	if exists(select pre_id from permiso where pre_id = @@pre_id and us_id = @@us_id) begin
		set @@bGranted = 1
	end else begin
		if exists(select pre_id from permiso where pre_id = @@pre_id and exists (select rol_id from usuariorol where us_id=@@us_id and rol_id = permiso.rol_id)) begin
			set @@bGranted = 1
		end
	end
end
go