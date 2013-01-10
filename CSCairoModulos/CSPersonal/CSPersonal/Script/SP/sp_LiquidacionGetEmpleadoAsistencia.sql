if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionGetEmpleadoAsistencia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionGetEmpleadoAsistencia]

go

-- sp_LiquidacionGetEmpleadoAsistencia 1

create procedure sp_LiquidacionGetEmpleadoAsistencia (
  @@liq_id     int,
  @@em_id     int
)
as

begin

  declare @fecha_desde datetime
  declare @fecha_hasta datetime

  select   @fecha_desde = liq_fechadesde,
          @fecha_hasta = liq_fechahasta

  from Liquidacion
  where liq_id = @@liq_id

  select   emh.emh_id      as emh_id,
          emh.emh_fecha    as emh_fecha,
          emh.emh_desde    as emh_desde,
          emh.emh_hasta    as emh_hasta,
          emh.emh_horas    as emh_horas,

          emh.ccos_id            as ccos_id,
          ccos.ccos_nombre      as ccos_nombre,
          ccos.ccos_codigo      as ccos_codigo,

          ccosp.ccos_id          as ccos_id_padre,
          ccosp.ccos_nombre      as ccos_nombre_padre,
          ccosp.ccos_codigo     as ccos_codigo_padre,

          emh.east_id     as east_id,
          east_nombre     as east_nombre,
          east_codigo      as east_codigo

  from EmpleadoHoras emh left  join CentroCosto ccos   on emh.ccos_id = ccos.ccos_id
                         left  join CentroCosto ccosp on ccos.ccos_id_padre = ccosp.ccos_id
                         left  join EmpleadoAsistenciaTipo east on emh.east_id = east.east_id

  where emh.em_id = @@em_id
    and emh_fecha between @fecha_desde and @fecha_hasta

  order by emh_fecha

end

go