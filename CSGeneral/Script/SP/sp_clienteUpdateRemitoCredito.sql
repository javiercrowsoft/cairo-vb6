if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteUpdateRemitoCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteUpdateRemitoCredito]

/*

 sp_clienteUpdateRemitoCredito 12

*/

go
create procedure sp_clienteUpdateRemitoCredito (
  @@cli_id    int,
  @@emp_id     int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_remitoVenta      int
  declare @deudaRemitoAnterior  decimal(18,6)
  declare @deudaRemito          decimal(18,6)

  set @doct_remitoVenta = 3

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Deuda en el cache
  --
  select @deudaRemito = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_remitoVenta and cli_id = @@cli_id

  -- Deuda en el Cliente
  --
  select @deudaRemitoAnterior = cli_deudaRemito from Cliente where cli_id = @@cli_id

  update Cliente set 
                    cli_deudaRemito = IsNull(@deudaRemito,0), 
                    cli_deudaTotal   = cli_deudaTotal - IsNull(@deudaRemitoAnterior,0) + IsNull(@deudaRemito,0)
        where cli_id = @@cli_id

  -- Actualizo la deuda en la tabla EmpresaClienteDeuda
  --
  select @deudaRemito         = 0, 
         @deudaRemitoAnterior = 0

  -- Deuda en el cache para la empresa del documento modificado
  --
  select @deudaRemito = sum(clicc_importe) from ClienteCacheCredito where  doct_id = @doct_remitoVenta 
                                                                         and cli_id = @@cli_id
                                                                         and emp_id = @@emp_id

  declare @empclid_id int
  select @empclid_id = empclid_id from EmpresaClienteDeuda where   cli_id = @@cli_id
                                                              and emp_id = @@emp_id
  if isnull(@empclid_id,0)<>0 begin

    select @deudaRemitoAnterior = empclid_deudaRemito from EmpresaClienteDeuda where empclid_id = @empclid_id
  
    update EmpresaClienteDeuda set 
                      empclid_deudaRemito = IsNull(@deudaRemito,0),
                      empclid_deudaTotal   =   empclid_deudaTotal 
                                            - IsNull(@deudaRemitoAnterior,0) 
                                            + IsNull(@deudaRemito,0)
          where empclid_id = @empclid_id

  end else begin

    exec sp_dbgetnewid 'EmpresaClienteDeuda', 'empclid_id', @empclid_id out, 0

    insert into EmpresaClienteDeuda (empclid_id,  cli_id,   emp_id,   empclid_deudaRemito,    empclid_deudaTotal)
                            values  (@empclid_id, @@cli_id, @@emp_id, IsNull(@deudaRemito,0), IsNull(@deudaRemito,0))

  end
end
go