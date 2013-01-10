/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_HojaRuta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_HojaRuta]


/*

sp_lsdoc_HojaRuta 1,'20070101','20071128','','0','0','0'

*/

go
create procedure sp_lsdoc_HojaRuta (
  @@hr_id    int
)as 

begin

select 

  hr_id,
  ''                as TypeTask,
  hr_fecha          as Fecha,
  hr_nrodoc          as Numero,
  prs_nombre        as [Salida de],
  cam_patente       as Camion,
  hr.creado         as Creado,
  hr.modificado     as Modificado,
  us.us_nombre      as Modifico,
  case when hr_cumplida <> 0 then 'Si' else 'No' end as Cumplida,
  hr_descrip        as [Descripción]

from 

    HojaRuta hr  left join Camion cam    on hr.cam_id   = cam.cam_id
                left join Usuario us    on hr.modifico = us.us_id
                left join Persona prs   on hr.prs_id   = prs.prs_id

where 
          hr_id = @@hr_id
end
go



