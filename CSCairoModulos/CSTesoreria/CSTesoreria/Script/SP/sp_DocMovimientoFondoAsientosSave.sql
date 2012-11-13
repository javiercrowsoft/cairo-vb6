if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoAsientosSave]

/*

	declare @tiempo datetime
	set @tiempo = getdate()

	delete MovimientoFondoAsiento

	insert into MovimientoFondoAsiento (mf_id,mf_fecha) 
	select mf_id,'20040304' from MovimientoFondo 
	where mf_grabarAsiento <> 0 

  exec sp_DocMovimientoFondoAsientosSave 

	select datediff(n,getdate(),@tiempo)

	select * from asiento
  select mf_id,as_id from MovimientoFondo
  update MovimientoFondo set as_id = null

	sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocMovimientoFondoAsientosSave 
as

begin

	set nocount on

	declare @mf_id 		int
	declare @est_id   int
	declare @as_id    int
	declare @bError 	smallint
  declare @MsgError varchar(5000)

	declare c_FacturaAsientos insensitive cursor for
		select mfa.mf_id, est_id, as_id 
		from MovimientoFondoAsiento mfa inner join MovimientoFondo mf on mfa.mf_id = mf.mf_id 
		order by mfa.mf_fecha

	open c_FacturaAsientos
	fetch next from c_FacturaAsientos into @mf_id, @est_id, @as_id

	while @@fetch_status=0 begin

		if @est_id = 7 begin

			update MovimientoFondo set as_id = null where mf_id = @mf_id
			exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
			delete MovimientoFondoAsiento where mf_id = @mf_id

		end else begin

			exec sp_DocMovimientoFondoAsientoSave @mf_id,0,@bError out, @MsgError out
		  if @bError <> 0 begin
				raiserror ('Ha ocurrido un error al grabar la factura de venta. sp_DocMovimientoFondoAsientosSave.', 16, 1)
			end else begin
	      delete MovimientoFondoAsiento where mf_id = @mf_id
	    end

		end

		fetch next from c_FacturaAsientos into @mf_id, @est_id, @as_id
  end

	close c_FacturaAsientos
	deallocate c_FacturaAsientos

end