if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioGetItems]

go

/*

sp_DocOrdenServicioGetItems 9

*/
create procedure sp_DocOrdenServicioGetItems (
  @@os_id int
)
as

begin

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  REMITO venta ITEMS
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select   osi.*, 
          pr_nombreventa, 
          pr_llevanroserie,
          pr_llevanrolote,
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          un_nombre,
          stl_codigo,
          tar_nombre,
          pr.rub_id,
          cont_nombre,
          etf_nombre
          

  from   OrdenServicioItem osi
        inner join Producto pr            on osi.pr_id               = pr.pr_id
        inner join Unidad un              on pr.un_id_venta         = un.un_id
        left join TasaImpositiva as tri    on pr.ti_id_ivariventa    = tri.ti_id
        left join TasaImpositiva as trni   on pr.ti_id_ivarniventa   = trni.ti_id
        left join Centrocosto as ccos     on osi.ccos_id             = ccos.ccos_id
        left join StockLote as stl        on osi.stl_id              = stl.stl_id
        left join Tarea tar               on osi.tar_id             = tar.tar_id
        left join Contacto cont           on osi.cont_id            = cont.cont_id
        left join EquipoTipoFalla etf     on osi.etf_id             = etf.etf_id

  where 
      osi.os_id = @@os_id

  order by osi_orden

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  NUMEROS DE SERIE
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select 
                  prns.pr_id,
                  prns.prns_id,
                  prns.stl_id,
                  prns_codigo,
                  prns_codigo2,
                  prns_codigo3,
                  prns_descrip,
                  prns_fechavto,
                  osi_id,
                  stl_codigo

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join OrdenServicioItem osi     on sti.sti_grupo  = osi.osi_id
                                inner join OrdenServicio rc         on osi.os_id      = rc.os_id
                                left  join StockLote stl            on prns.stl_id    = stl.stl_id

  where osi.os_id = @@os_id 
    and sti.st_id = rc.st_id

  group by
          prns.pr_id,
          prns.prns_id,
          prns.stl_id,
          prns_codigo,
          prns_codigo2,
          prns_codigo3,
          prns_descrip,
          prns_fechavto,
          osi_id,
          stl_codigo

  order by
          osi_id

end