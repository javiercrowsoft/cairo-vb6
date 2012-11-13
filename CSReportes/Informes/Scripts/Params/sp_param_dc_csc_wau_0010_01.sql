if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_param_dc_csc_wau_0010_01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_param_dc_csc_wau_0010_01]

/*

sp_param_dc_csc_wau_0010_01 

*/

go
create procedure sp_param_dc_csc_wau_0010_01 
as
begin

        select id = 25000 + 1 *1000000, valor = 'Cambiar estado de una noticia'
  union
        select id = 25000 + 2 *1000000, valor = 'Modificar noticia'
  union
        select id = 25000 + 3 *1000000, valor = 'Ver noticias'
  union
        select id = 25000 + 4 *1000000, valor = 'Borrar noticias'
  union
        select id = 1015  + 1 *1000000, valor = 'Departamentos por usuario'
  union
        select id = 1015  + 2 *1000000, valor = 'Departamento por usuario'
  union
        select id = 1015  + 3 *1000000, valor = 'Puede editar el departamento?'
  union
        select id = 2001  + 1 *1000000, valor = 'Modificar contacto'
  union
        select id = 2001  + 2 *1000000, valor = 'Contactos por usuario'
  union
        select id = 2001  + 3 *1000000, valor = 'Borrar contacto'
  union
        select id = 3     + 1 *1000000, valor = 'Cambiar clave'
  union
        select id = 3     + 2 *1000000, valor = 'Consultar el indice corporativo'
  union
        select id = 3     + 3 *1000000, valor = 'Login'
  union
        select id = 3     + 4 *1000000, valor = 'Consultar un registro del indice corporativo'
  union
        select id = 2010  + 1 *1000000, valor = 'Obtener agenda personal'
  union
        select id = 1     + 1 *1000000, valor = 'Tiene acceso a la prestacion?'
  union
        select id = 7001  + 1 *1000000, valor = 'Listar reportes por usuario y seccion'
  union
        select id = 7001  + 2 *1000000, valor = 'Obtener definicion de un reporte'
  union
        select id = 15002 + 1 *1000000, valor = 'Actualizar alarma'
  union
        select id = 15002 + 2 *1000000, valor = 'Modificar Parte diario'
  union
        select id = 15002 + 3 *1000000, valor = 'Listar Parte diario'
  union
        select id = 15002 + 4 *1000000, valor = 'Borrar Parte diario'
  union
        select id = 15002 + 5 *1000000, valor = 'Editar estado del Parte diario'
  
  order by valor

end
GO
