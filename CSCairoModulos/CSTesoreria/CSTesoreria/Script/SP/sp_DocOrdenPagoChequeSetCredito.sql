if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoChequeSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoChequeSetCredito]

/*

 sp_DocOrdenPagoChequeSetCredito 61

*/

go
create procedure sp_DocOrdenPagoChequeSetCredito (
	@@opg_id     int,
  @@borrar     tinyint = 0
)
as

begin

	-- Si no hay documento adios
	--
	if @@opg_id = 0 return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	declare @pendiente    			decimal(18,6)
  declare @doct_ordenpagochq	int
	declare @prov_id           	int
	declare @emp_id           	int

  set @doct_ordenpagochq = 1016 -- Cheques por OrdenPagos

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
	select @prov_id = prov_id, @emp_id = emp_id from OrdenPago where opg_id = @@opg_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar referencias a este documento por otro proveedor
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Siempre borro cualquier mencion a este documento en el cache de cualquier 
  -- proveedor que no sea el indicado por el documento
	if exists(select prov_id 
						from ProveedorCacheCredito 
         		where prov_id <> @prov_id 
           		and doct_id = @doct_ordenpagochq 
           		and id      = @@opg_id
						) begin

		declare @oldprov int
		declare c_oldprov insensitive cursor for 
						select prov_id 
						from ProveedorCacheCredito 
         		where prov_id <> @prov_id 
           		and doct_id = @doct_ordenpagochq 
           		and id      = @@opg_id
		open c_oldprov

		delete ProveedorCacheCredito 
	         where prov_id <> @prov_id 
	           and doct_id = @doct_ordenpagochq 
	           and id      = @@opg_id

		fetch next from c_oldprov into @oldprov
		while @@fetch_status=0 begin

			exec sp_proveedorUpdateCredito @oldprov, @emp_id

			fetch next from c_oldprov into @oldprov
		end
		close c_oldprov
		deallocate c_oldprov

	end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if @@borrar <> 0 begin	

			delete ProveedorCacheCredito 
	           where prov_id = @prov_id 
	             and doct_id = @doct_ordenpagochq 
	             and id      = @@opg_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Insert - Update
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end else begin

		select @pendiente = sum(cheq_importe) 
		from Cheque 
		where opg_id = @@opg_id 
			and cheq_fechacobro > getdate()
			and cheq_anulado   = 0
			and cheq_rechazado = 0

		set @pendiente = Round(IsNull(@pendiente,0),2)

		if exists(select id from ProveedorCacheCredito 
	            where prov_id = @prov_id 
	              and doct_id = @doct_ordenpagochq 
	              and id      = @@opg_id) begin
	
			if abs(@pendiente) >= 0.01 begin

				update ProveedorCacheCredito set provcc_importe = @pendiente  
		           where prov_id = @prov_id 
		             and doct_id = @doct_ordenpagochq 
		             and id      = @@opg_id

			-- Si no hay nada pendiente lo saco del cache
			end else begin 	

				delete ProveedorCacheCredito 
		           where prov_id  = @prov_id 
		             and doct_id = @doct_ordenpagochq 
		             and id      = @@opg_id
			end
	
	  end else begin
	
			-- Solo si hay algo pendiente
			if abs(@pendiente) >= 0.01 begin
				insert into ProveedorCacheCredito (prov_id,doct_id,id,provcc_importe,emp_id) 
		                              values(@prov_id, @doct_ordenpagochq, @@opg_id, @pendiente, @emp_id)
			end
		end
	end -- Insertar - Actualizar

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda en cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Actualizo la deuda en la tabla proveedor
	--
	exec sp_proveedorUpdateCredito @prov_id, @emp_id

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

	raiserror ('Ha ocurrido un error al actualizar el estado de la orden de pago. sp_DocOrdenPagoChequeSetCredito.', 16, 1)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if @bInternalTransaction <> 0 
		rollback transaction	

end