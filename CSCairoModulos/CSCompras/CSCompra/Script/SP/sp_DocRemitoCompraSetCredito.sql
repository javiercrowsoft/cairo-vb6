if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraSetCredito]

/*

 sp_DocRemitoCompraSetCredito 12

*/

go
create procedure sp_DocRemitoCompraSetCredito (
	@@rc_id      int,
  @@borrar     tinyint = 0
)
as

begin

	-- Si no hay documento adios
	--
	if @@rc_id = 0 return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	declare @pendiente    				decimal(18,6)
  declare @doct_remitocompra	  int
	declare @prov_id           		int
  declare @doct_id          		int
	declare @emp_id           		int

  set @doct_remitocompra = 4

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

	select 	@prov_id 		= prov_id, 
					@pendiente 	= case when rc_cotizacion > 0 then round(rc_pendiente,2) * rc_cotizacion
														 else 											 round(rc_pendiente,2)
												end, 
					@doct_id 		= rc.doct_id, 
					@emp_id 		= doc.emp_id,
					@desc1 		 	= rc_descuento1,
					@desc2 		 	= rc_descuento2
 
	from RemitoCompra rc inner join Documento doc on rc.doc_id = doc.doc_id
	where rc_id = @@rc_id

	set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc1/100)
	set @pendiente = IsNull(@pendiente,0) - (IsNull(@pendiente,0) * @desc2/100)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar referencias a este documento por otro cliente
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	-- Siempre borro cualquier mencion a este documento en el cache de cualquier 
  -- proveedor que no sea el indicado por el documento
	if exists(select prov_id 
						from ProveedorCacheCredito 
         		where prov_id  <> @prov_id 
           		and doct_id = @doct_remitocompra 
           		and id      = @@rc_id
						) begin

		declare @oldprov int
		declare c_oldprov insensitive cursor for 
						select prov_id 
						from ProveedorCacheCredito 
         		where prov_id  <> @prov_id 
           		and doct_id = @doct_remitocompra 
           		and id      = @@rc_id
		open c_oldprov

		delete ProveedorCacheCredito 
	         where prov_id  <> @prov_id 
	           and doct_id = @doct_remitocompra 
	           and id      = @@rc_id

		fetch next from c_oldprov into @oldprov
		while @@fetch_status=0 begin

			exec sp_proveedorUpdateRemitoCredito @oldprov, @emp_id

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
	           where prov_id  = @prov_id 
	             and doct_id  = @doct_remitocompra 
	             and id       = @@rc_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Insert - Update
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end else begin

    if @doct_id = 25 /*devolucion*/ set @pendiente = -@pendiente
	
		if exists(select id from ProveedorCacheCredito 
	            where prov_id = @prov_id 
	              and doct_id = @doct_remitocompra 
	              and id      = @@rc_id) begin
	
			if abs(@pendiente) >= 0.01 begin

				update ProveedorCacheCredito set provcc_importe = @pendiente  
		           where prov_id = @prov_id 
		             and doct_id = @doct_remitocompra 
		             and id      = @@rc_id

			-- Si no hay nada pendiente lo saco del cache
			end else begin 	

				delete ProveedorCacheCredito 
		           where prov_id = @prov_id 
		             and doct_id = @doct_remitocompra 
		             and id      = @@rc_id
			end
	
	  end else begin
	
			-- Solo si hay algo pendiente
			if abs(@pendiente) >= 0.01 begin
				insert into ProveedorCacheCredito (prov_id,doct_id,id,provcc_importe, emp_id) 
		                              values  (@prov_id, @doct_remitocompra, @@rc_id, @pendiente, @emp_id)
			end
		end
	end -- Insertar - Actualizar

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda en cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Actualizo la deuda en la tabla Cliente
	exec sp_proveedorUpdateRemitoCredito @prov_id, @emp_id

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

	raiserror ('Ha ocurrido un error al actualizar el estado del remito de compra. sp_DocRemitoCompraSetCredito.', 16, 1)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if @bInternalTransaction <> 0 
		rollback transaction	

end