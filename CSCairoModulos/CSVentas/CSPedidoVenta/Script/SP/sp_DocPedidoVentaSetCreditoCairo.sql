if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSetCreditoCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSetCreditoCairo]

/*

 sp_DocPedidoVentaSetCreditoCairo 8

*/

go
create procedure sp_DocPedidoVentaSetCreditoCairo (
  @@pv_id      int,
  @@borrar     tinyint = 0
)
as

begin

  -- Si no hay documento adios
  --
  if @@pv_id = 0 return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @pendiente            decimal(18,6)
  declare @doct_pedidoVenta      int
  declare @cli_id               int
  declare @doct_id              int
  declare @emp_id               int

  set @doct_pedidoVenta = 5

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Datos del documento
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @cotizacion decimal(18,6)
  declare @mon_id     int
  declare @fecha      datetime
  declare @desc1       decimal(18,6)
  declare @desc2       decimal(18,6)

  select   @cli_id     = cli_id, 
          @pendiente   =  round(pv_pendiente,2), 
          @doct_id     = pv.doct_id, 
          @emp_id     = doc.emp_id,
          @mon_id     = doc.mon_id,
          @desc1        = pv_descuento1,
          @desc2        = pv_descuento2

  from PedidoVenta pv inner join Documento doc on pv.doc_id = doc.doc_id
  where pv_id = @@pv_id

  set @fecha = getdate()
  exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotizacion out

  if not exists(select * from Moneda where mon_id = @mon_id and mon_legal <> 0) begin
    if @cotizacion > 0 set @pendiente = @pendiente * @cotizacion
  end

  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc1/100)
  set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc2/100)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar referencias a este documento por otro cliente
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Siempre borro cualquier mencion a este documento en el cache de cualquier 
  -- cliente que no sea el indicado por el documento
  if exists(select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_PedidoVenta 
               and id      = @@pv_id
            ) begin

    declare @oldcli int
    declare c_oldcli insensitive cursor for 
            select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_PedidoVenta 
               and id      = @@pv_id
    open c_oldcli

    delete ClienteCacheCredito 
           where cli_id  <> @cli_id 
             and doct_id = @doct_PedidoVenta 
             and id      = @@pv_id

    fetch next from c_oldcli into @oldcli
    while @@fetch_status=0 begin

      exec sp_clienteUpdatePedidoCredito @oldcli, @emp_id

      fetch next from c_oldcli into @oldcli
    end
    close c_oldcli
    deallocate c_oldcli

  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @@borrar <> 0 begin  

      select @cli_id = cli_id from PedidoVenta where pv_id = @@pv_id      
      delete ClienteCacheCredito 
             where cli_id  = @cli_id 
               and doct_id = @doct_pedidoVenta 
               and id      = @@pv_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Insert - Update
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  end else begin

    if @doct_id = 22 /*devolucion*/ set @pendiente = -@pendiente
  
    if exists(select id from ClienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_pedidoVenta 
                and id      = @@pv_id) begin
  
      if abs(@pendiente) >= 0.01 begin

        update ClienteCacheCredito set clicc_importe = @pendiente  
               where cli_id  = @cli_id 
                 and doct_id = @doct_pedidoVenta 
                 and id      = @@pv_id

      -- Si no hay nada pendiente lo saco del cache
      end else begin   

        delete ClienteCacheCredito 
               where cli_id  = @cli_id 
                 and doct_id = @doct_pedidoVenta 
                 and id      = @@pv_id
      end
  
    end else begin
  
      -- Solo si hay algo pendiente
      if abs(@pendiente) >= 0.01 begin
        insert into ClienteCacheCredito (cli_id,doct_id,id,clicc_importe, emp_id) 
                                  values(@cli_id, @doct_pedidoVenta, @@pv_id, @pendiente, @emp_id)
      end
    end
  end -- Insertar - Actualizar


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda en cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Actualizo la deuda en la tabla Cliente
  exec sp_clienteUpdatePedidoCredito @cli_id, @emp_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @bInternalTransaction <> 0 
    commit transaction

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Fin
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Errores
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del pedido de venta. sp_DocPedidoVentaSetCreditoCairo.', 16, 1)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @bInternalTransaction <> 0 
    rollback transaction  

end
go