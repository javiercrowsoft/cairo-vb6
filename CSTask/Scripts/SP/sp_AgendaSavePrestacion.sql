if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AgendaSavePrestacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AgendaSavePrestacion]

/*

 select * from Agenda
 select * from prestacion where pre_id > 14000000
  

  delete prestacion where pre_id > 14000000
    update Agenda set pre_id_agregar = null

 sp_AgendaSavePrestacion 1

*/

go
create procedure sp_AgendaSavePrestacion (
  @@agn_id     int
)
as

begin

  declare @pre_id int
  declare @agn_nombre varchar(100)
  declare @us_id int
  declare @per_id int
  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_agregar, @agn_nombre = agn_nombre, @us_id = modifico from Agenda where agn_id = @@agn_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15010001,15020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Agregar (' + @agn_nombre + ')','Agendas',@agn_nombre)

      update Agenda set pre_id_agregar = @pre_id where agn_id = @@agn_id
      
      exec sp_dbGetNewId 'Permiso','per_id', @per_id out, 0

      insert into Permiso (per_id, us_id, pre_id, modifico)
      values (@per_id, @us_id, @pre_id, @us_id)

  end else begin

      update prestacion set 
                              pre_nombre = 'Agregar (' + @agn_nombre + ')',
                              pre_grupo2 = @agn_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_editar, @agn_nombre = agn_nombre, @us_id = modifico from Agenda where agn_id = @@agn_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15010001,15020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Editar (' + @agn_nombre + ')','Agendas',@agn_nombre)

      update Agenda set pre_id_editar = @pre_id where agn_id = @@agn_id

      exec sp_dbGetNewId 'Permiso','per_id', @per_id out, 0

      insert into Permiso (per_id, us_id, pre_id, modifico)
      values (@per_id, @us_id, @pre_id, @us_id)

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar (' + @agn_nombre + ')',
                              pre_grupo2 = @agn_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_borrar, @agn_nombre = agn_nombre, @us_id = modifico from Agenda where agn_id = @@agn_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15010001,15020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Borrar (' + @agn_nombre + ')','Agendas',@agn_nombre)

      update Agenda set pre_id_borrar = @pre_id where agn_id = @@agn_id

      exec sp_dbGetNewId 'Permiso','per_id', @per_id out, 0

      insert into Permiso (per_id, us_id, pre_id, modifico)
      values (@per_id, @us_id, @pre_id, @us_id)

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar (' + @agn_nombre + ')',
                              pre_grupo2 = @agn_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_listar, @agn_nombre = agn_nombre, @us_id = modifico from Agenda where agn_id = @@agn_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15010001,15020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Listar (' + @agn_nombre + ')','Agendas',@agn_nombre)

      update Agenda set pre_id_listar = @pre_id where agn_id = @@agn_id

      exec sp_dbGetNewId 'Permiso','per_id', @per_id out, 0

      insert into Permiso (per_id, us_id, pre_id, modifico)
      values (@per_id, @us_id, @pre_id, @us_id)

  end else begin

      update prestacion set 
                              pre_nombre = 'Listar (' + @agn_nombre + ')',
                              pre_grupo2 = @agn_nombre
      where pre_id = @pre_id
  end


  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  select @pre_id = pre_id_propietario, @agn_nombre = agn_nombre, @us_id = modifico from Agenda where agn_id = @@agn_id

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 15010001,15020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo2)
              values(@pre_id,'Propietario (' + @agn_nombre + ')','Agendas',@agn_nombre)

      update Agenda set pre_id_propietario = @pre_id where agn_id = @@agn_id

      exec sp_dbGetNewId 'Permiso','per_id', @per_id out, 0

      insert into Permiso (per_id, us_id, pre_id, modifico)
      values (@per_id, @us_id, @pre_id, @us_id)

  end else begin

      update prestacion set 
                              pre_nombre = 'Propietario (' + @agn_nombre + ')',
                              pre_grupo2 = @agn_nombre
      where pre_id = @pre_id
  end

end

go