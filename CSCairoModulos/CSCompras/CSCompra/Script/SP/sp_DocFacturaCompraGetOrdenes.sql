if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetOrdenes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetOrdenes]

go

/*
select * from documentotipo
update OrdenCompra set oc_nrodoc = oc_numero
exec sp_DocFacturaCompraGetOrdenes 4,2

*/

create procedure sp_DocFacturaCompraGetOrdenes (
	@@emp_id					int,
	@@prov_id 				int,
  @@mon_id          int
)
as

begin

declare @doct_Orden 		int set @doct_Orden 		= 35

	select 

				oc.oc_id,
				d.doc_nombre,
				oc_numero,
        oc_nrodoc,
        oc_fecha,
        oc_total,
        oc_pendiente,
        oc_descrip

  from OrdenCompra oc inner join Documento d on oc.doc_id = d.doc_id
											inner join Moneda m on d.mon_id = m.mon_id
	where 
					oc.prov_id  = @@prov_id
		and   oc.est_id   <> 7 -- Anulado
		and		oc.doct_id  = @doct_Orden
    and   d.mon_id 	  = @@mon_id
		and   d.emp_id    = @@emp_id
    and   exists(select oci_id from OrdenCompraItem where oc_id = oc.oc_id and oci_pendientefac > 0)

	order by 

				oc_nrodoc,
				oc_fecha
end
go