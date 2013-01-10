if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaSave]

/*

    0) Graba la NC o la ND
    1) Graba el header de la cobranza
    2.1) Graba los cheques y tarjetas
    2.2) Graba los items de la cobranza
    3) Borra temporales

............................................................................
Nota: Las cobranzas solo se relacionan con Facturas y Notas de debito, 
      las notas de credito no se mencionan en los recibos.

      Las notas de debito se vinculan con las facturas o notas de debito
      por medio de la tabla FacturaVentaNotaCredito.
............................................................................

begin tran

exec sp_DocCobranzaSave 23339

rollback tran


*/

go
create procedure sp_DocCobranzaSave (
  @@cobzTMP_id int
)
as

begin

  set nocount on

  -- Antes que nada valido que este el centro de costo
  --

   declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'Exigir Centro Costo COBZ',
                        @cfg_valor out,
                        0
  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    if exists(select ccos_id  from CobranzaTMP where ccos_id is null and cobzTMP_id = @@cobzTMP_id)
    begin

      if exists(select ccos_id from CobranzaItemTMP where ccos_id is null and cobzTMP_id = @@cobzTMP_id and cobzi_tipo in (1,2,3,4))
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

    end
    
  end


-- /*
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- */
-- 
-- -- Diferencia de cambio por cuenta contable
-- -- si existe una cuenta en otros que dice 'Diferencia de cambio'
-- -- le resto a la cuenta corriente ese importe para que balancee
-- -- 
-- 
-- if exists(select * from CobranzaItemTMP where cobzi_descrip = 'Diferencia de cambio' and cobzTMP_id = @@cobzTMP_id)
-- begin
-- 
--   declare @dif_cambio_cuenta_contable decimal(18,6)
-- 
--   select @dif_cambio_cuenta_contable = cobzi_importe from CobranzaItemTMP where cobzi_descrip = 'Diferencia de cambio' and cobzTMP_id = @@cobzTMP_id
-- 
--   update CobranzaItemTMP set cobzi_importe = cobzi_importe - @dif_cambio_cuenta_contable
--   where cobzi_tipo = 5 and cobzTMP_id = @@cobzTMP_id
-- 
--   update CobranzaTMP set cobz_otros = cobz_otros - @dif_cambio_cuenta_contable
--   where cobzTMP_id = @@cobzTMP_id
-- 
--   update CobranzaTMP set cobz_total = cobz_total - @dif_cambio_cuenta_contable
--   where cobzTMP_id = @@cobzTMP_id
-- 
-- end

  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @MsgError  varchar(5000) set @MsgError = ''

  declare @cobz_id        int
  declare @cobzi_id        int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @cobz_fecha     datetime 
  declare  @cli_id         int
  declare  @doc_id         int
  declare  @doct_id        int
  declare  @cobz_nrodoc    varchar (50) 
  declare @emp_id         int
  declare @us_id          int
  declare @cobz_hojaruta  tinyint

  -- Si no existe chau
  if not exists (select cobzTMP_id from CobranzaTMP where cobzTMP_id = @@cobzTMP_id)
    return
  
  select 
          @cobz_id         = cobz_id, 
          @cobz_fecha     = cobz_fecha, 
          @cli_id         = cli_id,
          @doc_id         = Documento.doc_id,
          @doct_id         = doct_id,
          @cobz_nrodoc    = cobz_nrodoc,
          @emp_id         = emp_id,
          @us_id          = CobranzaTMP.modifico,
          @cobz_hojaruta  = cobz_hojaruta

  from CobranzaTMP inner join Documento on CobranzaTMP.doc_id = Documento.doc_id
  where cobzTMP_id = @@cobzTMP_id
  
  set @cobz_id = isnull(@cobz_id,0)

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                          CAJA A LA QUE PERTENCE ESTA OPERACION                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @cj_id     int
  declare @bError   smallint
  declare @errorMsg varchar(2000)

  exec sp_MovimientoCajaGetCjForUsId @us_id, 0, @cj_id out, @bError out, @errorMsg out, @cobz_hojaruta

  if @bError <> 0 begin
    raiserror (@errorMsg, 16, 1)
    return
  end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  

-- Campos de las tablas

