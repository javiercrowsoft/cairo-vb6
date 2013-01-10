if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteUpdatePedidoCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteUpdatePedidoCredito]

/*

 sp_clienteUpdatePedidoCredito 12

*/

go
create procedure sp_clienteUpdatePedidoCredito (
  @@cli_id    int,
  @@emp_id     int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_PedidoVenta      int
  declare @deudaPedidoAnterior  decimal(18,6)
  declare @deudaPedido          decimal(18,6)

  set @doct_PedidoVenta = 5

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Deuda en el cache
  --
  select @deudaPedido = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_PedidoVenta and cli_id = @@cli_id

  -- Deuda en el Cliente
  --
  select @deudaPedidoAnterior = cli_deudaPedido from Cliente where cli_id = @@cli_id

  update Cliente set 
                    cli_deudaPedido = IsNull(@deudaPedido,0), 
                    cli_deudaTotal   = cli_deudaTotal - IsNull(@deudaPedidoAnterior,0) + IsNull(@deudaPedido,0)
        where cli_id = @@cli_id

  -- Actualizo la deuda en la tabla EmpresaClienteDeuda
  --
  select @deudaPedido         = 0, 
         @deudaPedidoAnterior = 0

  -- Deuda en el cache para la empresa del documento modificado
  --
  select @deudaPedido = sum(clicc_importe) from ClienteCacheCredito where  doct_id = @doct_PedidoVenta 
                                                                         and cli_id = @@cli_id
                                                                         and emp_id = @@emp_id

  declare @empclid_id int
  select @empclid_id = empclid_id from EmpresaClienteDeuda where   cli_id = @@cli_id
                                                              and emp_id = @@emp_id
  if isnull(@empclid_id,0)<>0 begin

    select @deudaPedidoAnterior = empclid_deudaPedido from EmpresaClienteDeuda where empclid_id = @empclid_id
  
    update EmpresaClienteDeuda set 
                      empclid_deudaPedido = IsNull(@deudaPedido,0),
                      empclid_deudaTotal   =   empclid_deudaTotal 
                                            - IsNull(@deudaPedidoAnterior,0) 
                                            + IsNull(@deudaPedido,0)
          where empclid_id = @empclid_id

  end else begin

    exec sp_dbgetnewid 'EmpresaClienteDeuda', 'empclid_id', @empclid_id out, 0

    insert into EmpresaClienteDeuda (empclid_id,  cli_id,   emp_id,   empclid_deudaPedido,    empclid_deudaTotal)
                            values  (@empclid_id, @@cli_id, @@emp_id, IsNull(@deudaPedido,0), IsNull(@deudaPedido,0))

  end
end
go