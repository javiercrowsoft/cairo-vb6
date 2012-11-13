if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentoSavePrestacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentoSavePrestacion]

/*

 select * from Documento
 select * from prestacion where pre_id > 14000000
  

  delete prestacion where pre_id > 14000000
    update Documento set pre_id_new = null

 sp_DocumentosSavePrestacion 1

*/

go
create procedure sp_DocumentoSavePrestacion (
	@@doc_id 		int
)
as

begin

  declare @pre_id int
  declare @doc_nombre varchar(100)

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_new, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Agregar Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_new = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Agregar Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_edit, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Editar Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_edit = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_delete, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Borrar Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_delete = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_list, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Listar Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_list = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Listar Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end


  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_anular, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Anular Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_anular = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Anular Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_desAnular, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Des-anular Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_desAnular = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Des-anular Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_aplicar, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Aplicar Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_aplicar = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Aplicar Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_print, @doc_nombre = doc_nombre from Documento where doc_id = @@doc_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15020001,16020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Imprimir Documentos (' + @doc_nombre + ')','Documentos',@doc_nombre)

      update Documento set pre_id_print = @pre_id where doc_id = @@doc_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Imprimir Documentos (' + @doc_nombre + ')',
                              pre_grupo2 = @doc_nombre
      where pre_id = @pre_id
  end

end

go