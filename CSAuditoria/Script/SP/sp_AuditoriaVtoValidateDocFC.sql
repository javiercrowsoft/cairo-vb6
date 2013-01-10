-- Script de Chequeo de Integridad de:

-- 2 - Control de vencimientos FC y FV

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaVtoValidateDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaVtoValidateDocFC]

go

create procedure sp_AuditoriaVtoValidateDocFC (

  @@fc_id       int,
  @@aud_id       int

)
as

begin

  set nocount on

  declare @audi_id       int
  declare @doct_id      int
  declare @fc_nrodoc     varchar(50) 
  declare @fc_numero     varchar(50) 
  declare @est_id       int

  select 
            @doct_id     = doct_id,
            @fc_nrodoc  = fc_nrodoc,
            @fc_numero  = convert(varchar,fc_numero),
            @est_id     = est_id

  from FacturaCompra where fc_id = @@fc_id

  -- 1 Si esta anulado no tiene que tener deuda ni pendiente en items
  --
  if @est_id = 7 begin

    if exists(select * from FacturaCompraDeuda where fc_id = @@fc_id) begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'La factura esta anulada y posee deuda '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   2,
                                   @doct_id,
                                   @@fc_id
                                  )
    end

    if exists(select * from FacturaCompraPago where fc_id = @@fc_id) begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'La factura esta anulada y posee pagos '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   2,
                                   @doct_id,
                                   @@fc_id
                                  )
    end

    if exists(select * from FacturaCompraItem where fc_id = @@fc_id and fci_pendiente <> 0) begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'La factura esta anulada y posee pendiente en sus items '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   2,
                                   @doct_id,
                                   @@fc_id
                                  )
    end

  end else begin

    declare @fc_pendiente  decimal(18,6)
    declare @vto           decimal(18,6)
    declare @deuda        decimal(18,6)
    declare @pagos        decimal(18,6)
    declare @total        decimal(18,6)

    select @deuda = sum (fcd_importe) from FacturaCompraDeuda where fc_id = @@fc_id
    select @pagos = sum (fcp_importe) from FacturaCompraPago  where fc_id = @@fc_id

    declare  @fc_descuento1    decimal(18, 6)
    declare  @fc_descuento2    decimal(18, 6)
  
    declare  @fc_totalotros            decimal(18, 6)
    declare  @fc_totalpercepciones     decimal(18, 6)

    select 
            @fc_descuento1          = fc_descuento1,
            @fc_descuento2          = fc_descuento2,
            @fc_totalotros          = fc_totalotros,
            @fc_totalpercepciones   = fc_totalpercepciones,
            @fc_pendiente            = fc_pendiente

    from FacturaCompra where fc_id = @@fc_id

    declare @fc_totaldeuda decimal(18,6)
  
    select @fc_totaldeuda = sum(fci_importe) 
    from FacturaCompraItem fci inner join TipoOperacion t on fci.to_id = t.to_id
    where fc_id = @@fc_id 
      and to_generadeuda <> 0
  
    set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento1) / 100)
    set @fc_totaldeuda = @fc_totaldeuda - ((@fc_totaldeuda * @fc_descuento2) / 100)
    set @fc_totaldeuda = @fc_totaldeuda + @fc_totalotros + @fc_totalpercepciones

    select @total = IsNull(@fc_totaldeuda,0)

    set @vto = IsNull(@deuda,0) + IsNull(@pagos,0)

    if abs(round(@vto - @total,2)) > 0.01 begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El total de la factura no coincide con el total de su deuda '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   2,
                                   @doct_id,
                                   @@fc_id
                                  )
    end

    select @deuda = sum (fcd_pendiente) from FacturaCompraDeuda where fc_id = @@fc_id

    if abs(round(@fc_pendiente - IsNull(@deuda,0),2)) > 0.01 begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El pendiente de la factura no coincide con el total de su deuda '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   2,
                                   @doct_id,
                                   @@fc_id
                                  )
    end

    if exists(select * from FacturaCompraDeuda fcd
              where abs(round(
                        (fcd_pendiente + (    IsNull(
                                                (select sum(fcopg_importe) from FacturaCompraOrdenPago 
                                                 where fcd_id = fcd.fcd_id),0)
                                            +  IsNull(
                                                (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
                                                 where 
                                                       (fcd_id_factura     = fcd.fcd_id and @doct_id in (2,10))
                                                    or (fcd_id_notacredito = fcd.fcd_id and @doct_id = 8)
                                                ),0)
                                          ) 
                        )
                         - fcd_importe
                        ,2)) > 0.01

                and fc_id = @@fc_id
              )
    begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El importe de la deuda de esta factura no coincide con la suma de sus aplicaciones '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   2,
                                   @doct_id,
                                   @@fc_id
                                  )
    end

    if exists(select * from FacturaCompraPago fcp
              where abs(round(  fcp_importe   
                              - (    IsNull(
                                      (select sum(fcopg_importe) from FacturaCompraOrdenPago 
                                       where fcp_id = fcp.fcp_id),0)
                                  +  IsNull(
                                      (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
                                       where 
                                             (fcp_id_factura     = fcp.fcp_id and @doct_id in (2,10))
                                          or (fcp_id_notacredito = fcp.fcp_id and @doct_id = 8)
                                      ),0)
                                ),2)) > 0.01 
                and fc_id = @@fc_id
              )
    begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  
                    
        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El importe del pago de esta factura no coincide con la suma de sus aplicaciones '
                                   + '(comp.:' + @fc_nrodoc + ' nro.: '+ @fc_numero + ')',
                                   3,
                                   2,
                                   @doct_id,
                                   @@fc_id
                                  )
    end

  end

ControlError:

end
GO