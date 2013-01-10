if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaAsientoSave]

/*
 select * from facturaventa
 sp_DocFacturaVentaAsientoSave 26

*/

go
create procedure sp_DocFacturaVentaAsientoSave (
  @@fv_id           int,
  @@bRaiseError     smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
  @@bSelect         smallint     = 0
)
as

begin

  set nocount on

  declare @fvi_id          int
  declare @IsNew          smallint

  declare @as_id          int
  declare  @cli_id         int
  declare @doc_id_factura int

  set @@bError = 0

  -- Si no existe chau
  if not exists (select fv_id from FacturaVenta where fv_id = @@fv_id and est_id <> 7)
    return

declare @desc1 decimal(18,6)
declare @desc2 decimal(18,6)
declare @descuento1 decimal(18,6)
declare @descuento2 decimal(18,6)
declare  @as_fecha   datetime 
  
  select 
          @as_id             = as_id, 
          @cli_id           = cli_id, 
          @doc_id_factura   = fv.doc_id,  
          @desc1            = fv_descuento1,
          @desc2            = fv_descuento2,
          @as_fecha         = case when cpg_asientoXVto <> 0 then fv_fechaVto 
                                   else fv_fechaiva 
                              end

  from FacturaVenta fv inner join condicionpago cpg on fv.cpg_id = cpg.cpg_id
  where fv_id = @@fv_id
  
  set @as_id = isnull(@as_id,0)
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

declare  @fvi_orden               smallint 
declare @fvi_importe             decimal(18, 6)
declare @fvi_importeorigen      decimal(18, 6)
declare @fvi_neto               decimal(18, 6)

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
         @doc_id           = doc_id_asiento, 
         @doct_id_factura = FacturaVenta.doct_id, 
         @doc_id_cliente  = Documento.doc_id,
         @mon_id           = Documento.mon_id,
         @ccos_id_cliente = ccos_id,
         @as_doc_cliente  = fv_nrodoc + ' ' + cli_nombre

  from FacturaVenta inner join Documento on FacturaVenta.doc_id = Documento.doc_id
                    inner join Cliente   on FacturaVenta.cli_id = Cliente.cli_id
  where fv_id = @@fv_id

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
                              fv_descrip,
                              @as_fecha,
                              @as_doc_cliente,
                              @doc_id,
                              @doct_id,
                              @doct_id_factura,
                              @doc_id_cliente,
                              @@fv_id,
                              modifico
      from FacturaVenta
      where fv_id = @@fv_id  

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
                              @as_descrip              = fv_descrip,
                              @modifico                = modifico,
                              @modificado             = modificado
    from FacturaVenta 
    where 
          fv_id = @@fv_id

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
                              id_cliente            = @@fv_id,
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
  select @to_count = count(distinct to_id) from FacturaVentaItem where fv_id = @@fv_id

  if @doct_id_factura = 1 /* Factura */ or @doct_id_factura = 9 /* Nota de Debito*/ begin

    -- TO
    declare @ordenItem smallint
    select @ordenItem = count(distinct to_id) from FacturaVentaItem where fv_id = @@fv_id

    if @desc1 <> 0 or @desc2 <> 0 set @asi_orden = @ordenItem + 2
    else                          set @asi_orden = @ordenItem + 1

  end else begin
    if @doct_id_factura = 7 /* Nota de Credito */ begin
  
      set @asi_orden = 1
    end
  end

  declare c_FacturaItemAsiento cursor for 

    select sum(fvi_neto), sum(fvi_importe), sum(fvi_importeorigen), 
           isnull(ccueg.cue_id,cueg.cue_id), ccos_id
    from FacturaVentaItem fvi inner join Producto p                 on fvi.pr_id         = p.pr_id
                              inner join CuentaGrupo cueg            on p.cueg_id_venta   = cueg.cueg_id
                              left  join ClienteCuentaGrupo ccueg    on     cueg.cueg_id   = ccueg.cueg_id
                                                                      and ccueg.cli_id  = @cli_id

    where fv_id = @@fv_id
    group by    
            isnull(ccueg.cue_id,cueg.cue_id), ccos_id

  open c_FacturaItemAsiento

  fetch next from c_FacturaItemAsiento into @fvi_neto, @fvi_importe, @fvi_importeorigen, @cue_id, @ccos_id
  while @@fetch_status = 0 
  begin

    if @doct_id_factura = 1 /* Factura */ or @doct_id_factura = 9 /* Nota de Debito*/ begin
        set @asi_debe  = 0
        set @asi_haber = @fvi_neto
    end else begin
      if @doct_id_factura = 7 /* Nota de Credito */ begin
          set @asi_debe  = @fvi_neto
          set @asi_haber = 0
      end
    end

    if @fvi_importeorigen <> 0 begin
          set @asi_origen = @fvi_neto / (@fvi_importe/@fvi_importeorigen)
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
    fetch next from c_FacturaItemAsiento into @fvi_neto, @fvi_importe, @fvi_importeorigen, @cue_id, @ccos_id
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

  declare c_FacturaItemAsiento cursor for 

    select sum(fvperc_importe), sum(fvperc_origen), cue_id, ccos_id
    from FacturaVentaPercepcion fvperc inner join Percepcion p       on fvperc.perc_id = p.perc_id
                                       inner join PercepcionTipo pt on p.perct_id = pt.perct_id

    where fv_id = @@fv_id
    group by    
            cue_id, ccos_id

  open c_FacturaItemAsiento

  set @asi_debe = 0
  fetch next from c_FacturaItemAsiento into @asi_haber, @asi_origen, @cue_id, @ccos_id
  while @@fetch_status = 0 
  begin

    if @doct_id_factura = 7 /* Nota de Credito */ begin
      set @asi_debe = @asi_haber
      set @asi_haber = 0
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
      fetch next from c_FacturaItemAsiento into @asi_haber, @asi_origen, @cue_id, @ccos_id
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
  exec sp_DocFacturaVentaAsientoSaveIva @@fv_id, @as_id, 1, @mon_id, 
                                        @doct_id_factura, @ccos_id, 
                                        @desc1, @desc2,
                                        @bError out
  if @bError <> 0 goto ControlError

  exec sp_DocFacturaVentaAsientoSaveIva @@fv_id, @as_id, 0, @mon_id, 
                                        @doct_id_factura, @ccos_id, 
                                        @desc1, @desc2,
                                        @bError out
  if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        INTERNOS                                                               //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  exec sp_DocFacturaVentaAsientoSaveInterno  @@fv_id, @as_id, @mon_id, 
                                             @doct_id_factura, @ccos_id, 
                                             @desc1, @desc2,
                                             @bError out
  if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        Ahora la cuenta del cliente                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- TO
  declare @coef             decimal(18,6)
  declare @to_id             int
  declare @asi_tipo          tinyint
  declare @fvperc_origen    decimal(18,6)
  declare @fvperc_importe   decimal(18,6)

  set @descuento2 = 0
  set @descuento1 = 0

  declare c_FacturaItemAsiento cursor for 

    select 
              sum(fvi_neto), 
              sum(fvi_importe), 
              sum(fvi_importeorigen), 
              to_id

    from FacturaVentaItem 

    where fv_id = @@fv_id
    group by    
            to_id

  open c_FacturaItemAsiento

  fetch next from c_FacturaItemAsiento into @fvi_neto, @fvi_importe, @fvi_importeorigen, @to_id
  while @@fetch_status = 0 
  begin
  
    exec sp_DocGetCueId @cli_id, @doc_id_factura, 0, @cue_id out, @mon_id out, @to_id
  
    if @doct_id_factura = 7 /* Nota de Credito */ begin

      set @asi_debe  = 0

      select @asi_haber         = @fvi_importe 

      -- Las Percepciones van con la cuenta asociada al tipo de operacion 1 (comercial)
      --
      if @to_id = 1 or @to_count = 1 /*Comercial*/ begin
    
        -- Sumo Percepciones
        select @fvperc_importe    = sum(fvperc_importe), 
               @fvperc_origen     = sum(fvperc_origen)
        from FacturaVentaPercepcion where fv_id = @@fv_id
  
      end else begin

        -- Otros tipos de operaciones
        --
        set @fvperc_importe  = 0 
        set @fvperc_origen  = 0

      end
  
      set @asi_haber           = @asi_haber + IsNull(@fvperc_importe,0)
      set @fvi_importeorigen  = @fvi_importeorigen + IsNull(@fvperc_origen,0)
  
      if @fvi_importeorigen <> 0 set @coef = @asi_haber / @fvi_importeorigen
      else                       set @coef = 0

      set @asi_haber = @asi_haber - (@asi_haber * @desc1 /100)
      set @asi_haber = @asi_haber - (@asi_haber * @desc2 /100)

      set @descuento2 = @descuento2 + (@fvi_neto - @fvi_neto * @desc1 /100) * @desc2 /100
      set @descuento1 = @descuento1 + @fvi_neto * @desc1 /100

      select @asi_orden = max(asi_orden)+1 from AsientoItem where as_id = @as_id
        
    end else begin

      if @doct_id_factura = 1 /* Factura */ or @doct_id_factura = 9 /* Nota de Debito*/ begin

        select @asi_debe           = @fvi_importe 

        -- Las Percepciones van con la cuenta asociada al tipo de operacion 1 (comercial)
        --
        if @to_id = 1 or @to_count = 1 /*Comercial*/ begin
      
          -- Sumo Percepciones
          select @fvperc_importe    = sum(fvperc_importe), 
                 @fvperc_origen     = sum(fvperc_origen)
          from FacturaVentaPercepcion where fv_id = @@fv_id

        end else begin    

          -- Otros tipos de operaciones
          --
          set @fvperc_importe  = 0 
          set @fvperc_origen  = 0

        end

        set @asi_debe           = @asi_debe + IsNull(@fvperc_importe,0)  
        set @fvi_importeorigen  = @fvi_importeorigen + IsNull(@fvperc_origen,0)
    
        if @fvi_importeorigen <> 0 set @coef = @asi_debe / @fvi_importeorigen
        else                       set @coef = 0

        set @asi_debe = @asi_debe - (@asi_debe * @desc1 /100)
        set @asi_debe = @asi_debe - (@asi_debe * @desc2 /100)

        set @descuento2 = @descuento2 + (@fvi_neto - @fvi_neto * @desc1 /100) * @desc2 /100
        set @descuento1 = @descuento1 + @fvi_neto * @desc1 /100

        set @asi_haber = 0

        set @asi_orden = 1

      end
    end
  
    if @fvi_importeorigen <> 0 begin
         set @fvi_importeorigen = @fvi_importeorigen - (@fvi_importeorigen * @desc1 /100)
         set @fvi_importeorigen = @fvi_importeorigen - (@fvi_importeorigen * @desc2 /100)
         set @asi_origen = @fvi_importeorigen
    end
    else set @asi_origen = 0

    if @to_count = 1 begin

      set @asi_tipo = 1 -- Cta deudor

    end else begin

      select @asi_tipo = to_generadeuda from TipoOperacion where to_id = @to_id
      if @asi_tipo <> 0 set @asi_tipo = 1 -- Cta deudor

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
    fetch next from c_FacturaItemAsiento into @fvi_neto, @fvi_importe, @fvi_importeorigen, @to_id
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

    exec sp_Cfg_GetValor  'Ventas-General',
                          'Cuenta Descuento Global',
                          @cfg_valor out,
                          0

    set @cue_id = convert(int,@cfg_valor)

    if @doct_id_factura = 7 /* Nota de Credito */ begin
      select @asi_orden = max(asi_orden)+1 from AsientoItem where as_id = @as_id
    end else begin
      if @doct_id_factura = 1 /* Factura */ or @doct_id_factura = 9 /* Nota de Debito*/ begin
        set @asi_orden = 2
      end
    end

    if @desc1 <> 0 begin
  
      if @doct_id_factura = 7 /* Nota de Credito */ begin
          set @asi_debe  = 0
          set @asi_haber = @descuento1
      end else begin
        if @doct_id_factura = 1 /* Factura */ or @doct_id_factura = 9 /* Nota de Debito*/ begin
            set @asi_debe = @descuento1 
            set @asi_haber = 0
        end
      end
  
      if @coef <> 0 begin
           set @asi_origen = @descuento1 / @coef
      end
      else set @asi_origen = 0
    end

    if @desc2 <> 0 begin
  
      select @asi_orden = max(asi_orden)+1 from AsientoItem where as_id = @as_id

      if @doct_id_factura = 7 /* Nota de Credito */ begin
          set @asi_debe  = 0
          set @asi_haber = @asi_haber + @descuento2
      end else begin
        if @doct_id_factura = 1 /* Factura */ or @doct_id_factura = 9 /* Nota de Debito*/ begin
            set @asi_debe = @asi_debe + @descuento2 
            set @asi_haber = 0
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
  update FacturaVenta set as_id = @as_id, fv_grabarasiento = 0 where fv_id = @@fv_id

  commit transaction

  set @@bError = 0

  if @@bSelect <> 0 select @as_id

  return
ControlError:

  set @@bError = -1

  if @@MsgError is not null set @@MsgError = @@MsgError + ';'

  set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la factura de venta. sp_DocFacturaVentaAsientoSave.'
                          
  if @@bRaiseError <> 0 begin
    raiserror (@@MsgError, 16, 1)
  end

  rollback transaction  

end