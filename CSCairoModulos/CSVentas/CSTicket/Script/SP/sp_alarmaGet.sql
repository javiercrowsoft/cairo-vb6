if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_alarmaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarmaGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(al_id) from tarea

-- sp_alarmaGet 131

create procedure sp_alarmaGet (
	@@al_id	int
)
as

set nocount on

begin

	select  al.*,
					cli_nombre,
					proy_nombre,
					rub_nombre,
					clis_nombre
	from 
		alarma al left join proyecto proy 				on al.proy_id = proy.proy_id
							left join cliente cli 	 				on al.cli_id  = cli.cli_id
							left join clientesucursal clis	on al.clis_id = clis.clis_id
							left join rubro rub           	on al.rub_id  = rub.rub_id
	where 
		   al.al_id = @@al_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



