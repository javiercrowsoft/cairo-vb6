if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioSubTareaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioSubTareaSave]

go

create procedure sp_DocOrdenServicioSubTareaSave (
  @@osTMP_id    int,
  @@os_id       int,
  @@bSuccess    tinyint out,
  @@ErrorMsg    varchar(5000) out,

  @prns_id              int,
  @tar_id_servicio      int,
  @tar_id_plantilla      int,
  @os_hora              smallint,
  @os_fecha              datetime,
  @cli_id                int,
  @clis_id              int,
  @proy_id_servicio     int,
  @rub_id                int,
  @os_nrodoc            varchar(50),
  @os_descrip           varchar(7000),
  @modifico             int,
  @cont_id_equipo        int,
  @prio_id              int,
  @@tar_id_new          int out
)
as

begin

  set nocount on

  declare @descrip          varchar(50)

  declare @tar_id_equipo    int
  declare @proy_id          int
  declare @ta_nrodoc        varchar(255)
  declare @ta_id            int
  declare @proy_nombre      varchar(255)

  declare @inicio     datetime
  declare @minutos    smallint
   declare @horas      smallint
   declare @estado1     datetime
   declare @estado2     datetime
   declare @fin         datetime
   declare @fin_fecha  datetime

  declare @tarest_id  int
  declare @proyi_id   int
  declare @obje_id    int
  declare @tar_id     int

  declare @tar_id_inicial  int -- La primera tarea de todo el WorkFlow

  declare @cli_id_proyecto int -- Las subtares van con el cliente del proyecto

  set @@bSuccess = 0

  select @proy_id = min(proy_id)
  from Tarea 
  where prns_id = @prns_id 
    and os_id   = @@os_id
    and tar_id <> @tar_id_servicio

  if @proy_id is null begin

    select @proy_id = proy_id from Tarea where tar_id = @tar_id_plantilla

    -- Obtenemos el talonario
    -- 
    select @ta_id = ta_id, @proy_nombre = proy_nombre from Proyecto where proy_id = @proy_id

    if @ta_id is null begin

      set @@ErrorMsg = '@@ERROR_SP:El proyecto ' + @proy_nombre + ' no posee talonario. No es posible guardar las tareas para esta orden de servicio.'
      return

    end

  end

  set @minutos = @os_hora % 100
  set @horas   = @os_hora / 100
  
  set @inicio = dateadd(hh,@horas,  @os_fecha)
  set @inicio = dateadd(n, @minutos,@inicio)

  declare @al_id  int 
  declare @dia    int
  declare @diames int

  set nocount on

  -- Me guardo el DATEFIRST original
  --
  declare @oldDateFirst int
  set @oldDateFirst = @@DATEFIRST 

  set datefirst 1 
  set @dia = datepart(dw,@inicio)
  set datefirst @oldDateFirst

  set @diames = datepart(d,@inicio)

  exec sp_alarmaGetFromFilters   @cli_id,
                                @clis_id,
                                @proy_id,
                                @rub_id,
                                @dia,
                                @diames,
                                @al_id out

  if @al_id is null begin

    set @@bSuccess = 0
    set @@ErrorMsg = '@@ERROR_SP:El sistema no pudo encontrar una definición de alarmas que ' +
                     'coincida con esta combinación de "cliente, sucursal, contrato, rubro, ' +
                     'día de la semana o día del mes". Verifique la definición de alarmas. '+
                     'Recuerde que todos los días deben estar alcanzados al menos por una alarma.'

    return
  end

  declare @ali_id       int
  declare @opcional     tinyint
  declare @ali_nombre    varchar(255)
  declare @alit_id      int 

  declare c_alarmaItems insensitive cursor for 
        select   ali_id,
                ali_nombre, 
                 case 
                  when ali_obligatorioremito + ali_obligatoriofactura <> 0 then 0
                  else 1
                end,
                alit_id

        from AlarmaItem ali
        where al_id = @al_id
          and (    ali_obligatorioremito  <> 0 
              or   ali_obligatoriofactura <> 0
              or  exists(select ali_id from OrdenServicioAlarmaTMP where ali_id = ali.ali_id and osTMP_id = @@osTMP_id)
              or  exists(select ali_id from AlarmaItem 
                         where   ali_id <> ali.ali_id 
                            and al_id  = ali.al_id
                            and ali_secuencia < ali.ali_secuencia 
                            and (ali_obligatorioremito  <> 0 or ali_obligatoriofactura <> 0)
                        )
              )
        order by ali_secuencia

  open c_alarmaItems

  fetch next from c_alarmaItems into @ali_id, @ali_nombre, @opcional, @alit_id
  while @@fetch_status = 0
  begin

    -- Obtenemos las fechas de alarma
    -- 
    exec sp_alarmaGetFechas @ali_id,
                            @tar_id_servicio,

                            @inicio      out, 
                            @estado1     out, 
                            @estado2     out, 
                            @fin         out,
                            @@bSuccess   out,
                            @@ErrorMsg   out

    -- le sacamos las horas, minutos, segundos y milisegundos
    --
    set @os_fecha = @inicio
    set @os_hora  = datepart(hh,@os_fecha)*100+datepart(n,@os_fecha)
    set @os_fecha = dateadd(hh, -datepart(hh,@os_fecha), @os_fecha)
    set @os_fecha = dateadd(n, -datepart(n,@os_fecha), @os_fecha)
    set @os_fecha = dateadd(s, -datepart(s,@os_fecha), @os_fecha)
    set @os_fecha = dateadd(ms, -datepart(ms,@os_fecha), @os_fecha)

    -- Si el documento no es valido
    --
    if @@error <> 0 goto ControlError
    if IsNull(@@bSuccess,0) = 0 return

    set @descrip = ' ' + @ali_nombre

    -- Busco una tarea asociada con este item de alarma
    --
    select @tar_id_equipo = tar_id, @proy_id = proy_id 
    from Tarea 
    where prns_id       = @prns_id 
      and tar_id_padre   = @tar_id_servicio
      and ali_id         = @ali_id

