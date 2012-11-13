if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_proveedorUpdateCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_proveedorUpdateCredito]

/*

 sp_proveedorUpdateCredito 12

*/

go
create procedure sp_proveedorUpdateCredito (
	@@prov_id     int,
	@@emp_id 			int
)
as

begin

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_facturaCpra			int
  declare @doct_OrdenPago	  		int
	declare @doct_ordenpagochq		int
	declare @DeudaCtaCteAnterior 	decimal(18,6)
  declare @DeudaCtaCte         	decimal(18,6)
	declare @CreditoCtaCte       	decimal(18,6)
	declare @DeudaDocAnterior     decimal(18,6)
	declare @DeudaDoc             decimal(18,6)

  set @doct_facturaCpra 	= 2
  set @doct_OrdenPago 		= 16
  set @doct_ordenpagochq	= 1016

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Deuda en el cache
	--
	select @DeudaCtaCte = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_facturaCpra and prov_id = @@prov_id

	-- Credito en el cache
	--
	select @CreditoCtaCte = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_OrdenPago   and prov_id = @@prov_id

	-- Deuda en el proveedor
	--
  select @DeudaCtaCteAnterior = prov_DeudaCtaCte from Proveedor where prov_id = @@prov_id

  update Proveedor set 
										prov_DeudaCtaCte 	= IsNull(@DeudaCtaCte,0) - IsNull(@CreditoCtaCte,0), 
										prov_deudaTotal 	= 	prov_deudaTotal 
																				- IsNull(@DeudaCtaCteAnterior,0) + (
																																							IsNull(@DeudaCtaCte,0)
																																						- IsNull(@CreditoCtaCte,0)
																																					)
			  where prov_id = @@prov_id

	-- Actualizo la deuda en la tabla EmpresaProveedorDeuda
	--
	select @DeudaCtaCte 				= 0, 
				 @DeudaCtaCteAnterior = 0,
				 @CreditoCtaCte 			= 0

	-- Deuda en el cache para la empresa del documento modificado
	--
	select @DeudaCtaCte = sum(provcc_importe) from ProveedorCacheCredito where  doct_id = @doct_facturaCpra 
																																			 		and prov_id = @@prov_id
																																			 		and emp_id  = @@emp_id

	-- Credito en el cache para la empresa del documento modificado
	--
	select @CreditoCtaCte = sum(provcc_importe) from ProveedorCacheCredito where 	doct_id = @doct_OrdenPago   
																																						and prov_id = @@prov_id
																																						and emp_id  = @@emp_id

	declare @empprovd_id int
	select @empprovd_id = empprovd_id from EmpresaProveedorDeuda where  prov_id = @@prov_id
																																	and emp_id 	= @@emp_id
	if isnull(@empprovd_id,0)<>0 begin

	  select @DeudaCtaCteAnterior = empprovd_DeudaCtaCte from EmpresaProveedorDeuda where empprovd_id = @empprovd_id
	
	  update EmpresaProveedorDeuda set 
											empprovd_DeudaCtaCte 	= IsNull(@DeudaCtaCte,0) - IsNull(@CreditoCtaCte,0),  
											empprovd_deudaTotal 	= 	empprovd_deudaTotal 
																							- IsNull(@DeudaCtaCteAnterior,0) + (
																																										IsNull(@DeudaCtaCte,0)
																																									-	IsNull(@CreditoCtaCte,0)
																																								)
				  where empprovd_id = @empprovd_id

	end else begin

		exec sp_dbgetnewid 'EmpresaProveedorDeuda', 'empprovd_id', @empprovd_id out, 0

		insert into EmpresaProveedorDeuda (empprovd_id,  emp_id,   prov_id,   empprovd_deudaCtaCte,   empprovd_deudaTotal)
															values  (@empprovd_id, @@emp_id, @@prov_id, IsNull(@DeudaCtaCte,0), IsNull(@DeudaCtaCte,0)
                                                                                                 -IsNull(@CreditoCtaCte,0)
																			)
	end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda Documentada desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Deuda en el cache
	--
	select @DeudaDoc = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_ordenpagochq and prov_id = @@prov_id

	-- Deuda en el Proveedor
	--
  select @DeudaDocAnterior = prov_deudaDoc from Proveedor where prov_id = @@prov_id

  update Proveedor set 
										prov_deudaDoc 			= IsNull(@DeudaDoc,0),
										prov_deudaTotal 		= 	prov_deudaTotal 
																				- IsNull(@DeudaDocAnterior,0) 
																				+ IsNull(@DeudaDoc,0)
			  where prov_id = @@prov_id

	-- Actualizo la deuda en la tabla EmpresaProveedorDeuda
	--
	select @DeudaDoc 					= 0, 
				 @DeudaDocAnterior 	= 0

	-- Deuda en el cache para la empresa del documento modificado
	--
	select @DeudaDoc = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_ordenpagochq 
																																			and prov_id = @@prov_id
																																			and emp_id  = @@emp_id

	set @empprovd_id = null
	select @empprovd_id = empprovd_id from EmpresaProveedorDeuda where  prov_id = @@prov_id
																																	and emp_id 	= @@emp_id
	if isnull(@empprovd_id,0)<>0 begin

	  select @DeudaDocAnterior = empprovd_DeudaDoc from EmpresaProveedorDeuda where empprovd_id = @empprovd_id
	
	  update EmpresaProveedorDeuda set 
											empprovd_DeudaDoc 		= IsNull(@DeudaDoc,0),  
											empprovd_deudaTotal 	= empprovd_deudaTotal 
																						- IsNull(@DeudaDocAnterior,0) 
																						+ IsNull(@DeudaDoc,0)
				  where empprovd_id = @empprovd_id

	end else begin

		exec sp_dbgetnewid 'EmpresaProveedorDeuda', 'empprovd_id', @empprovd_id out, 0

		insert into EmpresaProveedorDeuda (empprovd_id,  prov_id,   emp_id, empprovd_deudaDoc,   empprovd_deudaTotal)
														values  (@empprovd_id, @@prov_id, @@emp_id, IsNull(@DeudaDoc,0), IsNull(@DeudaDoc,0))

	end

end
go