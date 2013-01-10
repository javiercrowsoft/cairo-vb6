if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TrabajoImpresionGetNextJob]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TrabajoImpresionGetNextJob]

/*

*/

go
create procedure sp_TrabajoImpresionGetNextJob 
as

begin

  declare @timp_id int

  select @timp_id = min(timp_id) 
  from TrabajoImpresion 
  where timp_estado = 2 -- pendientes
  
  select t.*, emp_nombre, us_nombre
  from TrabajoImpresion t left join empresa e on t.emp_id = e.emp_id
                          left join usuario u on t.us_id = u.us_id
  where timp_id = @timp_id
  

end

go