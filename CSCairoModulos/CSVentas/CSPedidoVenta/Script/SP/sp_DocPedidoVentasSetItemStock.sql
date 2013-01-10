if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentasSetItemStock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentasSetItemStock]

/*

  sp_DocPedidoVentasSetItemStock

*/

go
create procedure sp_DocPedidoVentasSetItemStock 

as

begin

  set nocount on

  delete PedidoVentaItemStock 
  
  declare @pv_id int
  declare c_pedidos insensitive cursor for select pv_id from pedidoventa where est_id in (1,2,3,4,8)
  
  open c_pedidos
  
  fetch next from c_pedidos into @pv_id
  while @@fetch_status=0
  begin
  
    exec sp_DocPedidoVentaSetItemStock @pv_id, 0
  
    fetch next from c_pedidos into @pv_id
  end
  
  close c_pedidos
  deallocate c_pedidos

  select * from PedidoVentaItemStock

end
GO