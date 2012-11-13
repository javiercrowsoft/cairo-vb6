if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionesSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionesSetEstado]

/*

 sp_DocLiquidacionesSetEstado 

*/

go
create procedure sp_DocLiquidacionesSetEstado (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @liq_id int

	declare c_Liquidaciones insensitive cursor for 
		select liq_id from Liquidacion where liq_fecha between @@desde and @@hasta

	open c_Liquidaciones

	fetch next from c_Liquidaciones into @liq_id
	while @@fetch_status = 0 begin

		exec sp_DocLiquidacionSetEstado @liq_id

		fetch next from c_Liquidaciones into @liq_id
  end

	close c_Liquidaciones
	deallocate c_Liquidaciones
end