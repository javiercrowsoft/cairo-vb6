if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoComprasSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoComprasSetCredito]

/*

 sp_DocRemitoComprasSetCredito 

*/

go
create procedure sp_DocRemitoComprasSetCredito (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @rc_id int

  declare c_compras insensitive cursor for 
    select rc_id from Remitocompra where rc_fecha between @@desde and @@hasta

  open c_compras

  fetch next from c_compras into @rc_id
  while @@fetch_status = 0 begin

    exec sp_DocRemitoCompraSetCredito @rc_id

    fetch next from c_compras into @rc_id
  end

  close c_compras
  deallocate c_compras
end