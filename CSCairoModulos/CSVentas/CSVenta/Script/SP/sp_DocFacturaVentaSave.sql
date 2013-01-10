if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSave]

/*

 sp_DocFacturaVentaSave 124

*/

go
create procedure sp_DocFacturaVentaSave (
  @@fvTMP_id       int,
  @@bSelect        tinyint = 1,
  @@fv_id          int     = 0 out,
  @@bSuccess      tinyint = 0 out
)
as

begin

  set nocount on

declare @bSuccess tinyint
declare @MsgError  varchar(5000) set @MsgError = ''

  set @@bSuccess = 0

  exec sp_DocFacturaVentaSavePreCliente @@fvTMP_ID, 
                                        @bSuccess  out,
                                        @MsgError out

  if IsNull(@bSuccess,0) = 0 goto ControlError

  -- Antes que nada valido que este el centro de costo
  --
  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Ventas-General',
                        'Exigir Centro Costo',
                        @cfg_valor out,
                        0
  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    if exists(select ccos_id  from FacturaVentaTMP where ccos_id is null and fvTMP_id = @@fvTMP_id)
    begin

      if exists(select ccos_id from FacturaVentaItemTMP where ccos_id is null and fvTMP_id = @@fvTMP_id)
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

      if exists(select ccos_id from FacturaVentaPercepcionTMP where ccos_id is null and fvTMP_id = @@fvTMP_id)
      begin
      
        raiserror ('@@ERROR_SP:Debe indicar un centro de costo en cada item de percepciones o un centro de costo en la cabecera del documento.', 
                    16, 1)
        return
      end

    end
    
  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                          CAJA A LA QUE PERTENCE ESTA OPERACION                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @cj_id     int
  declare @us_id    int
  declare @bError   smallint
  declare @errorMsg varchar(2000)

  select @cj_id = cj_id, @us_id = modifico from FacturaVentaTMP where fvTMP_id = @@fvTMP_id

  if @cj_id is null begin
    exec sp_MovimientoCajaGetCjForUsId @us_id, 0, @cj_id out, @bError out, @errorMsg out

    if @bError <> 0 begin
      raiserror (@errorMsg, 16, 1)
      return
    end
  end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  declare @fv_id          int
  declare @fvi_id          int
  declare @IsNew          smallint
  declare @orden          smallint
  declare  @doct_id        int
  declare  @cpg_id         int
  declare  @fv_total       decimal(18, 6)
  declare  @fv_fecha       datetime 
  declare @fv_fechaIva    datetime
  declare  @fv_fechaVto     datetime 
  declare @depl_id        int
  declare @emp_id         int
  declare @doc_mueveStock   tinyint
  declare @doc_generaremito  tinyint

-- TO
  declare  @fv_descuento1    decimal(18, 6)
  declare  @fv_descuento2    decimal(18, 6)

  declare  @fv_totalpercepciones     decimal(18, 6)

  -- Si no existe chau
  if not exists (select fvTMP_id from FacturaVentaTMP where fvTMP_id = @@fvTMP_id)
    return
  
  select @fv_id = fv_id from FacturaVentaTMP where fvTMP_id = @@fvTMP_id
  
  set @fv_id = isnull(@fv_id,0)
  

  -- La moneda y el talonario siempre salen del documento 
  declare @mon_id         int
  declare @ta_id          int

-- Talonario
  declare  @fv_nrodoc          varchar (50) 
  declare  @doc_id             int
  declare  @cli_id             int

-- Remito
  declare  @rv_nrodoc          varchar(50)

