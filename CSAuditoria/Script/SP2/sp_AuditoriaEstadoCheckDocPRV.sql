-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocPRV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocPRV]

go

create procedure sp_AuditoriaEstadoCheckDocPRV (

  @@prv_id      int,
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
  declare @prv_nrodoc   varchar(50) 
  declare @prv_numero   varchar(50) 
  declare @est_id       int

  select 
            @doct_id       = doct_id,
            @prv_nrodoc    = prv_nrodoc,
            @prv_numero    = convert(varchar,prv_numero),
            @est_id       = est_id

  from PresupuestoVenta where prv_id = @@prv_id

  if exists(select * from PresupuestoVentaItem prvi
            where (prvi_pendiente +  (    IsNull(
                                          (select sum(prvpv_cantidad) from PresupuestoPedidoVenta 
                                           where prvi_id = prvi.prvi_id),0)
                                      +  IsNull(
                                          (select sum(prvdv_cantidad)   from PresupuestoDevolucionVenta 
                                           where 
                                                 (prvi_id_presupuesto = prvi.prvi_id and @doct_id = 11)
                                              or (prvi_id_devolucion  = prvi.prvi_id and @doct_id = 39)
                                          ),0)
                                    ) 
                  ) <> prvi_cantidadaremitir

              and prv_id = @@prv_id
            )
  begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de este presupuesto no coincide con la suma de sus aplicaciones' + char(10)
                  
  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @prv_pendiente  decimal(18,6)

    select 
            @prv_pendiente    = sum(prvi_pendiente)

    from PresupuestoVentaItem where prv_id = @@prv_id

    if @prv_pendiente = 0 begin

        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'El presupuesto no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)
                    
    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO