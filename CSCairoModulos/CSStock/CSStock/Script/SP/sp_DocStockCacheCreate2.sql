if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockCacheCreate2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockCacheCreate2]

/*

 sp_DocStockCacheCreate2 0

select * from stockcache

*/

go
create procedure sp_DocStockCacheCreate2 (
  @@pr_id int = 0,
  @@st_id int = 0
)
as

begin

  declare @MsgError            varchar(5000) set @MsgError = ''

  set nocount on

  if @@st_id = 0 begin

    begin transaction
  
    delete StockCache where pr_id = @@pr_id or @@pr_id = 0

    insert into StockCache(
                            stc_cantidad,
                            pr_id,
                            depl_id,
                            prns_id,
                            pr_id_kit,
                            stl_id
                          )
                  select
                            sum(sti_ingreso) - sum(sti_salida),
                            s.pr_id,
                            depl_id,
                            prns_id,
                            isnull(k.pr_id,pr_id_kit),
                            s.stl_id
                  from StockItem s left join StockItemKit k on s.stik_id = k.stik_id
                  where (s.pr_id = @@pr_id or @@pr_id = 0)
                    and (depl_id not in (-2,-3)) -- Los depositos internos no importan
                  group by
                            s.pr_id,
                            depl_id,
                            prns_id,
                            isnull(k.pr_id,pr_id_kit),
                            s.stl_id
    commit transaction

  end else begin

    begin transaction
  
    delete StockCache where exists(select pr_id from StockItem where st_id = @@st_id and pr_id = StockCache.pr_id)

    insert into StockCache(
                            stc_cantidad,
                            pr_id,
                            depl_id,
                            prns_id,
                            pr_id_kit,
                            stl_id
                          )
                  select
                            sum(sti_ingreso) - sum(sti_salida),
                            s.pr_id,
                            depl_id,
                            prns_id,
                            isnull(k.pr_id,pr_id_kit),
                            s.stl_id
                  from StockItem s left join StockItemKit k on s.stik_id = k.stik_id
                  where exists(select pr_id from StockItem where st_id = @@st_id and pr_id = s.pr_id)
                    and (depl_id not in (-2,-3)) -- Los depositos internos no importan
                  group by
                            s.pr_id,
                            depl_id,
                            prns_id,
                            isnull(k.pr_id,pr_id_kit),
                            s.stl_id
    commit transaction

  end
  

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al crear el cache de stock. sp_DocStockCacheCreate2. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end
end