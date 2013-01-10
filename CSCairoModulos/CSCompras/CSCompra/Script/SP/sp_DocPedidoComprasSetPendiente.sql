if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoComprasSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoComprasSetPendiente]

/*

 sp_DocPedidoComprasSetPendiente 

*/

go
create procedure sp_DocPedidoComprasSetPendiente (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @pc_id int

  declare c_Compras insensitive cursor for 
    select pc_id from PedidoCompra where pc_fecha between @@desde and @@hasta

  open c_Compras

  fetch next from c_Compras into @pc_id
  while @@fetch_status = 0 begin

    exec sp_DocPedidoCompraSetItemPendiente @pc_id
    exec sp_DocPedidoCompraSetPendiente @pc_id

    fetch next from c_Compras into @pc_id
  end

  close c_Compras
  deallocate c_Compras
end

go