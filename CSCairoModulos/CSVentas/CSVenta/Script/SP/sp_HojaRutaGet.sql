if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaGet]

go

create procedure sp_HojaRutaGet (
  @@hr_id int
)
as

begin


  select 
          hr.*,
          suc_nombre,

          case when prs_apellido <> '' then prs_apellido + ',' + prs_nombre
               else prs_nombre
          end as prs_nombre,

          chof_nombre,
          cam.cam_patente,
          case semi.cam_essemi
            when 0 then semi.cam_patentesemi
            else        semi.cam_patente
          end  as cam_patentesemi,

          isnull(fvf.fv_nrodoc, mfs.mf_nrodoc)   as mov_faltante,
          mft.mf_nrodoc                          as mov_tickets

  from 
  
      HojaRuta hr   inner join sucursal suc        on hr.suc_id          = suc.suc_id
                   left  join Camion cam          on hr.cam_id           = cam.cam_id
                   left  join Persona prs         on hr.prs_id          = prs.prs_id
                   left  join Chofer chof         on hr.chof_id          = chof.chof_id
                   left  join Camion semi         on hr.cam_id_semi     = semi.cam_id
                   left  join MovimientoFondo mfs  on hr.mf_id_sobrante   = mfs.mf_id
                   left  join MovimientoFondo mft  on hr.mf_id_tickets   = mft.mf_id
                   left  join FacturaVenta fvf    on hr.fv_id_faltante  = fvf.fv_id

  
  where 
        hr.hr_id = @@hr_id
  
end

go