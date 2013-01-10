if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_SecGetPermisosXRol]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_SecGetPermisosXRol]

go

/*

  04/09/00
  Proposito: Devuelve los permisos asigandos a un rol. Tiene dos
      modos:
          resumido: solo devuelve los id's de las 
              prestaciones a la que accede el usuario
              y el id del permiso
      (default)  extenso:  devuelve:
              per_id      
              pre_id      
              per_Creado                  
              per_Modifico_id 
              per_Modifico                                       
              pre_nombre                                         
              pre_grupo                                          


SP_SecGetPermisosXRol 2

*/

create procedure SP_SecGetPermisosXRol(
  @@rol_id int,
  @@resumido smallint=0
)
as 

if @@resumido <>0
  select per_id, pre_id from permiso where rol_id = @@rol_id
else
  select     
    p.per_id,
    pr.pre_id,
    per_Creado   = p.creado, 
    per_Modifico_id = p.modifico, 
    per_Modifico   = us_nombre, 
    pr.pre_nombre,
    pr.pre_grupo,
    IsNull(p2.rol_id,p.rol_id) as rol_id,
    p.per_id_padre,
    pr2.pre_nombre             as padre

    from permiso p inner join usuario u on p.modifico = u.us_id
                   inner join prestacion pr on p.pre_id = pr.pre_id
                   left  join permiso p2 on p.per_id_padre = p2.per_id
                   left  join prestacion pr2 on p2.pre_id = pr2.pre_id
    where p.rol_id = @@rol_id


