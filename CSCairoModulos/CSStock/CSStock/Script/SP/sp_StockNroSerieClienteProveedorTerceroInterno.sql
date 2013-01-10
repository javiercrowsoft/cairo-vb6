/*

- Todos los numeros de serie que figuran en StockItem donde el deposito de salida es tercero, es por
  que se compraron, y por lo tanto tienen un proveedor asociado

- Solo aquellos numeros de serie que estan en el deposito tercero pertenecen a un cliente

- Para encontrar el proveedor debo buscar el movimiento que ingreso a mi stock ese numero de serie

- 
*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockNroSerieClienteProveedorTerceroInterno]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockNroSerieClienteProveedorTerceroInterno]
go

-- sp_StockNroSerieClienteProveedorTerceroInterno 4193

create procedure sp_StockNroSerieClienteProveedorTerceroInterno (
 @@prns_id int = 0
)
as

begin

  set nocount on
  
  declare @prns_id         int
  declare @prov_id         int
  declare @cli_id          int
  declare @st_id           int
  declare @doct_id_cliente int
  declare @id_cliente      int

  declare c_prns_prov insensitive cursor for
  select prns_id from ProductoNumeroSerie ps
  where (prns_id = @@prns_id or @@prns_id = 0)
    and (depl_id not in (-2,-3))
    and exists(select * from StockItem where prns_id = ps.prns_id group by prns_id having count(*)>2)

  
  open c_prns_prov
  
  fetch next from c_prns_prov into @prns_id
  while @@fetch_status = 0 
  begin
  
    set @prov_id          = null
    set @st_id            = null
    set @prov_id          = null
    set @doct_id_cliente  = null
    set @id_cliente       = null

    select @st_id = st_id from StockItem where prns_id = @prns_id and sti_salida > 0 and depl_id = -3
                                  /*
                                  2  Factura de Compra  
                                  4  Remito de Compra  
                                  */
    select @prov_id = case doct_id_cliente
            when 2 then (select prov_id from FacturaCompra where fc_id = id_cliente)
            when 4 then (select prov_id from RemitoCompra  where rc_id = id_cliente)
            else null
           end,
           @doct_id_cliente = doct_id_cliente,
           @id_cliente      = id_cliente

    from Stock where st_id = @st_id
  
    update ProductoNumeroSerie set 
                                    prov_id         = @prov_id,
                                    doc_id_ingreso  = @id_cliente,
                                    doct_id_ingreso = @doct_id_cliente
    where prns_id = @prns_id
  
    fetch next from c_prns_prov into @prns_id
  end
  
  close c_prns_prov
  deallocate c_prns_prov
  
  --////////////////////////////////////////////////////////////////////////////////////////////////
  -- Clientes
  
  declare c_prns_cli insensitive cursor for
    select prns_id from ProductoNumeroSerie where depl_id = -3 and (prns_id = @@prns_id or @@prns_id = 0)
  
  open c_prns_cli
  
  fetch next from c_prns_cli into @prns_id
  while @@fetch_status = 0 
  begin

    set @st_id           = null
    set @cli_id          = null
    set @id_cliente      = null
    set @doct_id_cliente = null

    select top 1 @st_id = st_id from StockItem where prns_id = @prns_id and sti_ingreso > 0 and depl_id = -3 order by st_id desc
                                  /*
                                  1  Factura de Venta  
                                  3  Remito de Venta  
                                  */
    select @cli_id = case doct_id_cliente
            when 1 then (select cli_id from FacturaVenta where fv_id = id_cliente)
            when 3 then (select cli_id from RemitoVenta  where rv_id = id_cliente)
            else null
           end,
           @doct_id_cliente = doct_id_cliente,
           @id_cliente      = id_cliente

    from Stock where st_id = @st_id
  
    update ProductoNumeroSerie set 
                                    cli_id         = @cli_id,
                                    doc_id_salida  = @id_cliente,
                                    doct_id_salida = @doct_id_cliente
    where prns_id = @prns_id
  
    fetch next from c_prns_cli into @prns_id
  end
  
  close c_prns_cli
  deallocate c_prns_cli

end
go