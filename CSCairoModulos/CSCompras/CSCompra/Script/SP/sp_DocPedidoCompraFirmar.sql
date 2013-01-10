if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraFirmar]

go

/*

PedidoCompra                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pc_id                     reemplazar por el id del documento ej pv_id  (incluir 2 arrobas (@@))
PedidoCompra                 reemplazar por el nombre de la tabla ej PedidoVenta
pc_id                     reemplazar por el campo ID ej. pv_id
pc_firmado                reemplazar por el campo pv_firmado

sp_DocPedidoCompraFirmar 17,8

*/

create procedure sp_DocPedidoCompraFirmar (
  @@pc_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select pc_firmado from PedidoCompra where pc_id = @@pc_id and pc_firmado <> 0)
  begin
    update PedidoCompra set pc_firmado = 0 where pc_id = @@pc_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update PedidoCompra set pc_firmado = @@us_id where pc_id = @@pc_id
    set @bFirmar = 0
  end

  exec sp_DocPedidoCompraSetEstado @@pc_id

  select PedidoCompra.est_id,est_nombre 
  from PedidoCompra inner join Estado on PedidoCompra.est_id = Estado.est_id
  where pc_id = @@pc_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 17005, @@pc_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 17005, @@pc_id, @@us_id, 10

end