if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServiciosSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServiciosSetCredito]

/*

 sp_DocOrdenServiciosSetCredito 

*/

go
create procedure sp_DocOrdenServiciosSetCredito (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @os_id int

  declare c_compras insensitive cursor for 
    select os_id from OrdenServicio where os_fecha between @@desde and @@hasta

  open c_compras

  fetch next from c_compras into @os_id
  while @@fetch_status = 0 begin

    exec sp_DocOrdenServicioSetCredito @os_id

    fetch next from c_compras into @os_id
  end

  close c_compras
  deallocate c_compras
end