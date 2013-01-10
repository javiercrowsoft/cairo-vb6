if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_tarea]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_tarea]

-- sp_lsdoc_tarea 25

go
create procedure sp_lsdoc_tarea (
  @@tar_id  int
)
as

set nocount on

begin

declare @ambas tinyint
set @ambas = 2

declare @ahora datetime
set @ahora = getdate()

select 
  t.tar_id,
  ''                  as TypeTask,
  t.tar_nombre        as [Título],
  isnull(tp.tar_nombre,
         t.tar_nombre)
                      as [Tarea Principal],
  t.tar_numero        as [Número],
  cli_nombre          as Cliente,
  t.tar_estado1        as [Primera Alarma],
  t.tar_estado2       as [Segunda Alarma],
  t.tar_fechahorafin  as [Fin de la tarea],
  proy_nombre         as Proyecto,
  proyi_nombre        as [Sub Proyecto],
  obje_nombre         as Objetivo,
  t.tar_fechaini      as [Fecha inicio],
  t.tar_fechafin      as [Fecha fin],
  case 
        when t.tar_finalizada <> 0 then   'Si'
        else         'No'
  end                as Finalizada,
  case 
        when t.tar_cumplida <> 0 then   'Si'
        else         'No'
  end                as Cumplida,
  case 
        when t.tar_rechazada <> 0 then   'Si'
        else         'No'
  end                as Rechazada,
  case 
        when t.activo <> 0 then   'Si'
        else         'No'
  end                as Activa,
  cont_nombre        as Contacto,
  prio_nombre        as Prioridad,
  tarest_nombre      as Estado,
  r.us_nombre        as Responsable,
  a.us_nombre        as [Asignada por],
  t.modificado      as [Modificado],

  case t.tar_opcional    
        when 0 then 'No'
        else        'Si'
  end                as Opcional,

  case t.tar_facturable  
        when 1 then 'Facturable'
        when 2 then 'Bonificada'
        when 3 then 'Sin cargo'
  end                as Facturable,

  case t.tar_finalizada
        when 0 then ''
        else        convert(varchar,t.tar_terminada,120)
  end                as Terminada,

  rub_nombre      as Rubro,
  pr_nombreventa  as Equipo,
  prns_codigo     as Serie,
  alit_nombre     as Tipo,
  dpto_nombre     as Departamento,

  case

    when t.tar_estado1 >  @ahora                                   then 0
    when t.tar_estado1 <= @ahora and t.tar_estado2 > @ahora       then 1
    when t.tar_estado2 <= @ahora and t.tar_fechahorafin > @ahora  then 2
    when t.tar_fechahorafin <= @ahora and t.tar_finalizada = 0    then 3
    when t.tar_fechahorafin <= @ahora and t.tar_finalizada <> 0    then 4
    else 5

  end  as [Nivel Alarma],
  
  -- Tiene que ser la ultima columna para que funcione bien el ABM de documentos
  t.tar_descrip        as [Descripción]

  from 
    tarea t  inner join proyecto pr        on t.proy_id             = pr.proy_id
            left  join usuario r          on t.us_id_responsable  = r.us_id
            left  join usuario a          on t.us_id_asignador    = a.us_id
            left  join prioridad p        on t.prio_id             = p.prio_id
            left  join contacto c          on t.cont_id             = c.cont_id
            left  join tareaestado te      on t.tarest_id           = te.tarest_id
            left  join cliente cl          on t.cli_id              = cl.cli_id
            left  join proyectoitem py    on t.proyi_id            = py.proyi_id
            left  join objetivo ob        on t.obje_id             = ob.obje_id
            left  join tarea tp           on t.tar_id_padre        = tp.tar_id

            left  join productonumeroserie prns on t.prns_id  = prns.prns_id
            left  join producto pr2             on prns.pr_id = pr2.pr_id

            left  join alarmaitemtipo alit   on t.alit_id = alit.alit_id
            left  join alarmaitem ali       on t.ali_id  = ali.ali_id
            left  join rubro rub            on t.rub_id  = rub.rub_id
            left  join departamento dpto    on t.dpto_id = dpto.dpto_id 
  where

    -- Filtros
    @@tar_id = t.tar_id
end


