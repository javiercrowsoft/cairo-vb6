if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocGetDocIdForDoctId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocGetDocIdForDoctId]

go

/*

  sp_DocGetDocIdForDoctId 

*/

create procedure sp_DocGetDocIdForDoctId (
  @@emp_id          int,
  @@us_id           int,
  @@doct_id         int,
  @@doct_id_aplic    int,
  @@id              int,
  @@idEx             int   -- -1 Factura de Venta sobre Horas
                          -- -2 Remito de venta basado en boms
)
as

set nocount on

begin

  declare @mon_id int


  if @@doct_id_aplic = 3 -- Remitos de Venta
  begin

    select @mon_id = doc.mon_id 
    from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id
    where rv_id = @@id

  end else
  if @@doct_id_aplic= 4 -- Remitos de Compra
  begin

    select @mon_id = doc.mon_id 
    from RemitoCompra rc inner join Documento doc on rc.doc_id = doc.doc_id
    where rc_id = @@id
  
  end
  if @@doct_id_aplic = 5 -- Pedidos de Venta
  begin

    select @mon_id = doc.mon_id 
    from PedidoVenta pv inner join Documento doc on pv.doc_id = doc.doc_id
    where pv_id = @@id

  end else
  if @@doct_id_aplic = 11 -- Presupuesto de Venta
  begin

    select @mon_id = doc.mon_id 
    from PresupuestoVenta prv inner join Documento doc on prv.doc_id = doc.doc_id
    where prv_id = @@id

  end else
  if @@doct_id_aplic= 35 -- Ordenes de Compra
  begin

    select @mon_id = doc.mon_id 
    from OrdenCompra oc inner join Documento doc on oc.doc_id = doc.doc_id
    where oc_id = @@id
  
  end

  if @mon_id is null select @mon_id = mon_id from Moneda where mon_legal <> 0

  select doc_id,
         doc_nombre
  from Documento doc
  where doc.doct_id = @@doct_id
    and doc.mon_id  = @mon_id 
    and doc.emp_id  = @@emp_id
/*
  csETFacDirecta = 0
  csETFacPedido = 1
  csETFacRemito = 2
  csETFacPackingList = 3
  csETFacProyecto = 4
  csETFacOrden = 5
*/
    and (
              (doc_rv_desde_pv <> 0 and @@doct_id_aplic = 5  and @@doct_id = 3)
          or  (doc_rv_desde_os <> 0 and @@doct_id_aplic = 42 and @@doct_id = 3)
          or  (doc_rv_bom <> 0       and @@doct_id_aplic = 5  and @@doct_id = 3 and @@IdEx = -2)

          or  (doc_pv_desde_prv <> 0 and @@doct_id_aplic = 11 and @@doct_id = 5)

          or  (doc_rc_desde_oc <> 0 and @@doct_id_aplic = 35 and @@doct_id = 4)

          or  (doc_tipofactura  = 5 and @@doct_id_aplic = 35 and @@doct_id = 2)
          or  (doc_tipofactura  = 2 and @@doct_id_aplic = 4  and @@doct_id = 2)

          or  (doc_tipofactura  = 1 and @@doct_id_aplic = 5  and @@doct_id = 1)
          or  (doc_tipofactura  = 2 and @@doct_id_aplic = 3  and @@doct_id = 1)
          or  (doc_tipofactura  = 3 and @@doct_id_aplic = 21 and @@doct_id = 1)
          or  (doc_tipofactura  = 4 and @@doct_id_aplic = 0  and @@doct_id = 1 and @@IdEx = -1)
        )
    and exists(select * from Permiso 
               where pre_id = doc.pre_id_new
                 and (
                        (
                        us_id = @@us_id
                        )
                        or
                        exists(
                            select us_id from usuarioRol
                            where us_id  = @@us_id
                              and rol_id = permiso.rol_id
                        )
                      )
              )
end

go
