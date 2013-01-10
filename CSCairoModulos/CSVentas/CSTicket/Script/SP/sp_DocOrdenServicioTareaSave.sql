if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioTareaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioTareaSave]

go

create procedure sp_DocOrdenServicioTareaSave (
  @@osTMP_id    int,
  @@os_id       int,
  @@bSuccess    tinyint out,
  @@ErrorMsg    varchar(5000) out
)
as

begin

  set nocount on

  set @@bSuccess = 0

  if @@os_id is null 
  begin

    set @@ErrorMsg = '@@ERROR_SP:No se paso un ID de Orden de Servicio al SP sp_DocOrdenServicioTareaSave. No es posible guardar las tareas para esta orden de servicio.'
    return

  end

  declare @tar_id     int
  declare @cli_id     int
  declare @clis_id    int
  declare @proy_id    int 
  declare @os_nrodoc  varchar(50)
  declare @os_fecha   datetime
  declare @os_descrip varchar(7000)
  declare @rub_id     int
  declare @os_hora    smallint
  declare @modifico   int
  declare @cont_id    int
  declare @prio_id    int

  declare @tarest_id  int
  declare @proyi_id   int
  declare @obje_id    int

  declare @st_id      int

  declare @ta_nrodoc    varchar(255)
  declare @ta_id        int
  declare @proy_nombre  varchar(255)

  declare @tar_id_subtarea int

  select   @tar_id       = tar_id, 
          @proy_id       = proy_id, 
          @os_nrodoc    = os_nrodoc,
          @os_descrip   = os_descrip,
          @os_fecha     = os_fecha,
          @cli_id        = cli_id,
          @clis_id      = clis_id,
          @os_hora      = os_hora,
          @cont_id      = cont_id,
          @prio_id      = prio_id,
          @modifico      = modifico,
          @st_id        = st_id

  from OrdenServicio where os_id = @@os_id

  select @rub_id = max(rub_id) 
  from OrdenServicioItem osi inner join producto pr on osi.pr_id = pr.pr_id 
  where os_id = @@os_id

  declare @prns_id int

  if exists(select st_id 
            from StockItem 
            where st_id = @st_id 
              and sti_ingreso > 0 
            group by st_id
            having count(st_id)>1)
    set @prns_id = null
  else
    select @prns_id = prns_id from StockItem where st_id = @st_id and sti_ingreso > 0

  declare @tar_fechahoraini datetime

  set @tar_fechahoraini = dateadd(n,
                              @os_hora%100,
                              dateadd(hh,
                                      convert(int,@os_hora / 100), 
                                      @os_fecha)
                              )

  -- Creamos una tarea para la Orden de Servicio
  --
  if @tar_id is null begin

    -- Obtenemos el proyecto
    --
    if @proy_id is null begin

      declare @cfg_valor varchar(5000) 
  
      exec sp_Cfg_GetValor  'Servicios-General',
                            'Proyecto Generico',
                            @cfg_valor out,
                            0
  
      set @proy_id = convert(int,@cfg_valor)


      if @proy_id is null begin
  
        exec sp_Cfg_GetValor  'Ticket-General',
                              'Proyecto Generico',
                              @cfg_valor out,
                              0
    
        set @proy_id = convert(int,@cfg_valor)
      end

    end

    if @proy_id is null begin

      set @@ErrorMsg = '@@ERROR_SP:No se ha indicado un proyecto para esta orden de servicio, y no esta definido el proyecto genérico. No es posible guardar las tareas para esta orden de servicio.'
      return

    end

    -- Obtenemos el talonario
    -- 
    select @ta_id = ta_id, @proy_nombre = proy_nombre from Proyecto where proy_id = @proy_id

    if @ta_id is null begin

      set @@ErrorMsg = '@@ERROR_SP:El proyecto ' + @proy_nombre + ' no posee talonario. No es posible guardar las tareas para esta orden de servicio.'
      return

    end

    select @tarest_id = tarest_id 
    from TareaEstado 
    where tarest_id = (select min(proyest_id) from ProyectoTareaEstado where proy_id = @proy_id)

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
                        tar_finalizada,
                        tar_cumplida,
                        tar_rechazada,
                        tar_aprobada,
                        tar_plantilla,
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
                        modifico,
                        activo
                     )
              values  ( @tar_id,
                        null,
                        @ta_nrodoc, 
                        'Orden de Servicio ' + @os_nrodoc,
                        @os_descrip,
                        @os_fecha,
                        @os_hora,
                        @tar_fechahoraini,
                        0,
                        0,
                        0,
                        1,
                        0,
                        @rub_id,
                        null,
                        null,
                        @modifico,
                        @cont_id,
                        @tarest_id,
                        @prio_id,
                        @proy_id,
                        @proyi_id,
                        @obje_id,
                        @cli_id,
                        @clis_id,
                        null,
                        @prns_id,
                        @@os_id,
                        @modifico,
                        1
                     )
    if @@error <> 0 goto ControlError

    exec sp_TalonarioSet @ta_id,@ta_nrodoc
    if @@error <> 0 goto ControlError

    update OrdenServicio set tar_id = @tar_id where os_id = @@os_id
    if @@error <> 0 goto ControlError

  end else begin

    -- Obtenemos el proyecto
    --
    if @proy_id is null begin

      select @proy_id = proy_id from Tarea where tar_id = @tar_id

    end

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

    select @proyi_id = min(proyi_id) from ProyectoItem where proy_id = @proy_id
    select @obje_id  = min(obje_id)  from Objetivo      where proy_id = @proy_id

    -- Actualizamos la tarea
    --
    update Tarea set    tar_nombre  = 'Orden de Servicio ' + @os_nrodoc,
                        tar_descrip = case when tar_descrip <> @os_descrip then 
                                                    substring(tar_descrip + char(13) + '----' + @os_descrip,1,7000)
                                           else     tar_descrip
                                      end,
                        tar_fechaini      = @os_fecha,
                        tar_horaini        = @os_hora,
                        tar_fechahoraini  = @tar_fechahoraini,
                        rub_id            = @rub_id,
                        cont_id            = @cont_id,
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

                        prns_id       = @prns_id,

                        cli_id        = @cli_id,
                        clis_id        = @clis_id,
                        os_id          = @@os_id,
                        modifico      = @modifico

    where tar_id = @tar_id
    if @@error <> 0 goto ControlError

  end

  -- Creamos una tarea por cada equipo/producto
  -- que se ingrese en la orden de servicio
  --

  -- Nos guardamos el id del proyecto de la orden de servicio
  -- para obtener las alarmas
  --
  declare @proy_id_servicio int
  declare @tar_id_servicio  int

  set @proy_id_servicio = @proy_id
  set @tar_id_servicio  = @tar_id

  declare @tar_id_plantilla  int
  declare @cont_id_equipo   int
  declare @item             int

  declare c_equipos insensitive cursor for

      select sti.prns_id, tar.rub_id, osi.tar_id, osi_orden, osi.cont_id 
      from StockItem sti 
                inner join OrdenServicioItem osi 
                    on     sti.sti_grupo = osi.osi_id
                left join Tarea tar 
                    on osi.tar_id = tar.tar_id

      where st_id = @st_id
        and  osi.osi_id = @@os_id

  open c_equipos

  fetch next from c_equipos into @prns_id, @rub_id, @tar_id_plantilla, @item, @cont_id_equipo  
  while @@fetch_status=0
  begin

    if @tar_id_plantilla is not null begin

      if @cont_id_equipo is null set @cont_id_equipo = @cont_id

      exec sp_DocOrdenServicioSubTareaSave   @@osTMP_id,
                                            @@os_id,
                                            @@bSuccess out,
                                            @@ErrorMsg out,

                                            @prns_id,
                                            @tar_id_servicio,
                                            @tar_id_plantilla,
                                            @os_hora,
                                            @os_fecha,
                                            @cli_id,
                                            @clis_id,
                                            @proy_id_servicio,
                                            @rub_id,
                                            @os_nrodoc,
                                            @os_descrip,
                                            @modifico,
                                            @cont_id_equipo,
                                            @prio_id,
                                            @tar_id_subtarea out

      -- Si el documento no es valido
      if IsNull(@@bSuccess,0) = 0 return

      -- Solo recibo @tar_id_subtarea cuando la tarea es nueva
      -- para Updates sp_DocOrdenServicioSubTareaSave devuelve NULL
      -- de esta forma solo asocio el numero de serie con la 
      -- primer tarea del workflow cuando creo las tareas
      --
      if @tar_id_subtarea is not null begin
        update ProductoNumeroSerie set tar_id = @tar_id_subtarea where prns_id = @prns_id
        if @@error <> 0 goto ControlError
      end

    end else begin

      set @@ErrorMsg = '@@ERROR_SP:No se pudo obtener la tarea plantilla para el item '+ @item +'. No es posible guardar las tareas para esta orden de servicio.'
      return

    end

    fetch next from c_equipos into @prns_id, @rub_id, @tar_id_plantilla, @item, @cont_id_equipo
  end

  close c_equipos
  deallocate c_equipos

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--
--  ACTUALIZO LAS ALARMAS DE LA TAREA PRINCIPAL
--
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

  declare @tar_fechahorafin    datetime
  declare @tar_fechafin        datetime
  declare @tar_alarma          datetime

  select @tar_fechahorafin  = max(tar_fechahorafin) from Tarea where tar_id_padre = @tar_id_servicio
  select @tar_fechafin      =  max(tar_fechafin)     from Tarea where tar_id_padre = @tar_id_servicio
  select @tar_alarma        =  max(tar_alarma)       from Tarea where tar_id_padre = @tar_id_servicio

  set @tar_fechahorafin  = isnull(@tar_fechahorafin, getdate())
  set @tar_fechafin      =  isnull(@tar_fechafin, getdate())
  set @tar_alarma        = isnull(@tar_alarma, getdate())
  -- Actualizamos la tarea
  --
  update Tarea set    tar_fechahorafin   = @tar_fechahorafin,
                      tar_fechafin      = @tar_fechafin,
                      tar_alarma        = @tar_alarma

  where tar_id = @tar_id_servicio
  if @@error <> 0 goto ControlError

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--
--  FIN
--
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------


  set @@bSuccess = 1
  return

ControlError:

  set @@ErrorMsg = '@@ERROR_SP:Ha ocurrido un error. No es posible guardar las tareas para esta orden de servicio.'
  return

end
