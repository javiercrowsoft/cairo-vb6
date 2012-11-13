if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSetCreditoCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSetCreditoCairo]

/*

 sp_DocRemitoVentaSetCreditoCairo 12

*/

go
create procedure sp_DocRemitoVentaSetCreditoCairo (
	@@rv_id      int,
  @@borrar     tinyint = 0
)
as

begin

	-- Si no hay documento adios
	--
	if @@rv_id = 0 return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	declare @pendiente    			decimal(18,6)
  declare @doct_remitoventa	  int
	declare @cli_id           	int
  declare @doct_id          	int
	declare @emp_id           	int

  set @doct_remitoventa = 3

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
		begin transaction
  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Datos del documento
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	declare @desc1 		 decimal(18,6)
	declare @desc2 		 decimal(18,6)

	select 	@cli_id 		= cli_id, 
					@pendiente 	=	case when rv_cotizacion > 0 then round(rv_pendiente,2) * rv_cotizacion
														 else 											 round(rv_pendiente,2) 
												end, 
				 	@doct_id 		= rv.doct_id, 
				 	@emp_id 		= doc.emp_id,
					@desc1 		 	= rv_descuento1,
					@desc2 		 	= rv_descuento2

	from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id
	where rv_id = @@rv_id

	set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc1/100)
	set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc2/100)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar referencias a este documento por otro cliente
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Siempre borro cualquier mencion a este documento en el cache de cualquier 
  -- cliente que no sea el indicado por el documento
	if exists(select cli_id 
						from ClienteCacheCredito 
         		where cli_id  <> @cli_id 
           		and doct_id = @doct_remitoVenta 
           		and id      = @@rv_id
						) begin

		declare @oldcli int
		declare c_oldcli insensitive cursor for 
						select cli_id 
						from ClienteCacheCredito 
         		where cli_id  <> @cli_id 
           		and doct_id = @doct_remitoVenta 
           		and id      = @@rv_id
		open c_oldcli

		delete ClienteCacheCredito 
	         where cli_id  <> @cli_id 
	           and doct_id = @doct_remitoVenta 
	           and id      = @@rv_id

		fetch next from c_oldcli into @oldcli
		while @@fetch_status=0 begin

			exec sp_clienteUpdateRemitoCredito @oldcli, @emp_id

			fetch next from c_oldcli into @oldcli
		end
		close c_oldcli
		deallocate c_oldcli

	end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if @@borrar <> 0 begin	

			delete ClienteCacheCredito 
	           where cli_id  = @cli_id 
	             and doct_id = @doct_remitoventa 
	             and id      = @@rv_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Insert - Update
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end else begin

    if @doct_id = 24 /*devolucion*/ set @pendiente = -@pendiente
	
		if exists(select id from ClienteCacheCredito 
	            where cli_id  = @cli_id 
	              and doct_id = @doct_remitoventa 
	              and id      = @@rv_id) begin
	
			if abs(@pendiente) >= 0.01 begin

				update ClienteCacheCredito set clicc_importe = @pendiente  
		           where cli_id  = @cli_id 
		             and doct_id = @doct_remitoventa 
		             and id      = @@rv_id

			-- Si no hay nada pendiente lo saco del cache
			end else begin 	

				delete ClienteCacheCredito 
		           where cli_id  = @cli_id 
		             and doct_id = @doct_remitoventa 
		             and id      = @@rv_id
			end
	
	  end else begin
	
			-- Solo si hay algo pendiente
			if abs(@pendiente) >= 0.01 begin
				insert into ClienteCacheCredito (cli_id,doct_id,id,clicc_importe, emp_id) 
		                              values(@cli_id, @doct_remitoventa, @@rv_id, @pendiente, @emp_id)
			end
		end
	end -- Insertar - Actualizar


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda en cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Actualizo la deuda en la tabla Cliente
	exec sp_clienteUpdateRemitoCredito @cli_id, @emp_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if @bInternalTransaction <> 0 
		commit transaction

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Fin
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Errores
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el estado del remito de venta. sp_DocRemitoVentaSetCreditoCairo.', 16, 1)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if @bInternalTransaction <> 0 
		rollback transaction	

end
go