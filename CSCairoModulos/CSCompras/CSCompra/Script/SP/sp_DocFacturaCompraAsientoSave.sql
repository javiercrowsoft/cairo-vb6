if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraAsientoSave]

/*
 select * from facturaCompra
 sp_DocFacturaCompraAsientoSave 26

*/

go
create procedure sp_DocFacturaCompraAsientoSave (
  @@fc_id           int,
  @@bRaiseError     smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
  @@bSelect         smallint     = 0
)
as

begin

  set nocount on

  declare @fci_id          int
  declare @IsNew          smallint

  declare @as_id          int
  declare  @prov_id         int
  declare @doc_id_factura int

  set @@bError = 0

  -- Si no existe chau
  if not exists (select fc_id from FacturaCompra where fc_id = @@fc_id and est_id <> 7)
    return

declare @desc1 decimal(18,6)
declare @desc2 decimal(18,6)
declare @descuento1 decimal(18,6)
declare @descuento2 decimal(18,6)
declare  @as_fecha   datetime 
  
  select 
          @as_id             = as_id, 
          @prov_id           = prov_id, 
          @doc_id_factura   = fc.doc_id,  
          @desc1            = fc_descuento1,
          @desc2            = fc_descuento2,
          @as_fecha         = case when cpg_asientoXVto <> 0 and cpg_tipo not in (2,3) then fc_fechaVto 
                                   else fc_fechaiva 
                              end  

  from FacturaCompra fc inner join condicionpago cpg on fc.cpg_id = cpg.cpg_id
  where fc_id = @@fc_id
  
  set @as_id = isnull(@as_id,0)

declare @doc_esresumenbco tinyint

select @doc_esresumenbco = doc_esresumenbco from Documento where doc_id = @doc_id_factura

-- Campos de las tablas

declare  @as_numero  int 
declare  @as_nrodoc  varchar (50) 
declare  @as_descrip varchar (5000)

declare  @doc_id     int
declare @ta_id      int
declare  @doct_id    int

declare @ccos_id_cliente int
declare  @ccos_id    int
declare  @creado     datetime 
declare  @modificado datetime 
declare  @modifico   int 

declare  @asi_orden               smallint 
declare  @asi_debe               decimal(18, 6) 
declare  @asi_haber               decimal(18, 6)
declare  @asi_origen             decimal(18, 6)
declare @mon_id                 int

declare  @fci_orden               smallint 
declare @fci_importe             decimal(18, 6)
declare @fci_importeorigen      decimal(18, 6)
declare @fci_neto               decimal(18, 6)

declare @cue_id                 int
declare @doct_id_factura        int
declare @doc_id_cliente         int

declare @as_doc_cliente         varchar(5000)

declare @bError      tinyint

  begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Obtengo el documento @doc_id
  select 
         @doc_id             = doc_id_asiento, 
         @doct_id_factura   = FacturaCompra.doct_id, 
         @doc_id_cliente    = Documento.doc_id,
         @mon_id             = Documento.mon_id,
         @ccos_id_cliente = ccos_id,
         @as_doc_cliente  = fc_nrodoc + ' ' + prov_nombre

  from FacturaCompra inner join Documento on FacturaCompra.doc_id = Documento.doc_id
                    inner join Proveedor   on FacturaCompra.prov_id = Proveedor.prov_id
  where fc_id = @@fc_id

  if @as_id = 0 begin

    set @IsNew = -1
  
    exec SP_DBGetNewId 'Asiento','as_id',@as_id out, 0
    exec SP_DBGetNewId 'Asiento','as_numero',@as_numero out, 0


    -- Obtengo el as_nrodoc
    declare @ta_ultimonro  int 
    declare @ta_mascara   varchar(50) 

    select @ta_ultimonro=ta_ultimonro, @ta_mascara=ta_mascara, @doct_id = doct_id
    from documento inner join talonario on documento.ta_id = talonario.ta_id 
    where doc_id = @doc_id

    set @ta_ultimonro = @ta_ultimonro + 1
    set @as_nrodoc = convert(varchar(50),@ta_ultimonro)
    set @as_nrodoc = substring(@ta_mascara,1,len(@ta_mascara) - len(@as_nrodoc)) + @as_nrodoc

    insert into Asiento (
                              as_id,
                              as_numero,
                              as_nrodoc,
                              as_descrip,
                              as_fecha,
                              as_doc_cliente,
                              doc_id,
                              doct_id,
                              doct_id_cliente,
                              doc_id_cliente,
                              id_cliente,
                              modifico
                            )
      select
                              @as_id,
                              @as_numero,
                              @as_nrodoc,
                              fc_descrip,
                              @as_fecha,
                              @as_doc_cliente,
                              @doc_id,
                              @doct_id,
                              @doct_id_factura,
                              @doc_id_cliente,
                              @@fc_id,
                              modifico
      from FacturaCompra
      where fc_id = @@fc_id  

      if @@error <> 0 goto ControlError
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
                              @as_descrip              = fc_descrip,
                              @modifico                = modifico,
                              @modificado             = modificado
    from FacturaCompra 
    where 
          fc_id = @@fc_id

    select 
                              @doc_id                  = doc_id,
                              @doct_id                = doct_id
    from Asiento
    where 
          as_id = @as_id

    update Asiento set 
                              as_descrip            = @as_descrip,
                              as_fecha              = @as_fecha,
                              as_doc_cliente        = @as_doc_cliente,
                              doc_id                = @doc_id,
                              doct_id                = @doct_id,
                              doct_id_cliente        = @doct_id_factura,
                              doc_id_cliente        =  @doc_id_cliente,
                              id_cliente            = @@fc_id,
                              modifico              = @modifico,
                              modificado            = @modificado
  
    where as_id = @as_id
    if @@error <> 0 goto ControlError
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/


  -- Borro todos los items y solo hago inserts que se mucho mas simple y rapido
  delete AsientoItem where as_id = @as_id

  declare @to_count smallint
  select @to_count = count(distinct to_id) from FacturaCompraItem where fc_id = @@fc_id

  if @doct_id_factura = 2 /* Factura */ or @doct_id_factura = 10 /* Nota de Debito*/ begin

    set @asi_orden = 1

  end else begin
    if @doct_id_factura = 8 /* Nota de Credito */ begin

      -- TO
      declare @ordenItem smallint
      set @ordenItem = @to_count
  
      if @desc1 <> 0 or @desc2 <> 0 set @asi_orden = @ordenItem + 2
      else                          set @asi_orden = @ordenItem + 1
  
    end
  end

  -- Los resumenes bancarios no agrupan los renlgones por cuenta
  -- para ayudar a la conciliacion bancaria
  --
  if @doc_esresumenbco <> 0 begin

    declare c_FacturaItemAsiento cursor for 
  
      select fci_neto, fci_importe, fci_importeorigen, 
             isnull(pcueg.cue_id,cueg.cue_id), ccos_id
      from FacturaCompraItem fci inner join Producto p on fci.pr_id = p.pr_id
                                inner join CuentaGrupo cueg            on p.cueg_id_compra  = cueg.cueg_id
                                left  join ProveedorCuentaGrupo pcueg on     cueg.cueg_id   = pcueg.cueg_id
                                                                        and pcueg.prov_id  = @prov_id
  
      where fc_id = @@fc_id

  -- Las facturas normales agrupan por cuenta para hacer los asientos
  -- mas breves y ahorrar espacio en el libro diario
  --
  end else begin

    declare c_FacturaItemAsiento cursor for 
  
      select sum(fci_neto), sum(fci_importe), sum(fci_importeorigen), 
             isnull(pcueg.cue_id,cueg.cue_id), ccos_id
      from FacturaCompraItem fci inner join Producto p on fci.pr_id = p.pr_id
                                inner join CuentaGrupo cueg            on p.cueg_id_compra  = cueg.cueg_id
                                left  join ProveedorCuentaGrupo pcueg on     cueg.cueg_id   = pcueg.cueg_id
                                                                        and pcueg.prov_id  = @prov_id
  
      where fc_id = @@fc_id
      group by    
              isnull(pcueg.cue_id,cueg.cue_id), ccos_id

  end

  open c_FacturaItemAsiento

  fetch next from c_FacturaItemAsiento into @fci_neto, @fci_importe, @fci_importeorigen, @cue_id, @ccos_id
  while @@fetch_status = 0 
  begin

    if @doct_id_factura = 2 /* Factura */ or @doct_id_factura = 10 /* Nota de Debito*/ begin
        set @asi_debe  = @fci_neto
        set @asi_haber = 0
    end else begin
      if @doct_id_factura = 8 /* Nota de Credito */ begin
          set @asi_debe  = 0
          set @asi_haber = @fci_neto
      end
    end

    if @fci_importeorigen <> 0 begin
          set @asi_origen = @fci_neto / (@fci_importe/@fci_importeorigen)
    end
    else  set @asi_origen = 0

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_FacturaItemAsiento into @fci_neto, @fci_importe, @fci_importeorigen, @cue_id, @ccos_id
  end -- While

  close c_FacturaItemAsiento
  deallocate c_FacturaItemAsiento

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        OTROS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @aux decimal(18,6)

  -- Los resumenes bancarios no agrupan los renlgones por cuenta
  -- para ayudar a la conciliacion bancaria
  --
  if @doc_esresumenbco <> 0 begin

    declare c_FacturaItemAsiento cursor for 

      select fcot_debe, fcot_haber, fcot_origen, cue_id, ccos_id
      from FacturaCompraOtro fcot
  
      where fc_id = @@fc_id

  end else begin

    declare c_FacturaItemAsiento cursor for 

      select sum(fcot_debe), sum(fcot_haber), sum(fcot_origen), cue_id, ccos_id
      from FacturaCompraOtro fcot
  
      where fc_id = @@fc_id
      group by    
              cue_id, ccos_id

  end

  open c_FacturaItemAsiento

  fetch next from c_FacturaItemAsiento into @asi_debe, @asi_haber, @asi_origen, @cue_id, @ccos_id
  while @@fetch_status = 0 
  begin

    if @doct_id_factura = 8 begin
      set @aux        = @asi_debe
      set @asi_debe   = @asi_haber
      set @asi_haber  = @aux
    end

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id,
                                            null,
                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
      fetch next from c_FacturaItemAsiento into @asi_debe, @asi_haber, @asi_origen, @cue_id, @ccos_id
  end -- While

  close c_FacturaItemAsiento
  deallocate c_FacturaItemAsiento

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        PERCEPCIONES                                                                //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Los resumenes bancarios no agrupan los renlgones por cuenta
  -- para ayudar a la conciliacion bancaria
  --
  if @doc_esresumenbco <> 0 begin

    declare c_FacturaItemAsiento cursor for 
  
      select fcperc_importe, fcperc_origen, cue_id, ccos_id
      from FacturaCompraPercepcion fcperc inner join Percepcion p       on fcperc.perc_id = p.perc_id
                                          inner join PercepcionTipo pt   on p.perct_id = pt.perct_id
  
      where fc_id = @@fc_id

  end else begin

    declare c_FacturaItemAsiento cursor for 
  
      select sum(fcperc_importe), sum(fcperc_origen), cue_id, ccos_id
      from FacturaCompraPercepcion fcperc inner join Percepcion p       on fcperc.perc_id = p.perc_id
                                          inner join PercepcionTipo pt   on p.perct_id = pt.perct_id
  
      where fc_id = @@fc_id
      group by    
              cue_id, ccos_id
  end

  open c_FacturaItemAsiento

  set @asi_haber = 0
  fetch next from c_FacturaItemAsiento into @asi_debe, @asi_origen, @cue_id, @ccos_id
  while @@fetch_status = 0 
  begin

    if @doct_id_factura = 8 /* Nota de Credito */ begin
      set @asi_haber = @asi_debe
      set @asi_debe = 0
    end

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
      fetch next from c_FacturaItemAsiento into @asi_debe, @asi_origen, @cue_id, @ccos_id
  end -- While

  close c_FacturaItemAsiento
  deallocate c_FacturaItemAsiento

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        IVA                                                                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  exec sp_DocFacturaCompraAsientoSaveIva @@fc_id, @as_id, 1, @mon_id, 
                                        @doct_id_factura, @ccos_id, 
                                        @desc1, @desc2,
                                        @bError out, @doc_esresumenbco
  if @bError <> 0 goto ControlError

  exec sp_DocFacturaCompraAsientoSaveIva @@fc_id, @as_id, 0, @mon_id, 
                                        @doct_id_factura, @ccos_id, 
                                        @desc1, @desc2,
                                        @bError out, @doc_esresumenbco
  if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        INTERNOS                                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  exec sp_DocFacturaCompraAsientoSaveInterno @@fc_id, @as_id, @mon_id, 
                                            @doct_id_factura, @ccos_id, 
                                            @desc1, @desc2,
                                            @bError out, @doc_esresumenbco
  if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        Ahora la cuenta del Proveedor                                          //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @coef             decimal(18,6)
  declare @fcot_debe        decimal(18,6)
  declare @fcot_haber        decimal(18,6)
  declare @fcot_origen      decimal(18,6)
  declare @fcperc_origen    decimal(18,6)
  declare @fcperc_importe   decimal(18,6)

  -- TO
  declare @to_id       int
  declare @asi_tipo    tinyint

  set @descuento2 = 0
  set @descuento1 = 0

  declare c_FacturaItemAsiento cursor for 

    select 
              sum(fci_neto), 
              sum(fci_importe), 
              sum(fci_importeorigen), 
              to_id

    from FacturaCompraItem 

    where fc_id = @@fc_id
    group by    
            to_id

  open c_FacturaItemAsiento

  fetch next from c_FacturaItemAsiento into @fci_neto, @fci_importe, @fci_importeorigen, @to_id
  while @@fetch_status = 0 
  begin

    exec sp_DocGetCueId @prov_id, @doc_id_factura, 0, @cue_id out, @mon_id out, @to_id
  
    if @doct_id_factura = 8 /* Nota de Credito */ begin
  
      select @asi_debe           = @fci_importe 

      -- Otros y Percepciones van con la cuenta asociada al tipo de operacion 1 (comercial)
      --
      if @to_id = 1 or @to_count = 1 /*Comercial*/ begin
  
        -- Sumo Otros
        select @fcot_haber    = sum(fcot_haber), 
               @fcot_debe     = sum(fcot_debe),
               @fcot_origen   = sum(fcot_origen)
        from FacturaCompraOtro where fc_id = @@fc_id
    
        if @doct_id_factura = 8 begin
          set @aux         = @fcot_debe
          set @fcot_debe  = @fcot_haber 
          set @fcot_haber = @aux
        end

        -- Sumo Percepciones
        select @fcperc_importe    = sum(fcperc_importe), 
               @fcperc_origen     = sum(fcperc_origen)
        from FacturaCompraPercepcion where fc_id = @@fc_id
  
      end else begin

        -- Otros tipos de operaciones
        --
        set @fcot_debe      = 0 
        set @fcot_haber      = 0 
        set @fcot_origen    = 0
        set @fcperc_importe  = 0 
        set @fcperc_origen  = 0

      end
  
      set @asi_debe           = @asi_debe + IsNull(@fcot_haber,0) - IsNull(@fcot_debe,0) + IsNull(@fcperc_importe,0)
      set @fci_importeorigen  = @fci_importeorigen + IsNull(@fcot_origen,0) + IsNull(@fcperc_origen,0)
  
      if @fci_importeorigen <> 0 set @coef = @asi_debe / @fci_importeorigen
      else                       set @coef = 0

      set @asi_debe = @asi_debe - (@asi_debe * @desc1 /100)
      set @asi_debe = @asi_debe - (@asi_debe * @desc2 /100)
  
      set @descuento2 = @descuento2 + (@fci_neto - @fci_neto * @desc1 /100) * @desc2 /100
      set @descuento1 = @descuento1 + @fci_neto * @desc1 /100
  
      set @asi_haber = 0
  
      set @asi_orden = 1
        
    end else begin
      if @doct_id_factura = 2 /* Factura */ or @doct_id_factura = 10 /* Nota de Debito*/ begin
  
        set @asi_debe  = 0
  
        select @asi_haber         = @fci_importe
  
        -- Otros y Percepciones van con la cuenta asociada al tipo de operacion 1 (comercial)
        --
        if @to_id = 1 or @to_count = 1 /*Comercial*/ begin

          -- Sumo Otros
          select @fcot_debe      = sum(fcot_debe), 
                 @fcot_haber    = sum(fcot_haber),
                 @fcot_origen   = sum(fcot_origen)
          from FacturaCompraOtro where fc_id = @@fc_id
      
          -- Sumo Percepciones
          select @fcperc_importe    = sum(fcperc_importe), 
                 @fcperc_origen     = sum(fcperc_origen)
          from FacturaCompraPercepcion where fc_id = @@fc_id

        end else begin    

          -- Otros tipos de operaciones
          --
          set @fcot_debe      = 0 
          set @fcot_haber      = 0 
          set @fcot_origen    = 0
          set @fcperc_importe  = 0 
          set @fcperc_origen  = 0

        end

        set @asi_haber           = @asi_haber + IsNull(@fcot_debe,0) - IsNull(@fcot_haber,0) + IsNull(@fcperc_importe,0)  
        set @fci_importeorigen  = @fci_importeorigen + IsNull(@fcot_origen,0) + IsNull(@fcperc_origen,0)
    
        if @fci_importeorigen <> 0 set @coef = @asi_haber / @fci_importeorigen
        else                       set @coef = 0

        set @asi_haber = @asi_haber - (@asi_haber * @desc1 /100)
        set @asi_haber = @asi_haber - (@asi_haber * @desc2 /100)
  
        set @descuento2 = @descuento2 + (@fci_neto - @fci_neto * @desc1 /100) * @desc2 /100
        set @descuento1 = @descuento1 + @fci_neto * @desc1 /100
  
        select @asi_orden = max(asi_orden)+1 from AsientoItem where as_id = @as_id
      end
    end
  
    if @fci_importeorigen <> 0 begin
         set @fci_importeorigen = @fci_importeorigen - (@fci_importeorigen * @desc1 /100)
         set @fci_importeorigen = @fci_importeorigen - (@fci_importeorigen * @desc2 /100)
         set @asi_origen = @fci_importeorigen
    end
    else set @asi_origen = 0

    if @to_count = 1 begin

      set @asi_tipo = 2 -- Cta acreedor

    end else begin

      select @asi_tipo = to_generadeuda from TipoOperacion where to_id = @to_id
      if @asi_tipo <> 0 or @to_count = 1 set @asi_tipo = 2 -- Cta acreedor

    end
  
    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            @asi_haber,
                                            @asi_origen,
                                            @asi_tipo, -- TO
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id_cliente,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError

    set @asi_orden = @asi_orden + 1
    fetch next from c_FacturaItemAsiento into @fci_neto, @fci_importe, @fci_importeorigen, @to_id
  end -- While

  close c_FacturaItemAsiento
  deallocate c_FacturaItemAsiento

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Descuentos globales                                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  if @desc1 <> 0 or @desc2 <> 0 begin

    declare @cfg_valor varchar(5000) 

    exec sp_Cfg_GetValor  'Compras-General',
                          'Cuenta Descuento Global',
                          @cfg_valor out,
                          0

    set @cue_id = convert(int,@cfg_valor)

    if @doct_id_factura = 8 /* Nota de Credito */ begin
      set @asi_orden = 2
    end else begin
      if @doct_id_factura = 2 /* Factura */ or @doct_id_factura = 10 /* Nota de Debito*/ begin
        select @asi_orden = max(asi_orden)+1 from AsientoItem where as_id = @as_id
      end
    end

    if @desc1 <> 0 begin
  
      if @doct_id_factura = 8 /* Nota de Credito */ begin
        set @asi_debe = @descuento1 
        set @asi_haber = 0
      end else begin
        if @doct_id_factura = 2 /* Factura */ or @doct_id_factura = 10 /* Nota de Debito*/ begin
          set @asi_debe  = 0
          set @asi_haber = @descuento1
        end
      end
  
      if @coef <> 0 begin
           set @asi_origen = @descuento1 / @coef
      end
      else set @asi_origen = 0
    end

    if @desc2 <> 0 begin
  
      select @asi_orden = max(asi_orden)+1 from AsientoItem where as_id = @as_id

      if @doct_id_factura = 8 /* Nota de Credito */ begin
        set @asi_debe = @asi_debe + @descuento2 
        set @asi_haber = 0
      end else begin
        if @doct_id_factura = 2 /* Factura */ or @doct_id_factura = 10 /* Nota de Debito*/ begin
            set @asi_debe  = 0
            set @asi_haber = @asi_haber + @descuento2
        end
      end
  
      if @coef <> 0 begin
           set @asi_origen = @asi_origen + @descuento2 / @coef
      end
      else set @asi_origen = 0
    end

    exec sp_DocAsientoSaveItem 
                                            @IsNew,
                                            0,
                                            @as_id,
                                          
                                            @asi_orden,
                                            @asi_debe,
                                            @asi_haber,
                                            @asi_origen,
                                            0,
                                            @mon_id,
                                          
                                            @cue_id,
                                            @ccos_id_cliente,
                                            null,

                                            @bError out
    if @bError <> 0 goto ControlError
  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Valido el Asiento                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocAsientoValidate @as_id, @bError out, @@MsgError out
  if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Talonario                                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @ta_id = ta_id from documento where doc_id = @doc_id

  exec sp_TalonarioSet @ta_id,@as_nrodoc

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo la factura con su asiento                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  update FacturaCompra set as_id = @as_id, fc_grabarasiento = 0 where fc_id = @@fc_id

  commit transaction

  set @@bError = 0

  if @@bSelect <> 0 select @as_id

  return
ControlError:

  set @@bError = -1

  if @@MsgError is not null set @@MsgError = @@MsgError + ';'

  set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la factura de Compra. sp_DocFacturaCompraAsientoSave.'

  if @@bRaiseError <> 0 begin
    raiserror (@@MsgError, 16, 1)
  end

  rollback transaction  

end