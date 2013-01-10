if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockGetStockXPrId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockGetStockXPrId]

/*
  select * from depositologico
 sp_StockGetStockXPrId 254,2

*/

go
create procedure sp_StockGetStockXPrId (
  @@pr_id   int,
  @@depl_id int
)
as

begin

  set nocount on

  declare @cantidadStock decimal(18,6)

  if exists (select pr_id from Producto where pr_id = @@pr_id and pr_eskit <> 0) begin

    select @cantidadStock =(sum(sti_ingreso)  - sum(sti_salida))/pr_kitItems
    from
        StockItem sti  inner join DepositoLogico d           on sti.depl_id     = d.depl_id  
                      inner join Producto p                 on sti.pr_id_kit  = p.pr_id
    where 
              sti.depl_id = @@depl_id and p.pr_id = @@pr_id
    group by 
              p.pr_id, pr_kitItems

  end else begin

    select @cantidadStock = sum(sti_ingreso) - sum(sti_salida) 
    from StockItem 
    where depl_id = @@depl_id and pr_id = @@pr_id and pr_id_kit is null

  end

  select @cantidadStock as cantidad
end