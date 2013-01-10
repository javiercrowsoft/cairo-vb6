if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaCancelar ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaCancelar ]

/*

begin transaction

exec sp_DocRemitoVentaCancelar 1,1,165

rollback transaction

*/

go
create procedure sp_DocRemitoVentaCancelar  (
  @@us_id     int,
  @@emp_id     int,
  @@rv_id      int
)
as

begin

  set nocount on

  -- Valido que el documento no mueva stock
  -- Esta versio solo hace remitos por concepto
  --

  declare @doc_id int

  declare @cfg_valor varchar(5000) 
  declare @clave     varchar(255)

  set @clave = 'Documento Cancelacion de Remito Vta_' + convert(varchar,@@us_id)
  exec sp_Cfg_GetValor  'Usuario-Config',
                        @clave,
                        @cfg_valor out,
                        0,
                        @@emp_id

  set @cfg_valor = IsNull(@cfg_valor,0)
  set @doc_id = convert(int,@cfg_valor)

  if @doc_id = 0 begin

    raiserror ('@@ERROR_SP:Debe indicar un documento de cancelación de remitos en sus preferencias (use la opción Configurción \ General \ Preferencias, solapa Cancelación).', 16, 1)
    Goto fin

  end

  if exists(select * from documento where doc_id_stock is not null and doc_id = @doc_id)
  begin

    raiserror ('@@ERROR_SP:El documento de cancelación no debe mover stock. Para utilizar un documento de cancelación que mueve stock debe generar la cancelación manualmente.', 16, 1)
    Goto fin

  end

  -- 1 Cargo temporales con los mismos datos que el remito en header y solo pendientes en items
  --
  declare @cli_id int

  select @cli_id = cli_id from RemitoVenta where rv_id = @@rv_id

  declare @rvTMP_id   int

  exec sp_dbgetnewid 'RemitoVentaTMP', 'rvTMP_id', @rvTMP_id out, 0

  --/////////////////////////////////////////////////////////////////////////////////////
    
      declare @ta_nrodoc       varchar(100)
      declare @ta_id           int
  
      select @ta_id = ta_id from Documento where doc_id = @doc_id
    
      exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
      if @@error <> 0 begin
          return
      end
    
      -- Con esto evitamos que dos tomen el mismo número
      --
      exec sp_TalonarioSet @ta_id, @ta_nrodoc
      if @@error <> 0 begin
          return
      end
      
  --/////////////////////////////////////////////////////////////////////////////////////

  -- Totales

  declare @rv_neto                    decimal(18,6)
  declare @rv_ivari                    decimal(18,6)
  declare @rv_ivarni                  decimal(18,6)
  declare @rv_subtotal                decimal(18,6)
  declare @rv_total                    decimal(18,6)
  declare @rv_descuento1              decimal(18,6)
  declare @rv_descuento2              decimal(18,6)
  declare @rv_importedesc1            decimal(18,6)
  declare @rv_importedesc2            decimal(18,6)

  select   @rv_descuento1 = rv_descuento1,
          @rv_descuento2 = rv_descuento2
  from RemitoVenta
  where rv_id = @@rv_id

  select   
          @rv_ivari     = sum((rvi_ivari/rvi_cantidad)*rvi_pendientefac),
          @rv_ivarni     = sum((rvi_ivarni/rvi_cantidad)*rvi_pendientefac),
          @rv_subtotal  = sum((rvi_neto/rvi_cantidad)*rvi_pendientefac)

  from RemitoVentaItem
  where rv_id = @@rv_id
    and rvi_pendientefac > 0

  set @rv_importedesc1 = @rv_subtotal * @rv_descuento1 /100
  set @rv_neto = @rv_subtotal - @rv_importedesc1

  set @rv_importedesc2 = @rv_neto * @rv_descuento2 /100
  set @rv_neto = @rv_neto - @rv_importedesc2

  set @rv_ivari = @rv_ivari- (@rv_ivari * @rv_descuento1 /100)
  set @rv_ivari = @rv_ivari- (@rv_ivari * @rv_descuento2 /100)

  set @rv_ivarni = @rv_ivarni- (@rv_ivarni * @rv_descuento1 /100)
  set @rv_ivarni = @rv_ivarni- (@rv_ivarni * @rv_descuento2 /100)

  set @rv_total = @rv_neto + @rv_ivari + @rv_ivarni

  --/////////////////////////////////////////////////////////////////////////////////////

  insert into RemitoVentaTMP
                  (
                        rvTMP_id,
                        rv_id,
                        rv_numero,
                        rv_nrodoc,
                        rv_descrip,
                        rv_fecha,
                        rv_fechaentrega,
                        rv_neto,
                        rv_ivari,
                        rv_ivarni,
                        rv_subtotal,
                        rv_total,
                        rv_descuento1,
                        rv_descuento2,
                        rv_importedesc1,
                        rv_importedesc2,
                        rv_cotizacion,
                        est_id,
                        suc_id,
                        cli_id,
                        doc_id,
                        lp_id,
                        ld_id,
                        lgj_id,
                        cpg_id,
                        ccos_id,
                        ven_id,
                        st_id,
                        depl_id,
                        depl_id_temp,
                        pro_id_origen,
                        pro_id_destino,
                        trans_id,
                        clis_id,
                        creado,
                        modificado,
                        modifico
                  )
          select
                        @rvTMP_id,
                        0,
                        0,
                        @ta_nrodoc,
                        rv_descrip,
                        rv_fecha,
                        rv_fechaentrega,
                        @rv_neto,
                        @rv_ivari,
                        @rv_ivarni,
                        @rv_subtotal,
                        @rv_total,
                        @rv_descuento1,
                        @rv_descuento2,
                        @rv_importedesc1,
                        @rv_importedesc2,
                        rv_cotizacion,
                        est_id,
                        suc_id,
                        cli_id,
                        @doc_id,
                        lp_id,
                        ld_id,
                        lgj_id,
                        cpg_id,
                        ccos_id,
                        ven_id,
                        null,
                        null,
                        null,
                        pro_id_origen,
                        pro_id_destino,
                        trans_id,
                        clis_id,
                        rv.creado,
                        rv.modificado,
                        rv.modifico

        from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id where rv_id = @@rv_id


  declare @rviTMP_id                  int
  declare @rvi_orden                  smallint
  declare @rvi_cantidad                decimal(18,6)
  declare @rvi_cantidadaremitir        decimal(18,6)
  declare @rvi_pendiente              decimal(18,6)
  declare @rvi_pendientefac            decimal(18,6)
  declare @rvi_descrip                varchar(255)
  declare @rvi_precio                  decimal(18,6)
  declare @rvi_precioUsr              decimal(18,6)
  declare @rvi_precioLista            decimal(18,6)
  declare @rvi_descuento              varchar(100)
  declare @rvi_neto                    decimal(18,6)
  declare @rvi_ivari                  decimal(18,6)
  declare @rvi_ivarni                  decimal(18,6)
  declare @rvi_ivariporc              decimal(18,6)
  declare @rvi_ivarniporc              decimal(18,6)
  declare @rvi_importe                decimal(18,6)
  declare @pr_id                      int
  declare @ccos_id                    int

  declare c_Items insensitive cursor for select
                                                  rvi_orden,
                                                  rvi_pendientefac,
                                                  rvi_pendientefac,
                                                  rvi_pendiente,
                                                  rvi_pendientefac,
                                                  rvi_descrip,
                                                  rvi_precio,
                                                  rvi_precioUsr,
                                                  rvi_precioLista,
                                                  rvi_descuento,
                                                  (rvi_neto/rvi_cantidad)*rvi_pendientefac,
                                                  (rvi_ivari/rvi_cantidad)*rvi_pendientefac,
                                                  (rvi_ivarni/rvi_cantidad)*rvi_pendientefac,
                                                  rvi_ivariporc,
                                                  rvi_ivarniporc,
                                                  (rvi_importe/rvi_cantidad)*rvi_pendientefac,
                                                  pr_id,
                                                  ccos_id
                                          from RemitoVentaItem 
                                          where rv_id = @@rv_id 
                                            and rvi_pendientefac > 0
                                          order by rvi_orden

  open c_Items

  fetch next from c_Items into
                                  @rvi_orden,
                                  @rvi_cantidad,
                                  @rvi_cantidadaremitir,
                                  @rvi_pendiente,
                                  @rvi_pendientefac,
                                  @rvi_descrip,
                                  @rvi_precio,
                                  @rvi_precioUsr,
                                  @rvi_precioLista,
                                  @rvi_descuento,
                                  @rvi_neto,
                                  @rvi_ivari,
                                  @rvi_ivarni,
                                  @rvi_ivariporc,
                                  @rvi_ivarniporc,
                                  @rvi_importe,
                                  @pr_id,
                                  @ccos_id

  while @@fetch_status=0
  begin

    exec sp_dbgetnewid 'RemitoVentaItemTMP', 'rviTMP_id', @rviTMP_id out, 0

    insert into RemitoVentaItemTMP (
                                    rvTMP_id,
                                    rviTMP_id,
                                    rvi_id,
                                    rvi_orden,
                                    rvi_cantidad,
                                    rvi_cantidadaremitir,
                                    rvi_pendiente,
                                    rvi_pendientefac,
                                    rvi_descrip,
                                    rvi_precio,
                                    rvi_precioUsr,
                                    rvi_precioLista,
                                    rvi_descuento,
                                    rvi_neto,
                                    rvi_ivari,
                                    rvi_ivarni,
                                    rvi_ivariporc,
                                    rvi_ivarniporc,
                                    rvi_importe,
                                    rvi_importCodigo,
                                    pr_id,
                                    ccos_id

                                )
                        values  (
                                    @rvTMP_id,
                                    @rviTMP_id,
                                    0,
                                    @rvi_orden,
                                    @rvi_cantidad,
                                    @rvi_cantidadaremitir,
                                    @rvi_pendiente,
                                    @rvi_pendientefac,
                                    @rvi_descrip,
                                    @rvi_precio,
                                    @rvi_precioUsr,
                                    @rvi_precioLista,
                                    @rvi_descuento,
                                    @rvi_neto,
                                    @rvi_ivari,
                                    @rvi_ivarni,
                                    @rvi_ivariporc,
                                    @rvi_ivarniporc,
                                    @rvi_importe,
                                    '',
                                    @pr_id,
                                    @ccos_id
                                )
    fetch next from c_Items into
                                    @rvi_orden,
                                    @rvi_cantidad,
                                    @rvi_cantidadaremitir,
                                    @rvi_pendiente,
                                    @rvi_pendientefac,
                                    @rvi_descrip,
                                    @rvi_precio,
                                    @rvi_precioUsr,
                                    @rvi_precioLista,
                                    @rvi_descuento,
                                    @rvi_neto,
                                    @rvi_ivari,
                                    @rvi_ivarni,
                                    @rvi_ivariporc,
                                    @rvi_ivarniporc,
                                    @rvi_importe,
                                    @pr_id,
                                    @ccos_id
  end

  close c_Items
  deallocate c_Items

  -- Llamo a sp_DocRemitoVentaSave
  --

  declare @rv_id     int
  declare @rvrv_id  int

  exec sp_DocRemitoVentaSave @rvTMP_id, @rv_id out, 0
  if @@error <> 0 goto ControlError

  ---------------------------------------------------------------------------------------------------------------
  -- Aplicacion

  declare @rvi_id         int
  declare @rdv_id         int
  declare @rvdv_id        int

  declare c_aplicRemito insensitive cursor for 
            select rvi_id, rvi_pendientefac, rvi_orden 
            from RemitoVentaItem 
            where rv_id = @@rv_id 
              and rvi_pendientefac > 0
            order by rvi_orden

  open c_aplicRemito

  fetch next from c_aplicRemito into @rvi_id, @rvi_cantidad, @rvi_orden
  while @@fetch_status=0
  begin

    exec sp_dbgetnewid 'RemitoDevolucionVenta', 'rvdv_id', @rvdv_id out, 0

    select @rdv_id = rvi_id from RemitoVentaItem where rv_id = @rv_id and rvi_orden = @rvi_orden

    insert into RemitoDevolucionVenta (
                                      rvdv_id,
                                      rvdv_cantidad,
                                      rvi_id_devolucion,
                                      rvi_id_remito
                                    )
                            values (
                                      @rvdv_id,
                                      @rvi_cantidad,
                                      @rdv_id,
                                      @rvi_id
                                    )
    fetch next from c_aplicRemito into @rvi_id, @rvi_cantidad, @rvi_orden
  end

  close c_aplicRemito
  deallocate c_aplicRemito


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- PENDIENTE
  declare @bSuccess  tinyint

  exec sp_DocRemitoVentaSetPendiente @@rv_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

  -- Actualizo la deuda de la Pedido
  exec sp_DocRemitoVentaSetPendiente @rv_id, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  exec sp_DocRemitoVentaSetCredito @@rv_id
  if @@error <> 0 goto ControlError

  exec sp_DocRemitoVentaSetEstado @@rv_id
  if @@error <> 0 goto ControlError

  exec sp_DocRemitoVentaSetCredito @rv_id
  if @@error <> 0 goto ControlError

  exec sp_DocRemitoVentaSetEstado @rv_id
  if @@error <> 0 goto ControlError

  select 1 as result, '' as info, @rv_id as rv_id

  return
ControlError:

  select 0 as result, 'Ha ocurrido un error al grabar la devolucion de remito de venta. sp_DocRemitoVentaCancelar.' as info

fin:

end