--------------------------------------------------------------------------------------------------------------------------------------    
--------------------------------------------------------------------------------------------------------------------------------------    
--
--    INSERT DE LA TAREA
--
--------------------------------------------------------------------------------------------------------------------------------------    
--------------------------------------------------------------------------------------------------------------------------------------    

    if @tar_id_equipo is null begin
      
      select @proy_id = proy_id from Tarea where tar_id = @tar_id_plantilla
  
      -- Obtenemos el talonario
      -- 
      select @ta_id = ta_id, @proy_nombre = proy_nombre from Proyecto where proy_id = @proy_id
  
      if @ta_id is null begin
  
        set @@ErrorMsg = '@@ERROR_SP:El proyecto ' + @proy_nombre + ' no posee talonario. No es posible guardar las tareas para esta orden de servicio.'
        return
  
      end
      
      -- le sacamos las horas, minutos, segundos y milisegundos
      --
      set @fin_fecha = dateadd(hh, -datepart(hh,@fin), @fin)
      set @fin_fecha = dateadd(n, -datepart(n,@fin_fecha), @fin_fecha)
      set @fin_fecha = dateadd(s, -datepart(s,@fin_fecha), @fin_fecha)
      set @fin_fecha = dateadd(ms, -datepart(ms,@fin_fecha), @fin_fecha)
  
      select @tarest_id = tarest_id 
      from TareaEstado 
      where tarest_id = (select min(proyest_id) from ProyectoTareaEstado where proy_id = @proy_id)
  
      select @cli_id_proyecto = cli_id from Proyecto      where proy_id = @proy_id
      select @proyi_id = min(proyi_id) from ProyectoItem where proy_id = @proy_id
      select @obje_id  = min(obje_id)  from Objetivo      where proy_id = @proy_id
  
  
      exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out, 0
      if @@error <> 0 goto ControlError
  
      exec sp_dbgetnewid 'tarea', 'tar_id', @tar_id out, 0
      if @@error <> 0 goto ControlError
  
      -- Insertamos la tarea
      --
      insert into Tarea ( tar_id,
                          tar_id_padre,
                          tar_numero,
                          tar_nombre,
                          tar_descrip,
                          tar_fechaini,
                          tar_horaini,
                          tar_fechahoraini,
                          tar_fechafin,
                          tar_fechahorafin,
                          tar_alarma,
                          tar_estado1,
                          tar_estado2,
                          tar_finalizada,
                          tar_cumplida,
                          tar_rechazada,
                          tar_aprobada,
                          tar_plantilla,
                          tar_opcional,
                          rub_id,
                          us_id_responsable,
                          us_id_asignador,
                          us_id_alta,
                          cont_id,
                          tarest_id,
                          prio_id,
                          proy_id,
                          proyi_id,
                          obje_id,
                          cli_id,
                          clis_id,
                          dpto_id,
                          prns_id,
                          os_id,
                          ali_id,
                          alit_id,
                          modifico,
                          activo
                       )
                values  ( @tar_id,
                          @tar_id_servicio,
                          @ta_nrodoc, 
                          'O.S. ' + @os_nrodoc + @descrip,
                          @os_descrip,
                          @os_fecha,
                          @os_hora,
                          @inicio,
                          @fin_fecha,
                          @fin,
                          @estado2,
                          @estado1,
                          @estado2,
                          0,
                          0,
                          0,
                          1,
                          0,
                          @opcional,
                          @rub_id,
                          null,
                          null,
                          @modifico,
                          @cont_id_equipo,
                          @tarest_id,
                          @prio_id,
                          @proy_id,
                          @proyi_id,
                          @obje_id,
                          @cli_id_proyecto,
                          null,
                          null,
                          @prns_id,
                          @@os_id,
                          @ali_id,
                          @alit_id,
                          @modifico,
                          1
                       )
      if @@error <> 0 goto ControlError
  
      exec sp_TalonarioSet @ta_id,@ta_nrodoc
      if @@error <> 0 goto ControlError
  
      if @tar_id_inicial is null set @tar_id_inicial = @tar_id
  
