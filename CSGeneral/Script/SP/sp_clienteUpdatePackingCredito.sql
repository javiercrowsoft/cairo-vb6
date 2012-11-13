if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteUpdatePackingCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteUpdatePackingCredito]

/*

 sp_clienteUpdatePackingCredito 12

*/

go
create procedure sp_clienteUpdatePackingCredito (
	@@cli_id    int,
	@@emp_id 		int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_PackingList		 				int
	declare @deudaPackingListAnterior  decimal(18,6)
  declare @deudaPackingList          decimal(18,6)

  set @doct_PackingList = 21

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Deuda en el cache
	--
	select @deudaPackingList = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_PackingList and cli_id = @@cli_id

	-- Deuda en el Cliente
	--
  select @deudaPackingListAnterior = cli_deudaPackingList from Cliente where cli_id = @@cli_id

  update Cliente set 
										cli_deudaPackingList =  IsNull(@deudaPackingList,0), 
										cli_deudaTotal 	     = 		cli_deudaTotal 
																						- IsNull(@deudaPackingListAnterior,0) 
																						+ IsNull(@deudaPackingList,0)
			  where cli_id = @@cli_id

	-- Actualizo la deuda en la tabla EmpresaClienteDeuda
	--
	select @deudaPackingList 				 = 0, 
				 @deudaPackingListAnterior = 0

	-- Deuda en el cache para la empresa del documento modificado
	--
	select @deudaPackingList = sum(clicc_importe) from ClienteCacheCredito where  doct_id = @doct_PackingList 
																																			 	and cli_id = @@cli_id
																																			 	and emp_id = @@emp_id

	declare @empclid_id int
	select @empclid_id = empclid_id from EmpresaClienteDeuda where 	cli_id = @@cli_id
																															and emp_id = @@emp_id
	if isnull(@empclid_id,0)<>0 begin

	  select @deudaPackingListAnterior = empclid_deudaPackingList from EmpresaClienteDeuda where empclid_id = @empclid_id
	
	  update EmpresaClienteDeuda set 
											empclid_deudaPackingList 	= IsNull(@deudaPackingList,0),
											empclid_deudaTotal 				= 	empclid_deudaTotal 
																									- IsNull(@deudaPackingListAnterior,0) 
																									+ IsNull(@deudaPackingList,0)
				  where empclid_id = @empclid_id

	end else begin

		exec sp_dbgetnewid 'EmpresaClienteDeuda', 'empclid_id', @empclid_id out, 0

		insert into EmpresaClienteDeuda (empclid_id,  cli_id,   emp_id,   empclid_deudaPackingList,    empclid_deudaTotal)
														values  (@empclid_id, @@cli_id, @@emp_id, IsNull(@deudaPackingList,0), IsNull(@deudaPackingList,0))

	end
end
go