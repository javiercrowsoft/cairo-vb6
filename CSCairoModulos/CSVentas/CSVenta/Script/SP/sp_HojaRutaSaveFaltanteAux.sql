if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaSaveFaltanteAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaSaveFaltanteAux]

go

create procedure sp_HojaRutaSaveFaltanteAux (
  @@hr_id              int,
  @@fv_id_faltante     int out,
  @@fv_nrodoc          varchar(50) out,
  @@faltante           decimal(18,6),
  @@emp_id            int,
  @@us_id              int,
  @@cli_id            int,
  @@bsuccess          tinyint out
)
as

begin

  set @@fv_id_faltante   = isnull(@@fv_id_faltante,0)
  set @@fv_nrodoc        = isnull(@@fv_nrodoc,'')
  set @@bsuccess         = 0

  -- 0 valido que tengo todos los datos necesarios para hacer la factura
  -- 1 cargo una temporal
  -- 2 llamo al spDocFacturaVentaSave

------------------------------------------------------------------------------------------------------------

  -- 0 valido que tengo todos los datos necesarios para hacer la factura

  declare @doc_id int
  declare @pr_id  int

  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Ventas-General',
                        'Factura x Faltante en Hoja Ruta',
                        @cfg_valor out,
                        0,
                        @@emp_id

  set @cfg_valor = IsNull(@cfg_valor,0)
  set @doc_id = convert(int,@cfg_valor)

  if @doc_id = 0 begin

    select 0 as result, 'Debe indicar un documento de venta para la factura por faltante en rendiciones.' as info
    set @@bsuccess = 0
    return

  end

  exec sp_Cfg_GetValor  'Ventas-General',
                        'Articulo para Faltantes en Rendicion',
                        @cfg_valor out,
                        0,
                        @@emp_id

  set @cfg_valor = IsNull(@cfg_valor,0)
  set @pr_id = convert(int,@cfg_valor)

  if @pr_id = 0 begin

    select 0 as result, 'Debe indicar un producto de venta para la factura por faltante en rendiciones.' as info
    set @@bsuccess = 0
    return

  end

------------------------------------------------------------------------------------------------------------

  -- 1 cargo una temporal

  declare @fvTMP_id int

  declare @fv_nrodoc      varchar(50)
  declare @fv_descrip      varchar(255)
  declare @fv_fecha        datetime
  declare @suc_id          int
  declare @modifico       int

  declare @fv_neto            decimal(18,6)
  declare @fv_total            decimal(18,6)

  set @fv_neto     = @@faltante
  set @fv_total    = @fv_neto
  set @modifico   = @@us_id

  select   @suc_id     = suc_id,
          @fv_fecha   = hr_fechaentrega,
          @fv_descrip = 'Generada por faltante de cobranzas en hoja de ruta [' + hr_nrodoc + '] del ' + convert(varchar, hr_fecha, 105)

  from HojaRuta
  where hr_id = @@hr_id

  --------------------------------------------------------------------------------------------------------

  -- // Talonario
  
    if @@fv_nrodoc = '' begin
    
      declare @ta_nrodoc       varchar(100)
      declare @ta_id           int
      declare @cli_catfiscal  int
    
      select @cli_catfiscal = cli_catfiscal from Cliente where cli_id = @@cli_id
    
      select @ta_id = case @cli_catfiscal
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
                   end
    
      from Documento
    
      where doc_id = @doc_id
    
      exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
      if @@error <> 0 begin
          set @@bSuccess = 0
          return
      end
    
      -- Con esto evitamos que dos tomen el mismo número
      --
      exec sp_TalonarioSet @ta_id, @ta_nrodoc
      if @@error <> 0 begin
          set @@bSuccess = 0
          return
      end
    
      set @fv_nrodoc = @ta_nrodoc
  
    end else     
  
      set @fv_nrodoc = @@fv_nrodoc

    --////////////////////////////////////////////////////////////////////////////////  
  
    exec sp_dbgetnewid 'FacturaVentaTMP', 'fvTMP_id', @fvTMP_id out, 0
  
    set @fv_fecha = convert(varchar,getdate(),112)  

    insert into FacturaVentaTMP (
                                  fvTMP_id,
                                  fv_id,
                                  fv_numero,
                                  fv_nrodoc,
                                  fv_descrip,
                                  fv_fecha,
                                  fv_fechaentrega,
                                  fv_fechaiva,
                                  cli_id,
                                  suc_id,
                                  doc_id,
                                  cpg_id,
                                  lgj_id,
                                  fv_neto,
                                  fv_subtotal,
                                  fv_ivari,
                                  fv_totalpercepciones,
                                  fv_total,
                                  fv_grabarasiento,
                                  est_id,
                                  modifico
                                )
  
      values (
                                  @fvTMP_id,
                                  @@fv_id_faltante,  -- fv_id,
                                  0,                 -- fv_numero,
                                  @fv_nrodoc,
                                  @fv_descrip,
                                  @fv_fecha,
                                  @fv_fecha,
                                  @fv_fecha,
                                  @@cli_id,
                                  @suc_id,
                                  @doc_id,
                                  -2,     -- cpg_id = fecha del documento,
                                  null,   -- lgj_id,
                                  @fv_neto,
                                  @fv_neto,
                                  0,
                                  0,
                                  @fv_total,
                                  1,       -- fv_grabarasiento,
                                  1,       -- est_id = pendiente
                                  @modifico
              )

    --/////////////////////////////////////////////////////////////////////////////////////////////
    --
    -- ITEMS
    --
    --/////////////////////////////////////////////////////////////////////////////////////////////

    declare @cueg_id_venta       int
    declare @ti_id_ivariventa    int

    select @cueg_id_venta     = cueg_id_venta, 
           @ti_id_ivariventa   = ti_id_ivariventa 
    from producto where pr_id = @pr_id

    declare @cue_id int

    select @cue_id = cue_id 
    from ClienteCuentaGrupo 
    where cli_id = @@cli_id and cueg_id = @cueg_id_venta

    if @cue_id is null begin
      select @cue_id = cue_id 
      from CuentaGrupo where cueg_id = @cueg_id_venta
    end
  
    declare @cue_id_ivari int

    select @cue_id_ivari = cue_id
    from TasaImpositiva 
    where ti_id = @ti_id_ivariventa

    declare @fviTMP_id int
    declare @fvi_id    int

    if @@fv_id_faltante <> 0 select @fvi_id = fvi_id from FacturaVentaItem where fv_id = @@fv_id_faltante

    exec sp_dbgetnewid 'FacturaVentaItemTMP', 'fviTMP_id', @fviTMP_id out, 0

    insert into FacturaVentaItemTMP (
                                        fviTMP_id,
                                        fvi_id,
                                        fvi_cantidad,
                                        fvi_precio,
                                        fvi_preciousr,
                                        fvi_neto,
                                        fvi_Ivari,
                                        fvi_Ivariporc,
                                        pr_id,
                                        fvi_importe,
                                        cue_id,
                                        cue_id_IvaRI,
                                        fvi_orden,
                                        fvTMP_id,
                                        to_id
                                    )
      values (
                                        @fviTMP_id,
                                        isnull(@fvi_id,0),
                                        1,          -- fvi_cantidad,
                                        @fv_neto,   -- fvi_precio,
                                        @fv_neto,   -- fvi_preciousr,
                                        @fv_neto,   -- fvi_neto,
                                        0,          -- fvi_Ivari,
                                        0,          -- fvi_Ivariporc,
                                        @pr_id,      -- pr_id,
                                        @fv_total,  -- fvi_importe,
                                        @cue_id,
                                        @cue_id_ivari,
                                        1,          -- fvi_orden,
                                        @fvTMP_id,
                                        1
              )    

------------------------------------------------------------------------------------------------------------

  -- 2 llamo al spDocFacturaVentaSave

    declare @fv_id int

    exec sp_DocFacturaVentaSave   @fvTMP_id,
                                  0,
                                  @fv_id out,
                                  @@bSuccess out

    if @@bSuccess <> 0 begin

      update HojaRuta set fv_id_faltante = @fv_id where hr_id = @@hr_id

      set @@fv_id_faltante = @fv_id
      set @@fv_nrodoc      = @fv_nrodoc

    end
  
end

go