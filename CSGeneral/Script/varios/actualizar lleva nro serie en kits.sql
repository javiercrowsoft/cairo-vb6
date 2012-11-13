declare @pr_id           int
declare @bLlevaNroSerie  tinyint

declare c_prkitnons insensitive cursor for select pr_id from producto where pr_llevanroserie = 0 and pr_eskit <>0

open c_prkitnons

fetch next from c_prkitnons into @pr_id
while @@fetch_status=0
begin

  set @bLlevaNroSerie = 0
  exec sp_StockProductoKitLlevaNroSerie @pr_id, @bLlevaNroSerie out

  if @bLlevaNroSerie <> 0 update Producto set pr_llevanroserie = 1 where pr_id = @pr_id

  fetch next from c_prkitnons into @pr_id
end

close c_prkitnons
deallocate c_prkitnons

select pr_id,pr_nombrecompra,pr_codigo from producto where pr_llevanroserie = 0 and pr_eskit <>0 order by 1


-- sp_StockProductoGetKitInfo 98