--------------------------------------------------------------------------------------------------------------------------------------    
--------------------------------------------------------------------------------------------------------------------------------------    
--
--    UPDATE DE LA TAREA
--
--------------------------------------------------------------------------------------------------------------------------------------    
--------------------------------------------------------------------------------------------------------------------------------------    

    end else begin
  
      -- Esto no puede darse nunca
      -- pero por si las moscas
      --
      if @proy_id is null begin
  
        set @@ErrorMsg = '@@ERROR_SP:No se pudo obtener el proyecto para modificar la tarea. No es posible guardar las tareas para esta orden de servicio.'
        return
  
      end
  
      select @tarest_id = tarest_id 
      from TareaEstado 
      where tarest_id = (select min(proyest_id) from ProyectoTareaEstado where proy_id = @proy_id)
  
      select @cli_id_proyecto = cli_id from Proyecto      where proy_id = @proy_id
      select @proyi_id = min(proyi_id) from ProyectoItem where proy_id = @proy_id
      select @obje_id  = min(obje_id)  from Objetivo      where proy_id = @proy_id
  
      -- le sacamos las horas, minutos, segundos y milisegundos
      --
      set @fin_fecha = dateadd(hh, -datepart(hh,@fin), @fin)
      set @fin_fecha = dateadd(n, -datepart(n,@fin_fecha), @fin_fecha)
      set @fin_fecha = dateadd(s, -datepart(s,@fin_fecha), @fin_fecha)
      set @fin_fecha = dateadd(ms, -datepart(ms,@fin_fecha), @fin_fecha)
  
      -- Actualizamos la tarea
      --
      update Tarea set    tar_id_padre = @tar_id_servicio,
                          tar_nombre   = 'O.S. ' + @os_nrodoc + @descrip,
                          tar_descrip  = case when tar_descrip <> @os_descrip then 
                                                      substring(tar_descrip + char(13) + '----' + @os_descrip,1,7000)
                                              else     tar_descrip
                                         end,
  
                          tar_fechaini      = @os_fecha,
                          tar_horaini        = @os_hora,
                          tar_fechahoraini  = @inicio,
                          tar_fechafin      = @fin_fecha,
                          tar_fechahorafin  = @fin,
                          tar_alarma        = @estado2,
                          tar_estado1        = @estado1,
                          tar_estado2        = @estado2,
                          tar_opcional      = @opcional,
                          rub_id            = @rub_id,
                          cont_id            = @cont_id_equipo,
                          prio_id            = @prio_id,
                          proy_id            = @proy_id,
  
                          tarest_id     = case when proy_id = @proy_id then tarest_id
                                               else                         @tarest_id
                                          end,
                          proyi_id      = case when proy_id = @proy_id then proyi_id
                                               else                         @proyi_id
                                          end,
                          obje_id        = case when proy_id = @proy_id then obje_id
                                               else                         @obje_id
                                          end,
  
                          cli_id        = @cli_id_proyecto,
                          clis_id        = @clis_id,
                          os_id          = @@os_id,
                          alit_id       = @alit_id,
                          modifico      = @modifico
  
      where tar_id = @tar_id_equipo
      if @@error <> 0 goto ControlError
  
      set @@tar_id_new = null -- Solo devulevo le Id de la tarea cuando es nueva
  
    end

--------------------------------------------------------------------------------------------------------------------------------------    
--------------------------------------------------------------------------------------------------------------------------------------    
--
--    FIN TAREA
--
--------------------------------------------------------------------------------------------------------------------------------------    
--------------------------------------------------------------------------------------------------------------------------------------    

    fetch next from c_alarmaItems into @ali_id, @ali_nombre, @opcional, @alit_id
  end

  close c_alarmaItems
  deallocate c_alarmaItems

  set @@tar_id_new = @tar_id_inicial

  set @@bSuccess = 1
  return

ControlError:

  set @@ErrorMsg = '@@ERROR_SP:Ha ocurrido un error. No es posible guardar las tareas para esta orden de servicio.'
  return

end
