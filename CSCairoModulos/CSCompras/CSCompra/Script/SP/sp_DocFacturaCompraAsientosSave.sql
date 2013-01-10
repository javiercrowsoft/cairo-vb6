if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraAsientosSave]

/*

  delete FacturaCompraAsiento

  insert into FacturaCompraAsiento (fc_id,fc_fecha) select fc_id,'20040304' from FacturaCompra 
where fc_grabarAsiento <> 0 

  sp_DocFacturaCompraAsientosSave 

  select * from asiento
  select fc_id,as_id from facturaCompra
  update facturaCompra set as_id = null

  sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocFacturaCompraAsientosSave 
as

begin

  set nocount on

  declare @fc_id     int
  declare @est_id   int
  declare @as_id    int
  declare @bError   smallint
  declare @MsgError varchar(5000)

  declare c_FacturaAsientos insensitive cursor for
    select fca.fc_id, est_id, as_id 
    from FacturaCompraAsiento fca inner join FacturaCompra fc on fca.fc_id = fc.fc_id 
    order by fca.fc_fecha

  open c_FacturaAsientos
  fetch next from c_FacturaAsientos into @fc_id, @est_id, @as_id

  while @@fetch_status=0 begin

    if @est_id = 7 begin

      update FacturaCompra set as_id = null where fc_id = @fc_id
      exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
      delete FacturaCompraAsiento where fc_id = @fc_id

    end else begin

      exec sp_DocFacturaCompraAsientoSave @fc_id,0,@bError out, @MsgError out
      if @bError <> 0 begin
        raiserror ('Ha ocurrido un error al grabar la factura de Compra. sp_DocFacturaCompraAsientosSave.', 16, 1)
      end else begin
        delete FacturaCompraAsiento where fc_id = @fc_id
      end

    end

    fetch next from c_FacturaAsientos into @fc_id, @est_id, @as_id
  end

  close c_FacturaAsientos
  deallocate c_FacturaAsientos

end