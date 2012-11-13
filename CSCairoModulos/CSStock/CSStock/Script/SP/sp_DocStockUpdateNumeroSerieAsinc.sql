if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockUpdateNumeroSerieAsinc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockUpdateNumeroSerieAsinc]

/*

  select * from parteprodkit

  sp_DocStockUpdateNumeroSerieAsinc 64059,0

*/

go
create procedure sp_DocStockUpdateNumeroSerieAsinc (
	@@prns_id         int,
  @@st_id         	int,
	@@bRestar       	tinyint
)
as

begin

  set nocount on

  declare @doct_id_cliente  int
  declare @id_cliente       int
	declare @modificado 			datetime
	declare @creado     			datetime
  declare @cli_id           int
  declare @prov_id          int
  declare @depl_id          int

  declare @st_id2             int
  declare @cli_id2            int
  declare @id_cliente2        int
  declare @doct_id_cliente2   int

  select 	@doct_id_cliente 	= doct_id_cliente, 
					@id_cliente 			= id_cliente,
					@modificado 			= modificado, 
					@creado 					= creado
	from Stock where st_id = @@st_id

/*-------------------------------------------------------------------

		NUEVO

---------------------------------------------------------------------*/

	-- Solo puedo usarlo si no estoy borrando o anulando
	--
	if @modificado = @creado and @@bRestar = 0 begin

	    -- Ahora definimos a que proveedor y cliente pertenece
	
	        -- TODO aca todavia falta una vuelta de tuerca para estar seguro
	        -- que no hay otro movimiento posterior que envie el numero de serie
	        -- a un cliente, y este movimiento que ahora estamos borrando no
	        -- tiene efecto sobre el numero de serie
	        --
	
	                    /*
	                    1	Factura de Venta	
	                    3	Remito de Venta	
	                    */
	    -- Cliente
	    --
	    if @doct_id_cliente in (1,3) begin
	    
        select @cli_id = case @doct_id_cliente
                when 1 then (select cli_id from FacturaVenta where fv_id = @id_cliente)
                when 3 then (select cli_id from RemitoVenta  where rv_id = @id_cliente)
                else null
               end
        if @cli_id is not null update ProductoNumeroSerie set cli_id         = @cli_id,
                                                              doc_id_salida  = @id_cliente,
                                                              doct_id_salida = @doct_id_cliente
                               where prns_id = @@prns_id

	    end else begin
			
	                      /*
	                       7	Nota de Credito Venta
	                      24	Devolucion Remito Venta
	                      */
	      if @doct_id_cliente in (7,24) begin
					
          -- Si ya no esta en el deposito de terceros entonces lo desvinculo de cualquier cliente
          --
          update ProductoNumeroSerie set cli_id         = null, 
                                         doc_id_salida  = null,
                                         doct_id_salida = null
          where prns_id = @@prns_id
	
	      -- Proveedor
	      --
	      end else begin
	                      /*
	                      2	 Factura de Compra	
	                      4	 Remito de Compra
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
								                    else null
								                  end
								if @prov_id is not null	update ProductoNumeroSerie set prov_id         = @prov_id,
										                                                   doc_id_ingreso  = @id_cliente,
										                                                   doct_id_ingreso = @doct_id_cliente
								                        where prns_id = @@prns_id
		          end else begin	

								set @cli_id = null
								select @cli_id = cli_id from OrdenServicio where os_id = @id_cliente

								if @cli_id is not null 	update ProductoNumeroSerie set cli_id          = @cli_id,
										                                                   doc_id_ingreso  = @id_cliente,
										                                                   doct_id_ingreso = @doct_id_cliente
								                        where prns_id = @@prns_id

							end

	          end else begin
	                      /*
	                      8	 Nota de Credito de Compra	
	                      25 Devolucion de Remito de Compra
	                      */
							if @doct_id_cliente in (8,25) begin
	
							  update ProductoNumeroSerie set doc_id_salida  = @id_cliente,
							                                 doct_id_salida = @doct_id_cliente
							  where prns_id = @@prns_id
	
							end else begin

		                      /*
		                      28	Recuento de Stock
		                      30	Parte de Produccion
		                      */
								if @doct_id_cliente in (28,30) begin

									if @depl_id = -2 begin

									  update ProductoNumeroSerie set doc_id_salida  = @id_cliente,
									                                 doct_id_salida = @doct_id_cliente
									  where prns_id = @@prns_id

									end else begin

									  update ProductoNumeroSerie set doc_id_ingreso  = @id_cliente,
									                                 doct_id_ingreso = @doct_id_cliente
									  where prns_id = @@prns_id
									end

								end
							end
	          end
	      end
	    end
	end
