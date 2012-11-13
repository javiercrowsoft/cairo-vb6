if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetProyectos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetProyectos]

go

/*

select proy_id from hora
select cli_id from proyecto where proy_id = 1
exec sp_DocFacturaVentaGetProyectos 6,3,2

*/

create procedure sp_DocFacturaVentaGetProyectos (
  @@emp_id          int,
	@@cli_id 					int,
  @@mon_id          int
)
as

begin

	select 

				proy.proy_id,
				proy_nombre,
        proy_descrip

  from Proyecto proy 
	where 
					proy.cli_id  = @@cli_id
		and   proy.activo <> 0
    and   exists(select hora_id from hora where proy_id = proy.proy_id and hora_pendiente > 0)

	order by 

				proy_nombre
end
go