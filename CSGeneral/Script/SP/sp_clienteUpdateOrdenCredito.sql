if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteUpdateOrdenCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteUpdateOrdenCredito]

/*

 sp_clienteUpdateOrdenCredito 12

*/

go
create procedure sp_clienteUpdateOrdenCredito (
  @@cli_id    int,
  @@emp_id     int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_OrdenServicio      int
  declare @deudaOrdenAnterior  decimal(18,6)
  declare @deudaOrden          decimal(18,6)

  set @doct_OrdenServicio = 5

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Deuda en el cache
  --
  select @deudaOrden = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_OrdenServicio and cli_id = @@cli_id

  -- Deuda en el Cliente
  --
  select @deudaOrdenAnterior = cli_deudaOrden from Cliente where cli_id = @@cli_id

  update Cliente set 
                    cli_deudaOrden = IsNull(@deudaOrden,0), 
                    cli_deudaTotal   = cli_deudaTotal - IsNull(@deudaOrdenAnterior,0) + IsNull(@deudaOrden,0)
        where cli_id = @@cli_id

  -- Actualizo la deuda en la tabla EmpresaClienteDeuda
  --
  select @deudaOrden         = 0, 
         @deudaOrdenAnterior = 0

  -- Deuda en el cache para la empresa del documento modificado
  --
  select @deudaOrden = sum(clicc_importe) from ClienteCacheCredito where  doct_id = @doct_OrdenServicio 
                                                                         and cli_id = @@cli_id
                                                                         and emp_id = @@emp_id

  declare @empclid_id int
  select @empclid_id = empclid_id from EmpresaClienteDeuda where   cli_id = @@cli_id
                                                              and emp_id = @@emp_id
  if isnull(@empclid_id,0)<>0 begin

    select @deudaOrdenAnterior = empclid_deudaOrden from EmpresaClienteDeuda where empclid_id = @empclid_id
  
    update EmpresaClienteDeuda set 
                      empclid_deudaOrden = IsNull(@deudaOrden,0),
                      empclid_deudaTotal   =   empclid_deudaTotal 
                                            - IsNull(@deudaOrdenAnterior,0) 
                                            + IsNull(@deudaOrden,0)
          where empclid_id = @empclid_id

  end else begin

    exec sp_dbgetnewid 'EmpresaClienteDeuda', 'empclid_id', @empclid_id out, 0

    insert into EmpresaClienteDeuda (empclid_id,  cli_id,   emp_id,   empclid_deudaOrden,    empclid_deudaTotal)
                            values  (@empclid_id, @@cli_id, @@emp_id, IsNull(@deudaOrden,0), IsNull(@deudaOrden,0))

  end
end
go