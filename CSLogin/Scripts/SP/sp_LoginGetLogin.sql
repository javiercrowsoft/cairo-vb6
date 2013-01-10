if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LoginGetLogin]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LoginGetLogin]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

select * from empresausuario
select * from usuario
 sp_LoginGetLogin 'lizza',2
*/
create procedure sp_LoginGetLogin (
  @@us_nombre  varchar(255),
  @@emp_id    int
)
as

set nocount on

begin

  select us_clave,us_id,activo,us_externo from usuario 

  where 
          us_nombre = @@us_nombre 
      and (      us_id = 1 -- administrador
           or
                exists (select us_id from EmpresaUsuario where us_id = usuario.us_id and emp_id = @@emp_id)
          )

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



