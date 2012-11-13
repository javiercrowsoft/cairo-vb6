if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaEditableGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaEditableGet]

go
/*

sp_DocFacturaVentaEditableGet 11,13,7,0,'',1

*/

create procedure sp_DocFacturaVentaEditableGet (
	@@emp_id    		int,
	@@fv_id 				int,
  @@us_id     		int,
	@@bEditable 		tinyint        out,
	@@editMsg   		varchar(255)   out,
  @@ShowMsg   		tinyint = 0,
	@@bNoAnulado	  tinyint = 0,
	@@bDelete				tinyint = 0 --TODO:delete
)
as

begin

	declare @doc_id   			int
  declare @fv_fecha 			datetime
  declare @estado					int
  declare @anulado        int set @anulado = 7
  declare @firmado        int
	declare @emp_id         int
  declare @emp_nombre     varchar(255)
	declare @impreso        tinyint
	declare @cae            varchar(50)

  declare @csPreVtaEditFactura 		int set @csPreVtaEditFactura 		= 16003
	declare @csPreVtaDeleteFactura	int set @csPreVtaDeleteFactura	= 16004

	if @@fv_id <> 0 begin

		select 
					@doc_id    = d.doc_id, 
					@emp_id    = d.emp_id,
					@fv_fecha  = fv_fecha,
          @estado    = est_id,
					@impreso	 = c.impreso,
					@cae			 = fv_cae,
					@firmado   = fv_firmado

	  from FacturaVenta c inner join Documento d on c.doc_id = d.doc_id 
		where fv_id = @@fv_id

		if @cae <> '' begin

			set @@bEditable = 0
			if @@bDelete = 0 begin

        set @@editMsg = 'El comprobante ya tiene CAE asignado por la AFIP' 
												+ '. No es posible modificar el documento.'
			end else begin

        set @@editMsg = 'El comprobante ya tiene CAE asignado por la AFIP' 
												+ '. No es posible borrar el documento.'
			end
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
      return

		end

		if @@emp_id <> @emp_id begin

						select @emp_nombre = emp_nombre from Empresa where emp_id = @emp_id
						set @@bEditable = 0

--TODO:delete
						if @@bDelete = 0 begin

		          set @@editMsg = 'El comprobante pertenece a la empresa ' 
															+  @emp_nombre 
															+ ', para editarlo debe ingresar al sistema indicando dicha empresa.'
						end else begin

		          set @@editMsg = 'El comprobante pertenece a la empresa ' 
															+  @emp_nombre 
															+ ', para borrarlo debe ingresar al sistema indicando dicha empresa.'
						end
--TODO:delete

						if @@ShowMsg <> 0
							select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	          return
		end

		if @firmado <> 0 begin
			set @@bEditable = 0
			if @@bDelete = 0 begin

        set @@editMsg = 'El comprobante esta firmado' 
												+ '. No es posible modificar el documento.'
			end else begin

        set @@editMsg = 'El comprobante esta firmado' 
												+ '. No es posible borrar el documento.'
			end
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
      return
		end

		if @estado = @anulado and @@bNoAnulado = 0 begin
						set @@bEditable = 0
	          set @@editMsg = 'El comprobante esta anulado'
						if @@ShowMsg <> 0
							select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	          return
		end

--TODO:delete
		declare @pre_id int
		if @@bDelete = 0	set @pre_id = @csPreVtaEditFactura
		else							set @pre_id = @csPreVtaDeleteFactura
--TODO:delete

		-- Tiene permiso para editar facturas de venta
		--
		if not exists (select per_id from permiso 
	                   where pre_id = @pre_id --TODO:delete
	                         and (
																	(
																	us_id = @@us_id
																	)
																	or
																	exists(
																			select us_id from usuarioRol
	                                    where us_id  = @@us_id
	                                      and rol_id = permiso.rol_id
																	)
																) 
									 )begin
	 
						set @@bEditable = 0

--TODO:delete
						if @@bDelete = 0  set @@editMsg = 'Usted no tiene permiso para editar facturas de venta'
						else							set @@editMsg = 'Usted no tiene permiso para borrar facturas de venta'
--TODO:delete

						if @@ShowMsg <> 0
							select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	          return
		end
			
		-- Tiene permiso para editar este documento
		--
