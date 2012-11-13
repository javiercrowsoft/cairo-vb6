if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioGetAlarmas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioGetAlarmas]

/*
select getdate()
sp_web_ParteDiarioGetAlarmas 
                            	-6,
                            	0,
                            	0,
                            	0,
                            	0,
                            	0,
                            	0,
                              0,
                              1,
                              1,
                            	'20050422 18:08:55',
                            	'20050422 13:46:55',
                              1
	
select * from usuario where us_nombre = 'mamoros'

*/

go
create procedure sp_web_ParteDiarioGetAlarmas (
	@@ptdt_id									int,
	@@ptd_cumplida            int,
	@@dpto_id									int,
	@@cont_id									int,
	@@tarest_id								int,
	@@prio_id									int,
	@@lgj_id									int,
	@@cli_id									int,
  @@us_id_responsable       int,
  @@us_id_asignador         int,
	@@fechaDesde							datetime,
	@@fechaHasta							datetime,
	@@us_id										int
)
as

begin

	set nocount on

	-- NOTA: OJO el @@ptdt_id no se usa solo trae ptdt_id 5 y 6 (tareas y alarmas), y
  --       para ptdt_id = 5 solo con ptd_alarma <> 1/1/1900

	declare @fecha varchar(10)

	set @fecha = convert(varchar(10),@@fechaHasta,111)

	select
				ptd_id,
				'Tipo'            = ptdt_nombre,
        'Departamento'    = IsNull(dpto_nombre,''),
				'Fecha inicio'  	= ptd_fechaini,
				'Fecha fin'				= ptd_fechafin,
				'Hora inicio'  	  = ptd_horaini,
				'Hora fin'				= ptd_horafin,
			  'Alarma'    			= ptd_alarma,
				'Carpeta'   			=	IsNull(case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end,''),
				'Estado'    			= IsNull(tareaestado.tarest_nombre,''),
			  'Cliente'   			= IsNull(cli_nombre,''),
        'Proveedor'       = IsNull(prov_nombre,''),
				'Título'	  			= ptd_titulo,
				'Asigno'      		=	ua.us_nombre,
				'Responsable' 		=	ur.us_nombre,
				'Contacto'  			=	IsNull(contacto.cont_nombre,''),
				'Prioridad' 			=	IsNull(prioridad.prio_nombre,''),
				'Cumplido'				= case 
															when ptd_cumplida = 1 then 	'Pendiente'
															when ptd_cumplida = 2 then 	'Rechazado'
															when ptd_cumplida = 3 then 	'Cumplido'
															else 				'Sin definir'
														end,
				'Descripción' 		= ptd_descrip
	from 

		partediario as ptd left join usuario as ua 			on ptd.us_id_asignador   = ua.us_id
											 left join usuario as ur 			on ptd.us_id_responsable = ur.us_id
											 left join contacto      			on ptd.cont_id           = contacto.cont_id
											 left join prioridad     			on ptd.prio_id           = prioridad.prio_id	
											 left join cliente       			on ptd.cli_id            = cliente.cli_id
											 left join legajo        			on ptd.lgj_id            = legajo.lgj_id
											 left join tareaestado   			on ptd.tarest_id         = tareaestado.tarest_id
                       left join ParteDiarioTipo    on ptd.ptdt_id           = ParteDiarioTipo.ptdt_id
                       left join departamento       on ptd.dpto_id           = departamento.dpto_id
											 left join proveedor          on ptd.prov_id           = proveedor.prov_id

	where
-- 					(
-- 									(
-- 										 		datepart(hh,ptd_horaini) 	<= datepart(hh,@@fechaHasta) 
-- 										and datepart(n,ptd_horaini) 	<= datepart(n,@@fechaHasta)
-- 										and convert(varchar(10),ptd_alarma,111) = @fecha
-- 									)
-- 							or ptd_alarma <= @fecha
-- 					)
							ptd_alarma <= @@fechaHasta
					and ptd_cumplida = 1

		and   (ptd.ptdt_id = 6 or (ptd.ptdt_id = 5 and ptd_alarma <> '19000101'))

		and   (ptd.dpto_id      			= @@dpto_id or @@dpto_id = 0)
		and   (ptd.cont_id      			= @@cont_id or @@cont_id = 0)
    and   (ptd.ptd_cumplida       = @@ptd_cumplida or @@ptd_cumplida = 0)
		and   (ptd.tarest_id    			= @@tarest_id or @@tarest_id = 0)
		and   (ptd.prio_id      			= @@prio_id or @@prio_id = 0)
		and   (ptd.lgj_id       			= @@lgj_id or @@lgj_id = 0)
		and   (ptd.cli_id       			= @@cli_id or @@cli_id = 0)

    -- Responsable
    --
		and   (        -- El responsable de este parte es el que me indicaron
                   --
									(ptd.us_id_responsable 	= @@us_id_responsable)
							or 
                   -- El parte no tiene responsable y esta
                   -- en un departamento en el que el responsable
                   -- indicado participa
                   --
									 (exists (
													select dpto_id 
													from UsuarioDepartamento 
												  where us_id = @@us_id_responsable 
														and ptd.us_id_responsable is null -- no tiene responsable
														and dpto_id = ptd.dpto_id         -- el responsable indicado participa 
												)                                     -- en el departamento del parte
										)
                   -- No me indicaron ningun responsable
                   --
							or  (@@us_id_responsable = 0)
					)

    -- Asignador
    --
		and   (         -- El asignador de este parte es el que me indicaron
                    -- 
          				 (ptd.us_id_asignador = @@us_id_asignador)

                    -- El parte no tiene asignador
                    --
								or (ptd.us_id_asignador is null and @@us_id_asignador = 0)

                    -- No me ndicaron un asignador
                    --
                or (@@us_id_asignador = 0)

					)

    -- Controlo el acceso del usuario que
    -- que invoco al sp sobre los partes
    -- que le voy a mostrar
    --	
		and   (    -- El usuario es responsable, asignador o no me indicaron usuario
               --
               (ptd.us_id_responsable = @@us_id or ptd.us_id_asignador = @@us_id or @@us_id = 0)
             or
              (
                  -- El usuario invocante tiene permiso para ver las tareas del departamento
                  -- del parte
                  --
                  exists(select per_id from Permiso inner join Departamento d on pre_id = pre_id_vertareas
                         where  
                                pre_id = pre_id_vertareas
                            and d.dpto_id = ptd.dpto_id 
                            and ptd_publico <> 0
                            and (
                                   us_id = @@us_id 
                                or exists(select rol_id from usuariorol 
                                          where rol_id = Permiso.rol_id 
                                            and us_id = @@us_id 
                                         )
                                )
                        )
              )
          )
	order by

		ptd_fechaini, ptd_fechafin
end
GO