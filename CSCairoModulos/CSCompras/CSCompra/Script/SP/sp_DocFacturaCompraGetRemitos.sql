if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetRemitos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetRemitos]

go

/*
select * from documentotipo
select * from remitocompraitem
exec sp_DocFacturaCompraGetRemitos 4,2

*/

create procedure sp_DocFacturaCompraGetRemitos (
  @@emp_id          int,
  @@prov_id         int,
  @@mon_id          int
)
as

begin

declare @doct_Remito     int set @doct_Remito     = 4

  select 

        rc.rc_id,
        d.doc_nombre,
        rc_numero,
        rc_nrodoc,
        rc_fecha,
        rc_total,
        rc_pendiente,
        rc_descrip

  from RemitoCompra rc inner join Documento d on rc.doc_id = d.doc_id
                       inner join Moneda m on d.mon_id = m.mon_id
  where 
          rc.prov_id  = @@prov_id
    and   rc.est_id   <> 7 -- Anulado
    and    rc.doct_id  = @doct_Remito
    and   d.mon_id     = @@mon_id
    and   d.emp_id    = @@emp_id
    and   exists(select rci_id from RemitoCompraItem where rc_id = rc.rc_id and rci_pendientefac > 0)

  order by 

        rc_nrodoc,
        rc_fecha
end
go