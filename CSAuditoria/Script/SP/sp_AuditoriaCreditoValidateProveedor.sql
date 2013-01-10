-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateProveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateProveedor]

go

create procedure sp_AuditoriaCreditoValidateProveedor (

  @@prov_id     int,
  @@aud_id       int

)
as

begin

  set nocount on

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_ordenpago        int
  declare @doct_cheque          int
  declare @doct_proveedor       int
  declare @audi_id               int

  declare @DeudaCtaCte           decimal(18,6)
  declare @DeudaDoc             decimal(18,6)
  declare @CreditoCtaCte         decimal(18,6)

  set @doct_ordenpago   = 16

  set @doct_cheque       = 9999
  set @doct_proveedor   = 9996



--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Deuda en el cache
  --
  select @DeudaCtaCte   = sum(provcc_importe) from ProveedorCacheCredito where doct_id not in (@doct_cheque, 
                                                                                               @doct_ordenpago) 
                                                                           and prov_id = @@prov_id

  -- Credito en el cache
  --
  select @CreditoCtaCte = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_ordenpago   
                                                                           and prov_id = @@prov_id

  -- Deuda documentada
  --
  select @DeudaDoc      = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_cheque
                                                                           and prov_id = @@prov_id


  declare @prov_DeudaCtaCte      decimal(18,6)
  declare @prov_DeudaDoc        decimal(18,6)
  declare @prov_DeudaTotal      decimal(18,6)

  declare @prov_nombre          varchar(255)

  -- Deuda en el Proveedor
  --
  select 
          @prov_nombre       = prov_nombre,
          @prov_DeudaCtaCte  = prov_DeudaCtaCte,
          @prov_DeudaDoc     = prov_DeudaDoc,
          @prov_DeudaTotal   = prov_DeudaTotal

  from Proveedor where prov_id = @@prov_id


  set @DeudaCtaCte   = IsNull(@DeudaCtaCte,0) - IsNull(@CreditoCtaCte,0)
  set @DeudaDoc     = IsNull(@DeudaDoc,0) 

  if @prov_DeudaCtaCte <> @DeudaCtaCte begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor tiene un cache de credito invalido ya que la suma de la deuda'
                                 + ' en cuenta corriente del cache no coincide con el valor almacenado en la'
                                 + ' tabla proveedor '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )

  end
  
  if @prov_DeudaDoc <> @DeudaDoc begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor tiene un cache de credito invalido ya que la suma de la deuda'
                                 + ' documentada del cache no coincide con el valor almacenado en la'
                                 + ' tabla proveedor '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )
  end

  if @prov_DeudaTotal <> (@DeudaDoc + @DeudaCtaCte) begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor tiene un cache de credito invalido ya que la suma de'
                                 + ' toda la deuda del cache no coincide con el valor almacenado en la'
                                 + ' tabla proveedor '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )
  end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
--  DEUDA POR EMPRESA
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////

  declare @emp_id     int
  declare @pendiente   decimal(18,6)
  declare @cache      decimal(18,6)

-- Ordenes de Compra

  declare @DeudaOrden       decimal(18,6)
  declare @doct_OrdenCpra    int

  set @doct_OrdenCpra = 35
  
  -- Deuda en el cache
  --
  select @DeudaOrden = sum(provcc_importe) 
  from ProveedorCacheCredito where  doct_id = @doct_OrdenCpra
                                and prov_id = @@prov_id

  if @DeudaOrden <> 0 begin

    -- Credito por empresa
    --
    if not exists(select * 
                  from EmpresaProveedorDeuda 
                  where prov_id = @@prov_id
                  ) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor tiene saldo en su deuda de ordenes de compra y no hay '
                                 + 'registro en el cache de credito por empresa '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )

    end else begin

      declare c_deudaempresa insensitive cursor for

          select   emp_id,
                  sum(provcc_importe) 
          from ProveedorCacheCredito where  doct_id = @doct_ordencpra 
                                        and prov_id = @@prov_id
          group by emp_id

      open c_deudaempresa

      fetch next from c_deudaempresa into @emp_id, @pendiente
      while @@fetch_status=0
      begin
        
        select @cache = empprovd_deudaOrden from EmpresaProveedorDeuda where prov_id = @@prov_id
                                                                         and emp_id  = @emp_id
        set @cache = IsNull(@cache,0)
  
        if @pendiente <> @cache begin
    
          exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
          if @@error <> 0 goto ControlError  
                      
          insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                             values (@@aud_id, 
                                     @audi_id,
                                     'Este proveedor tiene saldo en su deuda de ordenes de compra distinto '
                                     + ' al registrado en el cache de credito por empresa '
                                     + '(Proveedor:' + @prov_nombre + ')',
                                     3,
                                     4,
                                     @doct_proveedor,
                                     @@prov_id
                                    )
        end

        fetch next from c_deudaempresa into @emp_id, @pendiente
      end

      close c_deudaempresa
      deallocate c_deudaempresa

    end
    --
    -- Fin credito por empresa

  end else begin

    -- Credito por empresa
    --
    if exists(select   emp_id
              from ProveedorCacheCredito 
              where doct_id = @doct_ordencpra 
                and prov_id = @@prov_id
            ) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor no tiene deuda en ordenes de compra y posee '
                                 + 'una entrada en el cache de credito por empresa '
                                 + 'con deuda en ordenes de compra distinta de cero '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )
    end

  end

