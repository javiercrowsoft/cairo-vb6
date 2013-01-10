if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EmpleadoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoGet]

go

create procedure sp_EmpleadoGet (
  @@em_id int
)
as

begin

  select   em.*,
          sind_nombre,
          sindco_nombre,
          sindca_nombre,
          ema_nombre,
          eme_nombre,
          estc_nombre,
          pro_nombre,
          pa_nombre

  from Empleado em   left join Sindicato sind on em.sind_id = sind.sind_id
                    left join SindicatoConvenio sindco on em.sindco_id = sindco.sindco_id
                    left join SindicatoCategoria sindca on em.sindca_id = sindca.sindca_id
                    left join EstadoCivil estc on em.estc_id = estc.estc_id
                    left join EmpleadoEspecialidad eme on em.eme_id = eme.eme_id
                    left join EmpleadoART ema on em.ema_id = ema.ema_id
                    left join Provincia pro on em.pro_id = pro.pro_id
                    left join Pais pa on em.pa_id = pa.pa_id
                    
  where em.em_id = @@em_id

end