if exists (select * from sysobjects where id = object_id(N'[dbo].[Sp_DocStockCacheUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Sp_DocStockCacheUpdate]

/*

  select * from parteprodkit

  Sp_DocStockCacheUpdate '',0,3750,0
*/

go
create procedure Sp_DocStockCacheUpdate (
	@@Message       	varchar(5200) out,
  @@bSuccess      	tinyint out,
  @@st_id         	int,
	@@bRestar       	tinyint,
	@@bNotUpdatePrns	tinyint = 0
)
as

begin

  set nocount on

	if @@bRestar <> 0 begin
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Quito de StockCache lo que se movio con los items de este movimiento
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		Update StockCache 
		set stc_cantidad = stc_cantidad 
											 - (select sum(sti_ingreso - sti_salida)
													from StockItem i 
													where	i.st_id = @@st_id
														and StockCache.pr_id = i.pr_id 
														and StockCache.depl_id = i.depl_id 
														and IsNull(StockCache.prns_id,0) 	 = IsNull(i.prns_id,0)
														and IsNull(StockCache.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
														and IsNull(StockCache.stl_id,0)    = IsNull(i.stl_id,0)
													)
		 
		where exists (select * from StockItem i
								 	where				i.st_id = @@st_id
													and StockCache.pr_id = i.pr_id 
													and StockCache.depl_id = i.depl_id 
													and IsNull(StockCache.prns_id,0) 	 = IsNull(i.prns_id,0)
													and IsNull(StockCache.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
													and IsNull(StockCache.stl_id,0)    = IsNull(i.stl_id,0)
									)
		--
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end else begin
	
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Agrego a StockCache lo que se movio con los items de este movimiento
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		Update StockCache 
		set stc_cantidad = stc_cantidad 
											 + (select sum(sti_ingreso - sti_salida)
													from StockItem i 
												  where i.st_id = @@st_id
	                          and StockCache.pr_id = i.pr_id 
														and StockCache.depl_id = i.depl_id 
														and IsNull(StockCache.prns_id,0)   = IsNull(i.prns_id,0)
														and IsNull(StockCache.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
														and IsNull(StockCache.stl_id,0)    = IsNull(i.stl_id,0)
													) 
	  where exists (select * from StockItem i
									where				i.st_id = @@st_id
                          and StockCache.pr_id = i.pr_id 
													and StockCache.depl_id = i.depl_id 
													and IsNull(StockCache.prns_id,0)   = IsNull(i.prns_id,0)
													and IsNull(StockCache.pr_id_kit,0) = IsNull(i.pr_id_kit,0)
													and IsNull(StockCache.stl_id,0)    = IsNull(i.stl_id,0)
									)
		--
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if @@bRestar = 0 begin
		exec Sp_DocStockValidate @@Message out, @@bSuccess out, @@st_id
	end else begin
		set @@bSuccess = 1
	end

	if @@bNotUpdatePrns	= 0 exec sp_DocStockUpdateNumeroSerie @@st_id,
																														@@bRestar

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
