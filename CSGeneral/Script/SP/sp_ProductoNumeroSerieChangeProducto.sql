if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ProductoNumeroSerieChangeProducto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoNumeroSerieChangeProducto]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

	select 'update ' + t.name + ' set ' + c.name + ' = @@pr_id where '
         + c.name + ' = @@prns_id'  
	from sysobjects t inner join syscolumns c on t.id = c.id
	where t.xtype='u'
		and c.name like '%prns_id%'
		and t.name not like '%tmp%'


*/
create procedure sp_ProductoNumeroSerieChangeProducto (
	@@prns_id 			int,
	@@pr_id					int,
	@@bSetPrecio		tinyint = 0
)
as
begin

	set nocount on

	begin transaction

	update StockCache set pr_id = @@pr_id where prns_id = @@prns_id
	if @@error <> 0 goto ControlError

	declare @bSuccess tinyint

	exec sp_ProductoNumeroUpdateOrdenServicio @@prns_id, @@pr_id, @@bSetPrecio, @bSuccess out
	if @bSuccess = 0 goto ControlError

	update ProductoSerieKit set pr_id = @@pr_id where prns_id = @@prns_id
	if @@error <> 0 goto ControlError

	update ProductoNumeroSerie set pr_id = @@pr_id where prns_id = @@prns_id
	if @@error <> 0 goto ControlError

	update StockItem set pr_id = @@pr_id where prns_id = @@prns_id
	if @@error <> 0 goto ControlError

	update RemitoVentaItem set pr_id = @@pr_id 
	where exists (
		select *
		from StockItem sti 
		where sti.sti_grupo = RemitoVentaItem.rvi_id
			and sti.prns_id		= @@prns_id
		)
	if @@error <> 0 goto ControlError

	update FacturaVentaItem set pr_id = @@pr_id 
	where exists (
		select *
		from StockItem sti 
		where sti.sti_grupo = FacturaVentaItem.fvi_id
			and sti.prns_id		= @@prns_id
		)
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	declare @MsgError varchar(5000)

	set @MsgError = 'Ha ocurrido un error al cambiar el articulo asociado al numero de serie. sp_ProductoNumeroSerieChangeProducto.'
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO