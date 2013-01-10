if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoAsientosSave]

/*

  update OrdenPago set opg_grabarAsiento = 1

  delete OrdenPagoAsiento

  insert into OrdenPagoAsiento (opg_id,opg_fecha) select opg_id,'20040304' from OrdenPago 
  where opg_grabarAsiento <> 0 

  sp_DocOrdenPagoAsientosSave 

  select * from asiento
  select opg_id,as_id from OrdenPago

  sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocOrdenPagoAsientosSave 
as

begin

  set nocount on

  declare @opg_id   int
  declare @est_id   int
  declare @as_id    int
  declare @bError   smallint
  declare @MsgError varchar(5000)

  declare c_OrdenPagoAsientos insensitive cursor for
    select opga.opg_id, est_id, as_id 
    from OrdenPagoAsiento opga inner join OrdenPago opg on opga.opg_id = opg.opg_id 
    order by opga.opg_fecha

  open c_OrdenPagoAsientos
  fetch next from c_OrdenPagoAsientos into @opg_id, @est_id, @as_id

  while @@fetch_status=0 begin

    if @est_id = 7 begin

      update OrdenPago set as_id = null where opg_id = @opg_id
      exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
      delete OrdenPagoAsiento where opg_id = @opg_id

    end else begin

      exec sp_DocOrdenPagoAsientoSave @opg_id,0,@bError out, @MsgError out
      if @bError <> 0 begin
        raiserror ('Ha ocurrido un error al grabar la OrdenPago. sp_DocOrdenPagoAsientosSave.', 16, 1)
      end else begin
        delete OrdenPagoAsiento where opg_id = @opg_id
      end

    end

    fetch next from c_OrdenPagoAsientos into @opg_id, @est_id, @as_id
  end

  close c_OrdenPagoAsientos
  deallocate c_OrdenPagoAsientos

end