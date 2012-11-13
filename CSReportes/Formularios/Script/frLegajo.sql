

if exists (select * from sysobjects where id = object_id(N'[dbo].[frLegajo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frLegajo]

/*

frLegajo 0

*/

go
create procedure frLegajo (

  @@lgj_id   int

)
as 

begin

  select 

            lgj_id,
            lgj_titulo,
            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
            lgj_descrip,
            lgj_fecha,
            lgj_ata,
            lgj_hawbbl,
            lgj_etd,
            lgj_eta,
            lgj_mawbbl,
            lgj_fob,
            lgj_giro,
            lgj_flete,
            legajotipo.lgjt_nombre,
            estado.est_nombre,
            cliente.cli_nombre,
            moneda.mon_nombre,
            transporte.trans_nombre,
            barco.barc_nombre,
            vuelo.vue_nombre,
            puerto.pue_nombre,
            legajo.modificado,
            legajo.creado,
            legajo.modifico,
            legajo.activo
  
    from legajo inner join estado          on legajo.est_id     = estado.est_id
                inner join legajotipo      on legajo.lgjt_id    = legajotipo.lgjt_id
                left  join cliente         on legajo.cli_id     = cliente.cli_id
                left  join moneda          on legajo.mon_id     = moneda.mon_id
                left  join barco           on legajo.barc_id    = barco.barc_id
                left  join vuelo           on legajo.vue_id     = vuelo.vue_id
                left  join puerto          on legajo.pue_id     = puerto.pue_id
                left  join transporte      on legajo.trans_id   = transporte.trans_id

  where lgj_id = @@lgj_id

end
go

