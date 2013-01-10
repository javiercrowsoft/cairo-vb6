if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListGetPedidos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListGetPedidos]

go

/*

update pedidoventa set pv_nrodoc = pv_numero
exec sp_DocPackingListGetPedidos 6,2

*/

create procedure sp_DocPackingListGetPedidos (
  @@emp_id          int,
  @@cli_id           int,
  @@mon_id          int
)
as

begin

declare @doct_pedido     int set @doct_pedido     = 5

  select 

        pv.pv_id,
        d.doc_nombre,
        pv_numero,
        pv_nrodoc,
        pv_fecha,
        pv_total,
        pv_pendiente,
        pv_descrip

  from PedidoVenta pv inner join Documento d on pv.doc_id = d.doc_id
                      inner join Moneda m on d.mon_id = m.mon_id
  where 
          pv.cli_id  = @@cli_id
    and    pv.doct_id = @doct_pedido
    and   d.mon_id    = @@mon_id
    and   d.emp_id   = @@emp_id
    and   exists(select pvi_id from PedidoVentaItem where pv_id = pv.pv_id and pvi_pendiente > 0)

  order by 

        pv_nrodoc,
        pv_fecha
end
go