if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepartamentoSavePrestacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepartamentoSavePrestacion]

/*

 select * from departamento
 select * from prestacion where pre_id > 14000000
  

  delete prestacion where pre_id > 14000000
    update departamento set pre_id_vernoticias = null

 sp_DepartamentoSavePrestacion 1

*/

go
create procedure sp_DepartamentoSavePrestacion (
  @@dpto_id     int
)
as

begin

  declare @pre_id int
  declare @dpto_nombre varchar(100)

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_vernoticias, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Ver Noticias (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_vernoticias = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Ver Noticias (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_editarnoticias, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Editar Noticias (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_editarnoticias = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar Noticias (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_vertareas, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Ver Tareas (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_vertareas = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Ver Tareas (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_asignartareas, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Asignar Tareas (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_asignartareas = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Asignar Tareas (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end


  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_AgregarDocumentos, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Agregar Documentos (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_AgregarDocumentos = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Agregar Documentos (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_BorrarDocumentos, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Borrar Documentos (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_BorrarDocumentos = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar Documentos (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_EditarDocumentos, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Editar Documentos (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_EditarDocumentos = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar Documentos (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_VerDocumentos, @dpto_nombre = dpto_nombre from Departamento where dpto_id = @@dpto_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15000000,15010000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Ver Documentos (' + @dpto_nombre + ')','Departamentos',@dpto_nombre)

      update Departamento set pre_id_VerDocumentos = @pre_id where dpto_id = @@dpto_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Ver Documentos (' + @dpto_nombre + ')',
                              pre_grupo2 = @dpto_nombre
      where pre_id = @pre_id
  end

end

go