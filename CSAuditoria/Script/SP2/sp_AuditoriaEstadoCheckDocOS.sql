-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocOS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocOS]

go

create procedure sp_AuditoriaEstadoCheckDocOS (

  @@os_id       int,
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
  declare @os_nrodoc     varchar(50) 
  declare @os_numero     varchar(50) 
  declare @est_id       int

  select 
            @doct_id     = doct_id,
            @os_nrodoc  = os_nrodoc,
            @os_numero  = convert(varchar,os_numero),
            @est_id     = est_id

  from OrdenServicio where os_id = @@os_id

  if exists(select * from OrdenServicioItem osi
            where (osi_pendiente + (  IsNull(
                                          (select sum(osrv_cantidad) from OrdenRemitoVenta
                                           where osi_id = osi.osi_id),0)
                                    ) 
                  ) <> osi_cantidadaremitir

              and os_id = @@os_id
            )
  begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de esta orden de servicio no coincide con la suma de sus aplicaciones' + char(10)

  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @os_pendiente  decimal(18,6)

    select 
            @os_pendiente    = sum(osi_pendiente)

    from OrdenServicioItem where os_id = @@os_id

    if @os_pendiente = 0 begin

        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'La orden de servicio no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)

    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO