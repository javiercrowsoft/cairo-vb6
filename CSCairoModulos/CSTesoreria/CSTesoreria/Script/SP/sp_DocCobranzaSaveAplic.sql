if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaSaveAplic]

/*

  exec  sp_DocCobranzaSaveAplic 38

*/

go
create procedure sp_DocCobranzaSaveAplic (
  @@cobzTMP_id     int,
  @@bSelect        tinyint = 1,
  @@bSuccess      tinyint = 0 out,
  @@bDelete       tinyint = 1
)
as

begin

  set nocount on

  declare @MsgError varchar(5000)

  declare @fvcobz_id               int
  declare @fvcobz_importe          decimal(18,6)
  declare @fvcobz_importeOrigen    decimal(18,6)
  declare @fvcobz_cotizacion       decimal(18,6)
  declare @fvd_pendiente          decimal(18,6)
  declare @fvd_importe            decimal(18,6)
  declare @fvd_id                  int
  declare @fvp_id                  int
  declare @fv_id                  int
  declare @pago                   decimal(18,6)
  declare @aplic                   decimal(18,6)
  declare @fvp_fecha              datetime
  declare @fvd_fecha              datetime
  declare @fvd_fecha2             datetime
  declare @cobz_id                 int   

  set @@bSuccess = 0

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @modifico int

  select @cobz_id = cobz_id, @modifico = modifico from CobranzaTMP where cobzTMP_id = @@cobzTMP_id

  ---------------------------------
  -- Si no hay cobranza no hago nada
  --
  if @cobz_id is null begin

    select @cobz_id
    return
  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        VALIDACIONES A LA APLICACION                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

        delete FacturaVentaCobranzaTMP 
        where cobzTMP_id = @@cobzTMP_id
          and fvd_id is null
          and fvp_id is null

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TRANSACCION                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Esta tabla es para almacenar todas las facturas afectadas por esta aplicacion
  -- para luego actualizarles el campo fv_pendiente
  --
  create table #FacturasVta (fv_id int not null)

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
  -- Sumo a la deuda pendiente de las facturas aplicadas a esta cobranza
  -- los importe cancelados por la misma
  --
  
  if @@bDelete = 0 begin -- (este if esta varias veces por que se dio prioridad a la legibilidad del codigo)

    -- Inserto en #FacturasVta solo las facturas mencionadas en la TMP
    --
    insert into #FacturasVta (fv_id) select distinct fv_id from FacturaVentaCobranzaTMP where cobz_id = @cobz_id

  end else begin

    -- Inserto en #FacturasVta todas las facturas vinculadas con esta cobranza
    --
    insert into #FacturasVta (fv_id) select distinct fv_id from FacturaVentaCobranza where cobz_id = @cobz_id
  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  begin transaction

  -- Tengo que eliminar la aplicacion anterior si es que existe
  --
  if exists(select fvcobz_id from FacturaVentaCobranza where cobz_id = @cobz_id) begin

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
    --                             1- Si se trata de una aplicacion desde factura de venta
    --                                solo se cargan las vinculaciones que estan en la tabla 
    --                                temporal ya que una factura no modifica toda la aplicacion
    --                                de una cobranza.
    --
    --                             2- Si se trata de una aplicacion desde cobranzas
    --                                se carga toda la aplicacion de la cobranza en cuestion
    --
    if @@bDelete = 0 begin

      declare c_pagos insensitive cursor for
            select 
                            fvp.fv_id, 
                            fvp.fvp_id, 
                            fvp_fecha,
                            fvp_importe,
                            sum(fvc.fvcobz_importe)  -- Sumo todas las aplicaciones de esta 
                                                     -- cobranza sobre el pago para obtener
                                                     -- el pendiente de la deuda
  
              from FacturaVentaCobranza fvc inner join FacturaVentaPago fvp on fvc.fvp_id = fvp.fvp_id
                                            inner join FacturaVentaCobranzaTMP fvct on fvc.fvcobz_id = fvct.fvcobz_id

              where fvct.cobzTMP_id = @@cobzTMP_id
              group by 
                            fvp.fv_id, 
                            fvp.fvp_id, 
                            fvp_fecha,
                            fvp_importe
    end else begin
      declare c_pagos insensitive cursor for
            select 
                            fvp.fv_id, 
                            fvp.fvp_id, 
                            fvp_fecha,
                            fvp_importe,
                            sum(fvcobz_importe)  -- Sumo todas las aplicaciones de esta 
                                                 -- cobranza sobre el pago para obtener
                                                 -- el pendiente de la deuda
  
              from FacturaVentaCobranza fvc inner join FacturaVentaPago fvp on fvc.fvp_id = fvp.fvp_id
              where cobz_id = @cobz_id
              group by 
                            fvp.fv_id, 
                            fvp.fvp_id, 
                            fvp_fecha,
                            fvp_importe
    end

    open c_pagos

    fetch next from c_pagos into @fv_id, @fvp_id, @fvp_fecha, @fvd_importe, @fvd_pendiente
    while @@fetch_status = 0 begin

      -- Creo la deuda
      --
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
                                      @fv_id
                                    )
      if @@error <> 0 goto ControlError

      -- Ahora que converti el pago en deuda borro las
      -- aplicaciones asociadas a este pago
      --
      if @@bDelete = 0 begin

        delete FacturaVentaCobranza from FacturaVentaCobranzaTMP fvct 
        where     FacturaVentaCobranza.fvp_id    = @fvp_id 
              and FacturaVentaCobranza.fvcobz_id = fvct.fvcobz_id
              and fvct.cobzTMP_id = @@cobzTMP_id

        if @@error <> 0 goto ControlError

        -- Borro la aplicacion
        --
        delete FacturaVentaCobranza 
        where fvp_id is null 
          and fvd_id is null
          and fv_id in (select fv_id from FacturaVentaCobranzaTMP where cobzTMP_id = @@cobzTMP_id)
        
        if @@error <> 0 goto ControlError

      end else begin

        -- Borro todas las aplicaciones que apuntaban al pago
        --
        delete FacturaVentaCobranza where fvp_id = @fvp_id and cobz_id = @cobz_id
        if @@error <> 0 goto ControlError
      end

      -- Actualizo todas las aplicaciones que no han sido modificadas por esta
      -- aplicacion y que apuntaban al pago para que apunten a la deuda
      --
      update FacturaVentaCobranza set fvd_id = @fvd_id, fvp_id = null where fvp_id = @fvp_id
      if @@error <> 0 goto ControlError

      -- Actualizo las aplicaciones entre facturas y notas de credito
      --
      update FacturaVentaNotaCredito set fvd_id_factura = @fvd_id, fvp_id_factura = null where fvp_id_factura = @fvp_id
      if @@error <> 0 goto ControlError

      -- Actualizo la nueva aplicacion para que pase de la deuda al pago
      --
      update FacturaVentaCobranzaTMP set fvd_id = @fvd_id where fvp_id = @fvp_id
      if @@error <> 0 goto ControlError

      -- Borro el pago que acabo de convertir en deuda
      --
      delete FacturaVentaPago where fvp_id = @fvp_id
      if @@error <> 0 goto ControlError

      fetch next from c_pagos into @fv_id, @fvp_id, @fvp_fecha, @fvd_importe, @fvd_pendiente
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
    -- Sumo a la deuda pendiente de las facturas aplicadas a esta cobranza
    -- los importe cancelados por la misma
    --

    -- El cursor tiene dos formas:
    --                             1- Si se trata de una aplicacion desde factura de venta
    --                                solo se cargan las vinculaciones que estan en la tabla 
    --                                temporal ya que una factura no modifica toda la aplicacion
    --                                de una cobranza.
    --
    --                             2- Si se trata de una aplicacion desde cobranzas
    --                                se carga toda la aplicacion de la cobranza en cuestion
    --
    if @@bDelete = 0 begin

      declare c_aplic insensitive cursor for
            select 
                    fvc.fvcobz_id, 
                    fvc.fvd_id, 
                    fvc.fvcobz_importe 
  
            from FacturaVentaCobranza fvc inner join FacturaVentaCobranzaTMP fvct on fvc.fvcobz_id = fvct.fvcobz_id
            where 
                      fvc.fvd_id is not null 
                and   fvct.cobzTMP_id = @@cobzTMP_id

    end else begin

      declare c_aplic insensitive cursor for
            select 
                    fvcobz_id, 
                    fvd_id, 
                    fvcobz_importe 
  
            from FacturaVentaCobranza 
            where 
                      fvd_id is not null 
                and   cobz_id = @cobz_id
    end

    open c_aplic
    
    fetch next from c_aplic into @fvcobz_id, @fvd_id, @fvcobz_importe
    while @@fetch_status = 0 begin

      -- Incremento la deuda
      --
      update FacturaVentaDeuda set fvd_pendiente = fvd_pendiente + @fvcobz_importe where fvd_id = @fvd_id
      if @@error <> 0 goto ControlError

      -- Borro la aplicacion
      --
      delete FacturaVentaCobranza where fvcobz_id = @fvcobz_id
      if @@error <> 0 goto ControlError

      fetch next from c_aplic into @fvcobz_id, @fvd_id, @fvcobz_importe
    end
    close c_aplic
    deallocate c_aplic

  end  

  -- Borro la aplicacion de esta cobranza
  -- Solo si se trata de una aplicacion generada por una cobranza
  --
  if @@bDelete <> 0 begin
    delete FacturaVentaCobranza where cobz_id = @cobz_id
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
                fvcobz_id, 
                fv_id, 
                fvd_id, 
                fvcobz_importe, 
                fvcobz_importeOrigen, 
                fvcobz_cotizacion 

            from FacturaVentaCobranzaTMP 
            where cobzTMP_id = @@cobzTMP_id
              and fvcobz_importe <> 0

  open c_deuda

  fetch next from c_deuda into @fvcobz_id, @fv_id, @fvd_id, @fvcobz_importe, @fvcobz_importeOrigen, @fvcobz_cotizacion

  while @@fetch_status = 0 begin

    -- Este es el while de pago agrupado. Abajo esta la explicacion
    --
    while @fvcobz_importe > 0 begin

      -- Obtengo el monto de la deuda
      --
      -- La cobranza permite cobrar sobre toda la deuda de la factura o sobre cada uno de sus vencimientos.
      -- Esto complica un poco la cosa para el programador. Si en la info de aplicacion (registro de la tabla
      -- FacturaVentaCobranzaTMP no tengo un fvd_id (id del vencimiento), es por que se efectuo la cobranza
      -- sobre toda la deuda de la factura. Esto se entiende con un ejemplo:
      --        Supongamos una factura con vtos. 30, 60 y 90 dias. Tiene 3 vtos, pero el usuario decide 
      --        aplicar sobre los tres agrupados un importe dado, para el ejemplo supongamos que los vtos
      --        son todos de 30 pesos o sea 90 pesos el total, y el usuario aplica 80 pesos. El sistema tiene
      --        que aplicar 30 al primer vto, 30 al segundo y 20 al tercero. Para poder hacer esto es que utiliza
      --        el while que esta arriba (while de pago agrupado).
      --
      -- Observen el If, si no hay fvd_id tomo el primero con el select que ordena por fvd_fecha
      if IsNull(@fvd_id,0) = 0 begin
        select top 1 @fvd_id = fvd_id, @fvd_pendiente = fvd_pendiente 
        from FacturaVentaDeuda 
        where fv_id = @fv_id
        order by fvd_fecha desc

      -- Si hay info de deuda (fvd_id <> 0) todo es mas facil
      end else begin
        select @fvd_pendiente = fvd_pendiente from FacturaVentaDeuda where fvd_id = @fvd_id
      end

      -- Si el pago no cancela el pendiente
      if @fvd_pendiente - @fvcobz_importe >= 0.01 begin
        -- No hay pago
        set @fvp_id = null
        set @aplic = @fvcobz_importe
  
      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin

        -- Acumulo en el pago toda la deuda para pasar de la tabla FacturaVentaDeuda a FacturaVentaPago
        --
        set @aplic = @fvd_pendiente
        set @pago  = 0
        select @fvd_fecha = fvd_fecha, @pago = fvd_pendiente from FacturaVentaDeuda where fvd_id = @fvd_id
        select @pago = @pago + IsNull(sum(fvcobz_importe),0) from FacturaVentaCobranza where fvd_id = @fvd_id
        select @pago = @pago + IsNull(sum(fvnc_importe),0) from FacturaVentaNotaCredito where fvd_id_factura = @fvd_id

        exec SP_DBGetNewId 'FacturaVentaPago','fvp_id',@fvp_id out,0
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
                                        @fv_id
                                      )
        if @@error <> 0 goto ControlError
      end

      -- Si hay pago borro la/s deudas        
      --
      if IsNull(@fvp_id,0) <> 0 begin

        -- Primero actualizo las referencias pasando de deuda a pago
        --
        update FacturaVentaCobranza set fvd_id = null, fvp_id = @fvp_id where fvd_id = @fvd_id
        if @@error <> 0 goto ControlError

        update FacturaVentaNotaCredito set fvd_id_factura = null, fvp_id_factura = @fvp_id where fvd_id_factura = @fvd_id
        if @@error <> 0 goto ControlError

        -- Ahora si borro
        --
        delete FacturaVentaDeuda where fv_id = @fv_id and (fvd_id = @fvd_id or IsNull(@fvd_id,0) = 0)
        if @@error <> 0 goto ControlError

        -- Actualizo la nueva aplicacion para que pase de la deuda al pago
        --
        update FacturaVentaCobranzaTMP set fvp_id = @fvp_id where fvd_id = @fvd_id
        if @@error <> 0 goto ControlError

        -- No hay mas deuda
        set @fvd_id = null
      end

      -- Finalmente grabo la vinculacion que puede estar asociada a una deuda o a un pago
      --
      exec SP_DBGetNewId 'FacturaVentaCobranza','fvcobz_id',@fvcobz_id out,0
      if @@error <> 0 goto ControlError

      insert into FacturaVentaCobranza (
                                          fvcobz_id,
                                          fvcobz_importe,
                                          fvcobz_importeOrigen,
                                          fvcobz_cotizacion,
                                          fv_id,
                                          fvd_id,
                                          fvp_id,
                                          cobz_id
                                        )
                                values (
                                          @fvcobz_id,
                                          @aplic,
                                          @fvcobz_importeOrigen,
                                          @fvcobz_cotizacion,
                                          @fv_id,
                                          @fvd_id,    --> uno de estos dos es null
                                          @fvp_id,    -->  "       "        "
                                          @cobz_id
                                        )
      if @@error <> 0 goto ControlError

      -- Si no hay un pago actualizo la deuda decrementandola
      --
      if IsNull(@fvp_id,0) = 0 begin
        update FacturaVentaDeuda set fvd_pendiente = fvd_pendiente - @aplic where fvd_id = @fvd_id
        if @@error <> 0 goto ControlError
      end

      -- Voy restando al pago el importe aplicado
      --
      set @fvcobz_importe = @fvcobz_importe - @aplic

    end -- Fin del while de pago agrupado

    fetch next from c_deuda into @fvcobz_id, @fv_id, @fvd_id, @fvcobz_importe, @fvcobz_importeOrigen, @fvcobz_cotizacion
  end

  close c_deuda
  deallocate c_deuda

  -- Si es una vinculacion por cobranza puede haber nuevas facturas
  --
  if @@bDelete <> 0 begin 

    -- Completo la tabla de facturas con las nuevas aplicaciones
    --
    insert into #FacturasVta (fv_id) select distinct fv_id from FacturaVentaCobranzaTMP where cobzTMP_id = @@cobzTMP_id

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

  declare c_deudaFac insensitive cursor for select distinct fv_id from #FacturasVta

  open c_deudaFac
  fetch next from c_deudaFac into @fv_id
  while @@fetch_status = 0 begin
    -- Actualizo la deuda de la factura
    exec sp_DocFacturaVentaSetPendiente @fv_id, @bSuccess out
  
    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError

    -- Estado
    exec sp_DocFacturaVentaSetCredito @fv_id
    if @@error <> 0 goto ControlError

    exec sp_DocFacturaVentaSetEstado @fv_id
    if @@error <> 0 goto ControlError

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- ESTADO
          exec sp_AuditoriaEstadoCheckDocFV    @fv_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError

      -- VTOS
          exec sp_AuditoriaVtoCheckDocFV      @fv_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError
      
      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocFV  @fv_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////

    fetch next from c_deudaFac into @fv_id
  end
  close c_deudaFac
  deallocate c_deudaFac

  -- Ahora el pendiente de la cobranza
  exec sp_DocCobranzaSetPendiente @cobz_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  -- Estado
  exec sp_DocCobranzaSetCredito @cobz_id
  if @@error <> 0 goto ControlError

  exec sp_DocCobranzaSetEstado @cobz_id
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        CUENTA CORRIENTE                                                       //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Tengo que regenerar la cuenta corriente de esta cobranza ya que al aplicar por nuevos montos
  -- y con nuevas facturas, las cuentas involucradas cambian.

  declare @orden                    smallint
  declare @cobzi_id                 int
  declare  @cobzi_orden               smallint 
  declare @cobzi_importe             decimal(18, 6)
  declare @cobzi_importeorigen      decimal(18, 6)
  declare @aplicOrigen              decimal(18, 6)
  declare @total                    decimal(18, 6)
  declare @cotiz                    decimal(18, 6)
  declare @cue_id                   int
  declare @cue_id_anticipo          int
  declare @mon_id                   int
  declare @mon_default              int

  declare @CobziTCtaCte    tinyint set @CobziTCtaCte   = 5  

  -- Guardo un id de cuenta para anticipos. 
  -- Esto funciona asi: Si despues de aplicar queda plata pendiente
  --                    la asigno a la cuenta anticipo
  select @cue_id_anticipo = cue_id from CobranzaItem 
    where cobz_id = @cobz_id and cobzi_tipo  = @CobziTCtaCte 
                             and cobzi_orden = ( select min(cobzi_orden) 
                                                 from CobranzaItem 
                                                 where cobz_id = @cobz_id and cobzi_tipo = @CobziTCtaCte 
                                                )
  -- Borro la info de cuenta corriente para esta cobranza
  --
  delete CobranzaItem where cobz_id = @cobz_id and cobzi_tipo = @CobziTCtaCte
  if @@error <> 0 goto ControlError

  -- Obtengo la cuenta corriente partiendo de la aplicacion
  --
  declare @cue_deudoresXvta int 
  set @cue_deudoresXvta = 4

  declare c_ctacte insensitive cursor for 
    select c.cue_id, sum(fvcobz_importe), sum(fvcobz_importeOrigen )
    from   FacturaVentaCobranza  inner join FacturaVenta       on FacturaVentaCobranza.fv_id = FacturaVenta.fv_id
                                inner join AsientoItem        on AsientoItem.as_id = FacturaVenta.as_id
                                 inner join Cuenta c           on AsientoItem.cue_id = c.cue_id

    where 
          cobz_id       = @cobz_id
    and    asi_debe       <> 0
    and   cuec_id       =  @cue_deudoresXvta

  group by c.cue_id

  set @cobzi_orden = 0
  set @aplic       = 0

  open c_ctacte

  fetch next from c_ctacte into @cue_id, @cobzi_importe, @cobzi_importeorigen
  while @@fetch_status = 0
  begin

    set @cobzi_orden = @cobzi_orden + 1

    -- Creo un nuevo registro de cobranza item
    --
    exec SP_DBGetNewId 'CobranzaItem','cobzi_id',@cobzi_id out,0
    if @@error <> 0 goto ControlError

    insert into CobranzaItem (
                                  cobz_id,
                                  cobzi_id,
                                  cobzi_orden,
                                  cobzi_importe,
                                  cobzi_importeorigen,
                                  cobzi_tipo,
                                  cue_id
                            )
                        Values(
                                  @cobz_id,
                                  @cobzi_id,
                                  @cobzi_orden,
                                  @cobzi_importe,
                                  @cobzi_importeorigen,
                                  @CobziTCtaCte,
                                  @cue_id
                            )

    if @@error <> 0 goto ControlError

    set @aplic = @aplic + @cobzi_importe

    fetch next from c_ctacte into @cue_id, @cobzi_importe, @cobzi_importeorigen
  end -- While

  close c_ctacte
  deallocate c_ctacte

  select @total = cobz_total, @cotiz = cobz_cotizacion from Cobranza where cobz_id = @cobz_id

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

    set @cobzi_orden = @cobzi_orden + 1

    -- Creo un nuevo registro de cobranza item
    --
    exec SP_DBGetNewId 'CobranzaItem','cobzi_id',@cobzi_id out,0
    if @@error <> 0 goto ControlError

    insert into CobranzaItem (
                                  cobz_id,
                                  cobzi_id,
                                  cobzi_orden,
                                  cobzi_importe,
                                  cobzi_importeorigen,
                                  cobzi_tipo,
                                  cue_id
                            )
                        Values(
                                  @cobz_id,
                                  @cobzi_id,
                                  @cobzi_orden,
                                  @aplic,
                                  @aplicOrigen,
                                  @CobziTCtaCte,
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

  exec sp_DocCobranzaAsientoSave @cobz_id,0,@bError out, @MsgError out
  if @bError <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_HistoriaUpdate 18004, @cobz_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete FacturaVentaCobranzaTMP where cobzTMP_id = @@cobzTMP_id
  if @@error <> 0 goto ControlError

  delete CobranzaItemTMP where cobzTMP_id = @@cobzTMP_id
  if @@error <> 0 goto ControlError

  delete CobranzaTMP where cobzTMP_id = @@cobzTMP_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  if @@bSelect <> 0 select @cobz_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la aplicación de la cobranza. sp_DocCobranzaSaveAplic. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end 

go