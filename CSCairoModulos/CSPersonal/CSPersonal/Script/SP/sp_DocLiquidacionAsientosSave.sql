if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionAsientosSave]

/*

	delete LiquidacionAsiento

	insert into LiquidacionAsiento (liq_id,liq_fecha) select liq_id,'20040304' from Liquidacion 
where liq_grabarAsiento <> 0 

  sp_DocLiquidacionAsientosSave 

	select * from asiento
  select liq_id,as_id from Liquidacion
  update Liquidacion set as_id = null

	sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocLiquidacionAsientosSave 
as

begin

	set nocount on

	declare @liq_id 		int
	declare @est_id   int
	declare @as_id    int
	declare @bError 	smallint
  declare @MsgError varchar(5000)

	declare c_LiquidacionAsientos insensitive cursor for
		select liqa.liq_id, est_id, as_id 
		from LiquidacionAsiento liqa inner join Liquidacion liq on liqa.liq_id = liq.liq_id 
		order by liqa.liq_fecha

	open c_LiquidacionAsientos
	fetch next from c_LiquidacionAsientos into @liq_id, @est_id, @as_id

	while @@fetch_status=0 begin

		if @est_id = 7 begin

			update Liquidacion set as_id = null where liq_id = @liq_id
			exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
			delete LiquidacionAsiento where liq_id = @liq_id

		end else begin

			exec sp_DocLiquidacionAsientoSave @liq_id,0,@bError out, @MsgError out
		  if @bError <> 0 begin
				raiserror ('Ha ocurrido un error al grabar la liquidacion de haberes. sp_DocLiquidacionAsientosSave.', 16, 1)
			end else begin
	      delete LiquidacionAsiento where liq_id = @liq_id
	    end

		end

		fetch next from c_LiquidacionAsientos into @liq_id, @est_id, @as_id
  end

	close c_LiquidacionAsientos
	deallocate c_LiquidacionAsientos

end