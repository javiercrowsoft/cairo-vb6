SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_DepartamentoCanEdit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_DepartamentoCanEdit]
GO

/*

  select * from departamento where dpto_nombre = 'sistemas'

insert into usuariodepartamento (usdpto_id,us_id,dpto_id,modifico)values(125,10,11,1)

 sp_web_DepartamentoCanEdit 1,75

*/

create Procedure sp_web_DepartamentoCanEdit
(
  @@us_id       int,
  @@dpto_id     int
)
as
begin

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  exec sp_HistoriaUpdate 1015, @@dpto_id, @@us_id, 3

    if exists(select per_id from Permiso inner join Departamento on pre_id = pre_id_editardocumentos
                     where    dpto_id = @@dpto_id 
                          and ( 
                                us_id = @@us_id
                              or
                                exists (select us_id from UsuarioRol where rol_id = Permiso.rol_id and us_id = @@us_id)
                              )
                     )
      select 1
    else
      select 0

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go

