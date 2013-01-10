if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteUpdateManifiestoCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteUpdateManifiestoCredito]

/*

 sp_clienteUpdateManifiestoCredito 12

*/

go
create procedure sp_clienteUpdateManifiestoCredito (
  @@cli_id    int,
  @@emp_id     int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_ManifiestoCarga       int
  declare @deudaManifiestoAnterior  decimal(18,6)
  declare @deudaManifiesto          decimal(18,6)

  set @doct_ManifiestoCarga = 20

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Deuda en el cache
  --
  select @deudaManifiesto = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_ManifiestoCarga and cli_id = @@cli_id

  -- Deuda en el Cliente
  --
  select @deudaManifiestoAnterior = cli_deudaManifiesto from Cliente where cli_id = @@cli_id

  update Cliente set 
                    cli_deudaManifiesto =  IsNull(@deudaManifiesto,0), 
                    cli_deudaTotal        =     cli_deudaTotal 
                                            - IsNull(@deudaManifiestoAnterior,0) 
                                            + IsNull(@deudaManifiesto,0)
        where cli_id = @@cli_id

  -- Actualizo la deuda en la tabla EmpresaClienteDeuda
  --
  select @deudaManifiesto          = 0, 
         @deudaManifiestoAnterior = 0

  -- Deuda en el cache para la empresa del documento modificado
  --
  select @deudaManifiesto = sum(clicc_importe) from ClienteCacheCredito where  doct_id = @doct_ManifiestoCarga 
                                                                         and cli_id = @@cli_id
                                                                         and emp_id = @@emp_id

  declare @empclid_id int
  select @empclid_id = empclid_id from EmpresaClienteDeuda where   cli_id = @@cli_id
                                                              and emp_id = @@emp_id
  if isnull(@empclid_id,0)<>0 begin

    select @deudaManifiestoAnterior = empclid_deudaManifiesto from EmpresaClienteDeuda where empclid_id = @empclid_id
  
    update EmpresaClienteDeuda set 
                      empclid_deudaManifiesto   = IsNull(@deudaManifiesto,0),
                      empclid_deudaTotal         =   empclid_deudaTotal 
                                                  - IsNull(@deudaManifiestoAnterior,0) 
                                                  + IsNull(@deudaManifiesto,0)
          where empclid_id = @empclid_id

  end else begin

    exec sp_dbgetnewid 'EmpresaClienteDeuda', 'empclid_id', @empclid_id out, 0

    insert into EmpresaClienteDeuda (empclid_id,  cli_id,   emp_id,   empclid_deudaManifiesto,    empclid_deudaTotal)
                            values  (@empclid_id, @@cli_id, @@emp_id, IsNull(@deudaManifiesto,0), IsNull(@deudaManifiesto,0))

  end
end
go