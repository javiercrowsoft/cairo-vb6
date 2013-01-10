if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorProductos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorProductos2]

/*

sp_infoProveedorProductos 1,1,34

*/

go
create procedure sp_infoProveedorProductos2 (
  @@us_id         int,
  @@emp_id        int,
  @@prov_id        int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  declare @fDesde datetime

  set @fDesde = dateadd(d,-180,getdate())

  select   top 40

          fc.doct_id,
          fc.fc_id, 
          pr_nombreCompra  as [Artículo],
          fc_fecha          as Fecha,
          fc_nrodoc         as Comprobante,

          (case when fc.doct_id = 8 then -fci_cantidad   else fci_cantidad  end) as Cantidad,
          (case when fc.doct_id = 8 then -fci_precio     else fci_precio    end)  as Precio,
          (case when fc.doct_id = 8 then -fci_importe    else fci_importe   end) as Importe,
          (case when fc.doct_id = 8 then -fci_pendiente  else fci_pendiente end)  as Pendiente,

          emp_nombre       as Empresa,
          fci_descrip      as Obsercaciones

  from FacturaCompra fc inner join FacturaCompraItem fci  on fc.fc_id   = fci.fc_id
                        inner join Documento doc          on fc.doc_id  = doc.doc_id
                        inner join Producto pr            on fci.pr_id  = pr.pr_id
                        inner join Empresa emp            on doc.emp_id = emp.emp_id

  where prov_id = @@prov_id 
    and fc_fecha >= @fDesde
    and est_id <> 7

  union all

  select   top 40

          oc.doct_id,
          oc.oc_id, 
          pr_nombreCompra  as [Artículo],
          oc_fecha          as Fecha,
          oc_nrodoc         as Comprobante,

          (case when oc.doct_id = 36 then -oci_cantidad   else oci_cantidad  end) as Cantidad,
          (case when oc.doct_id = 36 then -oci_precio     else oci_precio    end)  as Precio,
          (case when oc.doct_id = 36 then -oci_importe    else oci_importe   end) as Importe,
          (case when oc.doct_id = 36 then -oci_pendiente  else oci_pendiente end)  as Pendiente,

          emp_nombre       as Empresa,
          oci_descrip      as Obsercaciones

  from OrdenCompra oc   inner join OrdenCompraItem oci    on oc.oc_id  = oci.oc_id
                        inner join Producto pr            on oci.pr_id = pr.pr_id
                        inner join Empresa emp             on oc.emp_id = emp.emp_id

  where prov_id = @@prov_id 
    and oc_fecha >= @fDesde
    and est_id <> 7

  union all

  select   top 40

          rc.doct_id,
          rc.rc_id, 
          pr_nombreCompra    as [Artículo],
          rc_fecha           as Fecha,
          rc_nrodoc          as Comprobante,

          (case when rc.doct_id = 25 then -rci_cantidad     else rci_cantidad      end) as Cantidad,
          (case when rc.doct_id = 25 then -rci_precio       else rci_precio        end) as Precio,
          (case when rc.doct_id = 25 then -rci_importe      else rci_importe       end) as Importe,
          (case when rc.doct_id = 25 then -rci_pendientefac  else rci_pendientefac end) as Pendiente,

          emp_nombre        as Empresa,
          rci_descrip       as Obsercaciones

  from RemitoCompra rc  inner join RemitoCompraItem rci   on rc.rc_id   = rci.rc_id
                        inner join Documento doc          on rc.doc_id  = doc.doc_id
                        inner join Producto pr            on rci.pr_id  = pr.pr_id
                        inner join Empresa emp             on doc.emp_id = emp.emp_id

  where prov_id = @@prov_id 
    and rc_fecha >= @fDesde
    and est_id <> 7

  order by pr_nombreCompra, fc_fecha, fc.fc_id, emp_nombre

end
go