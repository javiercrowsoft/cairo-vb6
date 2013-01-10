if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetRemitos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetRemitos]

go

/*

update Remitoventa set rv_nrodoc = rv_numero
exec sp_DocFacturaVentaGetRemitos 6,2

*/

create procedure sp_DocFacturaVentaGetRemitos (
  @@emp_id          int,
  @@cli_id           int,
  @@mon_id          int
)
as

begin

declare @doct_Remito     int set @doct_Remito     = 3

  select 

        rv.rv_id,
        d.doc_nombre,
        rv_numero,
        rv_nrodoc,
        rv_fecha,
        rv_total,
        rv_pendiente,
        rv_descrip

  from RemitoVenta rv inner join Documento d on rv.doc_id = d.doc_id
                      inner join Moneda m on d.mon_id = m.mon_id
  where 
          rv.cli_id  = @@cli_id
    and   rv.est_id  <> 7 -- Anulado
    and    rv.doct_id = @doct_Remito
    and   d.mon_id    = @@mon_id
    and   d.emp_id   = @@emp_id
    and   exists(select rvi_id from RemitoVentaItem where rv_id = rv.rv_id and rvi_pendientefac > 0)

  order by 

        rv_nrodoc,
        rv_fecha
end
go