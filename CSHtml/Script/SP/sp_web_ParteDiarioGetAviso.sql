if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioGetAviso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioGetAviso]

/*

sp_web_ParteDiarioGetAviso 	-1001,0,0,0,0,0,0,0,557,0,'20050713','25000101','557'
	
select * from usuario where us_nombre = 'mamoros'

*/

go
create procedure sp_web_ParteDiarioGetAviso (
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

  declare @fechaAlarma datetime
  set @fechaAlarma = dateadd(d,-1,@@fechaDesde)

      select 
  					ptd_id,
						ptd.ptdt_id,
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
      
      where exists(select id from Aviso where avt_id = 1 /* Partes diarios */ 
                                          and us_id  = @@us_id_responsable
                                          and id     = ptd_id)             
        and
					(
	          (
             (   
                 (ptd_cumplida = 1)
	            or (   		ptd_fechaini >= @@fechaDesde -- Reglas 1 y 3
	  						  and		(ptd_fechafin >= @@fechaDesde or ptd.ptdt_id <> 5) -- Reglas 2 y 3
	  						  and   ptd.ptdt_id not in (3,6) -- Todos menos alarmas
	  					   ) 
	  				  or (    	ptd_alarma >= @fechaAlarma
	  						  and   ptd.ptdt_id in (3,6) -- select * from partediariotipo
	  					   ) 
	           ) 
             and @@fechaDesde <> @@fechaHasta
						 and not (
												(
												    (ptd_fechaini <= @@fechaDesde and ptd_fechafin >= @@fechaDesde and ptd.ptdt_id not in (3,6))
												 or (ptd_alarma = @@fechaDesde and ptd.ptdt_id in (3,6))
												 )
											)
							
	          ) 
            or (
							    (ptd_fechaini <= @@fechaDesde and ptd_fechafin >= @@fechaHasta and ptd.ptdt_id not in (3,6))
							 or (ptd_alarma = @@fechaDesde and ptd.ptdt_id in (3,6))
							 )
					)
--/////////////////////////////////////////////////////////////////////////////////////////
--/////////////////////////////////////////////////////////////////////////////////////////
end
GO