if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaNotaCreditoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaNotaCreditoSave]

/*

  1) Borrar aplicacion previa
     1.1) Incremento deuda
     1.2) Convierto pagos en deuda

 sp_DocFacturaVentaNotaCreditoSave 7

*/

go
create procedure sp_DocFacturaVentaNotaCreditoSave (
  @@fvTMP_id       int,
  @@bSuccess      tinyint = 0 out
)
as

begin

  set nocount on

declare @MsgError varchar(5000)

declare @fvnc_id                 int
declare @fvnc_importe            decimal(18,6)
declare @fvd_pendiente          decimal(18,6)
declare @fvd_importe            decimal(18,6)
declare @pago                   decimal(18,6)
declare @fvd_id                  int
declare @fvp_id                  int
declare @doct_id                int
declare @fv_id                  int
declare @fvp_fecha              datetime
declare @fvd_fecha              datetime
declare @fvd_fecha2             datetime
declare @bBorrarVinculacion     tinyint set @bBorrarVinculacion = 0

declare @fvd_id_factura          int
declare @fvd_id_notacredito      int
declare @fvp_id_factura          int
declare @fvp_id_notacredito      int
declare @fv_id_factura          int
declare @fv_id_notacredito      int

  set @@bSuccess = 0

  select @fv_id = fv_id from FacturaVentaTMP where fvTMP_id = @@fvTMP_id

  create table #FacturaVentaNotaCredito (fv_id int)
  
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION-PREVIA                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @doct_id = doct_id 
  from FacturaVentaTMP tmp inner join Documento d on tmp.doc_id = d.doc_id
  where tmp.doc_id = d.doc_id
    and fvTMP_id = @@fvTMP_id
  
  if @doct_id = 7 /*Nota de credito*/ begin

    if exists(select fvnc_id from FacturaVentaNotaCredito where fv_id_notacredito = @fv_id) begin
        set @bBorrarVinculacion = 1

        insert into #FacturaVentaNotaCredito (fv_id) 
                                                    select distinct fv_id_factura 
                                                    from FacturaVentaNotaCredito fvnc
                                                    where fv_id_notacredito = @fv_id
                                                      and not exists(select *
                                                                     from FacturaVentaNotaCreditoTMP 
                                                                     where fvTMP_id = @@fvTMP_id
                                                                       and fvnc_importe <> 0    
                                                                       and fv_id_factura = fvnc.fv_id_factura
                                                                    )
    end
  end else begin /*Nota de debito y Factura*/
    
    if exists(select fvnc_id from FacturaVentaNotaCredito where fv_id_factura = @fv_id) begin
        set @bBorrarVinculacion = 1

        insert into #FacturaVentaNotaCredito (fv_id) 
                                                    select distinct fv_id_notacredito 
                                                    from FacturaVentaNotaCredito fvnc
                                                    where fv_id_factura = @fv_id
                                                      and not exists(select *
                                                                     from FacturaVentaNotaCreditoTMP 
                                                                     where fvTMP_id = @@fvTMP_id
                                                                       and fvnc_importe <> 0    
                                                                       and fv_id_notacredito = fvnc.fv_id_notacredito
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
    -- Sumo a la deuda pendiente de las facturas aplicadas a esta FacturaVenta
    -- los importes cancelados por la misma
    declare c_aplic insensitive cursor for

          select 
                  fvnc_id, 
                  fvd_id_notacredito, 
                  fvd_id_factura, 
                  fvp_id_notacredito, 
                  fvp_id_factura, 
                  fvnc_importe 

          from FacturaVentaNotaCredito 

          where 
                  (
                          (fvd_id_notacredito is not null) 
                    and   (fv_id_notacredito = @fv_id and @doct_id = 7 /*Nota de credito*/)
                  )
            or    
                  (
                          (fvd_id_factura is not null)
                    and   (fv_id_factura = @fv_id and @doct_id <> 7 /*Nota de debito y Factura*/)
                  )
            or
                  (
                          (fvp_id_notacredito is not null) 
                    and   (fv_id_notacredito = @fv_id and @doct_id = 7 /*Nota de credito*/)
                  )
            or    
                  (
                          (fvp_id_factura is not null)
                    and   (fv_id_factura = @fv_id and @doct_id <> 7 /*Nota de debito y Factura*/)
                  )

    open c_aplic
    
    fetch next from c_aplic into 
                                    @fvnc_id, 
                                    @fvd_id_notacredito, 
                                    @fvd_id_factura, 
                                    @fvp_id_notacredito, 
                                    @fvp_id_factura, 
                                    @fvnc_importe 

    while @@fetch_status = 0 begin

      -- Actualizo la deuda de la factura
      --
      if @fvd_id_factura is not null begin
        update FacturaVentaDeuda set fvd_pendiente = fvd_pendiente + @fvnc_importe where fvd_id = @fvd_id_factura
        if @@error <> 0 goto ControlError
      end

      -- Actualizo la deuda de la nota de credito
      --
      if @fvd_id_notacredito is not null begin
        update FacturaVentaDeuda set fvd_pendiente = fvd_pendiente + @fvnc_importe where fvd_id = @fvd_id_notacredito
        if @@error <> 0 goto ControlError
      end

      -- Si hay un pago
      --
      if @fvp_id_factura is not null begin

        if exists(select fvp_id from FacturaVentaPago where fvp_id = @fvp_id_factura) begin

          select @fv_id_factura = fv_id, @fvd_importe = fvp_importe, @fvp_fecha = fvp_fecha from FacturaVentaPago where fvp_id = @fvp_id_factura

          select @fvd_pendiente = isnull(sum(fvnc_importe),0) 
          from FacturaVentaNotaCredito fvnc 
          where fvp_id_factura = @fvp_id_factura
            and exists(select * from FacturaVentaNotaCreditoTMP fvnctmp
                       where   fvTMP_id = @@fvTMP_id
                          and  (    fvnctmp.fvd_id_notacredito = fvnc.fvd_id_notacredito
                               or fvnctmp.fvp_id_notacredito = fvnc.fvp_id_notacredito
                              )
                      )

          -- Creo una deuda
          exec SP_DBGetNewId 'FacturaVentaDeuda','fvd_id',@fvd_id out, 0
          if @@error <> 0 goto ControlError

          exec sp_DocGetFecha2 @fvp_fecha, @fvd_fecha2 out, 0, null
          if @@error <> 0 goto ControlError

          insert into FacturaVentaDeuda (
                                          fvd_id,
                                          fvd_fecha,
                                          fvd_fecha2,
                                          fvd_importe,
                                          fvd_pendiente,
                                          fv_id
                                        )
                                values (
                                          @fvd_id,
                                          @fvp_fecha,
                                          @fvd_fecha2,
                                          @fvd_importe,
                                          @fvd_pendiente,
                                          @fv_id_factura
                                        )
          if @@error <> 0 goto ControlError

          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaVentaCobranza set fvd_id = @fvd_id, fvp_id = null 
                                            where fvp_id = @fvp_id_factura
          if @@error <> 0 goto ControlError
  
          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaVentaNotaCredito set fvd_id_factura = @fvd_id, fvp_id_factura = null 
                                            where fvp_id_factura = @fvp_id_factura
          if @@error <> 0 goto ControlError
    
          -- Actualizo la temporal para que apunte a la deuda
          update FacturaVentaNotaCreditoTMP set fvd_id_factura = @fvd_id 
                                            where fvp_id_factura = @fvp_id_factura
          if @@error <> 0 goto ControlError

          -- Actualizo la temporal para que apunte a la deuda
          update FacturaVentaCobranzaTMP set fvp_id = null, fvd_id = @fvd_id
                                            where fvp_id = @fvp_id_factura
          if @@error <> 0 goto ControlError
  
          -- Borro el pago
          delete FacturaVentaPago where fvp_id = @fvp_id_factura
          if @@error <> 0 goto ControlError

        end  
      end

      if @fvp_id_notacredito is not null begin

        if exists(select fvp_id from FacturaVentaPago where fvp_id = @fvp_id_notacredito) begin

          select @fv_id_notacredito = fv_id, @fvd_importe = fvp_importe, @fvp_fecha = fvp_fecha from FacturaVentaPago where fvp_id = @fvp_id_notacredito

          select @fvd_pendiente = isnull(sum(fvnc_importe),0) 
          from FacturaVentaNotaCredito fvnc 
          where fvp_id_notacredito = @fvp_id_notacredito
            and exists(select * from FacturaVentaNotaCreditoTMP fvnctmp
                       where   fvTMP_id = @@fvTMP_id
                          and  (    fvnctmp.fvd_id_factura = fvnc.fvd_id_factura
                               or fvnctmp.fvp_id_factura = fvnc.fvp_id_factura
                              )
                      )

          -- Creo una deuda
          exec SP_DBGetNewId 'FacturaVentaDeuda','fvd_id',@fvd_id out, 0
          if @@error <> 0 goto ControlError

          exec sp_DocGetFecha2 @fvp_fecha, @fvd_fecha2 out, 0, null
          if @@error <> 0 goto ControlError

          insert into FacturaVentaDeuda (
                                          fvd_id,
                                          fvd_fecha,
                                          fvd_fecha2,
                                          fvd_importe,
                                          fvd_pendiente,
                                          fv_id
                                        )
                                values (
                                          @fvd_id,
                                          @fvp_fecha,
                                          @fvd_fecha2,
                                          @fvd_importe,
                                          @fvd_pendiente,
                                          @fv_id_notacredito
                                        )
          if @@error <> 0 goto ControlError
  
          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaVentaCobranza set fvd_id = @fvd_id, fvp_id = null 
                                            where fvp_id = @fvp_id_notacredito
          if @@error <> 0 goto ControlError

          -- Actualizo la tabla de vinculacion para que apunte a la deuda
          update FacturaVentaNotaCredito set fvd_id_notacredito = @fvd_id, fvp_id_notacredito = null 
                                            where fvp_id_notacredito = @fvp_id_notacredito
          if @@error <> 0 goto ControlError
    
          -- Actualizo la temporal para que apunte a la deuda
          update FacturaVentaNotaCreditoTMP set fvd_id_notacredito = @fvd_id 
                                            where fvp_id_notacredito = @fvp_id_notacredito
          if @@error <> 0 goto ControlError
  
          -- Borro el pago
          delete FacturaVentaPago where fvp_id = @fvp_id_notacredito
          if @@error <> 0 goto ControlError
        end
      end

      delete FacturaVentaNotaCredito where fvnc_id = @fvnc_id
      if @@error <> 0 goto ControlError

      fetch next from c_aplic into 
                                      @fvnc_id, 
                                      @fvd_id_notacredito, 
                                      @fvd_id_factura, 
                                      @fvp_id_notacredito, 
                                      @fvp_id_factura, 
                                      @fvnc_importe 
    end
    close c_aplic
    deallocate c_aplic

    delete FacturaVentaNotaCredito where 
                                          (fv_id_notacredito   = @fv_id and @doct_id = 7 /*Nota de credito*/)
                                        or    
                                           (fv_id_factura       = @fv_id and @doct_id <> 7 /*Nota de debito y Factura*/)
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
                fvnc_importe,
                fv_id_factura,
                fv_id_notacredito,
                fvd_id_factura,
                fvd_id_notacredito,
                fvp_id_factura,
                fvp_id_notacredito

        from FacturaVentaNotaCreditoTMP 
        where fvTMP_id = @@fvTMP_id
          and fvnc_importe <> 0    

  open c_deuda

  fetch next from c_deuda into 
                                @fvnc_importe,
                                @fv_id_factura,
                                @fv_id_notacredito,
                                @fvd_id_factura,
                                @fvd_id_notacredito,
                                @fvp_id_factura,
                                @fvp_id_notacredito

  while @@fetch_status = 0 begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        FACTURA                                                                //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    -- Si tengo una factura    
    if @fvd_id_factura is not null begin

      -- Obtengo el monto de la deuda
      select @fvd_pendiente = fvd_pendiente from FacturaVentaDeuda where fvd_id = @fvd_id_factura

      -- Si el pago no cancela el pendiente
      if @fvd_pendiente - @fvnc_importe > 0.01 begin

        -- No hay pago
        set @fvp_id = null
  
      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin
  
        -- Acumulo en el pago toda la deuda para pasar de la tabla FacturaVentaDeuda a FacturaVentaPago
        --
        set @pago = 0
  
        select @fvd_fecha = fvd_fecha, @pago = fvd_importe from FacturaVentaDeuda where fvd_id = @fvd_id_factura
  
        exec SP_DBGetNewId 'FacturaVentaPago','fvp_id',@fvp_id out, 0
        if @@error <> 0 goto ControlError

        insert into FacturaVentaPago (
                                        fvp_id,
                                        fvp_fecha,
                                        fvp_importe,
                                        fv_id
                                      )
                              values (
                                        @fvp_id,
                                        @fvd_fecha,
                                        @pago,
                                        @fv_id_factura
                                      )
        if @@error <> 0 goto ControlError
  
        set @fvp_id_factura = @fvp_id
      end
  
      -- Si hay pago borro la/s deudas        
      if IsNull(@fvp_id,0) <> 0 begin
  
        -- Actualizo la tabla de vinculacion para que apunte al pago
        update FacturaVentaCobranza set fvd_id = null, fvp_id = @fvp_id 
                                          where fvd_id = @fvd_id_factura
        if @@error <> 0 goto ControlError

        -- Actualizo la tabla de vinculacion para que apunte a la deuda
        update FacturaVentaNotaCredito set fvd_id_factura = null, fvp_id_factura = @fvp_id 
                                           where fvd_id_factura = @fvd_id_factura
        if @@error <> 0 goto ControlError
  
        -- Actualizo la temporal para que apunte a la deuda
        update FacturaVentaNotaCreditoTMP set fvd_id_factura = null, fvp_id_factura = @fvp_id 
                                          where fvd_id_factura = @fvd_id_factura
        if @@error <> 0 goto ControlError
  
        -- Actualizo la temporal para que apunte a la deuda
        update FacturaVentaCobranzaTMP set fvd_id = null, fvp_id = @fvp_id
                                          where fvd_id = @fvd_id_factura
        if @@error <> 0 goto ControlError

        delete FacturaVentaDeuda where fv_id = @fv_id_factura and fvd_id = @fvd_id_factura
        if @@error <> 0 goto ControlError
  
        set @fvd_id_factura = null
  
      end else begin
  
        set @fvp_id_factura = null
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
    if @fvd_id_notacredito is not null begin

      -- Obtengo el monto de la deuda
      select @fvd_pendiente = fvd_pendiente from FacturaVentaDeuda where fvd_id = @fvd_id_notacredito
  
      -- Si el pago no cancela el pendiente
      if @fvd_pendiente - @fvnc_importe > 0.01 begin

        -- No hay pago
        set @fvp_id = null
  
      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin
  
        set @pago = 0
        select @fvd_fecha = fvd_fecha, @pago = fvd_importe from FacturaVentaDeuda where fvd_id = @fvd_id_notacredito
  
        exec SP_DBGetNewId 'FacturaVentaPago','fvp_id',@fvp_id out, 0
        if @@error <> 0 goto ControlError

        insert into FacturaVentaPago (
                                        fvp_id,
                                        fvp_fecha,
                                        fvp_importe,
                                        fv_id
                                      )
                              values (
                                        @fvp_id,
                                        @fvd_fecha,
                                        @pago,
                                        @fv_id_notacredito
                                      )
        if @@error <> 0 goto ControlError
  
        set @fvp_id_notacredito = @fvp_id
      end
  
      -- Si hay pago borro la/s deudas        
      if IsNull(@fvp_id,0) <> 0 begin
  
        -- Actualizo la tabla de vinculacion para que apunte al pago
        update FacturaVentaCobranza set fvd_id = null, fvp_id = @fvp_id 
                                          where fvd_id = @fvd_id_notacredito
        if @@error <> 0 goto ControlError

        -- Actualizo la tabla de vinculacion para que apunte a la deuda
        update FacturaVentaNotaCredito set fvd_id_notacredito = null, fvp_id_notacredito = @fvp_id 
                                           where fvd_id_notacredito = @fvd_id_notacredito
        if @@error <> 0 goto ControlError
  
        -- Actualizo la temporal para que apunte a la deuda
        update FacturaVentaNotaCreditoTMP set fvd_id_notacredito = null, fvp_id_notacredito = @fvp_id 
                                          where fvd_id_notacredito = @fvd_id_notacredito
        if @@error <> 0 goto ControlError

        delete FacturaVentaDeuda where fv_id = @fv_id_notacredito and fvd_id = @fvd_id_notacredito
        if @@error <> 0 goto ControlError
  
        set @fvd_id_notacredito = null
  
      end else begin
  
        set @fvp_id_notacredito = null
      end
    end
    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        VINCULACION                                                            //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    exec SP_DBGetNewId 'FacturaVentaNotaCredito','fvnc_id',@fvnc_id out, 0
    if @@error <> 0 goto ControlError

    insert into FacturaVentaNotaCredito (
                                        fvnc_id,
                                        fvnc_importe,
                                        fvd_id_factura,
                                        fvd_id_notacredito,
                                        fvp_id_factura,
                                        fvp_id_notacredito,
                                        fv_id_factura,
                                        fv_id_notacredito
                                      )
                              values (
                                        @fvnc_id,
                                        @fvnc_importe,
                                        @fvd_id_factura,
                                        @fvd_id_notacredito,
                                        @fvp_id_factura,
                                        @fvp_id_notacredito,
                                        @fv_id_factura,
                                        @fv_id_notacredito
                                      )
    if @@error <> 0 goto ControlError

    -- Si no hay un pago actualizo la deuda
    if IsNull(@fvp_id_factura,0) = 0 begin
      update FacturaVentaDeuda set fvd_pendiente = fvd_pendiente - @fvnc_importe where fvd_id = @fvd_id_factura
      if @@error <> 0 goto ControlError
    end

    -- Si no hay un pago actualizo la deuda
    if IsNull(@fvp_id_notacredito,0) = 0 begin
      update FacturaVentaDeuda set fvd_pendiente = fvd_pendiente - @fvnc_importe where fvd_id = @fvd_id_notacredito
      if @@error <> 0 goto ControlError
    end

    fetch next from c_deuda into 
                                  @fvnc_importe,
                                  @fv_id_factura,
                                  @fv_id_notacredito,
                                  @fvd_id_factura,
                                  @fvd_id_notacredito,
                                  @fvp_id_factura,
                                  @fvp_id_notacredito
  end

  close c_deuda
  deallocate c_deuda
  
  --////////////////////////////////////////////////////////////
  -- Pendiente en facturas o notas de credito 
  -- aplicadas a este comprobante
  --
  declare @fv_id_aplic int
  declare @bSuccess tinyint

  if @doct_id = 7 /*Nota de credito*/ begin

    declare c_fvncaplic insensitive cursor for
        select fv_id from #FacturaVentaNotaCredito
      union
        select fv_id_factura
        from FacturaVentaNotaCredito
        where fv_id_notacredito = @fv_id

  end else begin

    declare c_fvncaplic insensitive cursor for
        select fv_id from #FacturaVentaNotaCredito
      union
        select fv_id_notacredito 
        from FacturaVentaNotaCredito
        where fv_id_factura = @fv_id
  end

  open c_fvncaplic

  fetch next from c_fvncaplic into @fv_id_aplic
  while @@fetch_status=0
  begin

    -- Actualizo la deuda de la factura
    exec sp_DocFacturaVentaSetPendiente @fv_id_aplic, @bSuccess out
    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError

    exec sp_DocFacturaVentaSetCredito @fv_id_aplic
    if @@error <> 0 goto ControlError

    exec sp_DocFacturaVentaSetEstado  @fv_id_aplic
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- VTOS
          exec sp_AuditoriaVtoCheckDocFV      @fv_id_aplic,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError
      
      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocFV  @fv_id_aplic,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_fvncaplic into @fv_id_aplic
  end

  close c_fvncaplic
  deallocate c_fvncaplic
  
  -- Actualizo la deuda de la factura
  exec sp_DocFacturaVentaSetPendiente @fv_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete FacturaVentaNotaCreditoTMP where fvTMP_id = @@fvTMP_id
  if @@error <> 0 goto ControlError

  delete FacturaVentaTMP where fvTMP_id = @@fvTMP_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la aplicación de la factura de venta. sp_DocFacturaVentaSaveAplic. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end 
GO