if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCEditableGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCEditableGet]

go
/*

NOMBRE_DOC                   reemplazar por el nombre del comprobante Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del comprobante ej @@pv_id (incluir arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta
NOMBRE_PRESTACION            reemplazar por el nombre de la prestacion Ej. @csPrePVEditPedidoVta
NOMBRE2_PRESTACION					 reemplazar por el nombre de la prestacion Ej. @csPrePVDeletePedidoVta
CAMPO_FECHA                  reemplazar por el nombre del campo fecha pv_fecha
ID_PRESTACION	               reemplazar por el ID que corresponda fijarse en la DLL
                                ej. csPreCpraEditXXXX = poner el numero que aparece
NOMBRE_DOCUMENTO             reemplazar por el nombre coloquial del comprobante ej. factura de compra

sp_DocNOMBRE_DOCEditableGet 57,7,0,'',1

*/

create procedure sp_DocNOMBRE_DOCEditableGet (
	PARAM_ID 		int,
  @@us_id     int,
	@@bEditable tinyint        out,
	@@editMsg   varchar(255)   out,
  @@ShowMsg   tinyint = 0,
	@@bDelete		tinyint = 0 --TODO:delete
)
as

begin

	declare @doc_id   			int
  declare @CAMPO_FECHA 			datetime
  declare @estado					int
  declare @anulado        int set @anulado = 7
  declare @firmado        int
	declare @impreso        tinyint

  declare NOMBRE_PRESTACION int set NOMBRE_PRESTACION = ID_PRESTACION
	declare NOMBRE2_PRESTACION	int set NOMBRE2_PRESTACION	= ID2_PRESTACION

	if PARAM_ID <> 0 begin

		select 
					@doc_id    = doc_id, 
					@CAMPO_FECHA  = CAMPO_FECHA,
          @estado    = est_id,
					@impreso	 = c.impreso

	  from NOMBRE_TABLA where CAMPO_ID = PARAM_ID

		if @estado = @anulado begin
						set @@bEditable = 0
	          set @@editMsg = 'El comprobante esta anulado'
						if @@ShowMsg <> 0
							select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	          return
		end

		-- Tiene permiso para editar facturas de compra
		--
		if not exists (select per_id from permiso 
	                   where pre_id = NOMBRE_PRESTACION
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
	          set @@editMsg = 'Usted no tiene permiso para editar NOMBRE_DOCUMENTO'
						if @@ShowMsg <> 0
							select [Editable]=@@bEditable, [EditMsg]= @@editMsg
	          return
		end
			
		declare @fca_id int
	
		-- Fechas de control de Acceso
	  select @fca_id = fca_id from Documento where doc_id = @doc_id 
	
		if not @fca_id is null begin

		  if not exists(select fca_id from FechaControlAcceso 
		            where fca_id = @fca_id and @CAMPO_FECHA between fca_fechaDesde and fca_fechaHasta) begin
	
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
	
		if @impreso <> 0 and @@bNoAnulado = 0 begin

			declare @doc_editarimpresos tinyint
	
			select @doc_editarimpresos = doc_editarimpresos 
			from documento 
			where doc_id = @doc_id
	
			if @doc_editarimpresos = 0 begin
				set @@bEditable = 0
	      set @@editMsg = 'El comprobante esta impreso y su documento no permite la edición de comprobantes impresos.'
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