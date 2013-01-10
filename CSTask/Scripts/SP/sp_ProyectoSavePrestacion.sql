if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProyectoSavePrestacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProyectoSavePrestacion]

/*

 select * from Proyecto
 select * from prestacion where pre_id > 14000000
  

  delete prestacion where pre_id > 14000000
    update Proyecto set pre_id_owner = null

 sp_ProyectosSavePrestacion 1

*/

go
create procedure sp_ProyectoSavePrestacion (
  @@proy_id     int
)
as

begin

  declare @pre_id int
  declare @proy_nombre varchar(100)

  declare @pre_id_listTarea     int
  declare @pre_id_editTarea      int
  declare @pre_id_delTarea      int
  declare @pre_id_addTarea      int
  declare @pre_id_listTareaP    int
  declare @pre_id_editTareaP    int
  declare @pre_id_delTareaP      int
  declare @pre_id_listTareaD    int
  declare @pre_id_editTareaD    int
  declare @pre_id_delTareaD      int
  declare @pre_id_listHoraD      int
  declare @pre_id_listHora      int
  declare @pre_id_editHoraP      int
  declare @pre_id_delHoraP      int
  declare @pre_id_editHora      int
  declare @pre_id_delHora        int
  declare @pre_id_addHora        int
  declare @pre_id_tomarTarea    int
  declare @pre_id_asignarTarea  int
  declare @pre_id_aprobarTarea  int



  select  @proy_nombre             = proy_nombre,

          @pre_id_listTarea        = pre_id_listTarea,
          @pre_id_editTarea        = pre_id_editTarea,
          @pre_id_delTarea        = pre_id_delTarea,
          @pre_id_addTarea        = pre_id_addTarea,
          @pre_id_editTareaP      = pre_id_editTareaP,
          @pre_id_delTareaP        = pre_id_delTareaP,
          @pre_id_listTareaD      = pre_id_listTareaD,
          @pre_id_editTareaD      = pre_id_editTareaD,
          @pre_id_delTareaD        = pre_id_delTareaD,
          @pre_id_listHoraD        = pre_id_listHoraD,
          @pre_id_listHora        = pre_id_listHora,
          @pre_id_editHora        = pre_id_editHora,
          @pre_id_editHoraP        = pre_id_editHoraP,
          @pre_id_delHoraP        = pre_id_delHoraP,
          @pre_id_delHora          = pre_id_delHora,
          @pre_id_addHora          = pre_id_addHora,
          @pre_id_tomarTarea      = pre_id_tomarTarea,
          @pre_id_asignarTarea    = pre_id_asignarTarea,
          @pre_id_aprobarTarea    = pre_id_aprobarTarea


  from 
          Proyecto 
  
  where 
          proy_id = @@proy_id

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_listTarea  

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Listar tareas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_listTarea = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Listar tareas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end


  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_editTarea  

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Editar tareas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_editTarea = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar tareas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_delTarea  

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Borrar tareas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_delTarea = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar tareas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_addTarea  

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Agregar tareas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_addTarea = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Agregar tareas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_editTareaP

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Editar tareas propias del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_editTareaP = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar tareas propias del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_delTareaP

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Borrar tareas propias del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_delTareaP = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar tareas propias del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_listTareaD

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Listar tareas del departamento para el proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_listTareaD = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Listar tareas del departamento para el proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_editTareaD

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Editar tareas del departamento para el proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_editTareaD = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar tareas del departamento para el proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_delTareaD

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Borrar tareas del departamento para el proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_delTareaD = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar tareas del departamento para el proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_listHoraD

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Listar horas del departamento para el proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_listHoraD = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Listar horas del departamento para el proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --////////////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_listHora

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Listar horas del proyecto para el proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_listHora = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Listar horas del proyecto para el proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_editHora

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Editar horas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_editHora = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar horas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_delHora

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Borrar horas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_delHora = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar horas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_editHoraP

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Editar horas propias del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_editHoraP = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Editar horas propias del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_delHoraP

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Borrar horas propias del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_delHoraP = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Borrar horas propias del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_addHora

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Agregar horas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_addHora = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Agregar horas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_tomarTarea

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Tomar tareas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_tomarTarea = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Tomar tareas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_asignarTarea

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Asignar tareas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_asignarTarea = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Asignar tareas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

  --///////////////////////////////////////////////////////////////////////////////////
  --
  set @pre_id = @pre_id_aprobarTarea

  if @pre_id is null begin

     exec SP_DBGetNewId2 'prestacion', 'pre_id', 16020001,17020000,@pre_id out,0

      insert into Prestacion (pre_id,pre_nombre,pre_grupo1,pre_grupo4)
              values(@pre_id,'Aprobar tareas del proyecto (' + @proy_nombre + ')','Proyectos',@proy_nombre)

      update Proyecto set pre_id_aprobarTarea = @pre_id where proy_id = @@proy_id

  end else begin

      update prestacion set 
                              pre_nombre = 'Aprobar tareas del proyecto (' + @proy_nombre + ')',
                              pre_grupo4 = @proy_nombre
      where pre_id = @pre_id
  end

end

go