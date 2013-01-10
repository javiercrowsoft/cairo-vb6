if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockUpdateNumeroSerie2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockUpdateNumeroSerie2]

/*

  select * from parteprodkit

  sp_DocStockUpdateNumeroSerie2 64059,0

*/

go
create procedure [dbo].[sp_DocStockUpdateNumeroSerie2] (
  @@st_id           int,

  @doct_id_cliente  int,
  @id_cliente       int,
  @cli_id           int,
  @prov_id          int,
  @depl_id          int

)
as

begin

  set nocount on


    -- Ahora definimos a que proveedor y cliente pertenece

        -- TODO aca todavia falta una vuelta de tuerca para estar seguro
        -- que no hay otro movimiento posterior que envie el numero de serie
        -- a un cliente, y este movimiento que ahora estamos borrando no
        -- tiene efecto sobre el numero de serie
        --

                    /*
                    1  Factura de Venta  
                    3  Remito de Venta  
                    */
    -- Cliente
    --
    if @doct_id_cliente in (1,3) begin
    
      select @cli_id = case @doct_id_cliente
              when 1 then (select cli_id from FacturaVenta where fv_id = @id_cliente)
              when 3 then (select cli_id from RemitoVenta  where rv_id = @id_cliente)
              else null
             end

      update ProductoNumeroSerie set   depl_id        = @depl_id,
                                      cli_id         = @cli_id,
                                      doc_id_salida  = @id_cliente,
                                      doct_id_salida = @doct_id_cliente,
                                      st_id          = @@st_id
      
      where exists (select prns_id from StockItem 
                    where st_id = @@st_id 
                      and prns_id = ProductoNumeroSerie.prns_id)

    end else begin
    
                      /*
                       7  Nota de Credito Venta
                      24  Devolucion Remito Venta
                      */
      if @doct_id_cliente in (7,24) begin
        
        -- Si ya no esta en el deposito de terceros entonces lo desvinculo de cualquier cliente
        --
        update ProductoNumeroSerie set depl_id         = @depl_id,
                                       cli_id         = null, 
                                       doc_id_salida  = null,
                                       doct_id_salida = null,
                                       st_id          = @@st_id

        where exists (select prns_id from StockItem 
                      where st_id = @@st_id 
                        and prns_id = ProductoNumeroSerie.prns_id)

      -- Proveedor
      --
      end else begin
                      /*
                      2   Factura de Compra  
                      4   Remito de Compra
                      42 Orden de Servicio
                      */
  
          -- Nota: Si esta anulando el remito o la factura de compra, no me preocupo ya que
          --       en la anulacion y tambien al borrar el documento, se elimina del stock el
          --       numero de serie
          --                                                
          if @doct_id_cliente in (2,4,42) begin

            if @doct_id_cliente in (2,4) begin

              select @prov_id = case @doct_id_cliente
                                  when 2 then (select prov_id from FacturaCompra where fc_id = @id_cliente)
                                  when 4 then (select prov_id from RemitoCompra  where rc_id = @id_cliente)
                                end
              update ProductoNumeroSerie set depl_id          = @depl_id,
                                             prov_id         = @prov_id,
                                             doc_id_ingreso  = @id_cliente,
                                             doct_id_ingreso = @doct_id_cliente,
                                             st_id           = @@st_id

              where exists (select prns_id from StockItem 
                            where st_id = @@st_id 
                              and prns_id = ProductoNumeroSerie.prns_id)

            end else begin  

              select @cli_id = cli_id from OrdenServicio where os_id = @id_cliente

              update ProductoNumeroSerie set depl_id          = @depl_id,
                                             cli_id          = @cli_id,
                                             doc_id_ingreso  = @id_cliente,
                                             doct_id_ingreso = @doct_id_cliente,
                                             st_id           = @@st_id

              where exists (select prns_id from StockItem 
                            where st_id = @@st_id 
                              and prns_id = ProductoNumeroSerie.prns_id)

            end

          end else begin
                      /*
                      8   Nota de Credito de Compra  
                      25 Devolucion de Remito de Compra
                      */
            if @doct_id_cliente in (8,25) begin

              update ProductoNumeroSerie set depl_id         = @depl_id,
                                             doc_id_salida  = @id_cliente,
                                             doct_id_salida = @doct_id_cliente,
                                             st_id          = @@st_id

              where exists (select prns_id from StockItem 
                            where st_id = @@st_id 
                              and prns_id = ProductoNumeroSerie.prns_id)

            end else begin

                        /*
                        28  Recuento de Stock
                        30  Parte de Produccion
                        */
              if @doct_id_cliente in (28,30) begin

                if @depl_id = -2 begin

                  update ProductoNumeroSerie set depl_id         = @depl_id,
                                                 doc_id_salida  = @id_cliente,
                                                 doct_id_salida = @doct_id_cliente,
                                                 st_id          = @@st_id

                  where exists (select prns_id from StockItem 
                                where st_id = @@st_id 
                                  and prns_id = ProductoNumeroSerie.prns_id)

                end else begin

                  update ProductoNumeroSerie set depl_id          = @depl_id,
                                                 doc_id_ingreso  = @id_cliente,
                                                 doct_id_ingreso = @doct_id_cliente,
                                                 st_id           = @@st_id

                  where exists (select prns_id from StockItem 
                                where st_id = @@st_id 
                                  and prns_id = ProductoNumeroSerie.prns_id)
                end

              -- Cualquier otro documento (por ejemplo transferencia de stock)
              -- solo modifica el deposito
              --
              end else begin

                  update ProductoNumeroSerie set depl_id = @depl_id,
                                                 st_id   = @@st_id

                  where exists (select prns_id from StockItem 
                                where st_id = @@st_id 
                                  and prns_id = ProductoNumeroSerie.prns_id)

              end
            end
          end
      end
    end
end



