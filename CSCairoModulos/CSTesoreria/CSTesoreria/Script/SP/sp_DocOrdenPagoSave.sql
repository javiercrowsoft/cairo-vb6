if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoSave]

/*

    0) Graba la NC o la ND
    1) Graba el header de la OrdenPago
    2.1) Graba los cheques y tarjetas
    2.2) Graba los items de la OrdenPago
    3) Borra temporales

............................................................................
Nota: Las OrdenPagos solo se relacionan con Facturas y Notas de debito, 
      las notas de credito no se mencionan en los recibos.

      Las notas de debito se vinculan con las facturas o notas de debito
      por medio de la tabla FacturaCompraNotaCredito.
............................................................................

 sp_DocOrdenPagoSave 7

*/

go
create procedure sp_DocOrdenPagoSave (
  @@opgTMP_id         int,
  @@bSelect            tinyint = 1,
  @@opg_id            int     = 0 out,
  @@bSuccess          tinyint = 0 out,
  @@bDontRaiseError    tinyint = 0,
  @@MsgError          varchar(5000) = '' out,
  @@fc_id             int     = null    /* Me permite saber si la orden de pago se genero automaticamente
                                           La recibo como parametro ya que no puedo leerla del documento 
                                           cuando la OP es nueva ya que el campo se actualiza recien al 
                                           terminar de grabar el documento
                                        */
)
as

begin

  set nocount on

  -- Antes que nada valido que este el centro de costo
  --

  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'Exigir Centro Costo OPG',
                        @cfg_valor out,
                        0
  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    if exists(select ccos_id  from OrdenPagoTMP where ccos_id is null and opgTMP_id = @@opgTMP_id)
    begin

      if exists(select ccos_id from OrdenPagoItemTMP where ccos_id is null and opgTMP_id = @@opgTMP_id and opgi_tipo in (1,2,4,6))
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

    end
    
  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @MsgError  varchar(5000) set @MsgError = ''

  declare @opg_id          int
  declare @opgi_id        int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @opg_fecha       datetime 
  declare  @prov_id        int
  declare  @doc_id         int
  declare  @doct_id        int
  declare  @opg_nrodoc      varchar (50) 
  declare @emp_id         int

  set @@bSuccess = 0

  -- Si no existe chau
  if not exists (select opgTMP_id from OrdenPagoTMP where opgTMP_id = @@opgTMP_id)
    return
  
  select 
          @opg_id       = opg_id, 
          @opg_fecha     = opg_fecha, 
          @prov_id       = prov_id, 
          @doc_id       = Documento.doc_id, 
          @doct_id       = doct_id,
          @opg_nrodoc    = opg_nrodoc,
          @emp_id       = emp_id 

  from OrdenPagoTMP inner join Documento on OrdenPagoTMP.doc_id = Documento.doc_id
  where opgTMP_id = @@opgTMP_id

  
  set @opg_id = isnull(@opg_id,0)
  

-- Campos de las tablas

declare  @opg_numero      int 
declare  @opg_descrip     varchar (5000)
declare  @opg_neto       decimal(18, 6) 
declare  @opg_total      decimal(18, 6)
declare  @opg_pendiente  decimal(18, 6)
declare @opg_cotizacion decimal(18, 6)
declare @opg_otros      decimal(18, 6)
declare @opg_grabarAsiento smallint

declare  @est_id     int
declare  @suc_id     int
declare @ta_id      int
declare  @ccos_id    int
declare @lgj_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 


declare  @opgi_orden               smallint 
declare  @opgi_descrip             varchar (5000) 
declare  @opgi_descuento           varchar (100) 
declare  @opgi_neto                 decimal(18, 6) 
declare @opgi_importe             decimal(18, 6)
declare @opgi_importeorigen       decimal(18, 6)
declare @opgi_otroTipo            tinyint
declare @opgi_porcRetencion        decimal(18, 6)
declare @opgi_fechaRetencion      datetime
declare @opgi_nroRetencion        varchar(100)
declare @opgi_tipo                tinyint
declare @cheq_id                  int
declare @cue_id                   int
declare @cle_id                   int
declare @chq_id                   int
declare @bco_id                   int
declare @mon_id                   int
declare @ret_id                   int
declare @fc_id_ret                int
declare @cheq_numerodoc           varchar(100)
declare @cheq_fechaCobro          datetime
declare @cheq_fechaVto            datetime
declare @tjcc_numero              int
declare @tjcc_numerodoc           varchar(100)
declare @opgiTMP_fechaVto          datetime
declare @opgiTMP_nroTarjeta        varchar(50)
declare @opgiTMP_nroAutorizacion   varchar(50)
declare @opgiTMP_titular           varchar(255)

