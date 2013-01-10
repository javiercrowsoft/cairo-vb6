if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockGetItems]

go

/*

select * from recuentostock
sp_DocRecuentoStockGetItems 9

*/
create procedure sp_DocRecuentoStockGetItems (
  @@rs_id int
)
as

begin

  declare @st_id   int

  set nocount on

  select @st_id = st_id1 from RecuentoStock where rs_id = @@rs_id

    select   RecuentoStockItem.*, 
            pr_nombrecompra, 
            pr_llevanroserie,
            pr_llevanrolote,
            pr_eskit,
            un_nombre,
            depl_nombre,
            stl_codigo
  
    from   RecuentoStockItem
          inner join Producto               on RecuentoStockItem.pr_id = Producto.pr_id
          inner join Unidad                 on Producto.un_id_stock = unidad.un_id
          inner join DepositoLogico         on RecuentoStockItem.depl_id = DepositoLogico.depl_id
          left  join StockLote              on RecuentoStockItem.stl_id = StockLote.stl_id
  
    where 
            rs_id     = @@rs_id
      and    pr_eskit   = 0

  union

    select   RecuentoStockItem.*, 
            pr_nombrecompra, 
            (
              select min(stik_llevanroserie) from StockItemKit where pr_id = RecuentoStockItem.pr_id and st_id = @st_id 
            ) as pr_llevanroserie,
            0 as pr_llevanrolote,
            pr_eskit,
            un_nombre,
            depl_nombre,
            '' as stl_codigo
  
    from   RecuentoStockItem
          inner join Producto               on RecuentoStockItem.pr_id     = Producto.pr_id
          inner join Unidad                 on Producto.un_id_stock       = unidad.un_id
          inner join DepositoLogico         on RecuentoStockItem.depl_id   = DepositoLogico.depl_id

    where 
            rs_id     = @@rs_id
      and    pr_eskit   <> 0

  order by rsi_orden

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
                  rsi_id

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join RecuentoStockItem rsi     on sti.sti_grupo  = rsi.rsi_id
                                inner join RecuentoStock rs         on rsi.rs_id      = rs.rs_id
                                inner join Producto p               on prns.pr_id     = p.pr_id
  where rsi.rs_id = @@rs_id and sti.st_id = rs.st_id1

  group by
          prns.prns_id,
          prns.pr_id,
          pr_nombrecompra,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          rsi_id
  order by
          rsi_id

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