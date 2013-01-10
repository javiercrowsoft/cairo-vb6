if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoSaveAplic]

/*

  exec  sp_DocOrdenPagoSaveAplic 38

*/

go
create procedure sp_DocOrdenPagoSaveAplic (
  @@opgTMP_id     int,
  @@bSelect        tinyint = 1,
  @@bSuccess      tinyint = 0 out,
  @@bDelete       tinyint = 1
)
as

begin

  set nocount on

  declare @MsgError varchar(5000)

  declare @fcopg_id               int
  declare @fcopg_importe          decimal(18,6)
  declare @fcopg_importeOrigen    decimal(18,6)
  declare @fcopg_cotizacion       decimal(18,6)
  declare @fcd_pendiente          decimal(18,6)
  declare @fcd_importe            decimal(18,6)
  declare @fcd_id                  int
  declare @fcp_id                  int
  declare @fc_id                  int
  declare @pago                   decimal(18,6)
  declare @aplic                   decimal(18,6)
  declare @fcp_fecha              datetime
  declare @fcd_fecha              datetime
  declare @fcd_fecha2             datetime
  declare @opg_id                 int   

  set @@bSuccess = 0

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @modifico int

  select @opg_id = opg_id, @modifico = modifico from OrdenPagoTMP where opgTMP_id = @@opgTMP_id

  ---------------------------------
  -- Si no hay cobranza no hago nada
  --
  if @opg_id is null begin

    select @opg_id
    return
  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        VALIDACIONES A LA APLICACION                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

        delete FacturaCompraOrdenPagoTMP 
        where opgTMP_id = @@opgTMP_id
          and fcd_id is null
          and fcp_id is null

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TRANSACCION                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Esta tabla es para almacenar todas las facturas afectadas por esta aplicacion
  -- para luego actualizarles el campo fc_pendiente
  --
  create table #FacturasCpra (fc_id int not null)

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION-PREVIA                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  /*
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //                                                                                                               //
  //                                        ACTUALIZO LA DEUDA                                                     //
  //                                                                                                               //
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  */
  -- Sumo a la deuda pendiente de las facturas aplicadas a esta OrdenPago
  -- los importe cancelados por la misma
  --
  
  if @@bDelete = 0 begin -- (este if esta varias veces por que se dio prioridad a la legibilidad del codigo)

    -- Inserto en #FacturasCpra solo las facturas mencionadas en la TMP
    --
    insert into #FacturasCpra (fc_id) select distinct fc_id from FacturaCompraOrdenPagoTMP where opg_id = @opg_id

  end else begin

    -- Inserto en #FacturasCpra todas las facturas vinculadas con esta OrdenPago
    --
    insert into #FacturasCpra (fc_id) select distinct fc_id from FacturaCompraOrdenPago where opg_id = @opg_id
  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  begin transaction

  -- Tengo que eliminar la aplicacion anterior si es que existe
  --
  if exists(select fcopg_id from FacturaCompraOrdenPago where opg_id = @opg_id) begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        PAGOS                                                                  //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    -- Tengo que convertir los pagos en deuda
    --

    -- El cursor tiene dos formas:
    --                             1- Si se trata de una aplicacion desde factura de compra
    --                                solo se cargan las vinculaciones que estan en la tabla 
    --                                temporal ya que una factura no modifica toda la aplicacion
    --                                de una Orden de Pago.
    --
    --                             2- Si se trata de una aplicacion desde Ordenes de Pago
    --                                se carga toda la aplicacion de la Orden de Pago en cuestion
    --
    if @@bDelete = 0 begin

      declare c_pagos insensitive cursor for
            select 
                            fcp.fc_id, 
                            fcp.fcp_id, 
                            fcp_fecha,
                            fcp_importe,
                            sum(fco.fcopg_importe)  -- Sumo todas las aplicaciones de esta 
                                                     -- OrdenPago sobre el pago para obtener
                                                     -- el pendiente de la deuda
  
              from FacturaCompraOrdenPago fco inner join FacturaCompraPago fcp on fco.fcp_id = fcp.fcp_id
                                            inner join FacturaCompraOrdenPagoTMP fcot on fco.fcopg_id = fcot.fcopg_id

              where fcot.opgTMP_id = @@opgTMP_id
              group by 
                            fcp.fc_id, 
                            fcp.fcp_id, 
                            fcp_fecha,
                            fcp_importe
    end else begin
      declare c_pagos insensitive cursor for
            select 
                            fcp.fc_id, 
                            fcp.fcp_id, 
                            fcp_fecha,
                            fcp_importe,
                            sum(fcopg_importe)  -- Sumo todas las aplicaciones de esta 
                                                 -- OrdenPago sobre el pago para obtener
                                                 -- el pendiente de la deuda
  
              from FacturaCompraOrdenPago fco inner join FacturaCompraPago fcp on fco.fcp_id = fcp.fcp_id
              where opg_id = @opg_id
              group by 
                            fcp.fc_id, 
                            fcp.fcp_id, 
                            fcp_fecha,
                            fcp_importe
    end

    open c_pagos

    fetch next from c_pagos into @fc_id, @fcp_id, @fcp_fecha, @fcd_importe, @fcd_pendiente
    while @@fetch_status = 0 begin

      -- Creo la deuda
      --
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
                                      @fc_id
                                    )
      if @@error <> 0 goto ControlError

      -- Ahora que converti el pago en deuda borro las
      -- aplicaciones asociadas a este pago
      --
      if @@bDelete = 0 begin

        delete FacturaCompraOrdenPago from FacturaCompraOrdenPagoTMP fcot 
        where     FacturaCompraOrdenPago.fcp_id   = @fcp_id 
              and FacturaCompraOrdenPago.fcopg_id = fcot.fcopg_id
              and fcot.opgTMP_id = @@opgTMP_id

        if @@error <> 0 goto ControlError

        -- Borro la aplicacion
        --
        delete FacturaCompraOrdenPago 
        where fcp_id is null 
          and fcd_id is null
          and fc_id in (select fc_id from FacturaCompraOrdenPagoTMP where opgTMP_id = @@opgTMP_id)
        
        if @@error <> 0 goto ControlError

      end else begin

        -- Borro todas las aplicaciones que apuntaban al pago
        --
        delete FacturaCompraOrdenPago where fcp_id = @fcp_id and opg_id = @opg_id
        if @@error <> 0 goto ControlError
      end

      -- Actualizo todas las aplicaciones que no han sido modificadas por esta
      -- aplicacion y que apuntaban al pago para que apunten a la deuda
      --
      update FacturaCompraOrdenPago set fcd_id = @fcd_id, fcp_id = null where fcp_id = @fcp_id
      if @@error <> 0 goto ControlError

      -- Actualizo las aplicaciones entre facturas y notas de credito
      --
      update FacturaCompraNotaCredito set fcd_id_factura = @fcd_id, fcp_id_factura = null where fcp_id_factura = @fcp_id
      if @@error <> 0 goto ControlError

      -- Actualizo la nueva aplicacion para que pase de la deuda al pago
      --
      update FacturaCompraOrdenPagoTMP set fcd_id = @fcd_id where fcp_id = @fcp_id
      if @@error <> 0 goto ControlError

      -- Borro el pago que acabo de convertir en deuda
      --
      delete FacturaCompraPago where fcp_id = @fcp_id
      if @@error <> 0 goto ControlError

      fetch next from c_pagos into @fc_id, @fcp_id, @fcp_fecha, @fcd_importe, @fcd_pendiente
    end
    close c_pagos
    deallocate c_pagos

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        ACTUALIZO LA DEUDA                                                     //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    -- Sumo a la deuda pendiente de las facturas aplicadas a esta OrdenPago
    -- los importe cancelados por la misma
    --

    -- El cursor tiene dos formas:
    --                             1- Si se trata de una aplicacion desde factura de compra
    --                                solo se cargan las vinculaciones que estan en la tabla 
    --                                temporal ya que una factura no modifica toda la aplicacion
    --                                de una OrdenPago.
    --
    --                             2- Si se trata de una aplicacion desde OrdenPagos
    --                                se carga toda la aplicacion de la OrdenPago en cuestion
    --
    if @@bDelete = 0 begin

      declare c_aplic insensitive cursor for
            select 
                    fco.fcopg_id, 
                    fco.fcd_id, 
                    fco.fcopg_importe 
  
            from FacturaCompraOrdenPago fco inner join FacturaCompraOrdenPagoTMP fcot on fco.fcopg_id = fcot.fcopg_id
            where 
                      fco.fcd_id is not null 
                and   fcot.opgTMP_id = @@opgTMP_id

    end else begin

      declare c_aplic insensitive cursor for
            select 
                    fcopg_id, 
                    fcd_id, 
                    fcopg_importe 
  
            from FacturaCompraOrdenPago 
            where 
                      fcd_id is not null 
                and   opg_id = @opg_id
    end

    open c_aplic
    
    fetch next from c_aplic into @fcopg_id, @fcd_id, @fcopg_importe
    while @@fetch_status = 0 begin

      -- Incremento la deuda
      --
      update FacturaCompraDeuda set fcd_pendiente = fcd_pendiente + @fcopg_importe where fcd_id = @fcd_id
      if @@error <> 0 goto ControlError

      -- Borro la aplicacion
      --
      delete FacturaCompraOrdenPago where fcopg_id = @fcopg_id
      if @@error <> 0 goto ControlError

      fetch next from c_aplic into @fcopg_id, @fcd_id, @fcopg_importe
    end
    close c_aplic
    deallocate c_aplic

  end  

  -- Borro la aplicacion de esta OrdenPago
  -- Solo si se trata de una aplicacion generada por una OrdenPago
  --
  if @@bDelete <> 0 begin
    delete FacturaCompraOrdenPago where opg_id = @opg_id
    if @@error <> 0 goto ControlError
  end
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Recorro la nueva aplicacion
  --
  declare c_deuda insensitive cursor for
        select 
                fcopg_id, 
                fc_id, 
                fcd_id, 
                fcopg_importe, 
                fcopg_importeOrigen, 
                fcopg_cotizacion 

            from FacturaCompraOrdenPagoTMP 
            where opgTMP_id = @@opgTMP_id
              and fcopg_importe <> 0

  open c_deuda

  fetch next from c_deuda into @fcopg_id, @fc_id, @fcd_id, @fcopg_importe, @fcopg_importeOrigen, @fcopg_cotizacion

  while @@fetch_status = 0 begin

    -- Este es el while de pago agrupado. Abajo esta la explicacion
    --
    while @fcopg_importe > 0 begin

      -- Obtengo el monto de la deuda
      --
      -- La OrdenPago permite cobrar sobre toda la deuda de la factura o sobre cada uno de sus vencimientos.
      -- Esto complica un poco la cosa para el programador. Si en la info de aplicacion (registro de la tabla
      -- FacturaCompraOrdenPagoTMP no tengo un fcd_id (id del vencimiento), es por que se efectuo la OrdenPago
      -- sobre toda la deuda de la factura. Esto se entiende con un ejemplo:
      --        Supongamos una factura con vtos. 30, 60 y 90 dias. Tiene 3 vtos, pero el usuario decide 
      --        aplicar sobre los tres agrupados un importe dado, para el ejemplo supongamos que los vtos
      --        son todos de 30 pesos o sea 90 pesos el total, y el usuario aplica 80 pesos. El sistema tiene
      --        que aplicar 30 al primer vto, 30 al segundo y 20 al tercero. Para poder hacer esto es que utiliza
      --        el while que esta arriba (while de pago agrupado).
      --
      -- Observen el If, si no hay fcd_id tomo el primero con el select que ordena por fcd_fecha
      if IsNull(@fcd_id,0) = 0 begin
        select top 1 @fcd_id = fcd_id, @fcd_pendiente = fcd_pendiente 
        from FacturaCompraDeuda 
        where fc_id = @fc_id
        order by fcd_fecha desc

      -- Si hay info de deuda (fcd_id <> 0) todo es mas facil
      end else begin
        select @fcd_pendiente = fcd_pendiente from FacturaCompraDeuda where fcd_id = @fcd_id
      end

      -- Si el pago no cancela el pendiente
      if @fcd_pendiente - @fcopg_importe >= 0.01 begin
        -- No hay pago
        set @fcp_id = null
        set @aplic = @fcopg_importe
  
      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin

        -- Acumulo en el pago toda la deuda para pasar de la tabla FacturaCompraDeuda a FacturaCompraPago
        --
        set @aplic = @fcd_pendiente
        set @pago = 0
        select @fcd_fecha = fcd_fecha, @pago = fcd_pendiente from FacturaCompraDeuda where fcd_id = @fcd_id
        select @pago = @pago + IsNull(sum(fcopg_importe),0) from FacturaCompraOrdenPago where fcd_id = @fcd_id
        select @pago = @pago + IsNull(sum(fcnc_importe),0) from FacturaCompraNotaCredito where fcd_id_factura = @fcd_id

        exec SP_DBGetNewId 'FacturaCompraPago','fcp_id',@fcp_id out,0
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
                                        @fc_id
                                      )
        if @@error <> 0 goto ControlError
      end

      -- Si hay pago borro la/s deudas        
      --
      if IsNull(@fcp_id,0) <> 0 begin

        -- Primero actualizo las referencias pasando de deuda a pago
        --
        update FacturaCompraOrdenPago set fcd_id = null, fcp_id = @fcp_id where fcd_id = @fcd_id
        if @@error <> 0 goto ControlError

        update FacturaCompraNotaCredito set fcd_id_factura = null, fcp_id_factura = @fcp_id where fcd_id_factura = @fcd_id
        if @@error <> 0 goto ControlError

        -- Ahora si borro
        --
        delete FacturaCompraDeuda where fc_id = @fc_id and (fcd_id = @fcd_id or IsNull(@fcd_id,0) = 0)
        if @@error <> 0 goto ControlError

        -- Actualizo la nueva aplicacion para que pase de la deuda al pago
        --
        update FacturaCompraOrdenPagoTMP set fcp_id = @fcp_id where fcd_id = @fcd_id
        if @@error <> 0 goto ControlError

        -- No hay mas deuda
        set @fcd_id = null
      end

      -- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
      --
      exec SP_DBGetNewId 'FacturaCompraOrdenPago','fcopg_id',@fcopg_id out,0
      if @@error <> 0 goto ControlError

      insert into FacturaCompraOrdenPago (
                                          fcopg_id,
                                          fcopg_importe,
                                          fcopg_importeOrigen,
                                          fcopg_cotizacion,
                                          fc_id,
                                          fcd_id,
                                          fcp_id,
                                          opg_id
                                        )
                                values (
                                          @fcopg_id,
                                          @aplic,
                                          @fcopg_importeOrigen,
                                          @fcopg_cotizacion,
                                          @fc_id,
                                          @fcd_id,    --> uno de estos dos es null
                                          @fcp_id,    -->  "       "        "
                                          @opg_id
                                        )
      if @@error <> 0 goto ControlError

      -- Si no hay un pago actualizo la deuda decrementandola
      --
      if IsNull(@fcp_id,0) = 0 begin
        update FacturaCompraDeuda set fcd_pendiente = fcd_pendiente - @aplic where fcd_id = @fcd_id
        if @@error <> 0 goto ControlError
      end

      -- Voy restando al pago el importe aplicado
      --
      set @fcopg_importe = @fcopg_importe - @aplic

    end -- Fin del while de pago agrupado

    fetch next from c_deuda into @fcopg_id, @fc_id, @fcd_id, @fcopg_importe, @fcopg_importeOrigen, @fcopg_cotizacion
  end

  close c_deuda
  deallocate c_deuda

  -- Si es una vinculacion por OrdenPago puede haber nuevas facturas
  --
  if @@bDelete <> 0 begin 

    -- Completo la tabla de facturas con las nuevas aplicaciones
    --
    insert into #FacturasCpra (fc_id) select distinct fc_id from FacturaCompraOrdenPagoTMP where opgTMP_id = @@opgTMP_id

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN FACTURAS                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Finalmente actualizo el pendiente de las facturas
  --
  declare @bSuccess tinyint

  declare c_deudaFac insensitive cursor for select distinct fc_id from #FacturasCpra

  open c_deudaFac
  fetch next from c_deudaFac into @fc_id
  while @@fetch_status = 0 begin
    -- Actualizo la deuda de la factura
    exec sp_DocFacturaCompraSetPendiente @fc_id, @bSuccess out

    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError

    -- Estado
    exec sp_DocFacturaCompraSetCredito @fc_id
    if @@error <> 0 goto ControlError

    exec sp_DocFacturaCompraSetEstado @fc_id
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- ESTADO
          exec sp_AuditoriaEstadoCheckDocFC    @fc_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError

      -- VTOS
          exec sp_AuditoriaVtoCheckDocFC      @fc_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError
      
      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocFC  @fc_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_deudaFac into @fc_id
  end
  close c_deudaFac
  deallocate c_deudaFac

  -- Ahora el pendiente de la OrdenPago
  exec sp_DocOrdenPagoSetPendiente @opg_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  -- Estado
  exec sp_DocOrdenPagoSetCredito @opg_id
  if @@error <> 0 goto ControlError
  
  exec sp_DocOrdenPagoSetEstado @opg_id
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        CUENTA CORRIENTE                                                       //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Tengo que regenerar la cuenta corriente de esta OrdenPago ya que al aplicar por nuevos montos
  -- y con nuevas facturas, las cuentas involucradas cambian.

  declare @orden                    smallint
  declare @opgi_id                   int
  declare  @opgi_orden               smallint 
  declare @opgi_importe             decimal(18, 6)
  declare @opgi_importeorigen       decimal(18, 6)
  declare @aplicOrigen              decimal(18, 6)
  declare @total                    decimal(18, 6)
  declare @cotiz                    decimal(18, 6)
  declare @cue_id                   int
  declare @cue_id_anticipo          int
  declare @mon_id                   int
  declare @mon_default              int

  declare @opgiTCtaCte    tinyint set @opgiTCtaCte   = 5  

  -- Guardo un id de cuenta para anticipos. 
  -- Esto funciona asi: Si despues de aplicar queda plata pendiente
  --                    la asigno a la cuenta anticipo
  select @cue_id_anticipo = cue_id from OrdenPagoItem 
    where opg_id = @opg_id and opgi_tipo  = @opgiTCtaCte 
                             and opgi_orden = ( select min(opgi_orden) 
                                                 from OrdenPagoItem 
                                                 where opg_id = @opg_id and opgi_tipo = @opgiTCtaCte 
                                                )
  -- Borro la info de cuenta corriente para esta OrdenPago
  --
  delete OrdenPagoItem where opg_id = @opg_id and opgi_tipo = @opgiTCtaCte
  if @@error <> 0 goto ControlError

  -- Obtengo la cuenta corriente partiendo de la aplicacion
  --
  declare @cue_acreedoresXCpra int 
  set @cue_acreedoresXCpra = 8

  declare c_ctacte insensitive cursor for 
    select c.cue_id, sum(fcopg_importe), sum(fcopg_importeOrigen)
    from   FacturaCompraOrdenPago fcopg   inner join FacturaCompra fc  on fcopg.fc_id   = fc.fc_id
                                        inner join AsientoItem asi   on asi.as_id     = fc.as_id
                                         inner join Cuenta c         on asi.cue_id   = c.cue_id

    where 
          fcopg.opg_id   = @opg_id
    and    asi_haber      <> 0
    and   cuec_id       =  @cue_acreedoresXCpra

  group by c.cue_id

  set @opgi_orden = 0
  set @aplic      = 0

  open c_ctacte

  fetch next from c_ctacte into @cue_id, @opgi_importe, @opgi_importeorigen
  while @@fetch_status = 0
  begin

    set @opgi_orden = @opgi_orden + 1

    -- Creo un nuevo registro de OrdenPago item
    --
    exec SP_DBGetNewId 'OrdenPagoItem','opgi_id',@opgi_id out,0
    if @@error <> 0 goto ControlError

    insert into OrdenPagoItem (
                                  opg_id,
                                  opgi_id,
                                  opgi_orden,
                                  opgi_importe,
                                  opgi_importeorigen,
                                  opgi_tipo,
                                  cue_id
                            )
                        Values(
                                  @opg_id,
                                  @opgi_id,
                                  @opgi_orden,
                                  @opgi_importe,
                                  @opgi_importeorigen,
                                  @opgiTCtaCte,
                                  @cue_id
                            )

    if @@error <> 0 goto ControlError

    set @aplic = @aplic + @opgi_importe

    fetch next from c_ctacte into @cue_id, @opgi_importe, @opgi_importeorigen
  end -- While

  close c_ctacte
  deallocate c_ctacte

  select @total = opg_total, @cotiz = opg_cotizacion from OrdenPago where opg_id = @opg_id

  set @total = IsNull(@total,0)
  set @aplic = IsNull(@aplic,0)
  set @cotiz = IsNull(@cotiz,0)

  if @aplic < @total begin

    set @aplic = @total - @aplic

    select @mon_id = mon_id from Cuenta where cue_id = @cue_id_anticipo
    if exists(select * from Moneda where mon_id = @mon_id and mon_legal <> 0)
      set @cotiz = 0

    if @cotiz > 0     set @aplicOrigen = @aplic / @cotiz
    else              set @aplicOrigen = 0

    set @opgi_orden = @opgi_orden + 1

    -- Creo un nuevo registro de OrdenPago item
    --
    exec SP_DBGetNewId 'OrdenPagoItem','opgi_id',@opgi_id out,0
    if @@error <> 0 goto ControlError

    insert into OrdenPagoItem (
                                  opg_id,
                                  opgi_id,
                                  opgi_orden,
                                  opgi_importe,
                                  opgi_importeorigen,
                                  opgi_tipo,
                                  cue_id
                            )
                        Values(
                                  @opg_id,
                                  @opgi_id,
                                  @opgi_orden,
                                  @aplic,
                                  @aplicOrigen,
                                  @opgiTCtaCte,
                                  @cue_id_anticipo
                            )

    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bError smallint

  exec sp_DocOrdenPagoAsientoSave @opg_id,0,@bError out, @MsgError out
  if @bError <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_HistoriaUpdate 18005, @opg_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete FacturaCompraOrdenPagoTMP where opgTMP_id = @@opgTMP_id
  if @@error <> 0 goto ControlError

  delete OrdenPagoItemTMP where opgTMP_id = @@opgTMP_id
  if @@error <> 0 goto ControlError

  delete OrdenPagoTMP where opgTMP_id = @@opgTMP_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  if @@bSelect <> 0 select @opg_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar la aplicación de la Orden de Pago. sp_DocOrdenPagoSaveAplic.', 16, 1)
  rollback transaction  

end 

go