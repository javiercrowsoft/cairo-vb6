if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_SecGetRolesXUsuario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetRolesXUsuario]

go

create procedure SP_SecGetRolesXUsuario(
	@@us_id int
)
as 

select * from rol inner join usuariorol on rol.rol_id=usuariorol.rol_id

where usuariorol.us_id=@@us_id