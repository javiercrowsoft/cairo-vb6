if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_tareaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_tareaGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(tar_id) from tarea

-- sp_tareaGet 131

create procedure sp_tareaGet (
	@@tar_id	int
)
as

set nocount on

begin

	select  t.*,
					tp.tar_nombre       as padre,
					esta.tarest_nombre,
					res.us_nombre 			as res,
					asi.us_nombre 			as asig,
					cont.cont_nombre,
					prio.prio_nombre,
					proy.proy_nombre, 
					proyi.proyi_nombre, 
					cli.cli_nombre, 
					obje.obje_nombre,
					dpto.dpto_nombre,
					rub_nombre,
					os_nrodoc,
					prns_codigo,
					pr_nombreventa,
					clis_nombre
 
	from 
		tarea	t inner join proyecto proy 						on t.proy_id   					= proy.proy_id
						left  join tarea tp           			on t.tar_id_padre 			= tp.tar_id
						left  join cliente cli 	 						on t.cli_id    					= cli.cli_id
						left  join usuario asi 	 						on t.us_id_asignador    = asi.us_id
						left  join usuario res 	 						on t.us_id_responsable  = res.us_id
						left  join contacto cont 	 					on t.cont_id   					= cont.cont_id
						left  join prioridad prio 	 				on t.prio_id   					= prio.prio_id
						left  join tareaestado esta 				on t.tarest_id 					= esta.tarest_id
						left  join proyectoitem proyi 			on t.proyi_id  					= proyi.proyi_id
						left  join objetivo obje 	 					on t.obje_id   					= obje.obje_id
						left  join departamento dpto  			on t.dpto_id   					= dpto.dpto_id
						left  join rubro rub          			on t.rub_id             = rub.rub_id
						left  join ordenservicio os   			on t.os_id              = os.os_id
						left  join productonumeroserie prns on t.prns_id            = prns.prns_id
						left  join producto pr          		on prns.pr_id           = pr.pr_id
						left  join clientesucursal clis     on t.clis_id            = clis.clis_id

	where 
		   t.tar_id=@@tar_id
	end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



