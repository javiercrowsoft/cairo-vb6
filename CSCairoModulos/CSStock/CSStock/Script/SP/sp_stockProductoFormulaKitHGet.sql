if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_stockProductoFormulaKitHGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_stockProductoFormulaKitHGet]

/*

 select pr_id,pr_llevanroserie from producto where pr_eskit <> 0
 sp_stockProductoFormulaKitHGet 611

*/

go
create procedure sp_stockProductoFormulaKitHGet (
  @@prfk_id     int
)
as

begin

  set nocount on

  select

    pk.pr_id,
    pr_kitIdentidad              as bIdentidad,
    pr_kitIdentidadXItem        as bIdentidadXItem,
    pr_kitLote                  as bLote,
    pr_kitLoteXItem              as bLoteXItem,
    ta_id_kitSerie              as ta_id_serie,
    ta_id_kitLote                as ta_id_lote,

    pr_id_serie                  as pr_id_serie,
    pr_id_lote                  as pr_id_lote,

    case isnull(taserie.ta_tipo,0) when 1 then 1 else 0 end as bTalEditSerie,
    case isnull(talote.ta_tipo,0)  when 1 then 1 else 0 end as bTalEditLote

  
  from ProductoFormulaKit pk inner join Producto pr       on pk.pr_id           = pr.pr_id
                             left  join Talonario taserie on pr.ta_id_kitSerie  = taserie.ta_id
                             left  join Talonario talote  on pr.ta_id_kitLote   = talote.ta_id

  where prfk_id = @@prfk_id

end