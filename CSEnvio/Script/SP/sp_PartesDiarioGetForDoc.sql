if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PartesDiarioGetForDoc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PartesDiarioGetForDoc]

go

create procedure sp_PartesDiarioGetForDoc (
  @@us_id    int,
  @@emp_id  int,

  @@doct_id int,
  @@doc_id  int,

  @@dptot_id int = 0
)
as

begin

  select 
  
    ptd_id,
    'TypeTask'  = '',
    'Fecha inicio'  = ptd_fechaini,
    'Fecha fin'  = ptd_fechafin,
    'Alarma'    = ptd_alarma,
    'Carpeta'   =  case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end,
    'Estado'    = tareaestado.tarest_nombre,
    'Cliente'   = cli_nombre,
    'Título'    = ptd_titulo,
    'Asigno'      =  ua.us_nombre,
    'Responsable' =  ur.us_nombre,
    'Contacto'  =  contacto.cont_nombre,
    'Prioridad' =  prioridad.prio_nombre,
    'Cumplido'  = case 
                      when ptd_cumplida = 1 then   'Pendiente'
                      when ptd_cumplida = 2 then   'Rechazado'
                      when ptd_cumplida = 3 then   'Cumplido'
                      else         'Sin definir'
                  end,
    'Telefono'  = cli_tel,
    'Descripción' = ptd_descrip
  from 
  
      partediario as ptd left join usuario as ua on ptd.us_id_asignador   = ua.us_id
                         left join usuario as ur on ptd.us_id_responsable = ur.us_id
                         left join contacto      on ptd.cont_id           = contacto.cont_id
                         left join prioridad     on ptd.prio_id           = prioridad.prio_id  
                         left join cliente       on ptd.cli_id            = cliente.cli_id
                         left join legajo        on ptd.lgj_id            = legajo.lgj_id
                         left join tareaestado   on ptd.tarest_id         = tareaestado.tarest_id

                         left join departamento dpto on ptd.dpto_id       = dpto.dpto_id
  
  where 

        doct_id = @@doct_id
    and doc_id  = @@doc_id

    and (@@dptot_id = 0 or dpto.dptot_id = @@dptot_id)

    and (    ptd.modifico = @@us_id 
          or ptd.us_id_asignador = @@us_id
          or ptd.us_id_responsable = @@us_id
          or ptd_privado = 0
        )

union

  select 
  
    ptd_id,
    'TypeTask'  = '',
    'Fecha inicio'  = ptd_fechaini,
    'Fecha fin'  = ptd_fechafin,
    'Alarma'    = ptd_alarma,
    'Carpeta'   =  case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end,
    'Estado'    = tareaestado.tarest_nombre,
    'Cliente'   = cli_nombre,
    'Título'    = ptd_titulo,
    'Asigno'      =  ua.us_nombre,
    'Responsable' =  ur.us_nombre,
    'Contacto'  =  contacto.cont_nombre,
    'Prioridad' =  prioridad.prio_nombre,
    'Cumplido'  = case 
                      when ptd_cumplida = 1 then   'Pendiente'
                      when ptd_cumplida = 2 then   'Rechazado'
                      when ptd_cumplida = 3 then   'Cumplido'
                      else         'Sin definir'
                  end,
    'Telefono'  = cli_tel,
    'Descripción' = ptd_descrip
  from 
  
      partediario as ptd left join usuario as ua on ptd.us_id_asignador   = ua.us_id
                         left join usuario as ur on ptd.us_id_responsable = ur.us_id
                         left join contacto      on ptd.cont_id           = contacto.cont_id
                         left join prioridad     on ptd.prio_id           = prioridad.prio_id  
                         left join cliente       on ptd.cli_id            = cliente.cli_id
                         left join legajo        on ptd.lgj_id            = legajo.lgj_id
                         left join tareaestado   on ptd.tarest_id         = tareaestado.tarest_id

                         left join departamento dpto on ptd.dpto_id       = dpto.dpto_id
  
  where 

        @@doct_id = 37004 -- Alumno
    and alum_id = @@doc_id

    and (    ptd.modifico = @@us_id 
          or ptd.us_id_asignador = @@us_id
          or ptd.us_id_responsable = @@us_id
          or ptd_privado = 0
        )


end

go