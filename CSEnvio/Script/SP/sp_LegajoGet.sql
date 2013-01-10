if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LegajoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LegajoGet]

go

create procedure sp_LegajoGet (
  @@lgj_id int
)
as

begin

  set nocount on

  select  legajo.*, 
          cli_nombre, 
          est_nombre, 
          lgjt_nombre, 
          trans_nombre, 
          mon_nombre, 
          pue_nombre, 
          vue_nombre, 
          barc_nombre

  from legajo inner join estado       on legajo.est_id   = estado.est_id 
              inner join legajotipo   on legajo.lgjt_id  = legajotipo.lgjt_id 
              inner join moneda       on legajo.mon_id   = moneda.mon_id 
              left  join cliente      on legajo.cli_id   = cliente.cli_id 
              left  join transporte   on legajo.trans_id = transporte.trans_id 
              left  join vuelo        on legajo.vue_id   = vuelo.vue_id 
              left  join barco        on legajo.barc_id  = barco.barc_id 
              left  join puerto       on legajo.pue_id   = puerto.pue_id 

  Where lgj_id = @@lgj_id

end

GO