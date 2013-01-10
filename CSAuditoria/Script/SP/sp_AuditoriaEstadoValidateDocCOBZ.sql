-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocCOBZ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocCOBZ]

go

create procedure sp_AuditoriaEstadoValidateDocCOBZ (

  @@cobz_id     int,
  @@aud_id       int

)
as

begin

  set nocount on

  declare @audi_id           int
  declare @doct_id          int
  declare @cobz_nrodoc       varchar(50) 
  declare @cobz_numero       varchar(50) 
  declare @est_id           int
  declare @cobz_pendiente    decimal(18,6)
  declare @cobz_total        decimal(18,6)
  declare @aplicado         decimal(18,6)

  select 
            @doct_id          = doct_id,
            @cobz_nrodoc    = cobz_nrodoc,
            @cobz_numero    = convert(varchar,cobz_numero),
            @est_id          = est_id,
            @cobz_pendiente  = cobz_pendiente,
            @cobz_total      = cobz_total

  from Cobranza where cobz_id = @@cobz_id

  select @aplicado = (IsNull(
                          (select sum(fvcobz_importe) from FacturaVentaCobranza 
                           where cobz_id = @@cobz_id),0)
                      )

  if abs(round(@cobz_total,2) - round(@cobz_pendiente + @aplicado,2)) > 0.01  begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de la cobranza no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
                                 3,
                                 3,
                                 @doct_id,
                                 @@cobz_id
                                )
  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    if round(@cobz_pendiente,2) = 0 begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'La cobranza no tiene pendiente y su estado no es finalizado, o anulado, o pendiente de firma '
                                   + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
                                   3,
                                   3,
                                   @doct_id,
                                   @@cobz_id
                                  )
    end

  end

ControlError:

end
GO