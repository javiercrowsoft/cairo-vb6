if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_StockLoteValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockLoteValidate]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

	select * from StockLote stl 
	where not exists(select stl_id from StockItem where stl_id = stl.stl_id)
	
	select * from StockLote
	where not exists(select stl_id from StockItem where stl_id = StockLote.stl_id)
		and not exists(select stl_id from StockCache where stl_id = StockLote.stl_id)

*/
create procedure sp_StockLoteValidate
as
begin

	set nocount on

	delete StockCache where stl_id in (
	select stl_id from StockLote stl 
	where not exists(select stl_id from StockItem where stl_id = stl.stl_id)
	)
	and stc_cantidad = 0
	
	delete StockLote
	where not exists(select stl_id from StockItem where stl_id = StockLote.stl_id)
		and not exists(select stl_id from StockCache where stl_id = StockLote.stl_id)
end
GO