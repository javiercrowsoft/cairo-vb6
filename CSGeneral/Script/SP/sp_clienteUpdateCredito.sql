if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteUpdateCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteUpdateCredito]

/*

 sp_clienteUpdateCredito 12

*/

go
create procedure sp_clienteUpdateCredito (
	@@cli_id      int,
	@@emp_id 			int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_facturaVta			int
  declare @doct_cobranza	  		int
	declare @doct_cobranzachq			int
	declare @DeudaCtaCteAnterior 	decimal(18,6)
  declare @DeudaCtaCte         	decimal(18,6)
	declare @CreditoCtaCte       	decimal(18,6)
	declare @DeudaDocAnterior     decimal(18,6)
	declare @DeudaDoc             decimal(18,6)

  set @doct_facturaVta 	= 1
  set @doct_cobranza 		= 13
  set @doct_cobranzachq	= 1013

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Deuda en el cache
	--
	select @DeudaCtaCte 	= sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_facturaVta and cli_id = @@cli_id

	-- Credito en el cache
	--
	select @CreditoCtaCte = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_cobranza   and cli_id = @@cli_id

	-- Deuda en el cliente
	--
  select @DeudaCtaCteAnterior = cli_deudaCtaCte from Cliente where cli_id = @@cli_id

  update Cliente set 
										cli_deudaCtaCte 	= IsNull(@DeudaCtaCte,0) - IsNull(@CreditoCtaCte,0), 
										cli_deudaTotal 		= 	cli_deudaTotal 
																				- IsNull(@DeudaCtaCteAnterior,0) + (
																																							IsNull(@DeudaCtaCte,0)
																																						-	IsNull(@CreditoCtaCte,0)
																																					)
			  where cli_id = @@cli_id

	-- Actualizo la deuda en la tabla EmpresaClienteDeuda
	--
	select @DeudaCtaCte 				= 0, 
				 @DeudaCtaCteAnterior = 0,
				 @CreditoCtaCte 			= 0

	-- Deuda en el cache para la empresa del documento modificado
	--
	select @DeudaCtaCte = sum(clicc_importe) from ClienteCacheCredito where  doct_id = @doct_facturaVta 
																																			 and cli_id  = @@cli_id
																																			 and emp_id  = @@emp_id

	-- Credito en el cache para la empresa del documento modificado
	--
	select @CreditoCtaCte = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_cobranza   
																																				and cli_id 	= @@cli_id
																																				and emp_id  = @@emp_id

	declare @empclid_id int
	select @empclid_id = empclid_id from EmpresaClienteDeuda where  cli_id = @@cli_id
																															and emp_id = @@emp_id
	if isnull(@empclid_id,0)<>0 begin

	  select @DeudaCtaCteAnterior = empclid_DeudaCtaCte from EmpresaClienteDeuda where empclid_id = @empclid_id
	
	  update EmpresaClienteDeuda set 
											empclid_DeudaCtaCte 	= IsNull(@DeudaCtaCte,0) - IsNull(@CreditoCtaCte,0),  
											empclid_deudaTotal 		= 	empclid_deudaTotal 
																							- IsNull(@DeudaCtaCteAnterior,0) + (
																																										IsNull(@DeudaCtaCte,0)
																																									-	IsNull(@CreditoCtaCte,0)
																																								)
				  where empclid_id = @empclid_id

	end else begin

		exec sp_dbgetnewid 'EmpresaClienteDeuda', 'empclid_id', @empclid_id out, 0

		insert into EmpresaClienteDeuda (empclid_id,  cli_id,   emp_id,   empclid_deudaCtaCte,    empclid_deudaTotal)
														values  (@empclid_id, @@cli_id, @@emp_id, IsNull(@DeudaCtaCte,0), IsNull(@DeudaCtaCte,0)
                                                                                            -IsNull(@CreditoCtaCte,0)
																			)

	end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda Documentada desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Deuda en el cache
	--
	select @DeudaDoc = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_cobranzachq and cli_id = @@cli_id

	-- Deuda en el cliente
	--
  select @DeudaDocAnterior = cli_deudaDoc from Cliente where cli_id = @@cli_id

  update Cliente set 
										cli_deudaDoc 			= IsNull(@DeudaDoc,0),
										cli_deudaTotal 		= 	cli_deudaTotal 
																				- IsNull(@DeudaDocAnterior,0) 
																				+ IsNull(@DeudaDoc,0)
			  where cli_id = @@cli_id

	-- Actualizo la deuda en la tabla EmpresaClienteDeuda
	--
	select @DeudaDoc 					= 0, 
				 @DeudaDocAnterior 	= 0

	-- Deuda en el cache para la empresa del documento modificado
	--
	select @DeudaDoc = sum(clicc_importe) from ClienteCacheCredito where  doct_id = @doct_cobranzachq 
																																		and cli_id  = @@cli_id
																																		and emp_id  = @@emp_id

	set @empclid_id = null
	select @empclid_id = empclid_id from EmpresaClienteDeuda where  cli_id = @@cli_id
																															and emp_id = @@emp_id
	if isnull(@empclid_id,0)<>0 begin

	  select @DeudaDocAnterior = empclid_DeudaDoc from EmpresaClienteDeuda where empclid_id = @empclid_id
	
	  update EmpresaClienteDeuda set 
											empclid_DeudaDoc 		= IsNull(@DeudaDoc,0),  
											empclid_deudaTotal 	= empclid_deudaTotal 
																						- IsNull(@DeudaDocAnterior,0) 
																						+ IsNull(@DeudaDoc,0)
				  where empclid_id = @empclid_id

	end else begin

		exec sp_dbgetnewid 'EmpresaClienteDeuda', 'empclid_id', @empclid_id out, 0

		insert into EmpresaClienteDeuda (empclid_id,  cli_id,   emp_id,   empclid_deudaDoc,    empclid_deudaTotal)
														values  (@empclid_id, @@cli_id, @@emp_id, IsNull(@DeudaDoc,0), IsNull(@DeudaDoc,0))

	end

end
go