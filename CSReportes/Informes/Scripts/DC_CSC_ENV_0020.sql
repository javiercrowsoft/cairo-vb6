-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Legajo
---------------------------------------------------------------------*/
/*

DC_CSC_ENV_0020 3

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_ENV_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_ENV_0020]

-- DC_CSC_ENV_0020 38,0

go
create procedure DC_CSC_ENV_0020 (
  @@us_id       int,
  @@lgj_id      int
)as 

begin

    select
              0                   as rslt_id,
              lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              ''                                         as titulo01,
              ''                                         as valor01,
              ''                                         as titulo02,
              ''                                         as valor02,
              ''                                         as titulo03,
              ''                                         as valor03,
              ''                                         as titulo04,
              ''                                         as valor04,
              ''                                         as titulo05,
              ''                                         as valor05,
              ''                                         as titulo06,
              ''                                         as valor06,
              ''                                         as titulo07,
              ''                                         as valor07,
              ''                                         as titulo08,
              ''                                         as valor08,
              ''                                         as titulo09,
              ''                                         as valor09,
              ''                                         as titulo10,
              ''                                         as valor10,
              ''                                         as titulo11,
              ''                                         as valor11,
              ''                                         as titulo12,
              ''                                         as valor12,
              ''                                         as titulo13,
              ''                                         as valor13,
              ''                                         as titulo14,
              ''                                         as valor14,
              ''                                         as titulo15,
              ''                                         as valor15

  
    from legajo inner join estado          on legajo.est_id     = estado.est_id
                inner join legajotipo      on legajo.lgjt_id    = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id     = cliente.cli_id
                left  join moneda          on legajo.mon_id     = moneda.mon_id
  
    where lgj_id = @@lgj_id or @@lgj_id = 0

  union all

    select
              1                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cliente.cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              'Numero'                                           as titulo01,
              convert(varchar(255),ptd_numero)                   as valor01,
              'Alarma'                                           as titulo02,
              convert(varchar(255),ptd_alarma)                   as valor02,
              'Inicio'                                           as titulo03,
              convert(varchar(255),ptd_fechaini)                 as valor03,
              'Fin'                                              as titulo04,
              convert(varchar(255),ptd_fechafin)                 as valor04,
              'Cliente'                                          as titulo05,
              cliptd.cli_nombre                                  as valor05,
              'Cumplida'                                         as titulo06,
              case ptd_cumplida
                  when 1 then 'Pendiente'  -- csECumplida_Pendiente = 1
                  when 2 then 'Rechazada'  -- csECumplida_Rechazada = 2
                  when 3 then 'Cumplido'   -- csECumplida_Cumplida = 3
              end                                                as valor06,
              ''                                         as titulo07,
              ''                                         as valor07,
              ''                                         as titulo08,
              ''                                         as valor08,
              ''                                         as titulo09,
              ''                                         as valor09,
              ''                                         as titulo10,
              ''                                         as valor10,
              ''                                         as titulo11,
              ''                                         as valor11,
              ''                                         as titulo12,
              ''                                         as valor12,
              ''                                         as titulo13,
              ''                                         as valor13,
              ''                                         as titulo14,
              ''                                         as valor14,
              'Observaciones'                            as titulo15,
              ptd_descrip                                as valor15


    from legajo inner join estado          on legajo.est_id         = estado.est_id
                inner join legajotipo      on legajo.lgjt_id        = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id         = cliente.cli_id
                left  join moneda          on legajo.mon_id         = moneda.mon_id
                inner join partediario     on legajo.lgj_id         = partediario.lgj_id
                inner join cliente cliptd  on partediario.cli_id    = cliptd.cli_id
  
    where legajo.lgj_id = @@lgj_id or @@lgj_id = 0

  union all

    select
              2                   as rslt_id,
              legajo.lgj_id,
              lgj_titulo,
              lgj_codigo,
              lgj_descrip,
              lgj_fecha,
              lgjt_nombre,
              est_nombre,
              cliente.cli_nombre,
              mon_nombre,
              legajo.modificado,
              legajo.creado,
              legajo.modifico,
              legajo.activo,

              'Numero'                                           as titulo01,
              convert(varchar(255),fv_numero)                    as valor01,
              'Documento'                                        as titulo02,
              fv_nrodoc                                          as valor02,
              'Fecha'                                            as titulo03,
              convert(varchar(255),fv_fecha)                     as valor03,
              'Pendiente'                                        as titulo04,
              convert(varchar(255),convert(money,fv_pendiente),1)                 as valor04,
              'Cliente'                                          as titulo05,
              clifac.cli_nombre                                  as valor05,
              'Total'                                            as titulo06,
              convert(varchar(255),convert(money,fv_total),1)                     as valor06,
              'Condición Pago'                                   as titulo07,
              cpg_nombre                                         as valor07,
              'Sucursal'                                         as titulo08,
              suc_nombre                                         as valor08,

              ''                                         as titulo09,
              ''                                         as valor09,
              ''                                         as titulo10,
              ''                                         as valor10,
              ''                                         as titulo11,
              ''                                         as valor11,
              ''                                         as titulo12,
              ''                                         as valor12,
              ''                                         as titulo13,
              ''                                         as valor13,
              ''                                         as titulo14,
              ''                                         as valor14,
              ''                                         as titulo15,
              ''                                         as valor15

    from legajo inner join estado          on legajo.est_id         = estado.est_id
                inner join legajotipo      on legajo.lgjt_id        = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id         = cliente.cli_id
                left  join moneda          on legajo.mon_id         = moneda.mon_id
                inner join facturaventa    on legajo.lgj_id         = facturaventa.lgj_id
                inner join cliente clifac  on facturaventa.cli_id   = clifac.cli_id
                inner join condicionpago   on facturaventa.cpg_id   = condicionpago.cpg_id
                inner join sucursal        on facturaventa.suc_id   = sucursal.suc_id
  
    where legajo.lgj_id = @@lgj_id or @@lgj_id = 0

end
go