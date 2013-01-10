if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorPedidos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorPedidos2]

/*

sp_infoProveedorPedidos 1,1,39

*/

go
create procedure sp_infoProveedorPedidos2 (
  @@us_id         int,
  @@emp_id        int,
  @@prov_id       int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  declare @fDesde datetime

  set @fDesde = dateadd(d,-180,getdate())

  select   top 20

          oc.doct_id,
          oc.oc_id, 
          oc_fecha         as Fecha,
          oc_nrodoc        as Comprobante,

          (case when oc.doct_id = 36 then -oc_total     else oc_total      end)  as Total,
          (case when oc.doct_id = 36 then -oc_pendiente else oc_pendiente  end)  as Pendiente,

          emp_nombre      as Empresa,
          oc_descrip      as Obsercaciones

  from OrdenCompra oc  inner join Empresa emp on oc.emp_id = emp.emp_id
                       inner join OrdenCompraItem oci on oc.oc_id = oci.oc_id

  where prov_id = @@prov_id 
    and oc_fecha >= @fDesde
    and est_id <> 7
    and est_id <> 5

  group by 
          oc.doct_id,
          oc.oc_id, 
          oc_fecha,         
          oc_nrodoc,        
          oc_total,        
          oc_pendiente,     
          emp_nombre,      
          oc_descrip      

  having sum(oci_pendiente) > 0

  union all

  select   top 20

          rc.doct_id,
          rc.rc_id, 
          rc_fecha         as Fecha,
          rc_nrodoc        as Comprobante,

          (case when rc.doct_id = 25 then -rc_total     else rc_total      end)  as Total,
          (case when rc.doct_id = 25 then -rc_pendiente else rc_pendiente  end)  as Pendiente,

          emp_nombre      as Empresa,
          rc_descrip      as Obsercaciones

  from RemitoCompra rc  inner join Documento doc on rc.doc_id = doc.doc_id
                        inner join Empresa emp on doc.emp_id = emp.emp_id
                         inner join RemitoCompraItem rci on rc.rc_id = rci.rc_id

  where prov_id = @@prov_id 
    and rc_fecha >= @fDesde
    and est_id <> 7
    and est_id <> 5

  group by 
          rc.doct_id,
          rc.rc_id, 
          rc_fecha,         
          rc_nrodoc,        
          rc_total,        
          rc_pendiente,     
          emp_nombre,      
          rc_descrip      

  having sum(rci_pendientefac) > 0

  order by oc_fecha, oc.oc_id, emp_nombre

end
go