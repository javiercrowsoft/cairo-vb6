'-------------------------------------------------------------------------------'
/*
  declare @n         int
  declare @n2        int
  declare @old_dia   int
  
  set @@fin = @@inicio
  set @n     = 60
  set @n2    = 60

  declare @hora     int
  declare @minuto    int
  declare @desde_hora     tinyint
  declare @desde_minuto    tinyint
  declare @hasta_hora     tinyint
  declare @hasta_minuto    tinyint

  while @minutos > 0
  begin

    -- @n es una hora salvo que en
    -- minutos nos queden menos de 60
    --
    if @n > @minutos set @n = @minutos

    -- Le agregamos una hora
    --
    set @@fin = dateadd(n,@n,@@fin)
    set @minutos = @minutos - @n

    set @minuto = datepart(n,@@fin)
    set @hora   = datepart(hh,@@fin)
    set @hora   = @hora*100+@minuto -- Obtenemos la hora en formato milico

    -- Alarma semanal
    --
    if @diatipo = 1 begin

      -- Obtenemos el dia de la semana
      -- para esta fecha
      --
      set datefirst 1 
      set @dia = datepart(dw,@@fin)
      set datefirst @oldDateFirst        

      set @old_dia = @dia

      -- Obtenemos la franja horaria para
      -- este dia
      --
      select   @desde_hora   = alds_desdehora, 
              @desde_minuto = alds_desdeminuto, 
              @hasta_hora   = alds_hastahora, 
              @hasta_minuto = alds_hastaminuto

      from AlarmaDiaSemana
      where alds_dia = @dia
        and al_id    = @al_id    

      -- usamos el esquema de los milicos "son las mil cuatrocientos srrr"
      -- a pesar de todo a veces piensan
      --
      set @hasta_hora = @hasta_hora*100+@hasta_minuto
      set @desde_hora = @desde_hora*100+@desde_minuto

      -- Mientras la hora este fuera de la franja horaria
      -- le sumamos una hora
      --
      while @hora > @hasta_hora or @hora < @desde_hora
      begin

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
    
          select   @desde_hora   = alds_desdehora, 
                  @desde_minuto = alds_desdeminuto, 
                  @hasta_hora   = alds_hastahora, 
                  @hasta_minuto = alds_hastaminuto
    
          from AlarmaDiaSemana
          where alds_dia = @dia
            and al_id    = @al_id    

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

      -- Cargamos la franja horaria
      --
      select   @desde_hora   = aldm_desdehora, 
              @desde_minuto = aldm_desdeminuto, 
              @hasta_hora   = aldm_hastahora, 
              @hasta_minuto = aldm_hastaminuto

      from AlarmaDiaMes
      where aldm_dia = @dia
        and al_id    = @al_id    

      set @hasta_hora = @hasta_hora*100+@hasta_minuto
      set @desde_hora = @desde_hora*100+@desde_minuto

      -- Mientras estemos fuera de la franja horaria
      --
      while @hora > @hasta_hora or @hora < @desde_hora
      begin

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
    
          select   @desde_hora   = aldm_desdehora, 
                  @desde_minuto = aldm_desdeminuto, 
                  @hasta_hora   = aldm_hastahora, 
                  @hasta_minuto = aldm_hastaminuto
    
          from AlarmaDiaMes
          where aldm_dia = @dia
            and al_id    = @al_id    

          set @hasta_hora = @hasta_hora*100+@hasta_minuto
          set @desde_hora = @desde_hora*100+@desde_minuto

        end

      end

    end    

  end
'-------------------------------------------------------------------------------'
*/