declare  @cobz_numero  int 
declare  @cobz_descrip varchar (5000)
declare  @cobz_neto       decimal(18, 6) 
declare  @cobz_total      decimal(18, 6)
declare @cobz_otros      decimal(18, 6)
declare  @cobz_pendiente  decimal(18, 6)
declare @cobz_cotizacion decimal(18, 6)
declare @cobz_grabarAsiento smallint

declare  @est_id     int
declare  @suc_id     int
declare @ta_id      int
declare  @ccos_id    int
declare @lgj_id     int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 


declare  @cobzi_orden               smallint 
declare  @cobzi_descrip             varchar (5000) 
declare  @cobzi_descuento           varchar (100) 
declare  @cobzi_neto               decimal(18, 6) 
declare @cobzi_importe             decimal(18, 6)
declare @cobzi_importeorigen      decimal(18, 6)
declare @cobzi_otroTipo            tinyint
declare @cobzi_porcRetencion      decimal(18, 6)
declare @cobzi_fechaRetencion     datetime
declare @cobzi_nroRetencion       varchar(100)
declare @cobzi_tipo               tinyint
declare @cobzi_tarjetaTipo        tinyint
declare @cheq_id                  int
declare @cue_id                   int
declare @cue_id_cupon             int
declare @tjccu_id                 int
declare @tjcc_id                  int
declare @cle_id                   int
declare @bco_id                   int
declare @tjc_id                   int
declare @mon_id                   int
declare @ret_id                   int
declare @fv_id_ret                int
declare @cheq_numero              int
declare @cheq_propio              tinyint
declare @cheq_sucursal            varchar(255)
declare @cheq_numerodoc           varchar(100)
declare @cheq_fechaCobro          datetime
declare @cheq_fechaVto            datetime
declare @cheq_fecha2                datetime
declare @tjcc_numero              int
declare @tjcc_numerodoc           varchar(100)
declare @cobziTMP_fechaVto        datetime
declare @cobziTMP_nroTarjeta      varchar(50)
declare @cobziTMP_nroAutorizacion varchar(50)
declare @cobziTMP_titular         varchar(255)

declare @CobziTCheques             tinyint set @CobziTCheques   = 1
declare @CobziTEfectivo            tinyint set @CobziTEfectivo = 2
declare @CobziTTarjeta            tinyint set @CobziTTarjeta   = 3
declare @CobziTOtros              tinyint set @CobziTOtros     = 4
declare @CobziTCtaCte              tinyint set @CobziTCtaCte   = 5