-- Estado
  declare  @est_id             int

  select @mon_id           = mon_id,
         @ta_id           = case cli_catfiscal
                              when 1  then ta_id_inscripto   --'Inscripto'
                              when 2  then ta_id_final       --'Exento'
                              when 3  then ta_id_inscripto   --'No inscripto'
                              when 4  then ta_id_final       --'Consumidor Final'
                              when 5  then ta_id_externo     --'Extranjero'
                              when 6  then ta_id_final       --'Mono Tributo'
                              when 7  then ta_id_externo     --'Extranjero Iva'
                              when 8  then ta_id_final       --'No responsable'
                              when 9  then ta_id_final       --'No Responsable exento'
                              when 10 then ta_id_final       --'No categorizado'
                              when 11 then ta_id_inscripto   --'Inscripto M'
                              else         -1                --'Sin categorizar'
                           end,
         @doct_id         = Documento.doct_id,
         @cpg_id          = FacturaVentaTMP.cpg_id,
         @fv_total        = FacturaVentaTMP.fv_total,
         @fv_fecha        = FacturaVentaTMP.fv_fecha,
         @fv_fechaIva      = FacturaVentaTMP.fv_fechaIva,
         @fv_fechaVto     = FacturaVentaTMP.fv_fechaVto,
         @depl_id         = FacturaVentaTMP.depl_id,

         @doc_mueveStock    = Documento.doc_muevestock,
         @doc_generaremito  = Documento.doc_generaremito,
         @rv_nrodoc         = FacturaVentaTMP.rv_nrodoc,
-- TO
         @fv_descuento1         = FacturaVentaTMP.fv_descuento1,
         @fv_descuento2         = FacturaVentaTMP.fv_descuento2,
         @fv_totalpercepciones  = FacturaVentaTMP.fv_totalpercepciones,

         @est_id          = FacturaVentaTMP.est_id,

         @emp_id          = Documento.emp_id,

-- Talonario
         @fv_nrodoc = fv_nrodoc,
         @doc_id    = FacturaVentaTMP.doc_id,
         @cli_id    = FacturaVentaTMP.cli_id


  from FacturaVentaTMP inner join Documento on FacturaVentaTMP.doc_id = Documento.doc_id
                       inner join Cliente   on FacturaVentaTMP.cli_id = Cliente.cli_id
  where fvTMP_id = @@fvTMP_id

  if @ta_id = -1 begin
    select col1 = 'ERROR', col2 = 'El cliente no esta categorizado. Debe indicar en que categoria fiscal se encuentra el cliente.'
    return
  end

  if @fv_fechaIva < '19900101'
    set @fv_fechaIva = @fv_fecha
  else
    set @fv_fechaIva = dbo.DateOnly(@fv_fechaIva)

-- Campos de las tablas

declare  @fv_numero          int 
declare  @fv_descrip         varchar (5000)
declare  @fv_fechaentrega     datetime 
declare  @fv_neto            decimal(18, 6) 
declare  @fv_ivari           decimal(18, 6)
declare  @fv_ivarni          decimal(18, 6)
declare @fv_internos        decimal(18, 6)
declare  @fv_subtotal        decimal(18, 6)
declare  @fv_totalorigen     decimal(18, 6)
declare @fv_cotizacion      decimal(18, 6)

declare  @fv_importedesc1    decimal(18, 6)
declare  @fv_importedesc2    decimal(18, 6)
declare @fv_grabarasiento   tinyint
declare @fv_cai             varchar(100)
declare @fv_ordencompra   varchar (255)

declare  @suc_id             int
declare  @lp_id              int 
declare  @ld_id              int 
declare  @ccos_id            int
declare @stl_id             int
declare @lgj_id             int
declare @ven_id             int
declare @pro_id_origen      int
declare @pro_id_destino     int
declare @trans_id           int
declare @clis_id            int
declare  @creado             datetime 
declare  @modificado         datetime 
declare  @modifico           int 

