if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorCompras2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorCompras2]

/*

sp_infoProveedorCompras '',114,1

*/

go
create procedure sp_infoProveedorCompras2 (
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

          fc.fc_id, 
          fc_fecha         as Fecha,
          fc_nrodoc        as Comprobante,

          (case when fc.doct_id = 8 then -fc_total         else fc_total       end) as Total,
          (case when fc.doct_id = 8 then -fcd_pendiente   else fcd_pendiente   end) as Pendiente,

          fcd_fecha       as Vto,
          emp_nombre      as Empresa,
          fc_descrip      as Observaciones

  from FacturaCompra fc inner join FacturaCompraDeuda fcd on fc.fc_id   = fcd.fc_id
                        inner join Documento doc          on fc.doc_id  = doc.doc_id
                         inner join Empresa emp             on doc.emp_id = emp.emp_id

  where prov_id = @@prov_id 
    and fc_fecha >= @fDesde
    and est_id <> 7

  order by fc_fecha desc, fc.fc_id, fcd_fecha, emp_nombre

end
go