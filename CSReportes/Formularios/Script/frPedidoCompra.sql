/*

select * from PedidoCompra
frPedidoCompra 2

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frPedidoCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frPedidoCompra]

go
create procedure frPedidoCompra (

  @@pc_id      int

)as 

begin

  select PedidoCompra.*, 
         PedidoCompraItem.*, 
         doc_nombre, 
         ccos_nombre, 
         suc_nombre,
         pr_nombrecompra,
         prs_nombre + ' ' + prs_apellido as Nombre,
         us_nombre as usuario 
      

  from PedidoCompra  inner join PedidoCompraItem       on PedidoCompra.pc_id         = PedidoCompraItem.pc_id
                     inner join Documento             on PedidoCompra.doc_id        = Documento.doc_id
                     inner join Usuario               on PedidoCompra.us_id         = Usuario.us_id
                     inner join Producto              on PedidoCompraItem.pr_id     = Producto.pr_id

                     left join  Persona                on Persona.prs_id              = Usuario.prs_id
                     left join  Legajo                on PedidoCompra.lgj_id        = Legajo.lgj_id
                     left join  Sucursal              on PedidoCompra.suc_id        = Sucursal.suc_id
                     left join  CentroCosto           on PedidoCompraItem.ccos_id   = CentroCosto.ccos_id
                     

  where PedidoCompra.pc_id = @@pc_id

  order by pci_orden

end
go