/*-------------------------------------------------------------------

		UPDATE

---------------------------------------------------------------------*/

	else begin
	
    -- Por cada uno de estos numeros de serie voy a determinar a que proveedor
    -- y a que cliente esta ligado
    --

    -- Ahora definimos a que proveedor y cliente pertenece

        -- TODO aca todavia falta una vuelta de tuerca para estar seguro
        -- que no hay otro movimiento posterior que envie el numero de serie
        -- a un cliente, y este movimiento que ahora estamos borrando no
        -- tiene efecto sobre el numero de serie
        --

                    /*
                    1	Factura de Venta	
                    3	Remito de Venta	
                    */
    -- Cliente
    --
    if @doct_id_cliente in (1,3) begin
    
      -- Si esta borrando el movimiento
      -- entonces el numero de serie ya no esta asociado al cliente
      --
      if @@bRestar <> 0 begin
        
        update ProductoNumeroSerie set  cli_id         = null,
                                        doc_id_salida  = null,
                                        doct_id_salida = null
        where prns_id = @@prns_id
			
      end else begin
			
        select @cli_id = case @doct_id_cliente
                when 1 then (select cli_id from FacturaVenta where fv_id = @id_cliente)
                when 3 then (select cli_id from RemitoVenta  where rv_id = @id_cliente)
                else null
               end
        if @cli_id is not null update ProductoNumeroSerie set cli_id         = @cli_id,
                                                              doc_id_salida  = @id_cliente,
                                                              doct_id_salida = @doct_id_cliente
                               where prns_id = @@prns_id
      end
    end else begin
		
                      /*
                       7	Nota de Credito Venta
                      24	Devolucion Remito Venta
                      */
      if @doct_id_cliente in (7,24) begin
				
        -- Si esta borrando el movimiento
        -- entonces el numero de serie se debe volver a asociar al cliente si corresponde
        --
        if @@bRestar <> 0 begin
		
          set @st_id2           = null
          set @cli_id2          = null
          set @id_cliente2      = null
          set @doct_id_cliente2 = null
      
          select top 1 @st_id2 = st_id from StockItem where prns_id = @@prns_id 
                                                        and sti_ingreso > 0 
                                                        and depl_id = -3 order by st_id desc
                                        /*
                                        1	Factura de Venta	
                                        3	Remito de Venta	
                                        */
          select @cli_id2 = case doct_id_cliente
                  when 1 then (select cli_id from FacturaVenta where fv_id = id_cliente)
                  when 3 then (select cli_id from RemitoVenta  where rv_id = id_cliente)
                  else null
                 end,
                 @doct_id_cliente2 = doct_id_cliente,
                 @id_cliente2      = id_cliente
      
          from Stock where st_id = @st_id2
        
          update ProductoNumeroSerie set 
                                          cli_id         = @cli_id2,
                                          doc_id_salida  = @id_cliente2,
                                          doct_id_salida = @doct_id_cliente2
          where prns_id = @@prns_id
			
        end else begin

          -- Si ya no esta en el deposito de terceros entonces lo desvinculo de cualquier cliente
          --
          update ProductoNumeroSerie set cli_id         = null, 
                                         doc_id_salida  = null,
                                         doct_id_salida = null
          where prns_id = @@prns_id and depl_id <> -3
        end

      -- Proveedor
      --
      end else begin
                      /*
                      2	 Factura de Compra	
                      4	 Remito de Compra
                      42 Orden de Servicio
                      */
  
          -- Nota: Si esta anulando el remito o la factura de compra, no me preocupo ya que
          --       en la anulacion y tambien al borrar el documento, se elimina del stock el
          --       numero de serie
          --                                                
          if @doct_id_cliente in (2,4,42) begin

						-- Solo si no esta borrando o anulando
						--
						if @@bRestar = 0 begin
  
							if @doct_id_cliente in (2,4) begin

								select @prov_id = case @doct_id_cliente
								                    when 2  then (select prov_id from FacturaCompra where fc_id = @id_cliente)
								                    when 4  then (select prov_id from RemitoCompra  where rc_id = @id_cliente)
								                    else null
								                  end
								if @prov_id is not null update ProductoNumeroSerie set prov_id         = @prov_id,
									                                                     doc_id_ingreso  = @id_cliente,
									                                                     doct_id_ingreso = @doct_id_cliente
									                      where prns_id = @@prns_id
							end else begin

								set @cli_id = null
								select @cli_id = cli_id from OrdenServicio where os_id = @id_cliente

								if @cli_id is not null  update ProductoNumeroSerie set cli_id          = @cli_id,
								                                                       doc_id_ingreso  = @id_cliente,
								                                                       doct_id_ingreso = @doct_id_cliente
											                  where prns_id = @@prns_id
							end
						end

          end else begin
                      /*
                      8	Nota de Credito de Compra	
                      25	Devolucion de Remito de Compra
                      */
						if @doct_id_cliente in (8,25) begin

							-- Si esta borrando el movimiento
							-- entonces el numero de serie vuelve a la empresa ya
							-- que una nota de credito de compra o una devolucion de remito
							-- de compra le envian la mercaderia al proveedor.
							--
							if @@bRestar <> 0 begin
							  
							  update ProductoNumeroSerie set  doc_id_salida  = null,
							                                  doct_id_salida = null
							  where prns_id = @@prns_id
			
							end else begin
			
							  update ProductoNumeroSerie set doc_id_salida  = @id_cliente,
							                                 doct_id_salida = @doct_id_cliente
							  where prns_id = @@prns_id
							end

						end else begin

	                      /*
	                      28	Recuento de Stock
	                      30	Parte de Produccion
	                      */
							if @doct_id_cliente in (28,30) begin

								-- Solo si no esta borrando o anulando
								--
								if @@bRestar = 0 begin

									if @depl_id = -2 begin

									  update ProductoNumeroSerie set doc_id_salida  = @id_cliente,
									                                 doct_id_salida = @doct_id_cliente
									  where prns_id = @@prns_id

									end else begin

									  update ProductoNumeroSerie set doc_id_ingreso  = @id_cliente,
									                                 doct_id_ingreso = @doct_id_cliente
									  where prns_id = @@prns_id
									end
								end
							end

						end
          end
      end
    end
	
	  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	end

end

GO