declare @CheqTercero              tinyint set @CheqTercero    = 2
declare @fv_id                    int
declare @fvd_id                    int
declare  @doct_id_ncnd             int

  begin transaction

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        NC O ND Por Dif. de Cambio                                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @fvTMP_id                 int
declare @bSuccess                 int

  -- Obtengo el id de la temporal para la Nota de credito o Nota de debito por dif. de cambio
  --
  select @fvTMP_id = fvTMP_id from FacturaVentaTMP where cobzTMP_id = @@cobzTMP_id

  -- Si hay una ND o NC
  if IsNull(@fvTMP_id,0)<>0 begin

    -- Grabo la factura
    exec sp_DocFacturaVentaSave @fvTMP_id, 0, @fv_id out, @bSuccess out

    -- Si fallo al guardar
    if IsNull(@bSuccess,0) = 0 goto ControlError

    -- Obtengo el DocumentoTipo para saver si es una NC o ND
    select @doct_id_ncnd = doct_id from FacturaVenta where fv_id = @fv_id

    -- Si es una nota de credito es por que bajo la cotizacion de la moneda
    -- extranjera y por lo tanto tengo que aplicar la NC a las facturas cobradas
    -- que esten en moneda extranjera
    --
    if @doct_id_ncnd = 7 /*Nota de credito*/ begin

      -- Obtengo el id de la deuda (El max esta por las dudas)
      select @fvd_id = Max(fvd_id) from FacturaVentaDeuda where fv_id = @fv_id

      -- Actualizo el id fv_id_notacredito de la vinculacion
      update FacturaVentaNotaCreditoTMP 
                                      set fv_id_notacredito   = @fv_id,
                                          fvd_id_notacredito  = @fvd_id
      where fv_id_notacredito = (@fvTMP_id * -1)

      -- Este sp se encarga de todo
      exec sp_DocFacturaVentaNotaCreditoSave @fvTMP_id, @bSuccess out

      exec sp_DocFacturaVentaSetCredito @fv_id
      if @@error <> 0 goto ControlError
  
      exec sp_DocFacturaVentaSetEstado  @fv_id
      if @@error <> 0 goto ControlError

      -- Si fallo al guardar
      if IsNull(@bSuccess,0) = 0 goto ControlError

    end else begin

      -- Si es una nota de debito es por que el dolar subio y por ende
      -- cobre mas pesos. En este caso lo unico que hay que hacer es aplicar
      -- la ND con la cobranza y listo
      --
      if @doct_id_ncnd = 9 /*Nota de debito*/ begin

        -- Obtengo el Id de la deuda generada por el sp_DocFacturaVentaSave
        --
        select @fvd_id = max(fvd_id) from FacturaVentaDeuda where fv_id = @fv_id

        -- Actualizo la info de cobranza (fv_id y fvd_id) que fueron creados con la
        -- llamda al sp_DocFacturaVentaSave que esta arriba
        --
        update FacturaVentaCobranzaTMP set fv_id = @fv_id, fvd_id = @fvd_id 
          where 
                  cobzTMP_id = @@cobzTMP_id
            and   fv_id = @fvTMP_id *-1        -- !!! El registro en FacturaVentaCobranzaTMP que
                                               --     se refiere a la ND no tiene el fv_id por que
                                               --     cuando VB llamo a este sp no existia la ND
                                               --     (recuerden que fue creada con la llamada al
                                               --      sp_DocFacturaVentaSave que esta mas arriba)

            and   fvd_id = -1                   -- !!! Lo mismo paso con la deuda
      end
    end
  end
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Si es una nueva cobranza
  if @cobz_id = 0 begin

    -- Este flag es para cuando grabe los items
    set @IsNew = -1

    -- Obtengo id y numero para la cobranza
    --  
    exec SP_DBGetNewId 'Cobranza','cobz_id',@cobz_id out,0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'Cobranza','cobz_numero',@cobz_numero out,0
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

              set @cobz_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into Cobranza (
                              cobz_id,
                              cobz_numero,
                              cobz_nrodoc,
                              cobz_descrip,
                              cobz_fecha,
                              cobz_neto,
                              cobz_otros,
                              cobz_total,
                              cobz_cotizacion,
                              cobz_grabarAsiento,
                              cobz_hojaruta,
                              est_id,
                              suc_id,
                              cli_id,
                              emp_id,
                              doc_id,
                              doct_id,
                              ccos_id,
                              lgj_id,
                              modifico
                            )
      select
                              @cobz_id,
                              @cobz_numero,
                              @cobz_nrodoc,
                              cobz_descrip,
                              cobz_fecha,
                              cobz_neto,
                              cobz_otros,
                              cobz_total,
                              cobz_cotizacion,
                              cobz_grabarAsiento,
                              cobz_hojaruta,
                              est_id,
                              suc_id,
                              cli_id,
                              @emp_id,
                              doc_id,
                              @doct_id,
                              ccos_id,
                              lgj_id,
                              modifico
      from CobranzaTMP
      where cobzTMP_id = @@cobzTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @cobz_nrodoc = cobz_nrodoc from Cobranza where cobz_id = @cobz_id
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
                              @cobz_id                 = cobz_id,
                              @cobz_nrodoc            = cobz_nrodoc,
                              @cobz_descrip            = cobz_descrip,
                              @cobz_fecha              = cobz_fecha,
                              @cobz_neto              = cobz_neto,
                              @cobz_otros              = cobz_otros,
                              @cobz_total              = cobz_total,
                              @cobz_cotizacion        = cobz_cotizacion,
                              @cobz_grabarAsiento      = cobz_grabarAsiento,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @cli_id                  = cli_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                  = lgj_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from CobranzaTMP 
    where 
          cobzTMP_id = @@cobzTMP_id
  
    update Cobranza set 
                              cobz_nrodoc            = @cobz_nrodoc,
                              cobz_descrip          = @cobz_descrip,
                              cobz_fecha            = @cobz_fecha,
                              cobz_neto              = @cobz_neto,
                              cobz_otros            = @cobz_otros,
                              cobz_total            = @cobz_total,
                              cobz_cotizacion        = @cobz_cotizacion,
                              cobz_grabarAsiento    = @cobz_grabarAsiento,  
                              cobz_hojaruta          = @cobz_hojaruta,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              cli_id                = @cli_id,
                              emp_id                = @emp_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              ccos_id                = @ccos_id,
                              lgj_id                = @lgj_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where cobz_id = @cobz_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Recorro con un while que es mas rapido que un cursor. Uso cobzi_orden como puntero.
  --
  set @orden = 1
  while exists(select cobzi_orden from CobranzaItemTMP where cobzTMP_id = @@cobzTMP_id and cobzi_orden = @orden) 
  begin

    -- Cargo todo el registro de cobranzas en variables
    --
    select
            @cobzi_id                      = cobzi_id,
            @cobzi_orden                  = cobzi_orden,
            @cobzi_descrip                = cobzi_descrip,
            @cobzi_importe                = cobzi_importe,
            @cobzi_importeorigen          = cobzi_importeorigen,
            @ccos_id                      = ccos_id,
            @cobzi_otroTipo                = cobzi_otroTipo,
            @cobzi_porcRetencion          = cobzi_porcRetencion,
            @cobzi_fechaRetencion          = cobzi_fechaRetencion,
            @cobzi_nroRetencion            = cobzi_nroRetencion,
            @cobzi_tipo                    = cobzi_tipo,
            @cobzi_tarjetaTipo            = cobzi_tarjetaTipo,
            @cheq_id                      = cheq_id,
            @cue_id                        = cue_id,
            @tjcc_id                      = tjcc_id,
            @bco_id                       = bco_id,
            @cle_id                       = cle_id,
            @tjc_id                       = tjc_id,
            @cheq_propio                  = cobziTMP_propio,
            @cheq_numerodoc               = cobziTMP_cheque,
            @cheq_sucursal                = cobziTMP_sucursal,
            @cheq_fechaCobro              = cobziTMP_fechaCobro,
            @cheq_fechaVto                = cobziTMP_fechaVto,
            @tjcc_numerodoc               = cobziTMP_cupon,
            @cobziTMP_fechaVto            = cobziTMP_fechaVto,
            @cobziTMP_nroTarjeta          = cobziTMP_nroTarjeta,
            @cobziTMP_nroAutorizacion     = cobziTMP_autorizacion,
            @cobziTMP_titular             = cobziTMP_titular,
            @mon_id                       = mon_id,
            @tjccu_id                     = tjccu_id,
            @ret_id                       = ret_id,
            @fv_id_ret                    = fv_id_ret

    from CobranzaItemTMP where cobzTMP_id = @@cobzTMP_id and cobzi_orden = @orden

    -- Si este renglon es un cheque lo doy de alta en la tabla Cheque
    --
    if @cobzi_tipo = @CobziTCheques begin

      -- Si es nuevo Insert
      --
      if @cheq_id is null begin

        exec SP_DBGetNewId 'Cheque','cheq_id',@cheq_id out,0
        if @@error <> 0 goto ControlError

        exec SP_DBGetNewId 'Cheque','cheq_numero',@cheq_numero out,0
        if @@error <> 0 goto ControlError

        exec sp_DocGetFecha2 @cheq_fechaCobro,@cheq_fecha2 out, 1, @cle_id
        if @@error <> 0 goto ControlError

        insert into Cheque (
                              cheq_id,
                              cheq_numero,
                              cheq_numerodoc,
                              cheq_sucursal,
                              cheq_propio,
                              cheq_importe,
                              cheq_importeOrigen,
                              cheq_tipo,
                              cheq_fechaCobro,
                              cheq_fechaVto,
                              cheq_fecha2,
                              cheq_descrip,
                              cobz_id,
                              cle_id,
                              bco_id,
                              cli_id,
                              cue_id,
                              mon_id,
                              emp_id
                            )
                    values  (
                              @cheq_id,
                              @cheq_numero,
                              @cheq_numerodoc,
                              @cheq_sucursal,
                              @cheq_propio,
                              @cobzi_importe,
                              @cobzi_importeOrigen,
                              @CheqTercero,
                              @cheq_fechaCobro,
                              @cheq_fechaVto,
                              @cheq_fecha2,
                              @cobzi_descrip,
                              @cobz_id,
                              @cle_id,
                              @bco_id,
                              @cli_id,
                              @cue_id,
                              @mon_id,
                              @emp_id
                            )
      end else begin

        exec sp_DocGetFecha2 @cheq_fechaCobro,@cheq_fecha2 out, 1, @cle_id
        if @@error <> 0 goto ControlError

        -- Sino Update
        --
        update Cheque set 
                            cheq_numerodoc          = @cheq_numerodoc,
                            cheq_sucursal            = @cheq_sucursal,
                            cheq_propio             = @cheq_propio,
                            cheq_importe            = @cobzi_importe,
                            cheq_importeOrigen      = @cobzi_importeOrigen,
                            cheq_tipo                = @CheqTercero,
                            cheq_fechaCobro          = @cheq_fechaCobro,
                            cheq_fechaVto            = @cheq_fechaVto,
                            cheq_fecha2              = @cheq_fecha2,
                            cheq_descrip            = @cobzi_descrip,
                            cobz_id                  = @cobz_id,
                            cle_id                  = @cle_id,
                            bco_id                  = @bco_id,
                            cli_id                  = @cli_id,
                            mon_id                  = @mon_id

        where cheq_id = @cheq_id

        if not exists(select cheq_id 
                         from OrdenPagoItem opgi 
                                inner join OrdenPago opg 
                                   on opgi.opg_id = opg.opg_id 
                                  and opg.est_id <> 7 
                                  and opgi.cheq_id = @cheq_id
                        ) begin

          if not exists(select cheq_id 
                           from MovimientoFondoItem mfi
                                  inner join MovimientoFondo mf
                                     on mfi.mf_id = mf.mf_id 
                                    and mf.est_id <> 7 
                                    and mfi.cheq_id = @cheq_id
                          ) begin


            if not exists(select cheq_id 
                             from DepositoBancoItem dbcoi
                                    inner join DepositoBanco dbco
                                       on dbcoi.dbco_id = dbco.dbco_id 
                                      and dbco.est_id <> 7 
                                      and dbcoi.cheq_id = @cheq_id
                            ) begin
  
              update Cheque set cue_id = @cue_id
              where cheq_id = @cheq_id

            end
          end
        end
      end

    -- Sino es un cheque
    end else begin

      -- Si paga con tarjeta
      --
      if @cobzi_tipo = @CobziTTarjeta begin

        select   
                @cue_id_cupon   = case
                                    when @cobzi_tipo = 3 and @cobzi_tarjetaTipo = 1 then cue_id_presentado
                                    when @cobzi_tipo = 3 and @cobzi_tarjetaTipo = 2 then cue_id_encartera
                                  end
        from TarjetaCredito where tjc_id = @tjc_id

        set @cue_id = @cue_id_cupon

        -- Si es nuevo Insert
        --
        if @tjcc_id is null begin

          exec SP_DBGetNewId 'TarjetaCreditoCupon','tjcc_id',@tjcc_id out,0
          if @@error <> 0 goto ControlError

          exec SP_DBGetNewId 'TarjetaCreditoCupon','tjcc_numero',@tjcc_numero out,0
          if @@error <> 0 goto ControlError

          insert into TarjetaCreditoCupon (
                                            tjc_id,
                                            tjcc_id,
                                            tjcc_numero,
                                            tjcc_numerodoc,
                                            tjcc_descrip,
                                            tjcc_fechavto,
                                            tjcc_nroTarjeta,
                                            tjcc_nroAutorizacion,
                                            tjcc_titular,
                                            tjcc_importe,
                                            tjcc_importeOrigen,
                                            cobz_id,
                                            cli_id,
                                            cue_id,
                                            mon_id,
                                            tjccu_id
                                          )
                                values     (
                                            @tjc_id,
                                            @tjcc_id,
                                            @tjcc_numero,
                                            @tjcc_numerodoc,
                                            @cobzi_descrip,
                                            @cobziTMP_fechaVto,
                                            @cobziTMP_nroTarjeta,
                                            @cobziTMP_nroAutorizacion,
                                            @cobziTMP_titular,
                                            @cobzi_importe,
                                            @cobzi_importeOrigen,
                                            @cobz_id,
                                            @cli_id,
                                            @cue_id_cupon,
                                            @mon_id,
                                            @tjccu_id
                                          )

        end else begin

          -- Sino Update
          --
          update TarjetaCreditoCupon set
                                            tjc_id                = @tjc_id,
                                            tjcc_numerodoc        = @tjcc_numerodoc,
                                            tjcc_descrip          = @cobzi_descrip,
                                            tjcc_fechavto          = @cobziTMP_fechaVto,
                                            tjcc_nroTarjeta        = @cobziTMP_nroTarjeta,
                                            tjcc_nroAutorizacion  = @cobziTMP_nroAutorizacion,
                                            tjcc_titular          = @cobziTMP_titular,
                                            tjcc_importe          = @cobzi_importe,
                                            tjcc_importeOrigen    = @cobzi_importeOrigen,
                                            cobz_id                = @cobz_id,
                                            cli_id                = @cli_id,
                                            mon_id                = @mon_id,
                                            tjccu_id              = @tjccu_id

          where tjcc_id = @tjcc_id

          -- Solo le modifico la cuenta si no esta presentado o conciliado
          if not exists(select * from DepositoCuponItem where tjcc_id = @tjcc_id) begin
            --if not exists(select * from ConciliacionCuponItem where tjcc_id = @tjcc_id) begin    
              update TarjetaCreditoCupon set cue_id = @cue_id_cupon where tjcc_id = @tjcc_id
            --end
          end
        end
      end
    end -- Fin cheque y tarjeta

    -- Si es un renglon nuevo o una cobranza nueva
    --
    if @IsNew <> 0 or @cobzi_id = 0 begin

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
        exec SP_DBGetNewId 'CobranzaItem','cobzi_id',@cobzi_id out,0
        if @@error <> 0 goto ControlError

        insert into CobranzaItem (
                                      cobz_id,
                                      cobzi_id,
                                      cobzi_orden,
                                      cobzi_descrip,
                                      cobzi_importe,
                                      cobzi_importeorigen,
                                      ccos_id,
                                      cobzi_otroTipo,
                                      cobzi_porcRetencion,
                                      cobzi_fechaRetencion,
                                      cobzi_nroRetencion,
                                      cobzi_tipo,
                                      cobzi_tarjetaTipo,
                                      cheq_id,
                                      cue_id,
                                      tjcc_id,
                                      ret_id,
                                      fv_id_ret
                                )
                            Values(
                                      @cobz_id,
                                      @cobzi_id,
                                      @cobzi_orden,
                                      @cobzi_descrip,
                                      @cobzi_importe,
                                      @cobzi_importeorigen,
                                      @ccos_id,
                                      @cobzi_otroTipo,
                                      @cobzi_porcRetencion,
                                      @cobzi_fechaRetencion,
                                      @cobzi_nroRetencion,
                                      @cobzi_tipo,
                                      @cobzi_tarjetaTipo,
                                      @cheq_id,
                                      @cue_id,
                                      @tjcc_id,
                                      @ret_id,
                                      @fv_id_ret
                                )

        if @@error <> 0 goto ControlError
    end -- Insert

    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        UPDATE                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */
    else begin

        update CobranzaItem set

                  cobz_id                      = @cobz_id,
                  cobzi_orden                  = @cobzi_orden,
                  cobzi_descrip                = @cobzi_descrip,
                  cobzi_importe                = @cobzi_importe,
                  cobzi_importeorigen          = @cobzi_importeorigen,
                  ccos_id                      = @ccos_id,
                  cobzi_otroTipo              = @cobzi_otroTipo,
                  cobzi_porcRetencion          = @cobzi_porcRetencion,
                  cobzi_fechaRetencion        = @cobzi_fechaRetencion,
                  cobzi_nroRetencion          = @cobzi_nroRetencion,
                  cobzi_tipo                  = @cobzi_tipo,
                  cobzi_tarjetaTipo            = @cobzi_tarjetaTipo,
                  cheq_id                      = @cheq_id,
                  cue_id                      = @cue_id,
                  tjcc_id                      = @tjcc_id,
                  ret_id                      = @ret_id,
                  fv_id_ret                    = @fv_id_ret

        where cobz_id = @cobz_id and cobzi_id = @cobzi_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        DEUDA                                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @fvcobz_id               int
