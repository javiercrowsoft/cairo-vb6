if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentasSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentasSetEstado]

/*

 sp_DocPedidoVentasSetEstado 

*/

go
create procedure sp_DocPedidoVentasSetEstado (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @pv_id int

  declare c_Ventas insensitive cursor for 
    select pv_id from PedidoVenta where pv_fecha between @@desde and @@hasta

  open c_Ventas

  fetch next from c_Ventas into @pv_id
  while @@fetch_status = 0 begin

    exec sp_DocPedidoVentaSetEstado @pv_id

    fetch next from c_Ventas into @pv_id
  end

  close c_Ventas
  deallocate c_Ventas
end