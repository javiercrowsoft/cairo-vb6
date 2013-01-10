if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetOtros]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetOtros]

go

/*

sp_DocFacturaCompraGetOtros 1

*/
create procedure sp_DocFacturaCompraGetOtros (
  @@fc_id int
)
as

begin

  select   FacturaCompraOtro.*, 
          cue_nombre, 
          ccos_nombre

  from   FacturaCompraOtro
        inner join Cuenta                 on FacturaCompraOtro.cue_id = Cuenta.cue_id
        left join centrocosto as ccos     on FacturaCompraOtro.ccos_id = ccos.ccos_id
  where 
      fc_id = @@fc_id

  order by fcot_orden
end