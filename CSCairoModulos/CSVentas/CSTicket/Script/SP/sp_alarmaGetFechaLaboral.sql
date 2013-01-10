if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_alarmaGetFechaLaboral]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarmaGetFechaLaboral]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*
  select al_id from alarma

  declare @fin datetime
  exec sp_alarmaGetFechaLaboral 6, 1, '20061125 11:55', 120, 1, @fin out

  select @fin

*/


create procedure sp_alarmaGetFechaLaboral (
  @@al_id        int, 
  @@diatipo     tinyint,
  @@inicio      datetime,
  @@minutos     int,
  @@direccion    int,
  @@fin          datetime out
)
as

set nocount on

begin

  set nocount on

/* for debug
select 
    @@al_id        ,
    @@diatipo     ,
    @@inicio      ,
    @@minutos     ,
    @@direccion    ,
    @@fin          
*/

  -- Me guardo el DATEFIRST original
  --
  declare @oldDateFirst int
  set @oldDateFirst = @@DATEFIRST 

  declare @n         int
  declare @n2        int
  declare @dia      int
  declare @old_dia   int
  
  set @@fin = @@inicio
  set @n     = 60 * @@direccion
  set @n2    = 60 * @@direccion

  declare @z     int set @z   = 0
  declare @max  int set @max = 5000

  declare @hora     int
  declare @minuto    int
  declare @segundo  int
  declare @desde_hora     int
  declare @desde_minuto    tinyint
  declare @hasta_hora     int
  declare @hasta_minuto    tinyint
  declare @fecha_dia      datetime

  declare @bRestar1Minuto        tinyint
  declare @bIngresoFueraDeHora   tinyint
  set @bIngresoFueraDeHora = 0
  set @bRestar1Minuto      = 0

  while @@minutos > 0
  begin

    if @z > @max begin select @z return end
    else set @z = @z + 1

    set @minuto = datepart(n,@@fin)
    set @hora   = datepart(hh,@@fin)
    set @hora   = @hora*100+@minuto -- Obtenemos la hora en formato milico

    -- Alarma semanal
    --
    if @@diatipo = 1 begin

      -- Obtenemos el dia de la semana
      -- para esta fecha
      --
      set datefirst 1 
      set @dia = datepart(dw,@@fin)
      set datefirst @oldDateFirst        

      set @old_dia = @dia

      -- Buscamos este dia entre las fechas 
      -- especiales de la alarma
      --
      -- le sacamos las horas, minutos, segundos y milisegundos
      --
      set @fecha_dia = dateadd(hh, -datepart(hh,@@fin), @@fin)
      set @fecha_dia = dateadd(n, -datepart(n,@fecha_dia), @fecha_dia)
      set @fecha_dia = dateadd(s, -datepart(s,@fecha_dia), @fecha_dia)
      set @fecha_dia = dateadd(ms, -datepart(ms,@fecha_dia), @fecha_dia)

      if exists(select * from AlarmaFecha where alf_fecha = @fecha_dia and al_id = @@al_id) begin

        -- Obtenemos la franja horaria para
        -- este dia
        --
        select   @desde_hora   = alf_desdehora, 
                @desde_minuto = alf_desdeminuto, 
                @hasta_hora   = alf_hastahora, 
                @hasta_minuto = alf_hastaminuto

        from AlarmaFecha 
        where alf_fecha = @fecha_dia
          and al_id     = @@al_id

      end else begin

        -- Obtenemos la franja horaria para
        -- este dia
        --
        select   @desde_hora   = alds_desdehora, 
                @desde_minuto = alds_desdeminuto, 
                @hasta_hora   = alds_hastahora, 
                @hasta_minuto = alds_hastaminuto
  
        from AlarmaDiaSemana
        where alds_dia = @dia
          and al_id    = @@al_id    

      end
      -- usamos el esquema de los milicos "son las mil cuatrocientos srrr"
      -- a pesar de todo a veces piensan
      --
      set @hasta_hora = @hasta_hora*100+@hasta_minuto
      set @desde_hora = @desde_hora*100+@desde_minuto

      -- Si la orden se genera fuera de la franja horaria
      -- por ejemplo un alta via web, tenemos
      -- que empezar a contar desde el inicio de la franja
      -- horaria, es decir que la fecha inicial es desplazada
      -- directamente hasta la hora desde de la franja horaria
      --
      if (@hora > @hasta_hora or @hora < @desde_hora) and @z = 1 begin
        set @bIngresoFueraDeHora = 1
      end

      -- Mientras la hora este fuera de la franja horaria
      -- le sumamos una hora
      --
      while @hora > @hasta_hora or @hora < @desde_hora
      begin

        if @z > @max begin select @z return end
        else set @z = @z + 1

        -- Desplazamos la fecha en una hora
        -- ojo siempre una hora 
        --
        set @@fin = dateadd(n,@n2,@@fin)
    
        -- Otra vez a formato milico
        --
        set @minuto = datepart(n,@@fin)
        set @hora   = datepart(hh,@@fin)
        set @hora   = @hora*100+@minuto

        -- Vemos en que dia estamos
        --
        set datefirst 1 
        set @dia = datepart(dw,@@fin)
        set datefirst @oldDateFirst

        -- Si cambiamos de dia vamos a tener que
        -- volver a buscar la franja horaria
        --
        if @old_dia <> @dia begin

          set @old_dia = @dia
    

          -- Buscamos este dia entre las fechas 
          -- especiales de la alarma
          --
          -- le sacamos las horas, minutos, segundos y milisegundos
          --
          set @fecha_dia = dateadd(hh, -datepart(hh,@@fin), @@fin)
          set @fecha_dia = dateadd(n, -datepart(n,@fecha_dia), @fecha_dia)
          set @fecha_dia = dateadd(s, -datepart(s,@fecha_dia), @fecha_dia)
          set @fecha_dia = dateadd(ms, -datepart(ms,@fecha_dia), @fecha_dia)
    
          if exists(select * from AlarmaFecha where alf_fecha = @fecha_dia and al_id = @@al_id) begin
    
            -- Obtenemos la franja horaria para
            -- este dia
            --
            select   @desde_hora   = alf_desdehora, 
                    @desde_minuto = alf_desdeminuto, 
                    @hasta_hora   = alf_hastahora, 
                    @hasta_minuto = alf_hastaminuto
    
            from AlarmaFecha 
            where alf_fecha = @fecha_dia
              and al_id     = @@al_id
    
          end else begin

            select   @desde_hora   = alds_desdehora, 
                    @desde_minuto = alds_desdeminuto, 
                    @hasta_hora   = alds_hastahora, 
                    @hasta_minuto = alds_hastaminuto
      
            from AlarmaDiaSemana
            where alds_dia = @dia
              and al_id    = @@al_id    

          end

          set @hasta_hora = @hasta_hora*100+@hasta_minuto
          set @desde_hora = @desde_hora*100+@desde_minuto

        end

      end

    -- Alarma mensual
    --
    end else begin

      -- Obtenemos el dia del mes 1..31
      --
      set @dia = datepart(d,@@fin)
      set @old_dia = @dia

      -- Buscamos este dia entre las fechas 
      -- especiales de la alarma
      --
      -- le sacamos las horas, minutos, segundos y milisegundos
      --
      set @fecha_dia = dateadd(hh, -datepart(hh,@@fin), @@fin)
      set @fecha_dia = dateadd(n, -datepart(n,@fecha_dia), @fecha_dia)
      set @fecha_dia = dateadd(s, -datepart(s,@fecha_dia), @fecha_dia)
      set @fecha_dia = dateadd(ms, -datepart(ms,@fecha_dia), @fecha_dia)

      if exists(select * from AlarmaFecha where alf_fecha = @fecha_dia and al_id = @@al_id) begin

        -- Obtenemos la franja horaria para
        -- este dia
        --
        select   @desde_hora   = alf_desdehora, 
                @desde_minuto = alf_desdeminuto, 
                @hasta_hora   = alf_hastahora, 
                @hasta_minuto = alf_hastaminuto

        from AlarmaFecha 
        where alf_fecha = @fecha_dia
          and al_id     = @@al_id

      end else begin

        -- Cargamos la franja horaria
        --
        select   @desde_hora   = aldm_desdehora, 
                @desde_minuto = aldm_desdeminuto, 
                @hasta_hora   = aldm_hastahora, 
                @hasta_minuto = aldm_hastaminuto
  
        from AlarmaDiaMes
        where aldm_dia = @dia
          and al_id    = @@al_id    

      end

      set @hasta_hora = @hasta_hora*100+@hasta_minuto
      set @desde_hora = @desde_hora*100+@desde_minuto

      -- Si la orden se genera fuera de la franja horaria
      -- por ejemplo un alta via web, tenemos
      -- que empezar a contar desde el inicio de la franja
      -- horaria, es decir que la fecha inicial es desplazada
      -- directamente hasta la hora desde de la franja horaria
      --
      if (@hora > @hasta_hora or @hora < @desde_hora) and @z = 1 begin
        set @bIngresoFueraDeHora = 1
      end

      -- Mientras estemos fuera de la franja horaria
      --
      while @hora > @hasta_hora or @hora < @desde_hora
      begin

        if @z > @max begin select @z return end
        else set @z = @z + 1

        -- Le vamos agregando una hora hasta lograr
        -- entrar en la franja horaria
        --
        set @@fin = dateadd(n,@n2,@@fin)
    
        set @minuto = datepart(n,@@fin)
        set @hora   = datepart(hh,@@fin)
        set @hora   = @hora*100+@minuto -- Hora en formato milico

        set @dia = datepart(d,@@fin)

        -- Si cambiamos de dia volvemos cargar 
        -- la franja horaria
        --
        if @old_dia <> @dia begin

          set @old_dia = @dia
    
          -- Buscamos este dia entre las fechas 
          -- especiales de la alarma
          --
          -- le sacamos las horas, minutos, segundos y milisegundos
          --
          set @fecha_dia = dateadd(hh, -datepart(hh,@@fin), @@fin)
          set @fecha_dia = dateadd(n, -datepart(n,@fecha_dia), @fecha_dia)
          set @fecha_dia = dateadd(s, -datepart(s,@fecha_dia), @fecha_dia)
          set @fecha_dia = dateadd(ms, -datepart(ms,@fecha_dia), @fecha_dia)
    
          if exists(select * from AlarmaFecha where alf_fecha = @fecha_dia and al_id = @@al_id) begin
    
            -- Obtenemos la franja horaria para
            -- este dia
            --
            select   @desde_hora   = alf_desdehora, 
                    @desde_minuto = alf_desdeminuto, 
                    @hasta_hora   = alf_hastahora, 
                    @hasta_minuto = alf_hastaminuto
    
            from AlarmaFecha 
            where alf_fecha = @fecha_dia
              and al_id     = @@al_id
    
          end else begin

            select   @desde_hora   = aldm_desdehora, 
                    @desde_minuto = aldm_desdeminuto, 
                    @hasta_hora   = aldm_hastahora, 
                    @hasta_minuto = aldm_hastaminuto
      
            from AlarmaDiaMes
            where aldm_dia = @dia
              and al_id    = @@al_id    

          end

          set @hasta_hora = @hasta_hora*100+@hasta_minuto
          set @desde_hora = @desde_hora*100+@desde_minuto

        end

      end

    end    

    if @bIngresoFueraDeHora = 1 begin

      set @bIngresoFueraDeHora = 0

      -- Remplazo la hora de apertura del ticket por la hora
      -- de inicio de la franja horaria
      set @minuto   = datepart(n,@@fin)
      set @hora     = datepart(hh,@@fin)
      set @segundo  = datepart(s,@@fin)

      set @@fin = dateadd(s, -@segundo,@@fin)
      set @@fin = dateadd(n, -@minuto,@@fin)
      set @@fin = dateadd(hh,-@hora,@@fin)

      set @minuto = @desde_hora % 100
      set @hora   = (@desde_hora - @minuto) /100

      set @@fin = dateadd(n,@minuto,@@fin)
      set @@fin = dateadd(hh,@hora,@@fin)

      set @bRestar1Minuto = 1
      set @@fin = dateadd(n,1,@@fin)

    end

    -- @n es una hora salvo que en
    -- minutos nos queden menos de 60
    --
    if abs(@n) > @@minutos set @n = @@minutos * @@direccion

    -- Le agregamos una hora
    --
    set @@fin = dateadd(n,@n,@@fin)
    set @@minutos = @@minutos - (@n * @@direccion)

  end

  if @bRestar1Minuto <> 0 set @@fin = dateadd(n,-1,@@fin)

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
