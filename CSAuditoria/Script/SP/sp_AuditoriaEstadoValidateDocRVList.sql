-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocRVList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocRVList]

go

create procedure sp_AuditoriaEstadoValidateDocRVList (

  @@rv_id       int

)
as

begin

  set nocount on

  declare @doct_id      int
  declare @rv_nrodoc     varchar(50) 
  declare @rv_numero     varchar(50) 

  select 
            @doct_id     = doct_id,
            @rv_nrodoc  = rv_nrodoc,
            @rv_numero  = convert(varchar,rv_numero)

  from RemitoVenta where rv_id = @@rv_id

  select rv_id, rvi_id, rvi_cantidadaremitir, rvi_pendientefac,
         IsNull(
            (select sum(rvfv_cantidad) from RemitoFacturaVenta 
             where rvi_id = rvi.rvi_id),0)

            as Facturado,

         IsNull(
            (select sum(rvdv_cantidad)   from RemitoDevolucionVenta 
             where 
                   (rvi_id_remito      = rvi.rvi_id and @doct_id = 3)
                or (rvi_id_devolucion  = rvi.rvi_id and @doct_id = 24)
            ),0) 

            as Devoluciones

  from RemitoVentaItem rvi
  where (rvi_pendientefac + (  IsNull(
                                (select sum(rvfv_cantidad) from RemitoFacturaVenta 
                                 where rvi_id = rvi.rvi_id),0)
                            +  IsNull(
                                (select sum(rvdv_cantidad)   from RemitoDevolucionVenta 
                                 where 
                                       (rvi_id_remito      = rvi.rvi_id and @doct_id = 3)
                                    or (rvi_id_devolucion  = rvi.rvi_id and @doct_id = 24)
                                ),0)
                          ) 
        ) <> rvi_cantidadaremitir
  
    and rv_id = @@rv_id  

  select rv_id, rvi_id, rvi_cantidad, rvi_pendiente,
         IsNull(
              (select sum(pvrv_cantidad) from PedidoRemitoVenta 
               where rvi_id = rvi.rvi_id),0)
            as Aplicado

  from RemitoVentaItem rvi
  where (rvi_pendiente + (    IsNull(
                                (select sum(pvrv_cantidad) from PedidoRemitoVenta 
                                 where rvi_id = rvi.rvi_id),0)
                          ) 
        ) <> rvi_cantidad
  
    and rv_id = @@rv_id

end
GO