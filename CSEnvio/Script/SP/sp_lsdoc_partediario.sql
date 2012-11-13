if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_parteDiario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_parteDiario]

go

set quoted_identifier on 
go
set ansi_nulls on 
go


-- sp_lsdoc_parteDiario 1

create procedure sp_lsdoc_parteDiario (
	@@ptd_id	int
)
as

set nocount on

begin

select 
	ptd_id,
	'TypeTask'	= '',
	'Fecha inicio'  = ptd_fechaini,
	'Fecha fin'	= ptd_fechafin,
  'Alarma'    = ptd_alarma,
	'Carpeta'   =	case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end,
	'Estado'    = tareaestado.tarest_nombre,
  'Cliente'   = cli_nombre,
	'Proveedor' = prov_nombre,
	'Título'	  = ptd_titulo,
	'Asigno'      =	ua.us_nombre,
	'Responsable' =	ur.us_nombre,
	'Contacto'  =	contacto.cont_nombre,
	'Prioridad' =	prioridad.prio_nombre,
	'Cumplido'	= case 
										when ptd_cumplida = 1 then 	'Pendiente'
										when ptd_cumplida = 2 then 	'Rechazado'
										when ptd_cumplida = 3 then 	'Cumplido'
										else 				'Sin definir'
								end,
	'Telefono'  = cli_tel,
	'Dirección' = ' Localidad: '+
								cli_localidad + ' Calle: '+
								cli_calle + ' Nro: '+
								cli_callenumero + ' Piso: '+
								cli_piso + ' Dpto: '+
								cli_depto,
	'Descripción' = ptd_descrip
from 

		partediario as ptd left join usuario as ua on ptd.us_id_asignador   = ua.us_id
											 left join usuario as ur on ptd.us_id_responsable = ur.us_id
											 left join contacto      on ptd.cont_id           = contacto.cont_id
											 left join prioridad     on ptd.prio_id           = prioridad.prio_id	
											 left join cliente       on ptd.cli_id            = cliente.cli_id
											 left join legajo        on ptd.lgj_id            = legajo.lgj_id
											 left join tareaestado   on ptd.tarest_id         = tareaestado.tarest_id
											 left join proveedor prov on ptd.prov_id          = prov.prov_id

where 

		-- Filtros
		@@ptd_id = ptd_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



