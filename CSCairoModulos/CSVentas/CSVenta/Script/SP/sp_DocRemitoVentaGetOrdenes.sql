if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetOrdenes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetOrdenes]

go

/*

update ordenventa set os_nrodoc = os_numero
exec sp_DocRemitoVentaGetOrdenes 1,39,2

*/

create procedure sp_DocRemitoVentaGetOrdenes (
  @@emp_id          int,
  @@cli_id           int,
  @@mon_id          int
)
as

begin

  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Servicios-General',
                        'Exigir Tareas Cumplidas Para Remitir',
                        @cfg_valor out,
                        0
  declare @bTareas int
  set @bTareas = convert(int,IsNull(@cfg_valor,0))

  declare @doct_orden     int set @doct_orden     = 42

  select 

        os.os_id,
        d.doc_nombre,
        os_numero,
        os_nrodoc,
        os_fecha,
        os_total,
        os_pendiente,
        os_descrip

  from OrdenServicio os inner join Documento d   on os.doc_id = d.doc_id
                        inner join Moneda m     on d.mon_id = m.mon_id
  where 
          os.cli_id  = @@cli_id
    and   os.est_id <> 7 -- Anulado
    and    os.doct_id = @doct_orden
    and   d.mon_id    = @@mon_id
    and   d.emp_id   = @@emp_id
    and   exists(select osi_id from OrdenServicioItem where os_id = os.os_id and osi_pendiente > 0)

    and   (     not exists(select tar_id from Tarea where os_id = os.os_id and tar_finalizada = 0)
            or   @bTareas = 0
          )

  order by 

        os_nrodoc,
        os_fecha
end
go