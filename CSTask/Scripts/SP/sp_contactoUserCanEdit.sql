if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_contactoUserCanEdit ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_contactoUserCanEdit ]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*

	select * from contacto
	select * from agenda
	select * from permiso where pre_id = 15015733

	
	sp_contactoUserCanEdit  56,1

*/

create procedure sp_contactoUserCanEdit  (
	@@cont_id	int,
  @@us_id   int
)
as

set nocount on

begin

	declare @pre_id_propietario  int
	
	if IsNull(@@cont_id,0) = 0 begin

		select 1

	end else begin 

		select @pre_id_propietario = pre_id_propietario 
		from Agenda inner join Contacto on Agenda.agn_id = Contacto.agn_id
	  where cont_id = @@cont_id

		if exists(select per_id from permiso 
	                where pre_id = @pre_id_propietario 
	                  and (		 us_id = @@us_id 
													or exists(select rol_id 
																		from usuariorol 
																		where rol_id = permiso.rol_id
																			and us_id = @@us_id)
												)
									)
			select 1
		else
			select 0
	end
end
go
set quoted_identifier off 
go
set ansi_nulls on 
go