declare @fvcobz_importe          decimal(18,6)
declare @fvd_pendiente          decimal(18,6)
declare @fvp_id                  int
declare @pago                   decimal(18,6)
declare @pagoOrigen             decimal(18,6)
declare @fvcobz_importeOrigen    decimal(18,6)
declare @fvcobz_cotizacion       decimal(18,6)
declare @fvd_fecha              datetime


  -- Creo un cursor sobre los registros de aplicacion entre la cobranza 
  -- y las facturas y notas de debito
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
      if @fvd_pendiente - @fvcobz_importe > 0.01 begin
        -- No hay pago
        set @fvp_id = null
        set @pago = @fvcobz_importe
        set @pagoOrigen = @fvcobz_importeOrigen

      -- Si el pago cancela la deuda cargo un nuevo pago
      -- y luego voy a borrar la deuda
      end else begin

        if IsNull(@fvcobz_cotizacion,0) <> 0 set @pagoOrigen = @fvd_pendiente / @fvcobz_cotizacion
        else                                  set @pagoOrigen = 0

        -- Acumulo en el pago toda la deuda para pasar de la tabla FacturaVentaDeuda a FacturaVentaPago
        -- Ojo: Uso la variable pago para acumular toda la deuda, pero despues de insertar el pago
        --      le asigno a esta variable solo el monto de deuda pendiente que cancele con este pago
        --
        set @pago = 0
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
        
        -- Como explique mas arriba:
        -- Esta variable se usa para vincular el pago con la cobranza
        -- asi que la actualizo a la deuda que esta cobranza cancela
        --
        set @pago = @fvd_pendiente
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
                                          @pago,
                                          @pagoOrigen,
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
        update FacturaVentaDeuda set fvd_pendiente = fvd_pendiente - @pago where fvd_id = @fvd_id
        if @@error <> 0 goto ControlError
      end
    
      -- Voy restando al pago el importe aplicado
      --
      set @fvcobz_importe = @fvcobz_importe - @pago

    end -- Fin del while de pago agrupado

    fetch next from c_deuda into @fvcobz_id, @fv_id, @fvd_id, @fvcobz_importe, @fvcobz_importeOrigen, @fvcobz_cotizacion
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

  -- Hay que borrar los items borrados de la cobranza solo si esta no es nueva
  if @IsNew = 0 begin

    -- Antes que nada voy a tener que desvincular los cheques de los
    -- asientoitem vinculados a esta Cobranza
    --
    declare @as_id int
    select @as_id = as_id from Cobranza where cobz_id = @cobz_id
    if @as_id is not null begin
      Update AsientoItem set cheq_id = null where as_id = @as_id
      if @@error <> 0 goto ControlError
    end

    create table #cobzi_cheque (cheq_id int not null)

    insert #cobzi_cheque (cheq_id)
                                  select cheq_id 
                                  from CobranzaItem 
                                  where exists (select cobzi_id 
                                                from CobranzaItemBorradoTMP 
                                                where cobz_id     = @cobz_id
                                                  and cobzTMP_id   = @@cobzTMP_id
                                                  and cobzi_id     = CobranzaItem.cobzi_id
                                                )
                                    and cobz_id = @cobz_id 
                                    and cheq_id is not null
  
    create table #cobzi_cupon (tjcc_id int not null)

    insert #cobzi_cupon (tjcc_id)
                                select tjcc_id 
                                from CobranzaItem 
                                where exists (select cobzi_id 
                                              from CobranzaItemBorradoTMP 
                                              where cobz_id     = @cobz_id
                                                and cobzTMP_id   = @@cobzTMP_id 
                                                and cobzi_id     = CobranzaItem.cobzi_id
                                              )
                                  and cobz_id = @cobz_id 
                                  and tjcc_id is not null
    
    delete CobranzaItem 
            where exists (select cobzi_id 
                          from CobranzaItemBorradoTMP 
                          where cobz_id     = @cobz_id 
                            and cobzTMP_id   = @@cobzTMP_id
                            and cobzi_id     = CobranzaItem.cobzi_id
                          )
    if @@error <> 0 goto ControlError

    -- Borro los cheques de clientes que entraron por esta cobranza
    delete Cheque where exists (select cheq_id from #cobzi_cheque 
                                where cheq_id = Cheque.cheq_id
                                )
    if @@error <> 0 goto ControlError

    -- Borro los cupones de tarjeta que entraron por esta cobranza
    delete TarjetaCreditoCupon where exists (select tjcc_id from #cobzi_cupon
                                             where tjcc_id = TarjetaCreditoCupon.tjcc_id
                                             )
    if @@error <> 0 goto ControlError

    -- Chau temporal
    delete CobranzaItemBorradoTMP where cobz_id = @cobz_id and cobzTMP_id = @@cobzTMP_id
    if @@error <> 0 goto ControlError

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 PARTICULARIDADES DE LOS CLIENTES                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocCobranzaSaveCliente  @cobz_id, @@cobzTMP_ID,
                                  @bSuccess  out,
                                  @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PENDIENTE                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @cobz_pendiente = sum(fvcobz_importe) from FacturaVentaCobranza where cobz_id = @cobz_id

  update Cobranza set cobz_pendiente = cobz_total - IsNull(@cobz_pendiente,0) where cobz_id = @cobz_id
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                               UPDATE PENDIENTE EN FACTURAS                                                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Finalmente actualizo el pendiente de las facturas
  --
  declare c_deudaFac insensitive cursor for 
  select distinct fv_id from FacturaVentaCobranza where cobz_id = @cobz_id
  
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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TALONARIO                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@cobz_nrodoc
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocCobranzaSetCredito @cobz_id
  if @@error <> 0 goto ControlError

  exec sp_DocCobranzaSetEstado @cobz_id
  if @@error <> 0 goto ControlError

  exec sp_DocCobranzaChequeSetCredito @cobz_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  set @cfg_valor = null
  exec sp_Cfg_GetValor  'Tesoreria-General',
                        'Cobranza-Grabar Asiento',
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    exec sp_DocCobranzaAsientoSave @cobz_id,0,@bError out, @MsgError out
    if @bError <> 0 goto ControlError

  end else begin

    if not exists (select cobz_id from CobranzaAsiento where cobz_id = @cobz_id) begin
      insert into CobranzaAsiento (cobz_id,cobz_fecha) 
             select cobz_id,cobz_fecha from Cobranza
              where cobz_grabarAsiento <> 0 and cobz_id = @cobz_id

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
  exec sp_AuditoriaEstadoCheckDocCOBZ    @cobz_id,
                                        @bSuccess  out,
                                        @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocCOBZ  @cobz_id,
                                        @bSuccess  out,
                                        @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
  exec sp_AuditoriaCreditoCheckDocCOBZ  @cobz_id,
                                        @bSuccess  out,
                                        @MsgError out

