if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentoDelete]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_DocumentoDelete 2

create procedure sp_DocumentoDelete (
	@@doc_id	int
)
as

set nocount on

begin

	begin transaction

	declare @pre_id int

-- pre_id_new
	select @pre_id = pre_id_new from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_new = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

-- pre_id_edit
	select @pre_id = pre_id_edit from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_edit = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

-- pre_id_delete
	select @pre_id = pre_id_delete from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_delete = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

-- pre_id_list
	select @pre_id = pre_id_list from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_list = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

-- pre_id_anular
	select @pre_id = pre_id_anular from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_anular = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

-- pre_id_desanular
	select @pre_id = pre_id_desanular from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_desanular = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

-- pre_id_aplicar
	select @pre_id = pre_id_aplicar from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_aplicar = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

-- pre_id_print
	select @pre_id = pre_id_print from Documento where doc_id = @@doc_id

	if @pre_id is not null begin

		delete permiso where pre_id = @pre_id
		if @@error <> 0 goto ControlError

		update Documento set pre_id_print = null where doc_id = @@doc_id
	
		delete Prestacion where pre_id = @pre_id
		if @@error <> 0 goto ControlError
	end

	delete DocumentoImpresora where doc_id = @@doc_id
  if @@error <> 0 goto ControlError
	delete ReporteFormulario where doc_id = @@doc_id
  if @@error <> 0 goto ControlError
	delete DocumentoFirma where doc_id = @@doc_id
  if @@error <> 0 goto ControlError
	delete Documento where doc_id = @@doc_id
  if @@error <> 0 goto ControlError

	commit transaction
  return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el documento. sp_DocumentoDelete.', 16, 1)

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



