if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServiciosSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServiciosSetPendiente]

/*

 sp_DocOrdenServiciosSetPendiente 

*/

go
create procedure sp_DocOrdenServiciosSetPendiente (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @os_id int

  declare c_Compras insensitive cursor for 
    select os_id from OrdenServicio where os_fecha between @@desde and @@hasta

  open c_Compras

  fetch next from c_Compras into @os_id
  while @@fetch_status = 0 begin

    exec sp_DocOrdenServicioSetItemPendiente @os_id
    exec sp_DocOrdenServicioSetPendiente @os_id

    fetch next from c_Compras into @os_id
  end

  close c_Compras
  deallocate c_Compras
end