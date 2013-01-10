if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClientePedidos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClientePedidos2]

/*

sp_infoClientePedidos 1,1,39

*/

go
create procedure sp_infoClientePedidos2 (
  @@us_id         int,
  @@emp_id        int,
  @@cli_id        int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  declare @fDesde datetime

  set @fDesde = dateadd(d,-180,getdate())

  select   top 20

          pv.doct_id,
          pv.pv_id, 
          pv_fecha         as Fecha,
          pv_nrodoc        as Comprobante,

          (case when pv.doct_id = 22 then -pv_total     else pv_total     end) as Total,
          (case when pv.doct_id = 22 then -pv_pendiente else pv_pendiente end) as Pendiente,

          emp_nombre      as Empresa,
          pv_descrip      as Observaciones

  from PedidoVenta pv  inner join Empresa emp on pv.emp_id = emp.emp_id
                       inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id

  where cli_id = @@cli_id 
    and pv_fecha >= @fDesde
    and est_id <> 7
    and est_id <> 5

  group by 
          pv.doct_id,
          pv.pv_id, 
          pv_fecha,         
          pv_nrodoc,        
          pv_total,        
          pv_pendiente,     
          emp_nombre,      
          pv_descrip      

  having sum(pvi_pendiente) > 0

  union all

  select   top 20

          rv.doct_id,
          rv.rv_id, 
          rv_fecha         as Fecha,
          rv_nrodoc        as Comprobante,

          (case when rv.doct_id = 24 then -rv_total     else rv_total     end) as Total,
          (case when rv.doct_id = 24 then -rv_pendiente else rv_pendiente end) as Pendiente,

          emp_nombre      as Empresa,
          rv_descrip      as Observaciones

  from RemitoVenta rv  inner join Empresa emp on rv.emp_id = emp.emp_id
                       inner join RemitoVentaItem rvi on rv.rv_id = rvi.rv_id

  where cli_id = @@cli_id 
    and rv_fecha >= @fDesde
    and est_id <> 7
    and est_id <> 5

  group by 
          rv.doct_id,
          rv.rv_id, 
          rv_fecha,         
          rv_nrodoc,        
          rv_total,
          rv_pendiente,
          emp_nombre,      
          rv_descrip      

  having sum(rvi_pendientefac) > 0

  order by pv_fecha, pv.pv_id, emp_nombre

end
go