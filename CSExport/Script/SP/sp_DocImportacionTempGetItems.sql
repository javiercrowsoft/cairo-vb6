if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempGetItems]

go

/*

select impt_id from ImportacionTemp

sp_DocImportacionTempGetItems 1

*/
create procedure sp_DocImportacionTempGetItems (
  @@impt_id int
)
as

begin

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  IMPORTACION TEMPORAL ITEMS
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select   ImportacionTempItem.*, 
          pr_nombreCompra, 
          pr_llevanroserie,
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre

  from   ImportacionTempItem
        inner join Producto               on ImportacionTempItem.pr_id     = Producto.pr_id
        inner join Unidad                 on Producto.un_id_compra         = unidad.un_id
        left join tasaimpositiva as tri    on producto.ti_id_ivaricompra    = tri.ti_id
        left join tasaimpositiva as trni   on producto.ti_id_ivarnicompra   = trni.ti_id
        left join centrocosto as ccos     on ImportacionTempItem.ccos_id   = ccos.ccos_id
  where 
      impt_id = @@impt_id

  order by impti_orden

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  NUMEROS DE SERIE
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select 
                  prns.prns_id,
                  prns_codigo,
                  prns_descrip,
                  prns_fechavto,
                  impti_id

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join ImportacionTempItem rci     on sti.sti_grupo  = rci.impti_id
                                inner join ImportacionTemp rc          on rci.impt_id      = rc.impt_id
  where rci.impt_id = @@impt_id and sti.st_id = rc.st_id

  group by
          prns.prns_id,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          impti_id
  order by
          impti_id

end