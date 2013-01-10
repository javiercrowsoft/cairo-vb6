if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ProductoNumeroUpdateOrdenServicio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoNumeroUpdateOrdenServicio]
GO

/*

*/

create procedure sp_ProductoNumeroUpdateOrdenServicio (
  @@prns_id       int,
  @@pr_id          int,
  @@bSetPrecio    tinyint = 0,
  @bSuccess        tinyint = 0 out
)
as
begin

  set nocount on

  begin transaction

  --//////////////////////////////////////////////////////////////////////////////////////////////////
  --
  -- Precios
  --
  --//////////////////////////////////////////////////////////////////////////////////////////////////

  set @bSuccess = 0

  declare @lp_id           int
  declare @cfg_valor       varchar(5000) 
  declare @precio         decimal(18,6)
  declare @bUpdateTotal   tinyint

      -- Precios
      --
      exec sp_Cfg_GetValor  'Catalogo Web',
                            'Lista de Precios',
                            @cfg_valor out,
                            0
    
      if isnumeric(@cfg_valor)<>0 begin
    
        set @lp_id = convert(int,@cfg_valor)

      end

  --//////////////////////////////////////////////////////////////////////////////////////////////////
  --
  -- Orden de Servicio
  --
  --//////////////////////////////////////////////////////////////////////////////////////////////////

  --////////////////////////////////////////////////////////////
  --
  -- Regeneramos los items de la orden de servicio para que tenga
  -- tantos items como pr_id distintos entre sus prns_id
  --
  -- Esto se hace en base a un prns_id por ende solo hay que editar
  -- el osi_id donde se econtraba el prns_id y el nuevo osi_id que
  -- contendra unicamente a este prns_id es decir que osi_cantidad = 1
  --
  -- Esto impacta en cualquier aplicacion que pueda tener la orden de
  -- servicio
  --

  declare  @os_id int,
          @osi_id int,
          @osi_orden int,
          @osi_cantidad decimal(18,6),
          @osi_cantidadaremitir decimal(18,6),
          @osi_pendiente decimal(18,6),
          @osi_descrip varchar(255),
          @osi_precio decimal(18,6),
          @osi_precioUsr decimal(18,6),
          @osi_precioLista decimal(18,6),
          @osi_descuento varchar(255),
          @osi_neto decimal(18,6),
          @osi_ivari decimal(18,6),
          @osi_ivarni decimal(18,6),
          @osi_ivariporc decimal(18,6),
          @osi_ivarniporc decimal(18,6),
          @osi_importe decimal(18,6),
          @pr_id int,
          @ccos_id int,
          @stl_id int,
          @tar_id int,
          @cont_id int,
          @etf_id int,
          @cli_id int

  declare @bIvari  smallint,
          @bIvarni smallint

  declare @os_neto           decimal(18,6),
          @os_ivari         decimal(18,6),
          @os_ivarni         decimal(18,6),
          @os_subtotal       decimal(18,6),
          @desc1             decimal(18,6),
          @desc2             decimal(18,6),
          @os_importedesc1   decimal(18,6),
          @os_importedesc2   decimal(18,6)

  declare @osi_id_new       int,
          @osrv_id          int,
          @rvi_id           int,
          @osrv_cantidad    decimal(18,6)

  declare c_osi insensitive cursor for

          select 
                os.cli_id,
                osi.os_id,
                osi.osi_id,
                osi.osi_orden,
                osi.osi_cantidad,
                osi.osi_cantidadaremitir,
                osi.osi_pendiente,
                osi.osi_descrip,
                osi.osi_precio,
                osi.osi_precioUsr,
                osi.osi_precioLista,
                osi.osi_descuento,
                osi.osi_neto,
                osi.osi_ivari,
                osi.osi_ivarni,
                osi.osi_ivariporc,
                osi.osi_ivarniporc,
                osi.osi_importe,
                osi.pr_id,
                osi.ccos_id,
                osi.stl_id,
                osi.tar_id,
                osi.cont_id,
                osi.etf_id

          from OrdenServicioItem osi inner join ordenservicio os on osi.os_id = os.os_id
          where exists (
            select *
            from StockItem sti 
            where sti.sti_grupo = osi.osi_id
              and sti.prns_id    = @@prns_id
            )
            and pr_id <> @@pr_id -- Solo los que tienen distinto pr_id

  open c_osi

  fetch next from c_osi into 
                                      @cli_id,
                                      @os_id,
                                      @osi_id,
                                      @osi_orden,
                                      @osi_cantidad,
                                      @osi_cantidadaremitir,
                                      @osi_pendiente,
                                      @osi_descrip,
                                      @osi_precio,
                                      @osi_precioUsr,
                                      @osi_precioLista,
                                      @osi_descuento,
                                      @osi_neto,
                                      @osi_ivari,
                                      @osi_ivarni,
                                      @osi_ivariporc,
                                      @osi_ivarniporc,
                                      @osi_importe,
                                      @pr_id,
                                      @ccos_id,
                                      @stl_id,
                                      @tar_id,
                                      @cont_id,
                                      @etf_id
  while @@fetch_status = 0
  begin

    -- El precio se debe modificar siempre que se cambie el
    -- producto, ya que sino el articulo queda con el precio
    -- del producto anterior. Ej. si entra una solicitud
    -- de servicio con precio en 0 y se convierte en un
    -- articulo con precio 100 y luego lo volvemos a cambiar
    -- a otro articulo con precio 10, el precio va a quedar
    -- en 100 y esto es un error.
    --
    -- if @osi_precio = 0 and @lp_id is not null begin

    if @lp_id is not null begin

      set @precio = 0
      exec sp_LpGetPrecio @lp_id, @@pr_id, @precio out

    end else begin

      set @precio = 0 -- Si no tengo lista de precio pongo el precio en cero
                      -- para que el sistema alerte al usuario al momento de
                      -- facturarlo
    end

    -- Si la cantidad es mayor a 1 debo:
    --
    --   - crear un nuevo osi_id
    --   - modificar la aplicacion con remitos
    --   - modificar sti_grupo en stockitem
    --   - restar uno a osi_cantidad y si osi_cantidad = 0 borrar osi_id
    --
    if @osi_cantidad > 1 begin
      
      -- Como ya explique arriba, el precio
      -- se modifica siempre
      --
      --if @osi_precio = 0 and @precio <> 0
      --begin
            set @osi_precio       = @precio
            set @osi_precioUsr    = @precio
            set @osi_precioLista  = @precio
            set @bUpdateTotal     =  1
      --end
      --else  set @bUpdateTotal = 0

      set @osi_cantidad = 1
      set @osi_cantidadaremitir = 1

      -- neto
      set @osi_neto = @osi_precio * @osi_cantidad

      -- Obtengo los porcentajes de iva
      set @osi_ivariporc = 0
      select @osi_ivariporc = ti_porcentaje
      from Producto pr inner join TasaImpositiva ti on pr.ti_id_ivariventa = ti.ti_id
      where pr.pr_id = @pr_id

      set @osi_ivarniporc = 0
      select @osi_ivarniporc = ti_porcentaje
      from Producto pr inner join TasaImpositiva ti on pr.ti_id_ivarniventa = ti.ti_id
      where pr.pr_id = @pr_id

      set @osi_ivariporc   = isnull(@osi_ivariporc,0)
      set @osi_ivarniporc = isnull(@osi_ivarniporc,0)

      -- Determino si el cliente lleva iva
      exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
      if @@error <> 0 goto ControlError

      set @osi_ivari   = 0
      set @osi_ivarni  = 0

      if @bIvari <> 0
            set @osi_ivari = (@osi_neto * @osi_ivariporc) / 100

      if @bIvarni <> 0 
            set @osi_ivarni = (@osi_neto * @osi_ivarniporc) / 100

      set @osi_importe = @osi_neto + @osi_ivari + @osi_ivarni

      -- El pendiente se actualiza despues
      --
      set @osi_pendiente = 1

      exec sp_dbgetnewid 'OrdenServicioItem','osi_id',@osi_id_new out, 0
      if @@error <> 0 goto ControlError

      Insert into OrdenServicioItem (
                                      os_id,
                                      osi_id,
                                      osi_orden,
                                      osi_cantidad,
                                      osi_cantidadaremitir,
                                      osi_pendiente,
                                      osi_descrip,
                                      osi_precio,
                                      osi_precioUsr,
                                      osi_precioLista,
                                      osi_descuento,
                                      osi_neto,
                                      osi_ivari,
                                      osi_ivarni,
                                      osi_ivariporc,
                                      osi_ivarniporc,
                                      osi_importe,
                                      pr_id,
                                      ccos_id,
                                      stl_id,
                                      tar_id,
                                      cont_id,
                                      etf_id
                                    )
                            values (
                                      @os_id,
                                      @osi_id_new,
                                      @osi_orden,
                                      @osi_cantidad,
                                      @osi_cantidadaremitir,
                                      @osi_pendiente,
                                      @osi_descrip,
                                      @osi_precio,
                                      @osi_precioUsr,
                                      @osi_precioLista,
                                      @osi_descuento,
                                      @osi_neto,
                                      @osi_ivari,
                                      @osi_ivarni,
                                      @osi_ivariporc,
                                      @osi_ivarniporc,
                                      @osi_importe,
                                      @@pr_id,
                                      @ccos_id,
                                      @stl_id,
                                      @tar_id,
                                      @cont_id,
                                      @etf_id
                                    )

      -- Ahora actualizamos osi_cantidad
      --
      update OrdenServicioItem 
        set osi_cantidad = osi_cantidad -1, 
            osi_cantidadaremitir = osi_cantidadaremitir -1,
            osi_pendiente = osi_pendiente -1

      where osi_id = @osi_id
      if @@error <> 0 goto ControlError

      -- Ahora actualizamos osi_pendiente
      --
      if exists(select * from OrdenRemitoVenta where osi_id = @osi_id)
      begin

        select   @osrv_id         = osrv_id, 
                @osrv_cantidad   = osrv_cantidad,
                @rvi_id         = rvi_id

        from OrdenRemitoVenta 
        where osi_id = @osi_id

        exec sp_dbgetnewid 'OrdenRemitoVenta','osrv_id',@osrv_id out, 0
        if @@error <> 0 goto ControlError

        insert into OrdenRemitoVenta (osrv_id,
                                      osrv_cantidad,
                                      osi_id,
                                      rvi_id
                                    )
                            values (  @osrv_id,
                                      1,
                                      @osi_id_new,
                                      @rvi_id
                                    )

        if @osrv_cantidad = 1 begin

          delete OrdenRemitoVenta where osrv_id = @osrv_id
          if @@error <> 0 goto ControlError

        end

        update OrdenServicioItem set osi_pendiente = 0 where osi_id = @osi_id_new
        if @@error <> 0 goto ControlError

      end

      -- Ahora vamos por stockitem
      --
      update StockItem set sti_grupo = @osi_id_new
      where sti_grupo   = @osi_id
        and prns_id      = @@prns_id
      if @@error <> 0 goto ControlError

      -- Finalmente actualizo el total de la OS
      --
      if @bUpdateTotal <> 0 begin

        -- Obtengo lo que dicen los items
        --
        select @os_neto   = sum(osi_neto),
               @os_ivari   = sum(osi_ivari),
               @os_ivarni = sum(osi_ivarni)

        from OrdenServicioItem 
        where os_id = @os_id

        -- El subtotal es el neto
        set @os_subtotal = @os_neto
        
        -- Obtengo los descuentos
        select @desc1 = os_descuento1, @desc2 = os_descuento2
        from OrdenServicio
        where os_id = @os_id

        -- Le aplico descuentos a iva y neto
        --
        set @os_ivari  = @os_ivari  - (@os_ivari * @desc1 / 100)
        set @os_ivarni = @os_ivarni - (@os_ivarni * @desc1 / 100)
        
        set @os_ivari  = @os_ivari  - (@os_ivari * @desc2 / 100)
        set @os_ivarni = @os_ivarni - (@os_ivarni * @desc2 / 100)
        
        set @os_importedesc1 = @os_neto * @desc1 / 100
        
        set @os_neto = @os_neto - @os_importedesc1
        
        set @os_importedesc2 = @os_neto * @desc2 / 100
        
        set @os_neto = @os_neto - @os_importedesc2

        update OrdenServicio set   os_subtotal     = @os_subtotal,
                                  os_neto         = @os_neto,
                                  os_ivari         = @os_ivari,
                                  os_ivarni       = @os_ivarni,
                                  os_importedesc1 = @os_importedesc1,
                                  os_importedesc2 = @os_importedesc2,
                                  os_total         = @os_Neto + @os_IvaRni + @os_IvaRi
        where os_id = @os_id
        if @@error <> 0 goto ControlError

      end

    end else begin

      -- Como ya explique arriba, el precio
      -- se modifica siempre
      --
      --if @osi_precio = 0 and @precio <> 0
      --begin
            set @osi_precio       = @precio
            set @osi_precioUsr    = @precio
            set @osi_precioLista  = @precio
            set @bUpdateTotal     =  1
      --end
      --else  set @bUpdateTotal = 0

      --////////////////////////////////////////////////////////////////////////////////////

        set @osi_cantidad = 1
        set @osi_cantidadaremitir = 1
  
        -- neto
        set @osi_neto = @osi_precio * @osi_cantidad
  
        -- Obtengo los porcentajes de iva
        set @osi_ivariporc = 0
        select @osi_ivariporc = ti_porcentaje
        from Producto pr inner join TasaImpositiva ti on pr.ti_id_ivariventa = ti.ti_id
        where pr.pr_id = @pr_id
  
        set @osi_ivarniporc = 0
        select @osi_ivarniporc = ti_porcentaje
        from Producto pr inner join TasaImpositiva ti on pr.ti_id_ivarniventa = ti.ti_id
        where pr.pr_id = @pr_id
  
        set @osi_ivariporc   = isnull(@osi_ivariporc,0)
        set @osi_ivarniporc = isnull(@osi_ivarniporc,0)
  
        -- Determino si el cliente lleva iva
        exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
        if @@error <> 0 goto ControlError
  
        set @osi_ivari   = 0
        set @osi_ivarni  = 0
  
        if @bIvari <> 0
              set @osi_ivari = (@osi_neto * @osi_ivariporc) / 100
  
        if @bIvarni <> 0 
              set @osi_ivarni = (@osi_neto * @osi_ivarniporc) / 100
  
        set @osi_importe = @osi_neto + @osi_ivari + @osi_ivarni
  
        -- El pendiente se actualiza despues
        --
        set @osi_pendiente = 1

      --////////////////////////////////////////////////////////////////////////////////////

      -- Solo necesito actualizar el renglon
      --
      update OrdenServicioItem set   pr_id                   = @@pr_id,  
                                    osi_cantidad            = 1,
                                    osi_cantidadaremitir    = 1,
                                    osi_precio              = @osi_precio,
                                    osi_precioUsr            = @osi_precioUsr,
                                    osi_precioLista          = @osi_precioLista,
                                    osi_neto                = @osi_neto,
                                    osi_ivari                = @osi_ivari,
                                    osi_ivarni              = @osi_ivarni,
                                    osi_ivariporc            = @osi_ivariporc,
                                    osi_ivarniporc          = @osi_ivarniporc,
                                    osi_importe              = @osi_importe

      where osi_id = @osi_id
      if @@error <> 0 goto ControlError

      --///////////////////////////////////////////////////////////////////////////////////
      -- Finalmente actualizo el total de la OS
      --

      if @bUpdateTotal <> 0 begin

        -- Obtengo lo que dicen los items
        --
        select @os_neto   = sum(osi_neto),
               @os_ivari   = sum(osi_ivari),
               @os_ivarni = sum(osi_ivarni)

        from OrdenServicioItem 
        where os_id = @os_id

        -- El subtotal es el neto
        set @os_subtotal = @os_neto
        
        -- Obtengo los descuentos
        select @desc1 = os_descuento1, @desc2 = os_descuento2
        from OrdenServicio
        where os_id = @os_id

        -- Le aplico descuentos a iva y neto
        --
        set @os_ivari  = @os_ivari  - (@os_ivari * @desc1 / 100)
        set @os_ivarni = @os_ivarni - (@os_ivarni * @desc1 / 100)
        
        set @os_ivari  = @os_ivari  - (@os_ivari * @desc2 / 100)
        set @os_ivarni = @os_ivarni - (@os_ivarni * @desc2 / 100)
        
        set @os_importedesc1 = @os_neto * @desc1 / 100
        
        set @os_neto = @os_neto - @os_importedesc1
        
        set @os_importedesc2 = @os_neto * @desc2 / 100
        
        set @os_neto = @os_neto - @os_importedesc2

        update OrdenServicio set   os_subtotal     = @os_subtotal,
                                  os_neto         = @os_neto,
                                  os_ivari         = @os_ivari,
                                  os_ivarni       = @os_ivarni,
                                  os_importedesc1 = @os_importedesc1,
                                  os_importedesc2 = @os_importedesc2,
                                  os_total         = @os_Neto + @os_IvaRni + @os_IvaRi
        where os_id = @os_id
        if @@error <> 0 goto ControlError

      end

      --///////////////////////////////////////////////////////////////////////////////////
    end

    fetch next from c_osi into 
                                        @cli_id,
                                        @os_id,
                                        @osi_id,
                                        @osi_orden,
                                        @osi_cantidad,
                                        @osi_cantidadaremitir,
                                        @osi_pendiente,
                                        @osi_descrip,
                                        @osi_precio,
                                        @osi_precioUsr,
                                        @osi_precioLista,
                                        @osi_descuento,
                                        @osi_neto,
                                        @osi_ivari,
                                        @osi_ivarni,
                                        @osi_ivariporc,
                                        @osi_ivarniporc,
                                        @osi_importe,
                                        @pr_id,
                                        @ccos_id,
                                        @stl_id,
                                        @tar_id,
                                        @cont_id,
                                        @etf_id
  end

  close c_osi
  deallocate c_osi

  --////////////////////////////////////////////////////////////////////////////////////////////

  commit transaction

  set @bSuccess = 1

  return
ControlError:

  declare @MsgError varchar(5000)

  set @MsgError = 'Ha ocurrido un error al cambiar el articulo asociado al numero de serie. sp_ProductoNumeroUpdateOrdenServicio.'
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO