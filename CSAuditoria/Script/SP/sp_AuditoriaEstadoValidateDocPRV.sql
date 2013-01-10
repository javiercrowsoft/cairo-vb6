-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocPRV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocPRV]

go

create procedure sp_AuditoriaEstadoValidateDocPRV (

  @@prv_id      int,
  @@aud_id       int

)
as

begin

  set nocount on

  declare @audi_id       int
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
            where (prvi_pendiente +  (  IsNull(
                                          (select sum(prvpv_cantidad) from PresupuestoPedidoVenta 
                                           where prvi_id = prvi.prvi_id),0)
                                    ) 
                  ) <> prvi_cantidadaremitir

              and prv_id = @@prv_id
            )
  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de este presupuesto no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @prv_nrodoc + ' nro.: '+ @prv_numero + ')',
                                 3,
                                 3,
                                 @doct_id,
                                 @@prv_id
                                )
  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @prv_pendiente  decimal(18,6)

    select 
            @prv_pendiente    = sum(prvi_pendiente)

    from PresupuestoVentaItem where prv_id = @@prv_id

    if @prv_pendiente = 0 begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El pedido no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
                                   + '(comp.:' + @prv_nrodoc + ' nro.: '+ @prv_numero + ')',
                                   3,
                                   3,
                                   @doct_id,
                                   @@prv_id
                                  )
    end

  end

ControlError:

end
GO