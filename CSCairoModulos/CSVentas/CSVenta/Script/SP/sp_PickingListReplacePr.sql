if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListReplacePr]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListReplacePr]

go

/*

begin tran
exec sp_PickingListReplacePr 1,12,13,0,''
exec sp_PickingListReplacePr 1,13,12,0,''
rollback tran

*/

create procedure sp_PickingListReplacePr (

  @@pkl_id              int,
  @@pr_id_to_find        int,
  @@pr_id_new            int,
  @@no_update_precios    smallint,
  @@strIds              varchar(5000)

)
as

begin

  set nocount on

  declare @timeCode datetime

  if @@strIds <> '' begin

    set @timeCode = getdate()
    exec sp_strStringToTable @timeCode, @@strIds, ','

  end

  -- OJO: La transaccion no debe incluir la llamada a sp_strStringToTable

  begin transaction

  if @@strIds <> '' begin

    declare c_pedidos insensitive cursor for 
  
    select 
            pv_id, 
            pvi_id 
  
    from PedidoVentaItem pvi 
            inner join TmpStringToTable 
                on pvi.pvi_id = convert(int,TmpStringToTable.tmpstr2tbl_campo)
  
    where pr_id         = @@pr_id_to_find
      and tmpstr2tbl_id = @timeCode
      and exists(select * from PickingListPedidoItem where pvi_id = pvi.pvi_id and pkl_id = @@pkl_id)

  end else begin

    declare c_pedidos insensitive cursor for 
  
    select 
            pv_id, 
            pvi_id 
  
    from PedidoVentaItem pvi 

    where pr_id = @@pr_id_to_find
      and exists(  select * 
                  from PickingListPedidoItem 
                  where pvi_id = pvi.pvi_id 
                    and pkl_id = @@pkl_id
                )
  end

  declare @pv_id         int
  declare @pvi_id       int
  declare @precio       decimal(18,6)
  declare @lp_id         int
  declare @cli_id       int
  declare @mon_id       int
  declare @error_msg     varchar(5000)

  declare @pv_nrodoc    varchar(255)
  declare @cli_nombre   varchar(5000)

  declare @ti_porcentaje decimal(18,6)
  declare @ti_porcentajerni decimal(18,6)

  select @ti_porcentaje = ti_porcentaje from Producto pr inner join TasaImpositiva ti on pr.ti_id_ivariventa = ti.ti_id where pr_id = @@pr_id_new
  select @ti_porcentajerni = ti_porcentaje from Producto pr inner join TasaImpositiva ti on pr.ti_id_ivarniventa = ti.ti_id where pr_id = @@pr_id_new

  open c_pedidos

  fetch next from c_pedidos into @pv_id, @pvi_id
  while @@fetch_status=0
  begin

    -- Primero cambio el item

    update PedidoVentaItem set pr_id = @@pr_id_new where pvi_id = @pvi_id

    -- Solo si debo actualizar el precio

    if @@no_update_precios = 0 begin

      set @lp_id = null

      select   @lp_id     = pv.lp_id, 
              @cli_id   = pv.cli_id, 
              @mon_id   = doc.mon_id 

      from PedidoVenta pv inner join Documento doc on pv.doc_id = doc.doc_id
      where pv_id = @pv_id

      if @lp_id is null
        select @lp_id = lp_id from Cliente where cli_id = @cli_id

      if @lp_id is null
        select @lp_id = lp_id from ListaPrecio 
        where lp_default <> 0 
          and lp_tipo = 1 
          and mon_id  = @mon_id

      if @lp_id is null begin

        select @pv_nrodoc = pv_nrodoc from PedidoVenta where pv_id = @pv_id
        select @cli_nombre = cli_nombre from cliente where cli_id = @cli_id

        set @error_msg ='@@ERROR_SP:No se pudo encontrar una lista de precios para el pedido ' + @pv_nrodoc + ' del cliente ' + @cli_nombre + '.'

        goto RaiseErrorListaPrecio
      end

      exec sp_lpGetPrecio @lp_id, @@pr_id_new, @precio out, 0

      select
               @ti_porcentajerni = case cli_catfiscal
                                      when 1  then 0                   --'Inscripto'
                                      when 2  then 0                   -- FALTA VERIFICAR QUE SEA ASI --'Exento'
                                      when 3  then @ti_porcentajerni   --'No inscripto'
                                      when 4  then 0                   --'Consumidor Final'
                                      when 5  then 0                   --'Extranjero'
                                      when 6  then 0                   --'Mono Tributo'
                                      when 7  then 0                   --'Extranjero Iva'
                                      when 8  then 0                   --'No responsable'
                                      when 9  then 0                   -- FALTA VERIFICAR QUE SEA ASI --'No Responsable exento'
                                      when 10 then @ti_porcentajerni   --'No categorizado'
                                      when 11 then 0                   --'InscriptoM'
                                      else         0                   --'Sin categorizar'
                                   end
      from Cliente
      where cli_id = @cli_id


      -- Cambio el precio y el importe del item
      update PedidoVentaItem set 

                  pvi_precio         = @precio,
                  pvi_precioLista   = @precio,
                  pvi_precioUsr     = @precio,
                  
                  pvi_ivariporc     = @ti_porcentaje,
                  pvi_ivari         = pvi_cantidad * @precio * @ti_porcentaje / 100,
                  
                  pvi_ivarniporc     = @ti_porcentajerni,
                  pvi_ivarni         = pvi_cantidad * @precio * @ti_porcentajerni / 100,
                  
                  pvi_neto           = pvi_cantidad * @precio,
                  pvi_importe       = pvi_cantidad * (@precio + (@precio * @ti_porcentaje / 100)
                                                              + (@precio * @ti_porcentajerni / 100)
                                                      )
      where pvi_id = @pvi_id

      -- Despues cambio el header

      declare @subtotal    decimal(18,6)
      declare @neto       decimal(18,6)

      declare @desc1       decimal(18,6)
      declare @desc2       decimal(18,6)

      declare @ivari       decimal(18,6)
      declare @ivarni      decimal(18,6)

      declare @total       decimal(18,6)

      -----------------------

      select @desc1 = pv_descuento1, @desc2 = pv_descuento2 from PedidoVenta where pv_id = @pv_id

      select   @neto   = sum(pvi_neto), 
              @ivari   = sum(pvi_ivari), 
              @ivarni = sum(pvi_ivarni) 

      from PedidoVentaItem 

      where pv_id = @pv_id

      -----------------------

      set @subtotal = @neto

      -----------------------
      set @desc1 = (@neto * @desc1 / 100)
      set @neto  = @neto - @desc1

      set @desc2 = (@neto * @desc2 / 100)
      set @neto  = @neto - @desc2

      -----------------------
      -- iva

      set @ivari = @ivari - (@ivari * @desc1 / 100)
      set @ivari = @ivari - (@ivari * @desc2 / 100)

      set @ivarni = @ivarni - (@ivarni * @desc1 / 100)
      set @ivarni = @ivarni - (@ivarni * @desc2 / 100)

      -----------------------

      set @total = @neto + @ivari + @ivarni

      update PedidoVenta set pv_subtotal      = @subtotal,
                             pv_importedesc1 = @desc1,
                             pv_importedesc2 = @desc2,
                             pv_neto          = @neto,
                             pv_ivari        = @ivari,
                             pv_ivarni        = @ivarni,
                             pv_total        = @total
      where pv_id = @pv_id
  
      declare @bSuccess tinyint

      set @bSuccess = 0

      -- Finalmente actualizo estados y cache de credito
      exec sp_DocPedidoVentaSetPendiente @pv_id, @bSuccess out

      -- Si fallo al guardar
      if IsNull(@bSuccess,0) = 0 goto RaiseErrorEstado
    
      exec sp_DocPedidoVentaSetCredito @pv_id
      if @@error <> 0 goto RaiseErrorEstado

      /*
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //                                                                                                                    //
      //                                     VALIDACIONES AL DOCUMENTO                                                      //
      //                                                                                                                    //
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      */
      
      declare @MsgError  varchar(5000) set @MsgError = ''

      -- ESTADO
        exec sp_AuditoriaEstadoCheckDocPV    @pv_id,
                                            @bSuccess  out,
                                            @MsgError out
      
        -- Si el documento no es valido
        if IsNull(@bSuccess,0) = 0 goto ControlError

      -- FECHAS
      
      -- TOTALES
        exec sp_AuditoriaTotalesCheckDocPV  @pv_id,
                                            @bSuccess  out,
                                            @MsgError out
      
        -- Si el documento no es valido
        if IsNull(@bSuccess,0) = 0 goto ControlError

      -- CREDITO
        exec sp_AuditoriaCreditoCheckDocPV  @pv_id,
                                            @bSuccess  out,
                                            @MsgError out
      
        -- Si el documento no es valido
        if IsNull(@bSuccess,0) = 0 goto ControlError

      /*
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      //                                                                                                                    //
      //                                     VALIDACIONES AL DOCUMENTO                                                      //
      //                                                                                                                    //
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      */

    end

    fetch next from c_pedidos into @pv_id, @pvi_id
  end

  close c_pedidos
  deallocate c_pedidos

  commit transaction

  return

RaiseErrorListaPrecio:

  rollback transaction

  raiserror (@error_msg, 16, 1)
  Goto fin  

RaiseErrorEstado:

  if @@trancount > 0 begin
    rollback transaction  
  end

  set @error_msg = 'Ha ocurrido un error al grabar el pedido de venta. sp_PickingListReplacePr.' 
  raiserror (@error_msg, 16, 1)
  Goto fin  

ControlError:

  if @@trancount > 0 begin
    rollback transaction  
  end

  set @MsgError = 'Ha ocurrido un error al grabar el pedido de venta. sp_PickingListReplacePr. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)
  Goto fin  
fin:

end

go