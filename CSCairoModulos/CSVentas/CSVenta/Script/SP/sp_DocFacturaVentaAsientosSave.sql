if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaAsientosSave]

/*

	delete FacturaVentaAsiento

	insert into FacturaVentaAsiento (fv_id,fv_fecha) select fv_id,'20040304' from FacturaVenta 
where fv_grabarAsiento <> 0 

  sp_DocFacturaVentaAsientosSave 

	select * from asiento
  select fv_id,as_id from facturaventa
  update facturaventa set as_id = null

	sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocFacturaVentaAsientosSave 
as

begin

	set nocount on

	declare @fv_id 		int
	declare @est_id   int
	declare @as_id    int
	declare @bError 	smallint
  declare @MsgError varchar(5000)

	declare c_FacturaAsientos insensitive cursor for
		select fva.fv_id, est_id, as_id 
		from FacturaVentaAsiento fva inner join FacturaVenta fv on fva.fv_id = fv.fv_id 
		order by fva.fv_fecha

	open c_FacturaAsientos
	fetch next from c_FacturaAsientos into @fv_id, @est_id, @as_id

	while @@fetch_status=0 begin

		if @est_id = 7 begin

			update FacturaVenta set as_id = null where fv_id = @fv_id
			exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
			delete FacturaVentaAsiento where fv_id = @fv_id

		end else begin

			exec sp_DocFacturaVentaAsientoSave @fv_id,0,@bError out, @MsgError out
		  if @bError <> 0 begin
				raiserror ('Ha ocurrido un error al grabar la factura de venta. sp_DocFacturaVentaAsientosSave.', 16, 1)
			end else begin
	      delete FacturaVentaAsiento where fv_id = @fv_id
	    end

		end

		fetch next from c_FacturaAsientos into @fv_id, @est_id, @as_id
  end

	close c_FacturaAsientos
	deallocate c_FacturaAsientos

end