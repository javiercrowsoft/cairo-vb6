if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetPercepciones]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetPercepciones]

go

/*

sp_DocFacturaVentaGetPercepciones 1

*/
create procedure sp_DocFacturaVentaGetPercepciones (
  @@fv_id int
)
as

begin

  select   FacturaVentaPercepcion.*, 
          perc_nombre, 
          ccos_nombre

  from   FacturaVentaPercepcion
        inner join Percepcion             on FacturaVentaPercepcion.perc_id = Percepcion.perc_id
        left join centrocosto as ccos     on FacturaVentaPercepcion.ccos_id = ccos.ccos_id
  where 
      fv_id = @@fv_id

  order by fvperc_orden
end