-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidateCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidateCliente]

go

create procedure sp_AuditoriaCreditoValidateCliente (

	@@cli_id      int,
	@@aud_id 			int

)
as

begin

  set nocount on

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @doct_cobranza	  		int
	declare @doct_cheque          int
	declare @doct_cupon           int
	declare @doct_cliente         int
	declare @audi_id 							int

  declare @DeudaCtaCte         	decimal(18,6)
  declare @DeudaDoc           	decimal(18,6)
	declare @CreditoCtaCte       	decimal(18,6)

  set @doct_cobranza 		= 13

	set @doct_cheque 		= 9999
	set @doct_cupon  		=	9998
	set @doct_cliente 	= 9997

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda desde el cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Deuda en el cache
	--
	select @DeudaCtaCte 	= sum(clicc_importe) from ClienteCacheCredito where doct_id not in (@doct_cheque, 
																																														@doct_cupon, 
																																														@doct_cobranza) 
																																				and cli_id = @@cli_id

	-- Credito en el cache
	--
	select @CreditoCtaCte = sum(clicc_importe) from ClienteCacheCredito where doct_id = @doct_cobranza   
																																				and cli_id = @@cli_id

	-- Deuda documentada
	--
	select @DeudaDoc      = sum(clicc_importe) from ClienteCacheCredito where doct_id in (@doct_cheque, 
																																												@doct_cupon)
																																				and cli_id = @@cli_id


	declare @cli_DeudaCtaCte		decimal(18,6)
	declare @cli_DeudaDoc				decimal(18,6)
	declare @cli_DeudaTotal			decimal(18,6)

	declare @cli_nombre         varchar(255)

	-- Deuda en el cliente
	--
  select 
					@cli_nombre       = cli_nombre,
					@cli_DeudaCtaCte  = cli_DeudaCtaCte,
					@cli_DeudaDoc     = cli_DeudaDoc,
					@cli_DeudaTotal		= cli_DeudaTotal

	from Cliente where cli_id = @@cli_id


	set @DeudaCtaCte 	= IsNull(@DeudaCtaCte,0) - IsNull(@CreditoCtaCte,0)
	set @DeudaDoc 		= IsNull(@DeudaDoc,0) 

	if @cli_DeudaCtaCte <> @DeudaCtaCte begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene un cache de credito invalido ya que la suma de la deuda'
                                 + ' en cuenta corriente del cache no coincide con el valor almacenado en la'
                                 + ' tabla cliente '
                                 + '(cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)

	end
	
	if @cli_DeudaDoc <> @DeudaDoc begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene un cache de credito invalido ya que la suma de la deuda'
                                 + ' documentada del cache no coincide con el valor almacenado en la'
                                 + ' tabla cliente '
                                 + '(cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)
	end

	if @cli_DeudaTotal <> (@DeudaDoc + @DeudaCtaCte) begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene un cache de credito invalido ya que la suma de'
                                 + ' toda la deuda del cache no coincide con el valor almacenado en la'
                                 + ' tabla cliente '
                                 + '(cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)
	end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
--	DEUDA POR EMPRESA
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	declare @emp_id 		int
	declare @pendiente 	decimal(18,6)
	declare @cache      decimal(18,6)

-- Manifiesto de Carga

  declare @DeudaManifiesto   decimal(18,6)
  declare @doct_Manifiesto	 int

  set @doct_Manifiesto = 20
	
	-- Deuda en el cache
	--
	select @DeudaManifiesto = sum(clicc_importe) 
	from ClienteCacheCredito where doct_id = @doct_Manifiesto
														 and cli_id  = @@cli_id

	if @DeudaManifiesto <> 0 begin

		-- Credito por empresa
		--
		if not exists(select * 
									from EmpresaClienteDeuda 
									where cli_id = @@cli_id
									) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene saldo en su deuda de Manifiesto de Carga y no hay '
                                 + 'registro en el cache de credito por empresa '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)

		end else begin

			declare c_deudaempresa insensitive cursor for

					select 	emp_id,
									sum(clicc_importe) 
					from ClienteCacheCredito where doct_id = @doct_Manifiesto 
																		 and cli_id  = @@cli_id
					group by emp_id

			open c_deudaempresa

			fetch next from c_deudaempresa into @emp_id, @pendiente
			while @@fetch_status=0
			begin
				
			  select @cache = empclid_deudaManifiesto from EmpresaClienteDeuda where cli_id = @@cli_id
																																		 			 and emp_id = @emp_id
				set @cache = IsNull(@cache,0)
	
				if @pendiente <> @cache begin
		
					exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
					if @@error <> 0 goto ControlError	
											
					insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
														 values (@@aud_id, 
		                                 @audi_id,
		                                 'Este cliente tiene un saldo en su deuda de Manifiesto de Carga distinto '
		                                 + ' al registrado en el cache de credito por empresa '
		                                 + '(Cliente:' + @cli_nombre + ')',
																		 3,
																		 4,
																		 @doct_cliente,
																		 @@cli_id
																		)
				end

				fetch next from c_deudaempresa into @emp_id, @pendiente
			end

			close c_deudaempresa
			deallocate c_deudaempresa

		end
		--
		-- Fin credito por empresa

	end else begin

		-- Credito por empresa
		--
		if exists(select emp_id
							from ClienteCacheCredito 
							where doct_id = @doct_Manifiesto 
								and cli_id = @@cli_id
						) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente no tiene deuda en Manifiesto de Carga y posee '
                                 + 'una entrada en el cache de credito por empresa '
																 + 'con deuda en Manifiesto de Carga distinta de cero '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)
		end

	end

