if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockProductoKitLlevaNroSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockProductoKitLlevaNroSerie]

/*
 sp_StockProductoKitLlevaNroSerie 93
*/

go
create procedure sp_StockProductoKitLlevaNroSerie (
  @@pr_id          int,
  @@bResult       tinyint out,
  @@bCreateTable  tinyint = 1,
  @@prfk_id       int = null
)
as

begin

  set nocount on

  declare @nivel int

  set @@bResult = 0

  if @@prfk_id is null select @@prfk_id = prfk_id from ProductoFormulaKit where pr_id = @@pr_id and prfk_default <> 0

  -- Averiguo si este producto lleva numero de serie
  if exists(select pr_id from Producto where pr_id = @@pr_id and pr_llevanroserie <> 0) begin

    set @@bResult = 1

  end else begin

    -- Solo se crea la tabla en la primera llamada
    if @@bCreateTable <> 0 begin
      create table #KitItems(pr_id int not null, nivel int not null)
    end

    -- Agrego los items de este kit
    select @nivel = max(nivel) from #KitItems
    set @nivel = IsNull(@nivel,0)+1
    insert into #KitItems(pr_id,nivel) select pr_id_item, @nivel from ProductoKit where prfk_id = @@prfk_id
    
    -- Para cada item de este kit
    while exists(select * from #KitItems where nivel = @nivel) begin

      select @@pr_id = min(pr_id) from #KitItems where nivel = @nivel

      exec sp_StockProductoKitLlevaNroSerie @@pr_id, @@bResult out, 0

      if @@bResult <> 0 return

      -- Este ya lo procese asi que lo borro
      delete #KitItems where pr_id = @@pr_id
    end
  end
end