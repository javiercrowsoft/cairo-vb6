if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_usuarioValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_usuarioValidate]

/*

 sp_usuarioValidate 1, ''
*/

go
create procedure sp_usuarioValidate (
	@@us_id int,
  @@us_clave varchar(255),
  @@emp_id int
)
as

begin

	if @@us_id = 1 or exists(select * from EmpresaUsuario where emp_id = @@emp_id and us_id = @@us_id) begin
		if exists(select us_id from usuario where us_id = @@us_id and us_clave = @@us_clave)
					select -1

		else	select 0
	end
  else		select 0
end