-- PackingList

  declare @DeudaPacking   decimal(18,6)
  declare @doct_Packing	  int

  set @doct_Packing = 21
	
	-- Deuda en el cache
	--
	select @DeudaPacking = sum(clicc_importe) 
	from ClienteCacheCredito where doct_id = @doct_Packing
														 and cli_id  = @@cli_id

	if @DeudaPacking <> 0 begin

		-- Credito por empresa
		--
		if not exists(select * 
									from EmpresaClienteDeuda 
									where cli_id = @@cli_id
									) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene saldo en su deuda de PackingList y no hay '
                                 + 'registro en el cache de credito por empresa '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)

		end else begin

			declare c_deudaempresa insensitive cursor for

					select 	emp_id,
									sum(clicc_importe) 
					from ClienteCacheCredito where doct_id = @doct_Packing 
																		 and cli_id  = @@cli_id
					group by emp_id

			open c_deudaempresa

			fetch next from c_deudaempresa into @emp_id, @pendiente
			while @@fetch_status=0
			begin
				
			  select @cache = empclid_deudaPackingList from EmpresaClienteDeuda where cli_id = @@cli_id
																																			 			and emp_id = @emp_id
				set @cache = IsNull(@cache,0)
	
				if @pendiente <> @cache begin
		
					exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
					if @@error <> 0 goto ControlError	
											
					insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
														 values (@@aud_id, 
		                                 @audi_id,
		                                 'Este cliente tiene un saldo en su deuda de PackingList distinto '
		                                 + ' al registrado en el cache de credito por empresa '
		                                 + '(Cliente:' + @cli_nombre + ')',
																		 3,
																		 4,
																		 @doct_cliente,
																		 @@cli_id
																		)
				end

				fetch next from c_deudaempresa into @emp_id, @pendiente
			end

			close c_deudaempresa
			deallocate c_deudaempresa

		end
		--
		-- Fin credito por empresa

	end else begin

		-- Credito por empresa
		--
		if exists(select emp_id
							from ClienteCacheCredito 
							where doct_id = @doct_Packing 
								and cli_id = @@cli_id
						) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente no tiene deuda en PackingList y posee '
                                 + 'una entrada en el cache de credito por empresa '
																 + 'con deuda en PackingList distinta de cero '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)
		end

	end

-- pedidos de venta

  declare @DeudaPedido      decimal(18,6)
  declare @doct_PedidoVta	  int

  set @doct_PedidoVta = 5
	
	-- Deuda en el cache
	--
	select @DeudaPedido = sum(clicc_importe) 
	from ClienteCacheCredito where doct_id = @doct_PedidoVta
														 and cli_id  = @@cli_id

	if @DeudaPedido <> 0 begin

		-- Credito por empresa
		--
		if not exists(select * 
									from EmpresaClienteDeuda 
									where cli_id = @@cli_id
									) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene saldo en su deuda de pedidos de venta y no hay '
                                 + 'registro en el cache de credito por empresa '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)

		end else begin

			declare c_deudaempresa insensitive cursor for

					select 	emp_id,
									sum(clicc_importe) 
					from ClienteCacheCredito where doct_id = @doct_PedidoVta 
																		 and cli_id  = @@cli_id
					group by emp_id

			open c_deudaempresa

			fetch next from c_deudaempresa into @emp_id, @pendiente
			while @@fetch_status=0
			begin
				
			  select @cache = empclid_deudaPedido from EmpresaClienteDeuda where cli_id = @@cli_id
																																			 and emp_id = @emp_id
				set @cache = IsNull(@cache,0)
	
				if @pendiente <> @cache begin
		
					exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
					if @@error <> 0 goto ControlError	
											
					insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
														 values (@@aud_id, 
		                                 @audi_id,
		                                 'Este cliente tiene un saldo en su deuda de pedidos de venta distinto '
		                                 + ' al registrado en el cache de credito por empresa '
		                                 + '(Cliente:' + @cli_nombre + ')',
																		 3,
																		 4,
																		 @doct_cliente,
																		 @@cli_id
																		)
				end

				fetch next from c_deudaempresa into @emp_id, @pendiente
			end

			close c_deudaempresa
			deallocate c_deudaempresa

		end
		--
		-- Fin credito por empresa

	end else begin

		-- Credito por empresa
		--
		if exists(select 	emp_id
							from ClienteCacheCredito 
							where doct_id = @doct_PedidoVta 
								and cli_id = @@cli_id
						) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente no tiene deuda en pedidos de venta y posee '
                                 + 'una entrada en el cache de credito por empresa '
																 + 'con deuda en pedidos de venta distinta de cero '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)
		end

	end

