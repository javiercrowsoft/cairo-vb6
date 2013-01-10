if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_SecGetPermisosXUsuario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetPermisosXUsuario]

go

/*

  04/09/00
  Proposito: Devuelve los permisos asigandos a un usuario. Tiene dos
      modos:
          resumido: solo devuelve los id's de las 
              prestaciones a la que accede el usuario
              y el id del permiso
      (default)  extenso:  devuelve:
              per_id      
              pre_id      
              rol_nombre                                         
              per_Creado                  
              per_Modifico_id 
              per_Modifico                                       
              pre_nombre                                         
              pre_grupo                                          

SP_SecGetPermisosXUsuario 1,-1
SP_SecGetPermisosXUsuario 1,0
*/

create procedure SP_SecGetPermisosXUsuario(
  @@us_id int,
  @@resumido smallint=0
)
as 

begin

  set nocount on
  
  declare @rol_id int
  
  create table #roles (rol_id int)
  create table #permisos (per_id int,rol_id int)
  
  insert into #roles(rol_id) (select rol_id from usuariorol where us_id=@@us_id)
  
  declare C_R insensitive cursor for select rol_id from #roles
  
  open C_R
  
  fetch next from C_R into @rol_id
  
  while @@fetch_status = 0
  begin
    insert into #permisos(per_id,rol_id) (select per_id,@rol_id from permiso where rol_id=@rol_id)
  
    fetch next from C_R into @rol_id
  end
  
  close C_R
  deallocate C_R
  
  insert into #permisos(per_id) (select per_id from permiso where us_id = @@us_id)
  
  if @@resumido <>0
    select tp.per_id, pre_id from #permisos tp inner join permiso p on tp.per_id = p.per_id
  else
    select 
      p.per_id,
      p.us_id,
      p.rol_id,
      pr.pre_id,
      rol_nombre,
      p.creado, 
      p.modifico, 
      pr.pre_nombre,
      pr.pre_grupo,
      p.per_id_padre,
      pr2.pre_nombre as padre
    
      from (#permisos tp  inner join permiso p on tp.per_id = p.per_id 
                           inner join prestacion pr on p.pre_id = pr.pre_id
                           inner join usuario u on p.modifico = u.us_id
                          left  join permiso p2 on p.per_id_padre = p2.per_id
                          left  join prestacion pr2 on p2.pre_id = pr2.pre_id)

                          left join rol r on tp.rol_id = r.rol_id
end
go