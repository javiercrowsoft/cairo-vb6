if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockEditableGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockEditableGet]

go
/*

sp_DocRecuentoStockEditableGet 57,7,0,'',1

*/

create procedure sp_DocRecuentoStockEditableGet (
	@@emp_id    		int,
	@@rs_id 				int,
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
  declare @rs_fecha 			datetime
  declare @estado					int

  declare @csPreSTEditRecuentoStock 	int set @csPreSTEditRecuentoStock 	= 20008
	declare @csPreSTDeleteRecuentoStock	int set @csPreSTDeleteRecuentoStock	= 20009

	if @@rs_id <> 0 begin

		if @@bDelete = 0 begin

			set @@bEditable = 0
	    set @@editMsg = 'Los recuentos de stock no pueden modificarse.'
			if @@ShowMsg <> 0
				select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	    return

		end else begin

--//'----------------------------------------------------------------------------------------'
		-- @@bDelete <> 0

			declare @emp_id 			int
			declare @emp_nombre		varchar(255)
			declare @impreso			tinyint

			select 
						@doc_id   = d.doc_id, 
						@emp_id   = emp_id,
						@rs_fecha = rs_fecha,
						@impreso	= c.impreso
	
		  from RecuentoStock c inner join Documento d on c.doc_id = d.doc_id 
			where rs_id = @@rs_id
	
			if @@emp_id <> @emp_id begin
	
							select @emp_nombre = emp_nombre from Empresa where emp_id = @emp_id
							set @@bEditable = 0
	
		          set @@editMsg = 'El comprobante pertenece a la empresa ' 
															+  @emp_nombre 
															+ ', para borrarlo debe ingresar al sistema indicando dicha empresa.'

							if @@ShowMsg <> 0
								select [Editable]=@@bEditable, [EditMsg]= @@editMsg
		          return
			end
	
			-- Tiene permiso para editar presupuestos de envio
			--
			if not exists (select per_id from permiso 
		                   where pre_id = @csPreSTDeleteRecuentoStock
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
	
							set @@editMsg = 'Usted no tiene permiso para borrar recuentos de stock'
	
							if @@ShowMsg <> 0
								select [Editable]=@@bEditable, [EditMsg]= @@editMsg
		          return
			end
				
			-- Tiene permiso para editar este documento
			--
			declare @doc_nombre  		varchar(255)
			declare @pre_id_delete  int
	
			select @pre_id_delete = pre_id_delete,
						 @doc_nombre 		= doc_nombre 
			from documento 
			where doc_id = @doc_id
	
			if not exists (select per_id from permiso 
		                   where pre_id = @pre_id_delete
	
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
	
							set @@editMsg = 'Usted no tiene permiso para borrar ' + @doc_nombre
	
							if @@ShowMsg <> 0
								select [Editable]=@@bEditable, [EditMsg]= @@editMsg
		          return
			end
			declare @fca_id int
		
			-- Fechas de control de Acceso
		  select @fca_id = fca_id from Documento where doc_id = @doc_id 
		
			if not @fca_id is null begin
	
			  if not exists(select fca_id from FechaControlAcceso 
			            where fca_id = @fca_id and @rs_fecha between fca_fechaDesde and fca_fechaHasta) begin
		
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
		
			if @impreso <> 0 begin
	
				declare @doc_editarimpresos tinyint
		
				select @doc_editarimpresos = doc_editarimpresos 
				from documento 
				where doc_id = @doc_id
		
				if @doc_editarimpresos = 0 begin
					set @@bEditable = 0
	
					set @@editMsg = 'El comprobante esta impreso y la definición de su documento no permite eliminar comprobantes impresos.'
	
					if @@ShowMsg <> 0
						select [Editable]=@@bEditable, [EditMsg]= @@editMsg
		      return
				end
			end

		-- Fin @@bDelete <> 0
--//'----------------------------------------------------------------------------------------'

		end

	end
	
	set @@bEditable = 1
  set @@editMsg = ''

	if @@ShowMsg <> 0
		select @@bEditable as [Editable], @@editMsg as [EditMsg]
end