declare @opgiTCheques             tinyint set @opgiTCheques   = 1
declare @opgiTEfectivo            tinyint set @opgiTEfectivo   = 2
declare @opgiTTarjeta              tinyint set @opgiTTarjeta   = 3
declare @opgiTOtros                tinyint set @opgiTOtros     = 4
declare @opgiTCtaCte              tinyint set @opgiTCtaCte     = 5
declare @opgiTChequesT            tinyint set @opgiTChequesT  = 6

declare @CheqPropio               tinyint set @CheqPropio     = 1
              
declare @fc_id                    int
declare @fcd_id                    int
declare  @doct_id_ncnd             int
declare @bSuccess                 int

  begin transaction

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Si es una nueva OrdenPago
  if @opg_id = 0 begin

    -- Este flag es para cuando grabe los items
    set @IsNew = -1

    -- Obtengo id y numero para la OrdenPago
    --  
    exec SP_DBGetNewId 'OrdenPago','opg_id',@opg_id out,0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'OrdenPago','opg_numero',@opg_numero out,0
    if @@error <> 0 goto ControlError

    -- //////////////////////////////////////////////////////////////////////////////////
    --
    -- Talonario
    --
          declare @ta_propuesto tinyint
          declare @ta_tipo      smallint
      
          exec sp_talonarioGetPropuesto @doc_id, 0, @ta_propuesto out, 0, 0, @ta_id out, @ta_tipo out
          if @@error <> 0 goto ControlError
      
          if @ta_propuesto = 0 begin
      
            if @ta_tipo = 3 /*Auto Impresor*/ begin

              declare @ta_nrodoc varchar(100)

              exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
              if @@error <> 0 goto ControlError

              -- Con esto evitamos que dos tomen el mismo número
              --
              exec sp_TalonarioSet @ta_id, @ta_nrodoc
              if @@error <> 0 goto ControlError

              set @opg_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into OrdenPago (
                              opg_id,
                              opg_numero,
                              opg_nrodoc,
                              opg_descrip,
                              opg_fecha,
                              opg_neto,
                              opg_otros,
                              opg_total,
                              opg_cotizacion,
                              opg_grabarAsiento,
                              est_id,
                              suc_id,
                              prov_id,
                              emp_id,
                              doc_id,
                              doct_id,
                              ccos_id,
                              lgj_id,
                              modifico
                            )
      select
                              @opg_id,
                              @opg_numero,
                              @opg_nrodoc,
                              opg_descrip,
                              opg_fecha,
                              opg_neto,
                              opg_otros,
                              opg_total,
                              opg_cotizacion,
                              opg_grabarAsiento,
                              est_id,
                              suc_id,
                              prov_id,
                              @emp_id,
                              doc_id,
                              @doct_id,
                              ccos_id,
                              lgj_id,
                              modifico
      from OrdenPagoTMP
      where opgTMP_id = @@opgTMP_id  

      if @@error <> 0 goto ControlError
    
      select @opg_nrodoc = opg_nrodoc from OrdenPago where opg_id = @opg_id
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        UPDATE                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  else begin

    set @IsNew = 0

    select
                              @opg_id                 = opg_id,
                              @opg_nrodoc              = opg_nrodoc,
                              @opg_descrip            = opg_descrip,
                              @opg_fecha              = opg_fecha,
                              @opg_neto                = opg_neto,
                              @opg_otros              = opg_otros,
                              @opg_total              = opg_total,
                              @opg_cotizacion          = opg_cotizacion,
                              @opg_grabarAsiento      = opg_grabarAsiento,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @prov_id                = prov_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                  = lgj_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from OrdenPagoTMP 
    where 
          opgTMP_id = @@opgTMP_id
  
    update OrdenPago set 
                              opg_nrodoc            = @opg_nrodoc,
                              opg_descrip            = @opg_descrip,
                              opg_fecha              = @opg_fecha,
                              opg_neto              = @opg_neto,
                              opg_otros             = @opg_otros,
                              opg_total              = @opg_total,
                              opg_cotizacion        = @opg_cotizacion,
                              opg_grabarAsiento     = @opg_grabarAsiento,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              prov_id                = @prov_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              ccos_id                = @ccos_id,
                              lgj_id                = @lgj_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where opg_id = @opg_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Recorro con un while que es mas rapido que un cursor. Uso opgi_orden como puntero.
  --
  set @orden = 1
  while exists(select opgi_orden from OrdenPagoItemTMP where opgTMP_id = @@opgTMP_id and opgi_orden = @orden) 
  begin

    -- Cargo todo el registro de OrdenPagos en variables
    --
    select
            @opgi_id                      = opgi_id,
            @opgi_orden                    = opgi_orden,
            @opgi_descrip                  = opgi_descrip,
            @opgi_importe                  = opgi_importe,
            @opgi_importeorigen            = opgi_importeorigen,
            @ccos_id                      = ccos_id,
            @opgi_otroTipo                = opgi_otroTipo,
            @opgi_porcRetencion            = opgi_porcRetencion,
            @opgi_fechaRetencion          = opgi_fechaRetencion,
            @opgi_nroRetencion            = opgi_nroRetencion,
            @opgi_tipo                    = opgi_tipo,
            @chq_id                        = chq_id,
            @cheq_id                      = cheq_id,
            @cue_id                        = cue_id,
            @bco_id                       = bco_id,
            @cle_id                       = cle_id,
            @cheq_numerodoc               = opgiTMP_cheque,
            @cheq_fechaCobro              = opgiTMP_fechaCobro,
            @cheq_fechaVto                = opgiTMP_fechaVto,
            @tjcc_numerodoc               = opgiTMP_cupon,
            @opgiTMP_fechaVto              = opgiTMP_fechaVto,
            @opgiTMP_nroTarjeta            = opgiTMP_nroTarjeta,
            @opgiTMP_nroAutorizacion       = opgiTMP_autorizacion,
            @opgiTMP_titular               = opgiTMP_titular,
            @mon_id                       = mon_id,
            @ret_id                       = ret_id,
            @fc_id_ret                    = fc_id_ret

    from OrdenPagoItemTMP where opgTMP_id = @@opgTMP_id and opgi_orden = @orden

    -- Cheques
    --
    exec sp_DocOPMFChequeSave   @bSuccess out,
                                @opgi_tipo,
                                @cheq_id out,
                                @cheq_numerodoc,
                                @opgi_importe,
                                @opgi_importeOrigen,
                                @cheq_fechaCobro,
                                @cheq_fechaVto,
                                @opgi_descrip,
                                @chq_id,
                                @opg_id,
                                null,
                                null,
                                @cle_id,
                                @mon_id,
                                @prov_id,
                                null
    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError



    -- Si es un renglon nuevo o una OrdenPago nueva
    --
    if @IsNew <> 0 or @opgi_id = 0 begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
        exec SP_DBGetNewId 'OrdenPagoItem','opgi_id',@opgi_id out,0
        if @@error <> 0 goto ControlError

        insert into OrdenPagoItem (
                                      opg_id,
                                      opgi_id,
                                      opgi_orden,
                                      opgi_descrip,
                                      opgi_importe,
                                      opgi_importeorigen,
                                      ccos_id,
                                      opgi_otroTipo,
                                      opgi_porcRetencion,
                                      opgi_fechaRetencion,
                                      opgi_nroRetencion,
                                      opgi_tipo,
                                      cheq_id,
                                      chq_id,
                                      cue_id,
                                      ret_id,
                                      fc_id_ret
                                )
                            Values(
                                      @opg_id,
                                      @opgi_id,
                                      @opgi_orden,
                                      @opgi_descrip,
                                      @opgi_importe,
                                      @opgi_importeorigen,
                                      @ccos_id,
                                      @opgi_otroTipo,
                                      @opgi_porcRetencion,
                                      @opgi_fechaRetencion,
                                      @opgi_nroRetencion,
                                      @opgi_tipo,
                                      @cheq_id,
                                      @chq_id,
                                      @cue_id,
                                      @ret_id,
                                      @fc_id_ret
                                )

        if @@error <> 0 goto ControlError

        -- //////////////////////////////////////////////////////////////////////////////////
        --
        -- Talonario de Retenciones
        --
            declare @ta_id_ret int

            set @ta_id_ret = null

            select @ta_id_ret = ta_id from Retencion where ret_id = @ret_id

            if @ta_id_ret is not null begin

              exec sp_TalonarioSet @ta_id_ret, @opgi_nroRetencion
              if @@error <> 0 goto ControlError
            end    
        --
        -- Fin Talonario
        --
        -- //////////////////////////////////////////////////////////////////////////////////

    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

          update OrdenPagoItem set

                  opg_id                      = @opg_id,
                  opgi_orden                  = @opgi_orden,
                  opgi_descrip                = @opgi_descrip,
                  opgi_importe                = @opgi_importe,
                  opgi_importeorigen          = @opgi_importeorigen,
                  ccos_id                      = @ccos_id,
                  opgi_otroTipo                = @opgi_otroTipo,
                  opgi_porcRetencion          = @opgi_porcRetencion,
                  opgi_fechaRetencion          = @opgi_fechaRetencion,
                  opgi_nroRetencion            = @opgi_nroRetencion,
                  opgi_tipo                    = @opgi_tipo,
                  chq_id                      = @chq_id,
                  cheq_id                      = @cheq_id,
                  cue_id                      = @cue_id,
                  ret_id                      = @ret_id,
                  fc_id_ret                   = @fc_id_ret

        where opg_id = @opg_id and opgi_id = @opgi_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

  -- Cuenta en OrdenPagoItem para cheques propios
  --
  update OrdenPagoItem
       set cue_id = chq.cue_id
  from Cheque cheq inner join Chequera chq on cheq.chq_id = chq.chq_id
  where opgi_tipo = 1
    and OrdenPagoItem.cheq_id = cheq.cheq_id
    and OrdenPagoItem.opg_id = @opg_id

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        DEUDA                                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @fcopg_id               int
declare @fcopg_importe          decimal(18,6)
declare @fcd_pendiente          decimal(18,6)
declare @fcp_id                  int
declare @pago                   decimal(18,6)
declare @pagoOrigen             decimal(18,6)
declare @fcopg_importeOrigen    decimal(18,6)
declare @fcopg_cotizacion       decimal(18,6)
declare @fcd_fecha              datetime

  -- Creo un cursor sobre los registros de aplicacion entre la OrdenPago 
  -- y las facturas y notas de debito
  declare c_deuda insensitive cursor for

        select 
                fcopg_id, 
                 fc_id, 
                fcd_id, 
                fcopg_importe, 
                 fcopg_importeOrigen, 
                fcopg_cotizacion

         from FacturaCompraOrdenPagoTMP where opgTMP_id = @@opgTMP_id

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
        from FacturaCompraDeuda where fc_id = @fc_id
        order by fcd_fecha desc

      -- Si hay info de deuda (fcd_id <> 0) todo es mas facil
      end else begin
        select @fcd_pendiente = fcd_pendiente from FacturaCompraDeuda where fcd_id = @fcd_id
      end
  
      -- Si el pago no cancela el pendiente
      if @fcd_pendiente - @fcopg_importe >= 0.01 begin
        -- No hay pago
        set @fcp_id = null
        set @pago = @fcopg_importe
        set @pagoOrigen = @fcopg_importeOrigen

      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin

        if IsNull(@fcopg_cotizacion,0) <> 0 set @pagoOrigen = @fcd_pendiente / @fcopg_cotizacion
        else                                  set @pagoOrigen = 0

        -- Acumulo en el pago toda la deuda para pasar de la tabla FacturaCompraDeuda a FacturaCompraPago
        -- Ojo: Uso la variable pago para acumular toda la deuda, pero despues de insertar el pago
        --      le asigno a esta variable solo el monto de deuda pendiente que cancele con este pago
        --
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
        
        -- Como explique mas arriba:
        -- Esta variable se usa para vincular el pago con la OrdenPago
        -- asi que la actualizo a la deuda que esta OrdenPago cancela
        --
        set @pago = @fcd_pendiente
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
                                          @pago,
                                          @pagoOrigen,
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
        update FacturaCompraDeuda set fcd_pendiente = fcd_pendiente - @pago where fcd_id = @fcd_id
        if @@error <> 0 goto ControlError
      end
    
      -- Voy restando al pago el importe aplicado
      --
      set @fcopg_importe = @fcopg_importe - @pago

    end -- Fin del while de pago agrupado

    fetch next from c_deuda into @fcopg_id, @fc_id, @fcd_id, @fcopg_importe, @fcopg_importeOrigen, @fcopg_cotizacion
  end

  close c_deuda
  deallocate c_deuda

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ITEM'S BORRADOS                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados de la OrdenPago solo si esta no es nueva
  if @IsNew = 0 begin

    -- Antes que nada voy a tener que desvincular los cheques de los
    -- asientoitem vinculados a esta OP
    --
    declare @as_id int
    select @as_id = as_id from OrdenPago where opg_id = @opg_id
    if @as_id is not null begin
      Update AsientoItem set cheq_id = null where as_id = @as_id
      if @@error <> 0 goto ControlError
    end

    -- Hay tres situaciones a resolver con los cheques
    --
    -- 1- Borrar los cheques propios emitidos por esta orden
    --
    -- 2- Devolver a la cuenta mencionada en el ultimo 
    --    movimiento de fondos que menciono al cheque
    --
    -- 3- Devolver a documentos en cartera los cheques
    --    ingresados por una cobranza

    create table #cheques_a_borrar(cheq_id int not null, opgi_id int not null)

    insert into #cheques_a_borrar(cheq_id,opgi_id)
    select cheq_id,opgi_id
    from OrdenPagoItem
    where opgi_id in 
                ( select opgit.opgi_id 
                  from OrdenPagoItemBorradoTMP opgit 
                  where opgTMP_id = @@opgTMP_id
                  )
      and cheq_id is not null

    Update OrdenPagoItem set cheq_id = null 
    where opgi_id in 
                ( select opgit.opgi_id 
                  from OrdenPagoItemBorradoTMP opgit 
                  where opgTMP_id       = @@opgTMP_id
                  )

    if @@error <> 0 goto ControlError

    -- Borro los cheques propios entregados al proveedor
    delete Cheque 
    where Cheque.opg_id   = @opg_id 
      and chq_id is not null   -- solo los cheques propios tienen chequera (chq_id)
      and mf_id  is null      -- no entraron por movimiento de fondos
      and  exists (select opgit.opgi_id 
                  from OrdenPagoItemBorradoTMP opgit 
                          inner join OrdenPagoItem opgi   on opgit.opgi_id = opgi.opgi_id
                          inner join #cheques_a_borrar b  on opgit.opgi_id = b.opgi_id
                  where opgit.opg_id     = @opg_id 
                    and opgTMP_id       = @@opgTMP_id
                    and Cheque.cheq_id  = b.cheq_id
                  )

    if @@error <> 0 goto ControlError
  
    -- Devuelvo a documentos en cartera los cheques de tercero y los desvinculo de esta orden de pago
    update Cheque set cue_id = mfi.cue_id_debe, opg_id = null 
    from MovimientoFondoItem mfi
    where   Cheque.cheq_id = mfi.cheq_id
        and Cheque.mf_id   = mfi.mf_id
        and Cheque.opg_id  = @opg_id
        and  exists (select opgit.opgi_id 
                    from OrdenPagoItemBorradoTMP opgit 
                            inner join OrdenPagoItem opgi on opgit.opgi_id = opgi.opgi_id
                    where opgit.opg_id     = @opg_id 
                      and opgTMP_id       = @@opgTMP_id
                      and Cheque.cheq_id  = opgi.cheq_id
                    )

    if @@error <> 0 goto ControlError
  
    -- Devuelvo a documentos en cartera los cheques de tercero y los desvinculo de esta orden de pago
    update Cheque set cue_id = cobzi.cue_id, opg_id = null 
    from CobranzaItem cobzi
    where   cobzi.cheq_id   = Cheque.cheq_id 
        and Cheque.opg_id   = @opg_id
        and mf_id is null
        and  exists (select opgit.opgi_id 
                    from OrdenPagoItemBorradoTMP opgit 
                            inner join OrdenPagoItem opgi on opgit.opgi_id = opgi.opgi_id
                    where opgit.opg_id     = @opg_id 
                      and opgTMP_id       = @@opgTMP_id
                      and Cheque.cheq_id  = opgi.cheq_id
                    )

    if @@error <> 0 goto ControlError

    -- Finalmente borro los items
    --    
    delete OrdenPagoItem 
            where exists (select opgi_id 
                          from OrdenPagoItemBorradoTMP 
                          where opg_id     = @opg_id 
                            and opgTMP_id = @@opgTMP_id
                            and opgi_id   = OrdenPagoItem.opgi_id
                          )
    if @@error <> 0 goto ControlError

    -- Chau temporal
    delete OrdenPagoItemBorradoTMP where opg_id = @opg_id and opgTMP_id = @@opgTMP_id
    if @@error <> 0 goto ControlError

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        CHEQUES                                                                //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- Valido que no use un cheque dos veces en una misma op
  if exists(select cheq_id from OrdenPagoItem 
            where opg_id = @opg_id 
              and cheq_id is not null 
            group by cheq_id having count(*) > 1) begin

    set @MsgError = '@@ERROR_SP:Esta orden de pago menciona uno o varios cheques mas de una vez.;'
    goto ControlError

  end

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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PENDIENTE                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @opg_pendiente = sum(fcopg_importe) from FacturaCompraOrdenPago where opg_id = @opg_id

  update OrdenPago set opg_pendiente = opg_total - IsNull(@opg_pendiente,0) where opg_id = @opg_id
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN FACTURAS                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Finalmente actualizo el pendiente de las facturas
  --
  declare c_deudaFac insensitive cursor for select distinct fc_id from FacturaCompraOrdenPago where opg_id = @opg_id
  
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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TALONARIO                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@opg_nrodoc
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  exec sp_DocOrdenPagoSetCredito @opg_id
  if @@error <> 0 goto ControlError

  exec sp_DocOrdenPagoSetEstado @opg_id
  if @@error <> 0 goto ControlError

  exec sp_DocOrdenPagoChequeSetCredito @opg_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bError    smallint

  set @cfg_valor = null
  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'OrdenPago-Grabar Asiento',
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    exec sp_DocOrdenPagoAsientoSave @opg_id,0,@bError out, @MsgError out, 0, @@fc_id
    if @bError <> 0 goto ControlError

  end else begin

    if not exists (select opg_id from OrdenPagoAsiento where opg_id = @opg_id) begin
      insert into OrdenPagoAsiento (opg_id,opg_fecha) 
             select opg_id,opg_fecha from OrdenPago 
              where opg_grabarAsiento <> 0 and opg_id = @opg_id
    end
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocOPG    @opg_id,
                                        @bSuccess  out,
                                        @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocOPG    @opg_id,
                                        @bSuccess  out,
                                        @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
  exec sp_AuditoriaCreditoCheckDocOPG    @opg_id,
                                        @bSuccess  out,
                                        @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from OrdenPago where opg_id = @opg_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 18005, @opg_id, @modifico, 1
  else           exec sp_HistoriaUpdate 18005, @opg_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  set @@bSuccess = 1
  set @@opg_id = @opg_id
  if @@bSelect <> 0 select @opg_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la Orden de Pago. sp_DocOrdenPagoSave. ' + IsNull(@MsgError,'')

  if @@bDontRaiseError = 0 begin

    raiserror (@MsgError, 16, 1)

  end else begin

    set @@MsgError = @MsgError

  end

  rollback transaction  

end
go