-- Remitos de Compra

  declare @DeudaRemito      decimal(18,6)
  declare @doct_RemitoCpra  int

  set @doct_RemitoCpra = 4

  -- Deuda en el cache
  --
  select @DeudaRemito = sum(provcc_importe) 
  from ProveedorCacheCredito where  doct_id = @doct_RemitoCpra
                                and prov_id = @@prov_id

  if @DeudaRemito <> 0 begin

    -- Credito por empresa
    --
    if not exists(select * 
                  from EmpresaProveedorDeuda 
                  where prov_id = @@prov_id
                  ) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor tiene saldo en su deuda de remitos y no hay '
                                 + 'registro en el cache de credito por empresa '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )

    end else begin

      declare c_deudaempresa insensitive cursor for

          select   emp_id,
                  sum(provcc_importe) 
          from ProveedorCacheCredito where  doct_id = @doct_remitocpra 
                                        and prov_id = @@prov_id
          group by emp_id

      open c_deudaempresa

      fetch next from c_deudaempresa into @emp_id, @pendiente
      while @@fetch_status=0
      begin
        
        select @cache = empprovd_deudaRemito from EmpresaProveedorDeuda where prov_id = @@prov_id
                                                                          and emp_id   = @emp_id
        set @cache = IsNull(@cache,0)
  
        if @pendiente <> @cache begin
    
          exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
          if @@error <> 0 goto ControlError  
                      
          insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                             values (@@aud_id, 
                                     @audi_id,
                                     'Este proveedor tiene saldo en su deuda de remitos distinto '
                                     + ' al registrado en el cache de credito por empresa '
                                     + '(Proveedor:' + @prov_nombre + ')',
                                     3,
                                     4,
                                     @doct_proveedor,
                                     @@prov_id
                                    )
        end

        fetch next from c_deudaempresa into @emp_id, @pendiente
      end

      close c_deudaempresa
      deallocate c_deudaempresa

    end
    --
    -- Fin credito por empresa

  end else begin

    -- Credito por empresa
    --
    if exists(select   emp_id
              from ProveedorCacheCredito 
              where doct_id = @doct_remitocpra 
                and prov_id = @@prov_id
            ) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor no tiene deuda en remitos y posee '
                                 + 'una entrada en el cache de credito por empresa '
                                 + 'con deuda en remitos distinta de cero '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )
    end

  end

-- Facturas de Compra y Ordenes de Pago

  declare @doct_facturaCpra      int

  set @doct_facturaCpra = 2

  select @DeudaCtaCte = sum( case doct_id
                                when @doct_facturacpra then  provcc_importe
                                when @doct_OrdenPago   then -provcc_importe
                              end
                            ) 
  from ProveedorCacheCredito where  (      doct_id = @doct_facturacpra 
                                      or  doct_id = @doct_OrdenPago
                                    )
                                and prov_id = @@prov_id

  if @DeudaCtaCte <> 0 begin

    -- Credito por empresa
    --
    if not exists(select * 
                  from EmpresaProveedorDeuda 
                  where prov_id = @@prov_id
                  ) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor tiene saldo en su deuda y no hay registro en el cache de credito por empresa '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )

    end else begin

      declare c_deudaempresa insensitive cursor for

          select   emp_id,
                  sum( case doct_id
                          when @doct_facturacpra then  provcc_importe
                          when @doct_OrdenPago   then -provcc_importe
                        end
                      ) 
          from ProveedorCacheCredito where  (      doct_id = @doct_facturacpra 
                                              or  doct_id = @doct_OrdenPago
                                            )
                                        and prov_id = @@prov_id
          group by emp_id

      open c_deudaempresa

      fetch next from c_deudaempresa into @emp_id, @pendiente
      while @@fetch_status=0
      begin
        
        select @cache = empprovd_DeudaCtaCte from EmpresaProveedorDeuda where prov_id = @@prov_id
                                                                          and emp_id   = @emp_id
        set @cache = IsNull(@cache,0)
  
        if @pendiente <> @cache begin
    
          exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
          if @@error <> 0 goto ControlError  
                      
          insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                             values (@@aud_id, 
                                     @audi_id,
                                     'Este proveedor posee un importe de deuda en cta. cte. '
                                     + 'distinto al que figura en el cache de credito por empresa '
                                     + '(Proveedor:' + @prov_nombre + ')',
                                     3,
                                     4,
                                     @doct_proveedor,
                                     @@prov_id
                                    )
        end

        fetch next from c_deudaempresa into @emp_id, @pendiente
      end

      close c_deudaempresa
      deallocate c_deudaempresa

    end
    --
    -- Fin credito por empresa

  end else begin

    -- Credito por empresa
    --
    if exists(select prov_id from EmpresaProveedorDeuda 
              where prov_id = @@prov_id
                and empprovd_DeudaCtaCte <> 0
            ) begin
  
      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  
                  
      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'Este proveedor no tiene deuda en cta. cte. y posee '
                                 + 'una entrada en el cache de credito por empresa '
                                 + 'con deuda en cta. cte. distinta de cero '
                                 + '(Proveedor:' + @prov_nombre + ')',
                                 3,
                                 4,
                                 @doct_proveedor,
                                 @@prov_id
                                )
    end

  end

ControlError:

end
GO