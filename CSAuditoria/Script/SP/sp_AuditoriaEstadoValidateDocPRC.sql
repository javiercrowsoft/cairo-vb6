-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocPRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocPRC]

go

create procedure sp_AuditoriaEstadoValidateDocPRC (

  @@prc_id       int,
  @@aud_id       int

)
as

begin

  set nocount on

  declare @audi_id       int
  declare @doct_id      int
  declare @prc_nrodoc   varchar(50) 
  declare @prc_numero   varchar(50) 
  declare @est_id       int

  select 
            @doct_id      = doct_id,
            @prc_nrodoc  = prc_nrodoc,
            @prc_numero  = convert(varchar,prc_numero),
            @est_id      = est_id

  from PresupuestoCompra where prc_id = @@prc_id

  if exists(select * from PresupuestoCompraItem prci
            where (prci_pendiente 
                                +   (    IsNull(
                                          (select sum(cotprc_cantidad) from CotizacionPresupuestoCompra 
                                           where prci_id = prci.prci_id),0)
                                    ) 
                  ) <> prci_cantidad

              and prc_id = @@prc_id
            )
  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de esta presupuesto de compra no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @prc_nrodoc + ' nro.: '+ @prc_numero + ')',
                                 3,
                                 3,
                                 @doct_id,
                                 @@prc_id
                                )
  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @prc_pendiente  decimal(18,6)

    select 
            @prc_pendiente    = sum(prci_pendiente)

    from PresupuestoCompraItem where prc_id = @@prc_id

    if @prc_pendiente = 0 begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El presupuesto de compra no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
                                   + '(comp.:' + @prc_nrodoc + ' nro.: '+ @prc_numero + ')',
                                   3,
                                   3,
                                   @doct_id,
                                   @@prc_id
                                  )
    end

  end

ControlError:

end
GO