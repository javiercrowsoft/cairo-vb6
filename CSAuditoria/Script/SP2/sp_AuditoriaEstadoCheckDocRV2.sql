-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocRV2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocRV2]

go

create procedure sp_AuditoriaEstadoCheckDocRV2 (

  @@rv_id       int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  declare @bError tinyint

  set @bError     = 0
  set @@bSuccess   = 0
  set @@bErrorMsg = '@@ERROR_SP:'

  declare @doct_id      int
  declare @rv_nrodoc     varchar(50) 
  declare @rv_numero     varchar(50) 
  declare @est_id       int
  declare @rv_desde_os  tinyint

  select 
            @doct_id       = rv.doct_id,
            @rv_nrodoc    = rv_nrodoc,
            @rv_numero    = convert(varchar,rv_numero),
            @est_id       = est_id,
            @rv_desde_os  = doc_rv_desde_os

  from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id
  where rv_id = @@rv_id

  if exists(select rvi_id from RemitoVentaItem rvi
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
            )
  begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones (con facturas)' + char(10)

  end

  if exists(select rvi_id from RemitoVentaItem rvi inner join Producto pr on rvi.pr_id = pr.pr_id
            where (rvi_pendiente + (    IsNull(
                                          (select sum(pvrv_cantidad) from PedidoRemitoVenta 
                                           where rvi_id = rvi.rvi_id),0)
                                    ) 
                                 + (    IsNull(
                                          (select sum(osrv_cantidad) from OrdenRemitoVenta 
                                           where rvi_id = rvi.rvi_id),0)
                                    ) 
                  ) <> rvi_cantidad

              and rv_id = @@rv_id
              and (pr_esrepuesto = 0 or @rv_desde_os = 0)
            )
  begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de este remito no coincide con la suma de sus aplicaciones (con pedidos)' + char(10)
                  
  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @rv_pendiente  decimal(18,6)

    select 
            @rv_pendiente    = sum(rvi_pendientefac)

    from RemitoVentaItem where rv_id = @@rv_id

    if @rv_pendiente = 0 begin

        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'El remito no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)
                    
    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO