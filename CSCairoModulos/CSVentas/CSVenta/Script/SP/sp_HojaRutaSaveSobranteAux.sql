if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaSaveSobranteAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaSaveSobranteAux]

go

create procedure sp_HojaRutaSaveSobranteAux (
  @@hr_id              int,
  @@mf_id_sobrante     int out,
  @@mf_nrodoc          varchar(50) out,
  @@sobrante           decimal(18,6),
  @@emp_id            int,
  @@us_id              int,
  @@cli_id            int,
  @@bsuccess          tinyint out
)
as

begin

  set @@mf_id_sobrante   = isnull(@@mf_id_sobrante,0)
  set @@mf_nrodoc        = isnull(@@mf_nrodoc,'')
  set @@bsuccess         = 0

  -- 0 valido que tengo todos los datos necesarios para hacer el movimiento de fondos
  -- 1 cargo una temporal
  -- 2 llamo al spDocMovimientoFondoSave

------------------------------------------------------------------------------------------------------------

  -- 0 valido que tengo todos los datos necesarios para hacer el movimiento de fondos

  declare @doc_id int
  declare @cue_id int

  declare @cfg_valor varchar(5000) 

  exec sp_Cfg_GetValor  'Ventas-General',
                        'Mov. Fondo Sobrante en Hoja Ruta',
                        @cfg_valor out,
                        0,
                        @@emp_id

  set @cfg_valor = IsNull(@cfg_valor,0)
  set @doc_id = convert(int,@cfg_valor)

  if @doc_id = 0 begin

    select 0 as result, 'Debe indicar un documento de movimientos de fondos para registrar el monto sobrante en rendiciones.' as info
    set @@bsuccess = 0
    return

  end

  exec sp_Cfg_GetValor  'Ventas-General',
                        'Cuenta para Sobrante en Rendicion',
                        @cfg_valor out,
                        0,
                        @@emp_id

  set @cfg_valor = IsNull(@cfg_valor,0)
  set @cue_id = convert(int,@cfg_valor)

  if @cue_id = 0 begin

    select 0 as result, 'Debe indicar una cuenta contable para registrar el monto sobrante en rendiciones.' as info
    set @@bsuccess = 0
    return

  end

  declare @cue_id_caja int
  declare @cj_id       int

  select @cj_id = min(cj_id) from CajaCajero where us_id = @@us_id

  if @cj_id = 0 begin

    select 0 as result, 'El usuario que esta generando la recepcion de la hoja de ruta debe estar asociado a una caja.' as info
    set @@bsuccess = 0
    return

  end

  select @cue_id_caja = cue_id_trabajo
  from CajaCuenta cj inner join cuenta cue on cj.cue_id_trabajo = cue.cue_id and cue_esefectivo <> 0 and cuec_id = 14 -- caja
  where cj_id = @cj_id

  if @cue_id = 0 begin

    select 0 as result, 'Debe indicar una cuenta contable para registrar el monto sobrante en rendiciones.' as info
    set @@bsuccess = 0
    return

  end

------------------------------------------------------------------------------------------------------------

  -- 1 cargo una temporal

  declare @mfTMP_id int

  declare @mf_nrodoc      varchar(50)
  declare @mf_descrip      varchar(255)
  declare @mf_fecha        datetime
  declare @suc_id          int
  declare @modifico       int
  declare @mf_total        decimal(18,6)

  set @mf_total    = @@sobrante
  set @modifico   = @@us_id

  select   @suc_id     = suc_id,
          @mf_fecha   = hr_fechaentrega,
          @mf_descrip = 'Generado por sobrante de cobranzas en hoja de ruta [' + hr_nrodoc + '] del ' + convert(varchar, hr_fecha, 105)

  from HojaRuta
  where hr_id = @@hr_id

  --------------------------------------------------------------------------------------------------------

  -- // Talonario

    if @@mf_nrodoc = '' begin
    
      declare @ta_nrodoc       varchar(100)
      declare @ta_id           int
  
      select @ta_id = ta_id from Documento where doc_id = @doc_id
    
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
    
      set @mf_nrodoc = @ta_nrodoc
  
    end else     
  
      set @mf_nrodoc = @@mf_nrodoc

    --////////////////////////////////////////////////////////////////////////////////  
  
    exec sp_dbgetnewid 'MovimientoFondoTMP', 'mfTMP_id', @mfTMP_id out, 0
  
    set @mf_fecha = convert(varchar,getdate(),112)  

    insert into MovimientoFondoTMP (
                                  mfTMP_id,
                                  mf_id,
                                  mf_numero,
                                  mf_nrodoc,
                                  mf_descrip,
                                  mf_fecha,
                                  cli_id,
                                  suc_id,
                                  doc_id,
                                  lgj_id,
                                  mf_total,
                                  mf_grabarasiento,
                                  est_id,
                                  modifico
                                )
  
      values (
                                  @mfTMP_id,
                                  @@mf_id_sobrante,  -- mf_id,
                                  0,                 -- mf_numero,
                                  @mf_nrodoc,
                                  @mf_descrip,
                                  @mf_fecha,
                                  @@cli_id,
                                  @suc_id,
                                  @doc_id,
                                  null,   -- lgj_id,
                                  @mf_total,
                                  1,       -- mf_grabarasiento,
                                  1,       -- est_id = pendiente
                                  @modifico
              )

    --/////////////////////////////////////////////////////////////////////////////////////////////
    --
    -- ITEMS
    --
    --/////////////////////////////////////////////////////////////////////////////////////////////
  
    declare @mfiTMP_id int
    declare @mfi_id    int

    if @@mf_id_sobrante <> 0 select @mfi_id = mfi_id from MovimientoFondoItem where mf_id = @@mf_id_sobrante

    exec sp_dbgetnewid 'MovimientoFondoItemTMP', 'mfiTMP_id', @mfiTMP_id out, 0

    insert into MovimientoFondoItemTMP (
                                        mfiTMP_id,
                                        mfi_id,
                                        mfi_importe,
                                        cue_id_debe,
                                        cue_id_haber,
                                        mfi_orden,
                                        mfi_tipo,
                                        mfTMP_id
                                    )
      values (
                                        @mfiTMP_id,
                                        isnull(@mfi_id,0),
                                        @mf_total,   -- mfi_neto,
                                        @cue_id_caja,
                                        @cue_id,
                                        1,          -- mfi_orden,
                                        2,          -- mfi_tipo
                                        @mfTMP_id
              )    

------------------------------------------------------------------------------------------------------------

  -- 2 llamo al spDocMovimientoFondoSave

    declare @mf_id int

    exec sp_DocMovimientoFondoSave  @mfTMP_id,
                                    0,
                                    @mf_id out,
                                    @@bSuccess out

    if @@bSuccess <> 0 begin

      update HojaRuta set mf_id_sobrante = @mf_id where hr_id = @@hr_id

      set @@mf_id_sobrante = @mf_id
      set @@mf_nrodoc      = @mf_nrodoc
    end
  
end

go