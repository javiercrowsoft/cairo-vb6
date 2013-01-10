if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_alarmaGetFechas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_alarmaGetFechas]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select max(al_id) from tarea

-- sp_alarmaGetFechas 131

create procedure sp_alarmaGetFechas (
  @@ali_id          int,
  @@tar_id_servicio  int,

  @@inicio      datetime out,
  @@estado1      datetime out,
  @@estado2      datetime out,
  @@fin          datetime out,

  @@bSuccess    smallint out,
  @@ErrorMsg    varchar(5000) out
)
as

set nocount on

begin

  set nocount on

  if @@ali_id is null begin

    set @@bSuccess = 0
    set @@ErrorMsg = '@@ERROR_SP:No se paso un item de alarma a sp_alarmaGetFechas.'

    return
  end

  declare @al_id   int
  declare @diatipo int

  declare @minutos_estado1 int
  declare @minutos_estado2 int

  declare @tipo_estado1  int
  declare @tipo_estado2 int

  declare @tiempo       decimal(18,6)
  declare @tiempo_tipo  tinyint
  declare @horas        int
  declare @minutos      int
  declare @dhorasxdia   decimal(18,6)
  declare @horasxdia    tinyint
  declare @minutosxdia  smallint
  declare @tiempo_desde tinyint
  declare @ali_laboral  tinyint
  declare @secuencia    tinyint

  select @minutos_estado1 = ali_alarma1,
         @minutos_estado2 = ali_alarma2,

         @tipo_estado1    = ali_alarmatipo1,
         @tipo_estado2    = ali_alarmatipo2,

         @tiempo          = ali_tiempo,
         @tiempo_tipo      = ali_tiempotipo,
         @tiempo_desde    = ali_tiempodesde,

         @ali_laboral      = ali_laboral,
         @secuencia       = ali_secuencia,

         @al_id            = al.al_id,
         @diatipo          = al_diatipo,
         @dhorasxdia      = al_horasxdia

  from Alarma al inner join AlarmaItem ali on al.al_id = ali.al_id

  where ali_id = @@ali_id


  set @horasxdia     = @dhorasxdia
  set @minutosxdia  = @dhorasxdia * 100 - @horasxdia * 100
  set @minutosxdia  = @horasxdia  * 60 + @minutosxdia

  if @tiempo_desde = 2 begin

    declare @fin_paso_anterior datetime

    select @fin_paso_anterior = max(tar_fechahorafin) 

    from Tarea t inner join AlarmaItem a on t.ali_id = a.ali_id
                                        and  a.al_id  = @al_id
    where tar_id_padre = @@tar_id_servicio
      and ali_secuencia < @secuencia

    if @fin_paso_anterior is not null set @@inicio = @fin_paso_anterior 

  end

  -- Si el tipo de tiempo es dias y son dias corridos
  -- solo sumamos los dias
  --
  if @tiempo_tipo = 2 and @ali_laboral = 2 /*dias corridos*/ begin

    set @@fin = dateadd(d,@tiempo,@@inicio)

  end else begin

    -- Fecha de fin
    set @minutos =   case @tiempo_tipo
                        when 1 then @tiempo * 60
                        when 2 then @tiempo * @minutosxdia
                    end
  
  
    exec sp_alarmaGetFechaLaboral @al_id,
                                  @diatipo,
                                  @@inicio,
                                  @minutos,
                                  1, --@@direccion
                                  @@fin out

  end

  -- Fechas para estado 1 y 2


  -- Todos estos manejos de minutos
  -- que le agrego sirven para que 
  -- las alarmas corten correctamente
  -- sobre las horas limite tipo 18:00
  -- o 9:00
  --
  declare @fin_aux datetime
  set @fin_aux = dateadd(n,-1,@@fin)

  -- Si el tipo de tiempo es dias y son dias corridos
  -- solo sumamos los dias
  --
  if @tipo_estado1 = 2 and @ali_laboral = 2 /*dias corridos*/ begin

    set @@estado1 = dateadd(d,-@minutos_estado1,@fin_aux)

  end else begin

    set @minutos_estado1 = case @tipo_estado1
                              when 1 then @minutos_estado1
                              when 2 then @minutos_estado1 * 60
                              when 3 then @minutos_estado1 * @minutosxdia
                           end
  
    -- Todos estos manejos de minutos
    -- que le agrego sirven para que 
    -- las alarmas corten correctamente
    -- sobre las horas limite tipo 18:00
    -- o 9:00
    --
    set @minutos_estado1 = @minutos_estado1+1
  
    exec sp_alarmaGetFechaLaboral @al_id,
                                  @diatipo,
                                  @fin_aux,
                                  @minutos_estado1,
                                  -1, --@@direccion
                                  @@estado1 out

  end

  -- Si el tipo de tiempo es dias y son dias corridos
  -- solo sumamos los dias
  --
  if @tipo_estado1 = 2 and @ali_laboral = 2 /*dias corridos*/ begin

    set @@estado2 = dateadd(d,-@minutos_estado2,@fin_aux)

  end else begin

    set @minutos_estado2 = case @tipo_estado2
                              when 1 then @minutos_estado2
                              when 2 then @minutos_estado2 * 60
                              when 3 then @minutos_estado2 * @minutosxdia
                           end
  
    set @@estado1 = dateadd(n,1,@@estado1)
  
    -- Todos estos manejos de minutos
    -- que le agrego sirven para que 
    -- las alarmas corten correctamente
    -- sobre las horas limite tipo 18:00
    -- o 9:00
    --
    set @minutos_estado2 = @minutos_estado2+1
    
    exec sp_alarmaGetFechaLaboral @al_id,
                                  @diatipo,
                                  @fin_aux,
                                  @minutos_estado2,
                                  -1, --@@direccion
                                  @@estado2 out

    set @@estado2 = dateadd(n,1,@@estado2)

  end

  set @@bSuccess = 1

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
