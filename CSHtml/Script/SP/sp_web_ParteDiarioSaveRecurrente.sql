if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioSaveRecurrente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioSaveRecurrente]

go

/*

Si la distancia entre fecha ini y fecha fin es mayor 
a 0 periodos de recurrencia (dias, semanas, meses, años, etc.),
se repite dentro de dicho periodo, si la distancia es 0,
se repite durante este esquema:

si recurrente es:

        -- 1 > Semana              12
        -- 2 > Todos los dias      31
        -- 3 > Año                10
        -- 4 > Mes                24
        -- 6 > Bimestre            12
        -- 7 > Trimestre          8
        -- 8 > Cuatrimestre        6
        -- 9 > Semestre            4

select * from partediario where ptd_id_padre = 59

delete partediario where ptd_id_padre = 59

sp_web_ParteDiarioSaveRecurrente 59

*/

create procedure sp_web_ParteDiarioSaveRecurrente (
  @@ptd_id  int,
  @@bDelete tinyint
)
as

begin

  set nocount on

  if @@bDelete <> 0 delete ParteDiario where ptd_id_padre = @@ptd_id and ptd_recurrente <> 0 and ptd_recurrente <> 10

  if not exists(select * from ParteDiario where ptd_id = @@ptd_id 
                                            and ptd_recurrente <> 0
                                            and ptd_recurrente <> 10) return

  declare @ptd_recurrente    tinyint
  declare @ptd_fechaini      datetime
  declare @ptd_fechafin      datetime
  declare @ptd_alarma       datetime
  declare @ptd_fechaini2    datetime
  declare @ptd_fechafin2    datetime
  declare @ptd_alarma2      datetime
  declare @count            int

  select 
        @ptd_recurrente = ptd_recurrente,
        @ptd_fechaini    = ptd_fechaini,
        @ptd_fechafin    = ptd_fechafin,
        @ptd_alarma      = ptd_alarma

  from ParteDiario where ptd_id = @@ptd_id 

  select @count =
      case @ptd_recurrente
        -- 1 > Semana
        when 1 then
          datediff(wk,@ptd_fechaini,@ptd_fechafin)
        -- 2 > Todos los dias
        when 2 then
          datediff(dd,@ptd_fechaini,@ptd_fechafin)
        -- 3 > Año
        when 3 then
          datediff(yyyy,@ptd_fechaini,@ptd_fechafin)
        -- 4 > Mes
        when 4 then
          datediff(mm,@ptd_fechaini,@ptd_fechafin)
        -- 6 > Bimestre
        when 6 then
          datediff(mm,@ptd_fechaini,@ptd_fechafin)/2
        -- 7 > Trimestre
        when 7 then
          datediff(mm,@ptd_fechaini,@ptd_fechafin)/3
        -- 8 > Cuatrimestre
        when 8 then
          datediff(mm,@ptd_fechaini,@ptd_fechafin)/4
        -- 9 > Semestre
        when 9 then
          datediff(mm,@ptd_fechaini,@ptd_fechafin)/6
      end

  if @count = 0 begin

        -- 1 > Semana              12
        -- 2 > Todos los dias      31
        -- 3 > Año                10
        -- 4 > Mes                24
        -- 6 > Bimestre            12
        -- 7 > Trimestre          8
        -- 8 > Cuatrimestre        6
        -- 9 > Semestre            4

    select @count =
        case @ptd_recurrente
          -- 1 > Semana
          when 1 then            12
          -- 2 > Todos los dias
          when 2 then            31
          -- 3 > Año
          when 3 then            10
          -- 4 > Mes
          when 4 then            24
          -- 6 > Bimestre
          when 6 then            12
          -- 7 > Trimestre
          when 7 then            8
          -- 8 > Cuatrimestre
          when 8 then            6
          -- 9 > Semestre
          when 9 then            4
        end

  end

  select @count

  declare @i           int
  declare @ptd_id      int
  declare @ptd_numero int
  declare @ta_id      varchar(255)

  set @i = 1

  while @i < @count
  begin

    if @ptd_recurrente = 1 begin -- 1 > Semana
      set @ptd_fechaini2 = dateadd(wk,@i,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(wk,@i,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(wk,@i,@ptd_alarma)
    end
    if @ptd_recurrente = 2 begin -- 2 > Todos los dias
      set @ptd_fechaini2 = dateadd(dd,@i,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(dd,@i,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(dd,@i,@ptd_alarma)
    end
    if @ptd_recurrente = 3 begin -- 3 > Año
      set @ptd_fechaini2 = dateadd(yyyy,@i,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(yyyy,@i,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(yyyy,@i,@ptd_alarma)
    end
    if @ptd_recurrente = 4 begin -- 4 > Mes
      set @ptd_fechaini2 = dateadd(mm,@i,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(mm,@i,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(mm,@i,@ptd_alarma)
    end
    if @ptd_recurrente = 6 begin -- 6 > Bimestre
      set @ptd_fechaini2 = dateadd(mm,@i*2,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(mm,@i*2,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(mm,@i*2,@ptd_alarma)
    end
    if @ptd_recurrente = 7 begin -- 7 > Trimestre
      set @ptd_fechaini2 = dateadd(mm,@i*3,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(mm,@i*3,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(mm,@i*3,@ptd_alarma)
    end
    if @ptd_recurrente = 8 begin -- 8 > Cuatrimestre
      set @ptd_fechaini2 = dateadd(mm,@i*4,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(mm,@i*4,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(mm,@i*4,@ptd_alarma)
    end
    if @ptd_recurrente = 9 begin -- 9 > Semestre
      set @ptd_fechaini2 = dateadd(mm,@i*6,@ptd_fechaini)
      set @ptd_fechafin2 = dateadd(mm,@i*6,@ptd_fechafin)
      set @ptd_alarma2   = dateadd(mm,@i*6,@ptd_alarma)
    end

    if @ptd_alarma = '19000101' set @ptd_alarma2 = @ptd_alarma

    exec SP_DBGetNewId 'ParteDiario', 'ptd_id', @ptd_id out, 0
    
    exec sp_Cfg_GetValor 'Envio','Talonario Parte Diario', @ta_id out
    select @ptd_numero = ta_ultimonro from talonario where ta_id = convert(int,@ta_id)

    select @ptd_numero = @ptd_numero +1

    insert into ParteDiario (
                              ptd_id,
                              ptd_numero,
                              ptd_titulo,
                              ptd_descrip,
                              ptd_fechaini,
                              ptd_fechafin,
                              ptd_alarma,
                              ptd_cumplida,
                              ptd_recurrente,
                              ptd_listausuariosId,
                              ptd_publico,
                              ptd_horaini,
                              ptd_horafin,
                              ptd_id_padre,
                              ptdt_id,
                              us_id_responsable,
                              us_id_asignador,
                              cont_id,
                              tarest_id,
                              prio_id,
                              lgj_id,
                              cli_id,
                              prov_id,
                              dpto_id,
                              modifico
                            )
                    select  
                              @ptd_id,
                              @ptd_numero,
                              ptd_titulo,
                              ptd_descrip,

                              @ptd_fechaini2,
                              @ptd_fechafin2,
                              @ptd_alarma2,

                              ptd_cumplida,
                              ptd_recurrente,
                              ptd_listausuariosId,
                              ptd_publico,
                              ptd_horaini,
                              ptd_horafin,
                              @@ptd_id,
                              ptdt_id,
                              us_id_responsable,
                              us_id_asignador,
                              cont_id,
                              tarest_id,
                              prio_id,
                              lgj_id,
                              cli_id,
                              prov_id,
                              dpto_id,
                              modifico

                    from  ParteDiario
                    where  ptd_id = @@ptd_id

    exec sp_talonarioSet @ta_id, @ptd_numero

    set @i = @i + 1
  
  end

end
go

