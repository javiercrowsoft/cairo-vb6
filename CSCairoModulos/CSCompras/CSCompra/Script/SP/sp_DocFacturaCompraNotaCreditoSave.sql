if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraNotaCreditoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraNotaCreditoSave]

/*

  1) Borrar aplicacion previa
     1.1) Incremento deuda
     1.2) Convierto pagos en deuda

 sp_DocFacturaCompraNotaCreditoSave 7

*/

go
create procedure sp_DocFacturaCompraNotaCreditoSave (
  @@fcTMP_id       int,
  @@bSuccess      tinyint = 0 out
)
as

begin

  set nocount on

declare @MsgError varchar(5000)

declare @fcnc_id                 int
declare @fcnc_importe            decimal(18,6)
declare @fcd_pendiente          decimal(18,6)
declare @fcd_importe            decimal(18,6)
declare @pago                   decimal(18,6)
declare @fcd_id                  int
declare @fcp_id                  int
declare @doct_id                int
declare @fc_id                  int
declare @fcp_fecha              datetime
declare @fcd_fecha              datetime
declare @fcd_fecha2             datetime
declare @bBorrarVinculacion     tinyint set @bBorrarVinculacion = 0

declare @fcd_id_factura          int
declare @fcd_id_notacredito      int
declare @fcp_id_factura          int
declare @fcp_id_notacredito      int
declare @fc_id_factura          int
declare @fc_id_notacredito      int

  set @@bSuccess = 0

  select @fc_id = fc_id from FacturaCompraTMP where fcTMP_id = @@fcTMP_id

  create table #FacturaCompraNotaCredito (fc_id int)
  
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION-PREVIA                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @doct_id = doct_id 
  from FacturaCompraTMP tmp inner join Documento d on tmp.doc_id = d.doc_id
  where tmp.doc_id = d.doc_id
    and fcTMP_id = @@fcTMP_id
  
  if @doct_id = 8 /*Nota de credito*/ begin

    if exists(select fcnc_id from FacturaCompraNotaCredito where fc_id_notacredito = @fc_id) begin
        set @bBorrarVinculacion = 1

        insert into #FacturaCompraNotaCredito (fc_id) 
                                                    select distinct fc_id_factura 
                                                    from FacturaCompraNotaCredito fcnc
                                                    where fc_id_notacredito = @fc_id
                                                      and not exists(select *
                                                                     from FacturaCompraNotaCreditoTMP 
                                                                     where fcTMP_id = @@fcTMP_id
                                                                       and fcnc_importe <> 0    
                                                                       and fc_id_factura = fcnc.fc_id_factura
                                                                    )
    end
  end else begin /*Nota de debito y Factura*/
    
    if exists(select fcnc_id from FacturaCompraNotaCredito where fc_id_factura = @fc_id) begin
        set @bBorrarVinculacion = 1

        insert into #FacturaCompraNotaCredito (fc_id) 
                                                    select distinct fc_id_notacredito 
                                                    from FacturaCompraNotaCredito fcnc
                                                    where fc_id_factura = @fc_id
                                                      and not exists(select *
                                                                     from FacturaCompraNotaCreditoTMP 
                                                                     where fcTMP_id = @@fcTMP_id
                                                                       and fcnc_importe <> 0    
                                                                       and fc_id_notacredito = fcnc.fc_id_notacredito
                                                                    )
    end
  end

  begin transaction

  -- Tengo que eliminar la aplicacion anterior si es que existe
  --
  if IsNull(@bBorrarVinculacion,0) <> 0 begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        ACTUALIZO LA DEUDA                                                     //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    -- Sumo a la deuda pendiente de las facturas aplicadas a esta FacturaCompra
    -- los importe cancelados por la misma
    declare c_aplic insensitive cursor for

          select 
                  fcnc_id, 
                  fcd_id_notacredito, 
                  fcd_id_factura, 
                  fcp_id_notacredito, 
                  fcp_id_factura, 
                  fcnc_importe 

          from FacturaCompraNotaCredito 

          where 
                  (
                          (fcd_id_notacredito is not null) 
                    and   (fc_id_notacredito = @fc_id and @doct_id = 8 /*Nota de credito*/)
                  )
            or    
                  (
                          (fcd_id_factura is not null)
                    and   (fc_id_factura = @fc_id and @doct_id <> 8 /*Nota de debito y Factura*/)
                  )
            or
                  (
                          (fcp_id_notacredito is not null) 
                    and   (fc_id_notacredito = @fc_id and @doct_id = 8 /*Nota de credito*/)
                  )
            or    
                  (
                          (fcp_id_factura is not null)
                    and   (fc_id_factura = @fc_id and @doct_id <> 8 /*Nota de debito y Factura*/)
                  )

    open c_aplic
    
    fetch next from c_aplic into 
                                    @fcnc_id, 
                                    @fcd_id_notacredito, 
                                    @fcd_id_factura, 
                                    @fcp_id_notacredito, 
                                    @fcp_id_factura, 
                                    @fcnc_importe 

    while @@fetch_status = 0 begin

      -- Actualizo la deuda de la factura
      --
      if @fcd_id_factura is not null begin
        update FacturaCompraDeuda set fcd_pendiente = fcd_pendiente + @fcnc_importe where fcd_id = @fcd_id_factura
        if @@error <> 0 goto ControlError
      end

      -- Actualizo la deuda de la nota de credito
      --
      if @fcd_id_notacredito is not null begin
        update FacturaCompraDeuda set fcd_pendiente = fcd_pendiente + @fcnc_importe where fcd_id = @fcd_id_notacredito
        if @@error <> 0 goto ControlError
      end

      -- Si hay un pago
      --
      if @fcp_id_factura is not null begin

        if exists(select fcp_id from FacturaCompraPago where fcp_id = @fcp_id_factura) begin

          select @fc_id_factura = fc_id, @fcd_importe = fcp_importe, @fcp_fecha = fcp_fecha from FacturaCompraPago where fcp_id = @fcp_id_factura

          select @fcd_pendiente = isnull(sum(fcnc_importe),0) 
          from FacturaCompraNotaCredito fcnc 
          where fcp_id_factura = @fcp_id_factura
            and exists(select * from FacturaCompraNotaCreditoTMP fcnctmp
                       where   fcTMP_id = @@fcTMP_id
                          and  (    fcnctmp.fcd_id_notacredito = fcnc.fcd_id_notacredito
                               or fcnctmp.fcp_id_notacredito = fcnc.fcp_id_notacredito
                              )
                      )

          -- Creo una deuda
          exec SP_DBGetNewId 'FacturaCompraDeuda','fcd_id',@fcd_id out, 0
          if @@error <> 0 goto ControlError

          exec sp_DocGetFecha2 @fcp_fecha, @fcd_fecha2 out, 0, null
          if @@error <> 0 goto ControlError

          insert into FacturaCompraDeuda (
                                          fcd_id,
                                          fcd_fecha,
                                          fcd_fecha2,
                                          fcd_importe,
                                          fcd_pendiente,
                                          fc_id
                                        )
                                values (
                                          @fcd_id,
                                          @fcp_fecha,
                                          @fcd_fecha2,
                                          @fcd_importe,
                                          @fcd_pendiente,
                                          @fc_id_factura
                                        )
          if @@error <> 0 goto ControlError

          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaCompraOrdenPago set fcd_id = @fcd_id, fcp_id = null 
                                            where fcp_id = @fcp_id_factura
          if @@error <> 0 goto ControlError
  
          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaCompraNotaCredito set fcd_id_factura = @fcd_id, fcp_id_factura = null 
                                            where fcp_id_factura = @fcp_id_factura
          if @@error <> 0 goto ControlError
    
          -- Actualizo la temporal para que apunte a la deuda
          update FacturaCompraNotaCreditoTMP set fcd_id_factura = @fcd_id 
                                            where fcp_id_factura = @fcp_id_factura
          if @@error <> 0 goto ControlError

          -- Actualizo la temporal para que apunte a la deuda
          update FacturaCompraOrdenPagoTMP set fcp_id = null, fcd_id = @fcd_id
                                            where fcp_id = @fcp_id_factura
          if @@error <> 0 goto ControlError
  
          -- Borro el pago
          delete FacturaCompraPago where fcp_id = @fcp_id_factura
          if @@error <> 0 goto ControlError

        end  
      end

      if @fcp_id_notacredito is not null begin

        if exists(select fcp_id from FacturaCompraPago where fcp_id = @fcp_id_notacredito) begin

          select @fc_id_notacredito = fc_id, @fcd_importe = fcp_importe, @fcp_fecha = fcp_fecha from FacturaCompraPago where fcp_id = @fcp_id_notacredito

          select @fcd_pendiente = isnull(sum(fcnc_importe),0) 
          from FacturaCompraNotaCredito fcnc 
          where fcp_id_notacredito = @fcp_id_notacredito
            and exists(select * from FacturaCompraNotaCreditoTMP fcnctmp
                       where   fcTMP_id = @@fcTMP_id
                          and  (    fcnctmp.fcd_id_factura = fcnc.fcd_id_factura
                               or fcnctmp.fcp_id_factura = fcnc.fcp_id_factura
                              )
                      )

          -- Creo una deuda
          exec SP_DBGetNewId 'FacturaCompraDeuda','fcd_id',@fcd_id out, 0
          if @@error <> 0 goto ControlError

          exec sp_DocGetFecha2 @fcp_fecha, @fcd_fecha2 out, 0, null
          if @@error <> 0 goto ControlError

          insert into FacturaCompraDeuda (
                                          fcd_id,
                                          fcd_fecha,
                                          fcd_fecha2,
                                          fcd_importe,
                                          fcd_pendiente,
                                          fc_id
                                        )
                                values (
                                          @fcd_id,
                                          @fcp_fecha,
                                          @fcd_fecha2,
                                          @fcd_importe,
                                          @fcd_pendiente,
                                          @fc_id_notacredito
                                        )
          if @@error <> 0 goto ControlError

          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaCompraOrdenPago set fcd_id = @fcd_id, fcp_id = null 
                                            where fcp_id = @fcp_id_notacredito
          if @@error <> 0 goto ControlError

          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaCompraNotaCredito set fcd_id_notacredito = @fcd_id, fcp_id_notacredito = null 
                                            where fcp_id_notacredito = @fcp_id_notacredito
          if @@error <> 0 goto ControlError
    
          -- Actualizo la temporal para que apunte a la deuda
          update FacturaCompraNotaCreditoTMP set fcd_id_notacredito = @fcd_id 
                                            where fcp_id_notacredito = @fcp_id_notacredito
          if @@error <> 0 goto ControlError
  
          -- Borro el pago
          delete FacturaCompraPago where fcp_id = @fcp_id_notacredito
          if @@error <> 0 goto ControlError
        end
      end

      delete FacturaCompraNotaCredito where fcnc_id = @fcnc_id
      if @@error <> 0 goto ControlError

      fetch next from c_aplic into 
                                      @fcnc_id, 
                                      @fcd_id_notacredito, 
                                      @fcd_id_factura, 
                                      @fcp_id_notacredito, 
                                      @fcp_id_factura, 
                                      @fcnc_importe 
    end
    close c_aplic
    deallocate c_aplic

    delete FacturaCompraNotaCredito where 
                                          (fc_id_notacredito   = @fc_id and @doct_id = 8 /*Nota de credito*/)
                                        or    
                                           (fc_id_factura       = @fc_id and @doct_id <> 8 /*Nota de debito y Factura*/)
    if @@error <> 0 goto ControlError

  end  -- Aplicacion previa

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare c_deuda cursor for
        select 
                fcnc_importe,
                fc_id_factura,
                fc_id_notacredito,
                fcd_id_factura,
                fcd_id_notacredito,
                fcp_id_factura,
                fcp_id_notacredito

        from FacturaCompraNotaCreditoTMP 
        where fcTMP_id = @@fcTMP_id
          and fcnc_importe <> 0    

  open c_deuda

  fetch next from c_deuda into 
                                @fcnc_importe,
                                @fc_id_factura,
                                @fc_id_notacredito,
                                @fcd_id_factura,
                                @fcd_id_notacredito,
                                @fcp_id_factura,
                                @fcp_id_notacredito

  while @@fetch_status = 0 begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        FACTURA                                                                //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    -- Si tengo una factura    
    if @fcd_id_factura is not null begin

      -- Obtengo el monto de la deuda
      select @fcd_pendiente = fcd_pendiente from FacturaCompraDeuda where fcd_id = @fcd_id_factura

      -- Si el pago no cancela el pendiente
      if @fcd_pendiente - @fcnc_importe >= 0.01 begin

        -- No hay pago
        set @fcp_id = null
  
      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin
  
        -- Acumulo en el pago toda la deuda para pasar de la tabla FacturaCompraDeuda a FacturaCompraPago
        --
        set @pago = 0
  
        select @fcd_fecha = fcd_fecha, @pago = fcd_importe from FacturaCompraDeuda where fcd_id = @fcd_id_factura
  
        exec SP_DBGetNewId 'FacturaCompraPago','fcp_id',@fcp_id out, 0
        if @@error <> 0 goto ControlError

        insert into FacturaCompraPago (
                                        fcp_id,
                                        fcp_fecha,
                                        fcp_importe,
                                        fc_id
                                      )
                              values (
                                        @fcp_id,
                                        @fcd_fecha,
                                        @pago,
                                        @fc_id_factura
                                      )
        if @@error <> 0 goto ControlError
  
        set @fcp_id_factura = @fcp_id
      end
  
      -- Si hay pago borro la/s deudas        
      if IsNull(@fcp_id,0) <> 0 begin

        -- Actualizo la tabla de vinculacion para que apunte al pago
        update FacturaCompraOrdenPago set fcd_id = null, fcp_id = @fcp_id 
                                          where fcd_id = @fcd_id_factura
        if @@error <> 0 goto ControlError

        -- Actualizo la tabla de vinculacion para que apunte a la deuda
        update FacturaCompraNotaCredito set fcd_id_factura = null, fcp_id_factura = @fcp_id 
                                           where fcd_id_factura = @fcd_id_factura
        if @@error <> 0 goto ControlError
  
        -- Actualizo la temporal para que apunte a la deuda
        update FacturaCompraNotaCreditoTMP set fcd_id_factura = null, fcp_id_factura = @fcp_id 
                                          where fcd_id_factura = @fcd_id_factura
        if @@error <> 0 goto ControlError

        -- Actualizo la temporal para que apunte a la deuda
        update FacturaCompraOrdenPagoTMP set fcd_id = null, fcp_id = @fcp_id
                                          where fcd_id = @fcd_id_factura
        if @@error <> 0 goto ControlError
  
        delete FacturaCompraDeuda where fc_id = @fc_id_factura and fcd_id = @fcd_id_factura
        if @@error <> 0 goto ControlError
  
        set @fcd_id_factura = null
  
      end else begin
  
        set @fcp_id_factura = null
      end
    end
    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        NOTA DE CREDITO                                                        //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    -- Si tengo una factura    
    if @fcd_id_notacredito is not null begin

      -- Obtengo el monto de la deuda
      select @fcd_pendiente = fcd_pendiente from FacturaCompraDeuda where fcd_id = @fcd_id_notacredito

      -- Si el pago no cancela el pendiente
      if @fcd_pendiente - @fcnc_importe >= 0.01 begin

        -- No hay pago
        set @fcp_id = null
  
      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin
  
        set @pago = 0
        select @fcd_fecha = fcd_fecha, @pago = fcd_importe from FacturaCompraDeuda where fcd_id = @fcd_id_notacredito
  
        exec SP_DBGetNewId 'FacturaCompraPago','fcp_id',@fcp_id out, 0
        if @@error <> 0 goto ControlError

        insert into FacturaCompraPago (
                                        fcp_id,
                                        fcp_fecha,
                                        fcp_importe,
                                        fc_id
                                      )
                              values (
                                        @fcp_id,
                                        @fcd_fecha,
                                        @pago,
                                        @fc_id_notacredito
                                      )
        if @@error <> 0 goto ControlError
  
        set @fcp_id_notacredito = @fcp_id
      end
  
      -- Si hay pago borro la/s deudas        
      if IsNull(@fcp_id,0) <> 0 begin

        -- Actualizo la tabla de vinculacion para que apunte al pago
        update FacturaCompraOrdenPago set fcd_id = null, fcp_id = @fcp_id 
                                          where fcd_id = @fcd_id_notacredito
        if @@error <> 0 goto ControlError

        -- Actualizo la tabla de vinculacion para que apunte a la deuda
        update FacturaCompraNotaCredito set fcd_id_notacredito = null, fcp_id_notacredito = @fcp_id 
                                           where fcd_id_notacredito = @fcd_id_notacredito
        if @@error <> 0 goto ControlError
  
        -- Actualizo la temporal para que apunte a la deuda
        update FacturaCompraNotaCreditoTMP set fcd_id_notacredito = null, fcp_id_notacredito = @fcp_id 
                                          where fcd_id_notacredito = @fcd_id_notacredito
        if @@error <> 0 goto ControlError

        delete FacturaCompraDeuda where fc_id = @fc_id_notacredito and fcd_id = @fcd_id_notacredito
        if @@error <> 0 goto ControlError
  
        set @fcd_id_notacredito = null
  
      end else begin
  
        set @fcp_id_notacredito = null
      end
    end
    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        VINCULACION                                                            //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    exec SP_DBGetNewId 'FacturaCompraNotaCredito','fcnc_id',@fcnc_id out, 0
    if @@error <> 0 goto ControlError

    insert into FacturaCompraNotaCredito (
                                        fcnc_id,
                                        fcnc_importe,
                                        fcd_id_factura,
                                        fcd_id_notacredito,
                                        fcp_id_factura,
                                        fcp_id_notacredito,
                                        fc_id_factura,
                                        fc_id_notacredito
                                      )
                              values (
                                        @fcnc_id,
                                        @fcnc_importe,
                                        @fcd_id_factura,
                                        @fcd_id_notacredito,
                                        @fcp_id_factura,
                                        @fcp_id_notacredito,
                                        @fc_id_factura,
                                        @fc_id_notacredito
                                      )
    if @@error <> 0 goto ControlError

    -- Si no hay un pago actualizo la deuda
    if IsNull(@fcp_id_factura,0) = 0 begin
      update FacturaCompraDeuda set fcd_pendiente = fcd_pendiente - @fcnc_importe where fcd_id = @fcd_id_factura
      if @@error <> 0 goto ControlError
    end

    -- Si no hay un pago actualizo la deuda
    if IsNull(@fcp_id_notacredito,0) = 0 begin
      update FacturaCompraDeuda set fcd_pendiente = fcd_pendiente - @fcnc_importe where fcd_id = @fcd_id_notacredito
      if @@error <> 0 goto ControlError
    end

    fetch next from c_deuda into 
                                  @fcnc_importe,
                                  @fc_id_factura,
                                  @fc_id_notacredito,
                                  @fcd_id_factura,
                                  @fcd_id_notacredito,
                                  @fcp_id_factura,
                                  @fcp_id_notacredito
  end

  close c_deuda
  deallocate c_deuda
  
  --////////////////////////////////////////////////////////////
  -- Pendiente en facturas o notas de credito 
  -- aplicadas a este comprobante
  --
  declare @fc_id_aplic int
  declare @bSuccess tinyint

  if @doct_id = 8 /*Nota de credito*/ begin

    declare c_fcncaplic insensitive cursor for
        select fc_id from #FacturaCompraNotaCredito
      union
        select fc_id_factura
        from FacturaCompraNotaCredito
        where fc_id_notacredito = @fc_id

  end else begin

    declare c_fcncaplic insensitive cursor for
        select fc_id from #FacturaCompraNotaCredito
      union
        select fc_id_notacredito 
        from FacturaCompraNotaCredito
        where fc_id_factura = @fc_id
  end

  open c_fcncaplic

  fetch next from c_fcncaplic into @fc_id_aplic
  while @@fetch_status=0
  begin

    -- Actualizo la deuda de la factura
    exec sp_DocFacturaCompraSetPendiente @fc_id_aplic, @bSuccess out
    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError

    exec sp_DocFacturaCompraSetCredito @fc_id_aplic
    if @@error <> 0 goto ControlError

    exec sp_DocFacturaCompraSetEstado  @fc_id_aplic
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- VTOS
          exec sp_AuditoriaVtoCheckDocFC      @fc_id_aplic,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError
      
      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocFC  @fc_id_aplic,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_fcncaplic into @fc_id_aplic
  end

  close c_fcncaplic
  deallocate c_fcncaplic

  -- Actualizo la deuda de la factura
  exec sp_DocFacturaCompraSetPendiente @fc_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete FacturaCompraNotaCreditoTMP where fcTMP_id = @@fcTMP_id
  if @@error <> 0 goto ControlError

  delete FacturaCompraTMP where fcTMP_id = @@fcTMP_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la aplicación de la factura de compra. sp_DocFacturaCompraSaveAplic. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end 
go