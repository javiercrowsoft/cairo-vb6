if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraGetItems]

go

/*

sp_DocRemitoCompraGetItems 9

*/
create procedure sp_DocRemitoCompraGetItems (
  @@rc_id int
)
as

begin

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  REMITO COMPRA ITEMS
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select   rci.*, 
          pr_nombreCompra, 
          pr_llevanroserie,
          pr_llevanrolote,
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre,
          stl_codigo

  from   RemitoCompraItem rci
        inner join Producto pr            on rci.pr_id               = pr.pr_id
        inner join Unidad un              on pr.un_id_compra         = un.un_id
        left join TasaImpositiva as tri    on pr.ti_id_ivaricompra    = tri.ti_id
        left join TasaImpositiva as trni   on pr.ti_id_ivarnicompra   = trni.ti_id
        left join Centrocosto as ccos     on rci.ccos_id             = ccos.ccos_id
        left join StockLote as stl        on rci.stl_id              = stl.stl_id

  where 
      rc_id = @@rc_id

  order by rci_orden

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  NUMEROS DE SERIE
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select 
                  prns.prns_id,
                  prns.stl_id,
                  prns_codigo,
                  prns_descrip,
                  prns_fechavto,
                  rci_id,
                  stl_codigo

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join RemitoCompraItem rci     on sti.sti_grupo  = rci.rci_id
                                inner join RemitoCompra rc          on rci.rc_id      = rc.rc_id
                                left  join StockLote stl            on prns.stl_id    = stl.stl_id

  where rci.rc_id = @@rc_id 
    and sti.st_id = rc.st_id

  group by
          prns.prns_id,
          prns.stl_id,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          rci_id,
          stl_codigo

  order by
          rci_id

end