if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetPacking]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetPacking]

go

/*

update PackingList set pklst_nrodoc = pklst_numero
exec sp_DocFacturaVentaGetPacking 6,2

*/

create procedure sp_DocFacturaVentaGetPacking (
  @@emp_id          int,
  @@cli_id           int,
  @@mon_id          int
)
as

begin

declare @doct_PackingList     int set @doct_PackingList     = 21

  select 

        pklst.pklst_id,
        d.doc_nombre,
        pklst_numero,
        pklst_nrodoc,
        pklst_fecha,
        pklst_total,
        pklst_pendiente,
        pklst_descrip

  from PackingList pklst inner join Documento d on pklst.doc_id = d.doc_id
                         inner join Moneda m on d.mon_id = m.mon_id
  where 
          pklst.cli_id  = @@cli_id
    and    pklst.doct_id = @doct_PackingList
    and   d.mon_id    = @@mon_id
    and   d.emp_id   = @@emp_id
    and   exists(select pklsti_id from PackingListItem where pklst_id = pklst.pklst_id and pklsti_pendientefac > 0)

  order by 

        pklst_nrodoc,
        pklst_fecha
end
go