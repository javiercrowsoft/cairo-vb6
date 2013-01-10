if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraGetPedidos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraGetPedidos]

go

/*

sp_DocOrdenCompraGetPedidos 1,1,2

*/

create procedure sp_DocOrdenCompraGetPedidos (
  @@emp_id          int,
  @@us_id           int,
  @@mon_id          int
)
as

begin

declare @doct_pedido     int set @doct_pedido     = 6

  select 

        pc.pc_id,
        d.doc_nombre,
        pc_numero,
        pc_nrodoc,
        pc_fecha,
        pc_total,
        pc_pendiente,
        pc_descrip

  from PedidoCompra pc inner join Documento d on pc.doc_id = d.doc_id
                      inner join Moneda m on d.mon_id = m.mon_id
  where 
          (pc.us_id    = @@us_id or @@us_id = 0)
    and   pc.est_id   <> 7 -- Anulado
    and    pc.doct_id  = @doct_pedido
    and   d.mon_id     = @@mon_id
    and    d.emp_id    = @@emp_id
    and   exists(select pci_id from PedidoCompraItem where pc_id = pc.pc_id and pci_pendiente > 0)

    and   ((pc.pc_firmado <> 0 and d.doc_llevaFirma <> 0) or d.doc_llevaFirma = 0)

  order by 

        pc_nrodoc,
        pc_fecha
end
go