-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocCOT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocCOT]

go

create procedure sp_AuditoriaEstadoValidateDocCOT (

  @@cot_id       int,
  @@aud_id       int

)
as

begin

  set nocount on

  declare @audi_id       int
  declare @doct_id      int
  declare @cot_nrodoc   varchar(50) 
  declare @cot_numero   varchar(50) 
  declare @est_id       int

  select 
            @doct_id      = doct_id,
            @cot_nrodoc  = cot_nrodoc,
            @cot_numero  = convert(varchar,cot_numero),
            @est_id      = est_id

  from CotizacionCompra where cot_id = @@cot_id

  if exists(select * from CotizacionCompraItem coti
            where (coti_pendiente +  (    
                                      + IsNull(
                                          (select sum(pccot_cantidad) from PedidoCotizacionCompra 
                                           where coti_id = coti.coti_id),0)
                                    ) 
                  ) <> coti_cantidad

              and cot_id = @@cot_id
            )
  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de esta cotizacion no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @cot_nrodoc + ' nro.: '+ @cot_numero + ')',
                                 3,
                                 3,
                                 @doct_id,
                                 @@cot_id
                                )
  end

  if exists(select * from CotizacionCompraItem coti
            where (coti_pendienteoc +  (    
                                      + IsNull(
                                          (select sum(cotoc_cantidad) from CotizacionOrdenCompra 
                                           where coti_id = coti.coti_id),0)
                                    ) 
                  ) <> coti_cantidad

              and cot_id = @@cot_id
            )
  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de los items de esta cotizacion no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @cot_nrodoc + ' nro.: '+ @cot_numero + ')',
                                 3,
                                 3,
                                 @doct_id,
                                 @@cot_id
                                )
  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @cot_pendiente  decimal(18,6)

    select 
            @cot_pendiente    = sum(coti_pendiente)

    from CotizacionCompraItem where cot_id = @@cot_id

    if @cot_pendiente = 0 begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El pedido no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma '
                                   + '(comp.:' + @cot_nrodoc + ' nro.: '+ @cot_numero + ')',
                                   3,
                                   3,
                                   @doct_id,
                                   @@cot_id
                                  )
    end

  end

ControlError:

end
GO