-- Remitos de Venta

  declare @DeudaRemito      decimal(18,6)
  declare @doct_RemitoVta		int

  set @doct_RemitoVta = 3

	-- Deuda en el cache
	--
	select @DeudaRemito = sum(clicc_importe) 
	from ClienteCacheCredito where doct_id = @doct_RemitoVta
														 and cli_id  = @@cli_id

	if @DeudaRemito <> 0 begin

		-- Credito por empresa
		--
		if not exists(select * 
									from EmpresaClienteDeuda 
									where cli_id = @@cli_id
									) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene saldo en su deuda de remitos y no hay '
                                 + 'registro en el cache de credito por empresa '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)

		end else begin

			declare c_deudaempresa insensitive cursor for

					select 	emp_id,
									sum(clicc_importe) 
					from ClienteCacheCredito where doct_id = @doct_remitoVta 
																		 and cli_id  = @@cli_id
					group by emp_id

			open c_deudaempresa

			fetch next from c_deudaempresa into @emp_id, @pendiente
			while @@fetch_status=0
			begin
				
			  select @cache = empclid_deudaRemito from EmpresaClienteDeuda where cli_id = @@cli_id
																																			 and emp_id = @emp_id
				set @cache = IsNull(@cache,0)
	
				if @pendiente <> @cache begin
		
					exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
					if @@error <> 0 goto ControlError	
											
					insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
														 values (@@aud_id, 
		                                 @audi_id,
		                                 'Este cliente tiene saldo en su deuda de remitos distinto '
		                                 + ' al registrado en el cache de credito por empresa '
		                                 + '(Cliente:' + @cli_nombre + ')',
																		 3,
																		 4,
																		 @doct_cliente,
																		 @@cli_id
																		)
				end

				fetch next from c_deudaempresa into @emp_id, @pendiente
			end

			close c_deudaempresa
			deallocate c_deudaempresa

		end
		--
		-- Fin credito por empresa

	end else begin

		-- Credito por empresa
		--
		if exists(select emp_id
							from ClienteCacheCredito 
							where doct_id = @doct_remitoVta 
								and cli_id  = @@cli_id
						) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente no tiene deuda en remitos y posee '
                                 + 'una entrada en el cache de credito por empresa '
																 + 'con deuda en remitos distinta de cero '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)
		end

	end

-- Facturas de Venta y Pedidos de Pago

  declare @doct_facturaVta			int

  set @doct_facturaVta = 1

	select @DeudaCtaCte = sum( case doct_id
																when @doct_facturaVta then  clicc_importe
																when @doct_Cobranza   then -clicc_importe
															end
														) 
	from ClienteCacheCredito where  (			  doct_id = @doct_facturaVta 
																			or	doct_id = @doct_Cobranza
																		)
																and cli_id = @@cli_id

	if @DeudaCtaCte <> 0 begin

		-- Credito por empresa
		--
		if not exists(select * 
									from EmpresaClienteDeuda 
									where cli_id = @@cli_id
									) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente tiene saldo en su deuda y no hay registro en '
																 + 'el cache de credito por empresa '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)

		end else begin

			declare c_deudaempresa insensitive cursor for

					select 	emp_id,
									sum( case doct_id
													when @doct_facturaVta then  clicc_importe
													when @doct_Cobranza   then -clicc_importe
												end
											) 
					from ClienteCacheCredito where  (			  doct_id = @doct_facturaVta 
																							or	doct_id = @doct_Cobranza
																						)
																				and cli_id = @@cli_id
					group by emp_id

			open c_deudaempresa

			fetch next from c_deudaempresa into @emp_id, @pendiente
			while @@fetch_status=0
			begin
				
			  select @cache = empclid_DeudaCtaCte from EmpresaClienteDeuda where cli_id = @@cli_id
																																			and emp_id 	= @emp_id
				set @cache = IsNull(@cache,0)
	
				if @pendiente <> @cache begin
		
					exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
					if @@error <> 0 goto ControlError	
											
					insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
														 values (@@aud_id, 
		                                 @audi_id,
		                                 'Este cliente posee un importe de deuda en cta. cte. '
                                     + 'distinto al que figura en el cache de credito por empresa '
		                                 + '(Cliente:' + @cli_nombre + ')',
																		 3,
																		 4,
																		 @doct_cliente,
																		 @@cli_id
																		)
				end

				fetch next from c_deudaempresa into @emp_id, @pendiente
			end

			close c_deudaempresa
			deallocate c_deudaempresa

		end
		--
		-- Fin credito por empresa

	end else begin

		-- Credito por empresa
		--
		if exists(select cli_id from EmpresaClienteDeuda 
							where cli_id = @@cli_id
								and empclid_DeudaCtaCte <> 0
						) begin
	
			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este cliente no tiene deuda en cta. cte. y posee '
                                 + 'una entrada en el cache de credito por empresa '
																 + 'con deuda en cta. cte. distinta de cero '
                                 + '(Cliente:' + @cli_nombre + ')',
																 3,
																 4,
																 @doct_cliente,
																 @@cli_id
																)
		end

	end

ControlError:

end
GO