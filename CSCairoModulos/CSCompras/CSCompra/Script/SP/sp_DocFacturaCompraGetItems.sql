if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetItems]

go

/*

sp_DocFacturaCompraGetItems 1

*/
create procedure sp_DocFacturaCompraGetItems (
  @@fc_id int
)
as

begin

  select   fci.*, 
          pr_nombreCompra, 
          pr_llevanroserie,
          pr_llevanrolote,
          pr_porcinternoc,
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          tint.ti_porcentaje as internos_porcentaje,
          ccos_nombre,
          un_nombre,
          to_nombre,
          stl_codigo

  from   FacturaCompraItem fci
        inner join Producto               on fci.pr_id                     = Producto.pr_id
        inner join Unidad                 on Producto.un_id_Compra         = unidad.un_id
        inner join TipoOperacion          on fci.to_id                      = TipoOperacion.to_id
        left join tasaimpositiva as tri    on producto.ti_id_ivariCompra    = tri.ti_id
        left join tasaimpositiva as trni   on producto.ti_id_ivarniCompra   = trni.ti_id
        left join tasaimpositiva as tint   on producto.ti_id_internosc     = tint.ti_id
        left join centrocosto as ccos     on fci.ccos_id                   = ccos.ccos_id
        left join StockLote as stl        on fci.stl_id                     = stl.stl_id
  where 
      fc_id = @@fc_id

  order by fci_orden

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
                  fci_id

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join FacturaCompraItem fci     on sti.sti_grupo  = fci.fci_id
                                inner join FacturaCompra fc         on fci.fc_id      = fc.fc_id
  where fci.fc_id = @@fc_id and sti.st_id = fc.st_id

  group by
          prns.prns_id,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          fci_id
  order by
          fci_id

end