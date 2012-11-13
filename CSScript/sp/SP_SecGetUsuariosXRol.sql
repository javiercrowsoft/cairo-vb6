if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_SecGetUsuarioXRol]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetUsuarioXRol]

-- SP_SecGetUsuarioXRol 2
go

create procedure SP_SecGetUsuarioXRol(
	@@rol_id int
)
as 

select * from usuario inner join usuariorol on usuario.us_id=usuariorol.us_id

where usuariorol.rol_id=@@rol_id