--TODO:delete
		declare @doc_nombre  varchar(255)

		set @pre_id = null

		select @pre_id = case 
												when @@bDelete = 0 then pre_id_edit
												else                    pre_id_delete
										 end,
					 @doc_nombre = doc_nombre 
		from documento 
		where doc_id = @doc_id
--TODO:delete

		if not exists (select per_id from permiso 
	                   where pre_id = @pre_id --TODO:delete
	                         and (
																	(
																	us_id = @@us_id
																	)
																	or
																	exists(
																			select us_id from usuarioRol
	                                    where us_id  = @@us_id
	                                      and rol_id = permiso.rol_id
																	)
																) 
									 )begin
	 
						set @@bEditable = 0

--TODO:delete
						if @@bDelete = 0  set @@editMsg = 'Usted no tiene permiso para editar ' + @doc_nombre
						else							set @@editMsg = 'Usted no tiene permiso para borrar ' + @doc_nombre
--TODO:delete

						if @@ShowMsg <> 0
							select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	          return
		end

		declare @fca_id int
	
		-- Fechas de control de Acceso
	  select @fca_id = fca_id from Documento where doc_id = @doc_id 
	
		if not @fca_id is null begin

		  if not exists(select fca_id from FechaControlAcceso 
		            where fca_id = @fca_id and @fv_fecha between fca_fechaDesde and fca_fechaHasta) begin
	
							declare @fca_fechaDesde   datetime
					    declare @fca_fechaHasta   datetime
		
							select @fca_fechaDesde=fca_fechaDesde,
										 @fca_fechaHasta=fca_fechaHasta
              from FechaControlAcceso 
		            where fca_id = @fca_id

							set @@bEditable = 0
		          set @@editMsg = 'La fecha del comprobante esta fuera del intervalo definido por las fechas de control de acceso (' 
		                          + convert(varchar(20),isnull(@fca_fechaDesde,'')) +' - '+ convert(varchar(20),isnull(@fca_fechaHasta,'')) + ')'
							if @@ShowMsg <> 0
								select [Editable]=@@bEditable, [EditMsg]= @@editMsg
		          return
			end
		end

		if exists(select fv_id from facturaventacobranza where fv_id = @@fv_id) begin
			set @@bEditable = 0
      set @@editMsg = 'El comprobante esta vinculado a una cobranza'
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
      return
		end
	
		if exists(select fv_id_factura from facturaventanotacredito where fv_id_factura = @@fv_id or fv_id_notacredito = @@fv_id) begin
			set @@bEditable = 0
      set @@editMsg = 'El comprobante esta vinculado a una factura o nota de credito'
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
      return
		end
	
		if exists(select fv_id from remitofacturaventa r inner join facturaventaitem fvi on r.fvi_id = fvi.fvi_id where fv_id = @@fv_id) begin
			set @@bEditable = 0
      set @@editMsg = 'El comprobante esta vinculado a un remito'
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
      return
		end
	
		if exists(select fv_id from pedidofacturaventa r inner join facturaventaitem fvi on r.fvi_id = fvi.fvi_id where fv_id = @@fv_id) begin
			set @@bEditable = 0
      set @@editMsg = 'El comprobante esta vinculado a un pedido de venta'
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
      return
		end
	
		if exists(select fv_id from packinglistfacturaventa r inner join facturaventaitem fvi on r.fvi_id = fvi.fvi_id where fv_id = @@fv_id) begin
			set @@bEditable = 0
      set @@editMsg = 'El comprobante esta vinculado a un packing list'
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
      return
		end

		if @impreso <> 0 and @@bNoAnulado = 0 begin

			declare @doc_editarimpresos tinyint
	
			select @doc_editarimpresos = doc_editarimpresos 
			from documento 
			where doc_id = @doc_id
	
			if @doc_editarimpresos = 0 begin
				set @@bEditable = 0

--TODO:delete
				if @@bDelete = 0  set @@editMsg = 'El comprobante esta impreso y la definición de su documento no permite la edición de comprobantes impresos.'
				else							set @@editMsg = 'El comprobante esta impreso y la definición de su documento no permite eliminar comprobantes impresos.'
--TODO:delete

				if @@ShowMsg <> 0
					select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	      return
			end
		end
	end
	
	set @@bEditable = 1
  set @@editMsg = ''

	if @@ShowMsg <> 0
		select @@bEditable as [Editable], @@editMsg as [EditMsg]
end