-- USO de Cuentas por Usuarios que son Cajeros
--
  -- Si el usuario es un cajero debe utilizar cuentas que estan en la caja
  --
  if exists(select cj_id from CajaCajero where us_id = @us_id) 
  begin

    if exists(  select 1 
                from CobranzaItem 
                where cobz_id = @cobz_id 
                  and cobzi_tipo in (1,2,3) 
                  and cue_id not in (  select cue_id_trabajo 
                                      from CajaCuenta 
                                      where cj_id in ( select cj_id from CajaCajero where us_id = @us_id )
                                    )
              )
    begin

        set @bSuccess = 1
        set @MsgError = 'Su usuario esta configurado como cajero y por lo tanto solo puede generar cobranzas utilizando las cuentas asociadas a su caja.'
  
    end    
  
  end

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                          CAJA A LA QUE PERTENCE ESTA OPERACION                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @IsNew <> 0 begin
  
    declare @mcj_id int
  
    exec sp_MovimientoCajaGetFromCaja @cj_id,1/*Apertura*/,@mcj_id out
  
    update Cobranza set mcj_id = @mcj_id where cobz_id = @cobz_id
  
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from Cobranza where cobz_id = @cobz_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 18004, @cobz_id, @modifico, 1
  else           exec sp_HistoriaUpdate 18004, @cobz_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  commit transaction

  select @cobz_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la cobranza. sp_DocCobranzaSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end
end
go