declare @fviTMP_id              int
declare  @fvi_orden               smallint 
declare  @fvi_cantidad           decimal(18, 6) 
declare  @fvi_cantidadaremitir   decimal(18, 6) 
declare  @fvi_pendiente           decimal(18, 6) 
declare @fvi_pendientepklst     decimal(18, 6)
declare  @fvi_descrip             varchar (5000) 
declare  @fvi_precio             decimal(18, 6) 
declare  @fvi_precioUsr           decimal(18, 6)
declare  @fvi_precioLista         decimal(18, 6)
declare  @fvi_descuento           varchar (100) 
declare  @fvi_neto               decimal(18, 6) 
declare  @fvi_ivari               decimal(18, 6)
declare  @fvi_ivarni             decimal(18, 6)
declare  @fvi_ivariporc           decimal(18, 6)
declare  @fvi_ivarniporc         decimal(18, 6)
declare @fvi_internos           decimal(18, 6)
declare @fvi_internosporc       decimal(18, 6)
declare @fvi_importe             decimal(18, 6)
declare @fvi_importeorigen      decimal(18, 6)
declare @fvi_nostock            tinyint
declare  @pr_id                   int
declare @to_id                  int  -- TO
declare @cue_id                 int
declare @cue_id_ivari           int
declare @cue_id_ivarni          int

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @fv_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'FacturaVenta','fv_id',@fv_id out,0
    if @@error <> 0 goto ControlError

    exec SP_DBGetNewId 'FacturaVenta','fv_numero',@fv_numero out,0
    if @@error <> 0 goto ControlError

    -- //////////////////////////////////////////////////////////////////////////////////
    --
    -- Talonario
    --
          declare @ta_propuesto tinyint
          declare @ta_tipo      smallint

          exec sp_talonarioGetPropuesto @doc_id, 0, @ta_propuesto out, @cli_id, 0, @ta_id out, @ta_tipo out

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

              set @fv_nrodoc = @ta_nrodoc

            end
      
          end
    --
    -- Fin Talonario
    --
    -- //////////////////////////////////////////////////////////////////////////////////

    insert into FacturaVenta (
                              fv_id,
                              fv_numero,
                              fv_nrodoc,
                              fv_descrip,
                              fv_fecha,
                              fv_fechaentrega,
                              fv_fechaVto,
                              fv_fechaIva,
                              fv_neto,
                              fv_ivari,
                              fv_ivarni,
                              fv_internos,
                              fv_total,
                              fv_totalorigen,
                              fv_subtotal,
                              fv_totalpercepciones,
                              fv_descuento1,
                              fv_descuento2,
                              fv_importedesc1,
                              fv_importedesc2,
                              fv_grabarasiento,
                              fv_cotizacion,
                              fv_cai,
                              fv_ordencompra,
                              mon_id,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              ven_id,
                              pro_id_origen,
                              pro_id_destino,
                              trans_id,
                              emp_id,
                              clis_id,
                              modifico
                            )
      select
                              @fv_id,
                              @fv_numero,
                              @fv_nrodoc,
                              fv_descrip,
                              fv_fecha,
                              fv_fechaentrega,
                              fv_fechaVto,
                              @fv_fechaIva,
                              fv_neto,
                              fv_ivari,
                              fv_ivarni,
                              fv_internos,
                              fv_total,
                              fv_totalorigen,
                              fv_subtotal,
                              fv_totalpercepciones,
                              fv_descuento1,
                              fv_descuento2,
                              fv_importedesc1,
                              fv_importedesc2,
                              fv_grabarasiento,
                              fv_cotizacion,
                              fv_cai,
                              fv_ordencompra,
                              @mon_id,
                              est_id,
                              suc_id,
                              cli_id,
                              doc_id,
                              @doct_id,
                              lp_id,
                              ld_id,
                              cpg_id,
                              ccos_id,
                              lgj_id,
                              ven_id,
                              pro_id_origen,
                              pro_id_destino,
                              trans_id,
                              @emp_id,
                              clis_id,
                              modifico
      from FacturaVentaTMP
      where fvTMP_id = @@fvTMP_id  

      if @@error <> 0 goto ControlError
    
      select @doc_id = doc_id, @fv_nrodoc = fv_nrodoc from FacturaVenta where fv_id = @fv_id
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
                              @fv_id                   = fv_id,
                              @fv_nrodoc              = fv_nrodoc,
                              @fv_descrip              = fv_descrip,
                              @fv_fechaentrega        = fv_fechaentrega,
                              @fv_neto                = fv_neto,
                              @fv_ivari                = fv_ivari,
                              @fv_ivarni              = fv_ivarni,
                              @fv_internos            = fv_internos,
                              @fv_totalorigen          = fv_totalorigen,
                              @fv_cotizacion          = fv_cotizacion,
                              @fv_subtotal            = fv_subtotal,
                              @fv_importedesc1        = fv_importedesc1,
                              @fv_importedesc2        = fv_importedesc2,
                              @fv_grabarasiento       = fv_grabarasiento,
                              @fv_cai                  = fv_cai,
                              @fv_ordencompra          = fv_ordencompra,
                              @est_id                  = est_id,
                              @suc_id                  = suc_id,
                              @cli_id                  = cli_id,
                              @doc_id                  = doc_id,
                              @lp_id                  = lp_id,
                              @ld_id                  = ld_id,
                              @ccos_id                = ccos_id,
                              @lgj_id                 = lgj_id,
                              @ven_id                 = ven_id,
                              @pro_id_origen          = pro_id_origen,
                              @pro_id_destino          = pro_id_destino,
                              @trans_id                = trans_id,
                              @clis_id                = clis_id,
                              @modifico                = modifico,
                              @modificado             = modificado
    from FacturaVentaTMP 
    where 
          fvTMP_id = @@fvTMP_id

    --//////////////////////////////////////////////////////////////////////////////////////
    -- CAE
    if exists(select 1 from FacturaVenta where fv_id = @fv_id and fv_cae <> '')
    begin
      select @fv_nrodoc = substring(fv_nrodoc,1,2)+'0004-'+right('00000000'+fv_cae_nrodoc,8)
      from FacturaVenta
      where fv_id = @fv_id
    end

    -- CAE
    --//////////////////////////////////////////////////////////////////////////////////////
  
    update FacturaVenta set 
                              fv_nrodoc              = @fv_nrodoc,
                              fv_descrip            = @fv_descrip,
                              fv_fecha              = @fv_fecha,
                              fv_fechaentrega        = @fv_fechaentrega,
                              fv_fechaVto           = @fv_fechaVto,
                              fv_fechaIva            = @fv_fechaIva,
                              fv_neto                = @fv_neto,
                              fv_ivari              = @fv_ivari,
                              fv_ivarni              = @fv_ivarni,
                              fv_total              = @fv_total,
                              fv_totalorigen        = @fv_totalorigen,
                              fv_totalpercepciones  = @fv_totalpercepciones,
                              fv_cotizacion         = @fv_cotizacion,
                              fv_descuento1         = @fv_descuento1,
                              fv_descuento2         = @fv_descuento2,
                              fv_subtotal            = @fv_subtotal,
                              fv_internos            = @fv_internos,
                              fv_importedesc1       = @fv_importedesc1,
                              fv_importedesc2       = @fv_importedesc2,
                              fv_grabarasiento      = @fv_grabarasiento,
                              fv_cai                = @fv_cai,
                              fv_ordencompra        = @fv_ordencompra,
                              mon_id                = @mon_id,
                              est_id                = @est_id,
                              suc_id                = @suc_id,
                              cli_id                = @cli_id,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              lp_id                  = @lp_id,
                              ld_id                  = @ld_id,
                              cpg_id                = @cpg_id,
                              lgj_id                = @lgj_id,
                              ven_id                = @ven_id,
                              pro_id_origen          = @pro_id_origen,
                              pro_id_destino        = @pro_id_destino,
                              ccos_id                = @ccos_id,
                              trans_id              = @trans_id,
                              clis_id                = @clis_id,
                              emp_id                = @emp_id,
                              modifico              = @modifico,
                              modificado            = @modificado

                              -- Firma (cuando se modifica se elimina la firma)
                              --
                              ,fv_firmado = 0
  
    where fv_id = @fv_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  set @orden = 1
  while exists(select fvi_orden from FacturaVentaItemTMP where fvTMP_id = @@fvTMP_id and fvi_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @fviTMP_id                  = fviTMP_id,
            @fvi_id                      = fvi_id,
            @fvi_orden                  = fvi_orden,
            @fvi_cantidad                = fvi_cantidad,
            @fvi_cantidadaremitir        = fvi_cantidadaremitir,
            @fvi_pendiente              = fvi_pendiente,
            @fvi_pendientepklst          = fvi_pendientepklst,
            @fvi_descrip                = fvi_descrip,
            @fvi_precio                  = fvi_precio,
            @fvi_precioUsr              = fvi_precioUsr,
            @fvi_precioLista            = fvi_precioLista,
            @fvi_descuento              = fvi_descuento,
            @fvi_neto                    = fvi_neto,
            @fvi_ivari                  = fvi_ivari,
            @fvi_ivarni                  = fvi_ivarni,
            @fvi_ivariporc              = fvi_ivariporc,
            @fvi_ivarniporc              = fvi_ivarniporc,
            @fvi_internos               = fvi_internos,
            @fvi_internosporc           = fvi_internosporc,
            @fvi_importe                = fvi_importe,
            @fvi_importeorigen          = fvi_importeorigen,
            @pr_id                      = pr_id,
            @to_id                      = to_id, -- TO
            @ccos_id                    = ccos_id,
            @stl_id                     = stl_id,
            @fvi_nostock                = fvi_nostock,

            @cue_id                     = cue_id,
            @cue_id_ivari               = cue_id_ivari,
            @cue_id_ivarni              = cue_id_ivarni

    from FacturaVentaItemTMP where fvTMP_id = @@fvTMP_id and fvi_orden = @orden

    -- Cuando se inserta se indica 
    -- como cantidad a remitir la cantidad (Por ahora)
    set @fvi_cantidadaremitir = @fvi_cantidad

    if @IsNew <> 0 or @fvi_id = 0 begin

        -- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
        set @fvi_pendiente           = @fvi_cantidadaremitir
        set @fvi_pendientepklst     = @fvi_cantidadaremitir

        exec SP_DBGetNewId 'FacturaVentaItem','fvi_id',@fvi_id out,0
        if @@error <> 0 goto ControlError
    
        insert into FacturaVentaItem (
                                      fv_id,
                                      fvi_id,
                                      fvi_orden,
                                      fvi_cantidad,
                                      fvi_cantidadaremitir,
                                      fvi_descrip,
                                      fvi_pendiente,
                                      fvi_pendientepklst,
                                      fvi_precio,
                                      fvi_precioUsr,
                                      fvi_precioLista,
                                      fvi_descuento,
                                      fvi_neto,
                                      fvi_ivari,
                                      fvi_ivarni,
                                      fvi_ivariporc,
                                      fvi_ivarniporc,
                                      fvi_internos,
                                      fvi_internosporc,
                                      fvi_importe,
                                      fvi_importeorigen,
                                      fvi_nostock,
                                      pr_id,
                                      to_id, -- TO
                                      ccos_id,
                                      stl_id,
                                      cue_id,
                                      cue_id_ivari,
                                      cue_id_ivarni
                                )
                            Values(
                                      @fv_id,
                                      @fvi_id,
                                      @fvi_orden,
                                      @fvi_cantidad,
                                      @fvi_cantidadaremitir,
                                      @fvi_descrip,
                                      @fvi_pendiente,
                                      @fvi_pendientepklst,
                                      @fvi_precio,
                                      @fvi_precioUsr,
                                      @fvi_precioLista,
                                      @fvi_descuento,
                                      @fvi_neto,
                                      @fvi_ivari,
                                      @fvi_ivarni,
                                      @fvi_ivariporc,
                                      @fvi_ivarniporc,
                                      @fvi_internos,
                                      @fvi_internosporc,
                                      @fvi_importe,
                                      @fvi_importeorigen,
                                      @fvi_nostock,
                                      @pr_id,
                                      @to_id, -- TO
                                      @ccos_id,
                                      @stl_id,
                                      @cue_id,
                                      @cue_id_ivari,
                                      @cue_id_ivarni
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

          -- Cuando se actualiza se indica 
          -- como pendiente la cantidad a remitir menos lo aplicado
          select @fvi_pendiente = sum(pvfv_cantidad) from PedidoFacturaVenta where fvi_id = @fvi_id
          set @fvi_pendiente = @fvi_cantidadaremitir - isnull(@fvi_pendiente,0)

          select @fvi_pendientepklst = sum(pklstfv_cantidad) from PackingListFacturaVenta where fvi_id = @fvi_id
          set @fvi_pendientepklst = @fvi_cantidadaremitir - isnull(@fvi_pendientepklst,0)

          update FacturaVentaItem set

                  fv_id                      = @fv_id,
                  fvi_orden                  = @fvi_orden,
                  fvi_cantidad              = @fvi_cantidad,
                  fvi_cantidadaremitir      = @fvi_cantidadaremitir,
                  fvi_pendiente              = @fvi_pendiente,
                  fvi_pendientepklst        = @fvi_pendientepklst,
                  fvi_descrip                = @fvi_descrip,
                  fvi_precio                = @fvi_precio,
                  fvi_precioUsr              = @fvi_precioUsr,
                  fvi_precioLista            = @fvi_precioLista,
                  fvi_descuento              = @fvi_descuento,
                  fvi_neto                  = @fvi_neto,
                  fvi_ivari                  = @fvi_ivari,
                  fvi_ivarni                = @fvi_ivarni,
                  fvi_ivariporc              = @fvi_ivariporc,
                  fvi_ivarniporc            = @fvi_ivarniporc,
                  fvi_internos              = @fvi_internos,
                  fvi_internosporc          = @fvi_internosporc,
                  fvi_importe                = @fvi_importe,
                  fvi_importeorigen          = @fvi_importeorigen,
                  fvi_nostock                = @fvi_nostock,
                  pr_id                      = @pr_id,
                  to_id                      = @to_id, -- TO
                  ccos_id                    = @ccos_id,
                  stl_id                    = @stl_id,
                  cue_id                    = @cue_id,
                  cue_id_ivari              = @cue_id_ivari,
                  cue_id_ivarni             = @cue_id_ivarni

        where fv_id = @fv_id and fvi_id = @fvi_id 
        if @@error <> 0 goto ControlError
    end -- Update

    update FacturaVentaItemSerieTMP set fvi_id = @fvi_id where fviTMP_id = @fviTMP_id
    if @@error <> 0 goto ControlError

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        PERCEPCIONES                                                                //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @fvperc_id           int
  declare @fvperc_orden        smallint
  declare @fvperc_base         decimal(18,6)
   declare @fvperc_porcentaje  decimal(18,6)
   declare @fvperc_importe      decimal(18,6)
  declare @fvperc_origen      decimal(18,6)
  declare @fvperc_descrip     varchar(255)
  declare @perc_id            int

  set @orden = 1
  while exists(select fvperc_orden from FacturaVentaPercepcionTMP where fvTMP_id = @@fvTMP_id and fvperc_orden = @orden) 
  begin


    /*
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                                                                                               //
    //                                        INSERT                                                                 //
    //                                                                                                               //
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    */

    select
            @fvperc_id                      = fvperc_id,
            @fvperc_orden                    = fvperc_orden,
            @fvperc_base                    = fvperc_base,
            @fvperc_porcentaje              = fvperc_porcentaje,
            @fvperc_importe                 = fvperc_importe,
            @fvperc_origen                  = fvperc_origen,
            @fvperc_descrip                  = fvperc_descrip,
            @perc_id                         = perc_id,
            @ccos_id                        = ccos_id

    from FacturaVentaPercepcionTMP where fvTMP_id = @@fvTMP_id and fvperc_orden = @orden

    if @IsNew <> 0 or @fvperc_id = 0 begin

        exec SP_DBGetNewId 'FacturaVentaPercepcion','fvperc_id',@fvperc_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into FacturaVentaPercepcion (
                                      fv_id,
                                      fvperc_id,
                                      fvperc_orden,
                                      fvperc_base,
                                      fvperc_porcentaje,
                                      fvperc_importe,
                                      fvperc_origen,
                                      fvperc_descrip,
                                      perc_id,
                                      ccos_id
                                )
                            Values(
                                      @fv_id,
                                      @fvperc_id,
                                      @fvperc_orden,
                                      @fvperc_base,
                                      @fvperc_porcentaje,
                                      @fvperc_importe,
                                      @fvperc_origen,
                                      @fvperc_descrip,
                                      @perc_id,
                                      @ccos_id
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

          update FacturaVentaPercepcion set

                  fv_id                            = @fv_id,
                  fvperc_orden                    = @fvperc_orden,
                  fvperc_base                      = @fvperc_base,
                  fvperc_porcentaje                = @fvperc_porcentaje,
                  fvperc_importe                  = @fvperc_importe,
                  fvperc_origen                   = @fvperc_origen,
                  fvperc_descrip                  = @fvperc_descrip,
                  perc_id                         = @perc_id,
                  ccos_id                          = @ccos_id

        where fv_id = @fv_id and fvperc_id = @fvperc_id 
        if @@error <> 0 goto ControlError
    end -- Update

    set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ITEMS BORRADOS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar los items borrados del pedido
  if @IsNew = 0 begin
    
    delete FacturaVentaItem 
            where exists (select fvi_id 
                          from FacturaVentaItemBorradoTMP 
                          where fv_id     = @fv_id 
                            and fvTMP_id  = @@fvTMP_id
                            and fvi_id     = FacturaVentaItem.fvi_id
                          )
    if @@error <> 0 goto ControlError

    delete FacturaVentaItemBorradoTMP where fv_id = @fv_id and fvTMP_id  = @@fvTMP_id

    -----------------------------------------------------------------------------------------
    delete FacturaVentaPercepcion
            where exists (select fvperc_id 
                          from FacturaVentaPercepcionBorradoTMP 
                          where fv_id = @fv_id 
                            and fvperc_id = FacturaVentaPercepcion.fvperc_id
                            and fvTMP_id = @@fvTMP_id)
    if @@error <> 0 goto ControlError

    delete FacturaVentaPercepcionBorradoTMP where fv_id = @fv_id and fvTMP_id = @@fvTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     PAGO EN CTA CTE Y CONTADO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- TO
  declare @fv_totaldeuda decimal(18,6)

  select @fv_totaldeuda = sum(fvi_importe) 
  from FacturaVentaItem fvi inner join TipoOperacion t on fvi.to_id = t.to_id
  where fv_id = @fv_id 
    and to_generadeuda <> 0

  if @fv_totaldeuda is null begin

    set @fv_totaldeuda = 0

  end else begin

    set @fv_totaldeuda = @fv_totaldeuda - ((@fv_totaldeuda * @fv_descuento1) / 100)
    set @fv_totaldeuda = @fv_totaldeuda - ((@fv_totaldeuda * @fv_descuento2) / 100)
    set @fv_totaldeuda = @fv_totaldeuda + @fv_totalpercepciones

  end

  exec sp_DocFacturaVentaSaveDeuda       
                                    @fv_id,
                                    @cpg_id,
                                    @fv_fecha,
                                    @fv_fechaVto,
                                    @fv_totaldeuda,
                                    @est_id,
                                    @bSuccess  out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION PEDIDO - REMITO                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaVtaPedidoRemitoSaveAplic @fv_id, @@fvTMP_id, 0, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_TalonarioSet @ta_id,@fv_nrodoc
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     REMITO                                                                         //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if IsNull(@doc_generaremito,0) <> 0  and @IsNew <> 0 begin

    exec sp_DocFacturaVentaRemitoSave  @fv_id, 
                                       @rv_nrodoc,
                                       @bError out, 
                                       @MsgError out
    if @bError <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     CREDITO Y ESTADO                                                               //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaVentaSetPendiente @fv_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  exec sp_DocFacturaVentaSetCredito @fv_id
  if @@error <> 0 goto ControlError

  exec sp_DocFacturaVentaSetEstado @fv_id
  if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  set @cfg_valor = null
  exec sp_Cfg_GetValor  'Ventas-General',
                        'Grabar Asiento',
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
  if convert(int,@cfg_valor) <> 0 begin

    -- No genero asiento para facturas anuladas
    --
    if @est_id <> 7 begin

      exec sp_DocFacturaVentaAsientoSave @fv_id,0,@bError out, @MsgError out
      if @bError <> 0 goto ControlError

    end

  end else begin

    if not exists (select fv_id from FacturaVentaAsiento where fv_id = @fv_id) begin
      insert into FacturaVentaAsiento (fv_id,fv_fecha) 
            select fv_id,fv_fecha from FacturaVenta 
              where fv_grabarAsiento <> 0 and fv_id = @fv_id
    end
  end


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     STOCK                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if IsNull(@doc_mueveStock,0) <> 0 begin

    exec sp_DocFacturaVentaStockSave  @@fvTMP_id,
                                      @fv_id, 
                                      @depl_id, 
                                      0, 
                                      @bError out, 
                                      @MsgError out
    if @bError <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                          TOTAL COMERCIAL - NECESARIO PARA LOS REPORTES DE CTA CTE                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
    update facturaventa 
    set fv_totalcomercial = IsNull(@fv_totaldeuda,0)
    where fv_id = @fv_id


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
  
    update FacturaVenta set mcj_id = @mcj_id where fv_id = @fv_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
  exec sp_AuditoriaEstadoCheckDocFV    @fv_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- STOCK
  exec sp_AuditoriaStockCheckDocFV    @fv_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
  exec sp_AuditoriaTotalesCheckDocFV  @fv_id,
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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 CURSOS (debe hacerse antes de eliminar los items borrados)                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaVentaSaveCurso   @fv_id, @@fvTMP_ID,
                                     @bSuccess out,
                                     @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 PARTICULARIDADES DE LOS CLIENTES                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocFacturaVentaSaveCliente @fv_id, @@fvTMP_ID,
                                     @bSuccess out,
                                     @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

--/////////////////////////////////////////////////////////////////////////////////////////////////////  
--
-- FACTURA ELECTRONICA  (esto va dentro de la transaccion)
--
--/////////////////////////////////////////////////////////////////////////////////////////////////////

  if @IsNew <> 0 begin
    exec sp_FE_CheckTalonario @fv_id, 
                              @ta_id,
                              @bSuccess  out,
                              @MsgError out
    if IsNull(@bSuccess,0) = 0 goto ControlError
  end


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete HoraFacturaVentaTMP where fvTMP_ID = @@fvTMP_ID
  delete PackingListFacturaVentaTMP where fvTMP_ID = @@fvTMP_ID
  delete RemitoFacturaVentaTMP where fvTMP_ID = @@fvTMP_ID
  delete PedidoFacturaVentaTMP where fvTMP_ID = @@fvTMP_ID
  delete FacturaVentaItemSerieTMP where fvTMP_id = @@fvTMP_id
  delete FacturaVentaItemTMP where fvTMP_id = @@fvTMP_id
  delete FacturaVentaTMP where fvTMP_id = @@fvTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @modifico = modifico from FacturaVenta where fv_id = @fv_id
  if @IsNew <> 0 exec sp_HistoriaUpdate 16001, @fv_id, @modifico, 1
  else           exec sp_HistoriaUpdate 16001, @fv_id, @modifico, 3

--
--/////////////////////////////////////////////////////////////////////////////////////////////////////


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  commit transaction

--/////////////////////////////////////////////////////////////////////////////////////////////////////  
--
-- FACTURA ELECTRONICA  (esto va fuera de la transaccion)
--
--/////////////////////////////////////////////////////////////////////////////////////////////////////

  exec sp_DocFacturaVentaSaveFE @fv_id, 
                                @bSuccess  out,
                                @MsgError out
  if IsNull(@bSuccess,0) = 0 goto ControlError
--
--/////////////////////////////////////////////////////////////////////////////////////////////////////

  
  -- Notifico de anticipos si el usuario
  -- asi lo indico en su configuracion
  -- personal
  --
  declare @cfg_clave varchar(255) 
  set @cfg_clave = 'Informar Anticipos Vta_' + convert(varchar(15),@modifico)

  set @cfg_valor = 0
  exec sp_Cfg_GetValor  'Usuario-Config',
                        @cfg_clave,
                        @cfg_valor out,
                        0
  if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)

  if convert(int,@cfg_valor) <> 0 begin

    if exists(select * from Cobranza 
              where round(cobz_pendiente,2) > 0.02 
                and emp_id = @emp_id
                and cli_id = @cli_id
              )
    begin

      declare @cobz_nrodoc        varchar(50)
      declare @cobz_fecha          datetime
      declare @cobz_pendiente      decimal(18,2)

      declare @pendiente varchar(8000)
      set @pendiente = ''      

      declare c_cob_anticipos insensitive cursor for 
                select cobz_nrodoc, cobz_fecha, cobz_pendiente
                from Cobranza 
                where Round(cobz_pendiente,2) > 0
                  and emp_id = @emp_id
                  and cli_id = @cli_id
      open c_cob_anticipos

      fetch next from c_cob_anticipos into @cobz_nrodoc, @cobz_fecha, @cobz_pendiente
      while @@fetch_status=0
      begin
        set @pendiente = @pendiente + @cobz_nrodoc 
                          + ' del ' + convert(varchar(12),@cobz_fecha,105) 
                          + ' por pesos ' + convert(varchar(50),Round(@cobz_pendiente,2)) + ';'
        fetch next from c_cob_anticipos into @cobz_nrodoc, @cobz_fecha, @cobz_pendiente
      end

      close c_cob_anticipos
      deallocate c_cob_anticipos

      select 'INFO', 'Este cliente tiene anticipo/s en la cobranza/s:;;' + @pendiente

    end
  end  

  set @@fv_id = @fv_id
  set @@bSuccess = 1

  if @@bSelect <> 0 select @fv_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la factura de venta. sp_DocFacturaVentaSave. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

go