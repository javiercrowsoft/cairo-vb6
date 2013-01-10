if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionPlantillaGetitems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionPlantillaGetitems]

go

create procedure sp_LiquidacionPlantillaGetitems (
  @@liqp_id     int
)
as

begin

  set nocount on

  select   liqpi.*,
          em_apellido + ', ' + em_nombre as em_nombre,
          liqf_nombre,
          'Legajo: ' + em_legajo + ' DNI: ' + em_dni as Legajo

  from LiquidacionPlantillaItem liqpi left join Empleado em on liqpi.em_id = em.em_id
                                      left join LiquidacionFormula liqf on liqpi.liqf_id = liqf.liqf_id
  where liqpi.liqp_id = @@liqp_id
          

end

go