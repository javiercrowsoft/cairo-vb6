if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_alarmaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarmaGetItems]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(al_id) from tarea

-- sp_alarmaGetItems 131

create procedure sp_alarmaGetItems (
	@@al_id	int
)
as

set nocount on

begin

	select  ali.*,
					alit_nombre,
					dpto_nombre,
					mi.mail_nombre 	as mail_inicio,
					ma1.mail_nombre as mail_alarma1,
					ma2.mail_nombre as mail_alarma2,
					mf.mail_nombre 	as mail_finalizado,
					mv.mail_nombre 	as mail_vencido
	from 

		AlarmaItem ali 	Inner join AlarmaItemTipo alit on ali.alit_id = alit.alit_id
										left  join Departamento dpto   on ali.dpto_id = dpto.dpto_id

										left  join Mail mi        		 on ali.mail_id_inicio 			= mi.mail_id
										left  join Mail ma1        		 on ali.mail_id_alarma1 		= ma1.mail_id
										left  join Mail ma2       		 on ali.mail_id_alarma2 		= ma2.mail_id
										left  join Mail mf        		 on ali.mail_id_finalizado 	= mf.mail_id
										left  join Mail mv        		 on ali.mail_id_vencido 		= mv.mail_id
	where 
		   ali.al_id = @@al_id

	order by ali_secuencia

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



