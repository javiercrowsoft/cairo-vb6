if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraSetCredito]

/*

 sp_DocOrdenCompraSetCredito 12

*/

go
create procedure sp_DocOrdenCompraSetCredito (
	@@oc_id      int,
  @@borrar     tinyint = 0
)
as

begin

	-- Si no hay documento adios
	--
	if @@oc_id = 0 return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	declare @pendiente    				decimal(18,6)
  declare @doct_OrdenCompra	  	int
	declare @prov_id           		int
  declare @doct_id          		int
	declare @emp_id           		int

  set @doct_OrdenCompra = 35

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
	declare @cotizacion decimal(18,6)
	declare @mon_id     int
	declare @fecha      datetime
	declare @desc1 		  decimal(18,6)
	declare @desc2 		  decimal(18,6)

	select 	@prov_id 		= prov_id, 
					@pendiente	= round(oc_pendiente,2), 
					@doct_id 		= oc.doct_id, 
					@emp_id 		= doc.emp_id, 
					@mon_id 		= doc.mon_id,
					@desc1 		 	= oc_descuento1,
					@desc2 		 	= oc_descuento2

	from OrdenCompra oc inner join Documento doc on oc.doc_id = doc.doc_id
	where oc_id = @@oc_id

	set @fecha = getdate()
	exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotizacion out

	if not exists(select * from Moneda where mon_id = @mon_id and mon_legal <> 0) begin
		if @cotizacion > 0 set @pendiente = @pendiente * @cotizacion
	end

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
           		and doct_id = @doct_OrdenCompra 
           		and id      = @@oc_id
						) begin

		declare @oldprov int
		declare c_oldprov insensitive cursor for 
						select prov_id 
						from ProveedorCacheCredito 
         		where prov_id  <> @prov_id 
           		and doct_id = @doct_OrdenCompra 
           		and id      = @@oc_id
		open c_oldprov

		delete ProveedorCacheCredito 
	         where prov_id  <> @prov_id 
	           and doct_id = @doct_OrdenCompra 
	           and id      = @@oc_id

		fetch next from c_oldprov into @oldprov
		while @@fetch_status=0 begin

			exec sp_proveedorUpdateOrdenCompraCredito @oldprov, @emp_id

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
	             and doct_id = @doct_OrdenCompra 
	             and id      = @@oc_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Insert - Update
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	end else begin

    if @doct_id = 36 /*cancelacion*/ set @pendiente = -@pendiente
	
		if exists(select id from ProveedorCacheCredito 
	            where prov_id = @prov_id 
	              and doct_id = @doct_OrdenCompra 
	              and id      = @@oc_id) begin
	
			if abs(@pendiente) >= 0.01 begin

				update ProveedorCacheCredito set provcc_importe = @pendiente  
		           where prov_id = @prov_id 
		             and doct_id = @doct_OrdenCompra 
		             and id      = @@oc_id

			-- Si no hay nada pendiente lo saco del cache
			end else begin 	

				delete ProveedorCacheCredito 
		           where prov_id = @prov_id 
		             and doct_id = @doct_OrdenCompra 
		             and id      = @@oc_id
			end
	
	  end else begin                                 
	
			-- Solo si hay algo pendiente
			if abs(@pendiente) >= 0.01 begin
				insert into ProveedorCacheCredito (prov_id,doct_id,id,provcc_importe,emp_id) 
		                              values  (@prov_id, @doct_OrdenCompra, @@oc_id, @pendiente, @emp_id)
			end
		end
	end -- Insertar - Actualizar

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda en cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Actualizo la deuda en la tabla Cliente
	exec sp_proveedorUpdateOrdenCompraCredito @prov_id, @emp_id

  -- Actualizo la deuda en la tabla Proveedor
	declare @deudaOrdenAnterior decimal(18,6)
  declare @deudaOrden         decimal(18,6)

	select @deudaOrden = sum(provcc_importe) from ProveedorCacheCredito where doct_id = @doct_OrdenCompra and prov_id = @prov_id
  select @deudaOrdenAnterior = prov_deudaOrden from Proveedor where prov_id = @prov_id
  update Proveedor set 
										prov_deudaOrden 	= IsNull(@deudaOrden,0), 
										prov_deudaTotal 	= prov_deudaTotal - IsNull(@deudaOrdenAnterior,0) + IsNull(@deudaOrden,0)
			  where prov_id = @prov_id

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

	raiserror ('Ha ocurrido un error al actualizar el estado de la orden de compra. sp_DocOrdenCompraSetCredito.', 16, 1)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if @bInternalTransaction <> 0 
		rollback transaction	

end