if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepartamentoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepartamentoGet]

/*

 select * from cliente
 select * from documento

 sp_DepartamentoGet 6,14

*/

go
create procedure sp_DepartamentoGet (
  @@dpto_id     int
)
as

begin

  select d.*,
         emp_nombre,
         dp.dpto_nombre as [NombrePadre]

  from Departamento d inner join Empresa e           on d.emp_id = e.emp_id
                      left  join Departamento dp     on d.dpto_id_padre = dp.dpto_id

  where d.dpto_id = @@dpto_id

end

go