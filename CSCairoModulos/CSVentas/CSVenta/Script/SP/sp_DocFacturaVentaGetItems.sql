if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetItems]

go

/*

sp_DocFacturaVentaGetItems 

*/
create procedure sp_DocFacturaVentaGetItems (
  @@fv_id int
)
as

begin

  set nocount on

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  FACTURA VENTA ITEMS
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  declare @st_id   int

  select @st_id = st_id from FacturaVenta where fv_id = @@fv_id

    select   fvi.*, 
            pr_nombreventa, 
            pr_llevanroserie,
            pr_llevanrolote,
            pr_lotefifo,
            pr_eskit,
            pr_porcinternov,
            tri.ti_porcentaje as iva_ri_porcentaje,
            trni.ti_porcentaje as iva_rni_porcentaje,
            tint.ti_porcentaje as internos_porcentaje,
            ccos_nombre,
            un_nombre,
            to_nombre,
            stl_codigo
  
    from   FacturaVentaItem fvi
          inner join Producto pr            on fvi.pr_id             = pr.pr_id
          inner join Unidad un              on pr.un_id_venta       = un.un_id
          inner join TipoOperacion tp       on fvi.to_id             = tp.to_id
          left join tasaimpositiva as tri    on pr.ti_id_ivariventa  = tri.ti_id
          left join tasaimpositiva as trni   on pr.ti_id_ivarniventa = trni.ti_id
          left join tasaimpositiva as tint   on pr.ti_id_internosv   = tint.ti_id
          left join centrocosto as ccos     on fvi.ccos_id           = ccos.ccos_id
          left join StockLote as stl        on fvi.stl_id            = stl.stl_id

    where 
            fv_id     = @@fv_id
      and    pr_eskit   = 0

  union

    select   fvi.*, 
            pr_nombreventa, 
            (
              select min(stik_llevanroserie) from StockItemKit where pr_id = fvi.pr_id and st_id = @st_id 
            ) as pr_llevanroserie,
            pr_llevanrolote,
            pr_lotefifo,
            pr_eskit,
            pr_porcinternov,
            tri.ti_porcentaje as iva_ri_porcentaje,
            trni.ti_porcentaje as iva_rni_porcentaje,
            tint.ti_porcentaje as internos_porcentaje,
            ccos_nombre,
            un_nombre,
            to_nombre,
            stl_codigo
  
    from   FacturaVentaItem fvi
          inner join Producto pr            on fvi.pr_id             = pr.pr_id
          inner join Unidad un              on pr.un_id_venta       = un.un_id
          inner join TipoOperacion tp       on fvi.to_id             = tp.to_id
          left join tasaimpositiva as tri    on pr.ti_id_ivariventa  = tri.ti_id
          left join tasaimpositiva as trni   on pr.ti_id_ivarniventa = trni.ti_id
          left join tasaimpositiva as tint   on pr.ti_id_internosv   = tint.ti_id
          left join centrocosto as ccos     on fvi.ccos_id           = ccos.ccos_id
          left join StockLote as stl        on fvi.stl_id            = stl.stl_id

    where 
            fv_id     = @@fv_id
      and    pr_eskit   <> 0

  order by fvi_orden

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  NUMEROS DE SERIE
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////

  select 
                  prns.pr_id,
                  pr_nombrecompra,
                  prns.prns_id,
                  prns_codigo,
                  prns_descrip,
                  prns_fechavto,
                  fvi_id

  from FacturaVentaItem fvi  inner join FacturaVenta fv     on fvi.fv_id = fv.fv_id
                                                           and fvi.fv_id = @@fv_id 

                             inner join StockItem sti       on sti.st_id     = fv.st_id
                                                           and sti.sti_grupo = fvi.fvi_id

                             inner join ProductoNumeroSerie prns on prns.prns_id = sti.prns_id
                                
                             inner join Producto p          on prns.pr_id    = p.pr_id

  group by
          prns.prns_id,
          prns.pr_id,
          pr_nombrecompra,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          fvi_id
  order by
          fvi_id

  --///////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --  Info Kit
  --
  --///////////////////////////////////////////////////////////////////////////////////////////////////
  declare @pr_id int

  create table #KitItems      (
                                pr_id int not null, 
                                nivel int not null
                              )

  create table #KitItemsSerie(
                                pr_id_kit       int null,
                                cantidad         decimal(18,6) not null,
                                pr_id           int not null, 
                                prk_id           int not null,
                                nivel           smallint not null default(0)
                              )

  declare c_KitItem insensitive cursor for select pr_id from StockItemKit where st_id = @st_id
  
  open c_KitItem

  fetch next from c_KitItem into @pr_id
  while @@fetch_status = 0 begin

    exec sp_StockProductoGetKitInfo @pr_id, 0

    update #KitItemsSerie set pr_id_kit = @pr_id where pr_id_kit is null

    fetch next from c_KitItem into @pr_id
  end

  close c_KitItem
  deallocate c_KitItem

  select 
          k.pr_id_kit     as pr_id,
          k.pr_id         as pr_id_item, 
          pr_nombrecompra,
          pr_llevanroserie,
          cantidad 
  from 
          #KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id
end