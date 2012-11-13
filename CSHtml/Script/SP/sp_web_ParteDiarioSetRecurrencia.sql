if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioSetRecurrencia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioSetRecurrencia]

/*

sp_web_ParteDiarioSetRecurrencia 

solo afecta a las alarmas, tareas y vencimientos

-- 1  > Semana
-- 2  > Todos los dias
-- 3  > Año
-- 4  > Mes
-- 6  > Bimestre
-- 7  > Trimestre
-- 8  > Cuatrimestre
-- 9  > Semestre
-- 10 > Una sola vez

*/

go
create procedure sp_web_ParteDiarioSetRecurrencia 
as
begin
  set nocount on

  declare @ptd_fechaini    datetime
  declare @ptd_fechafin    datetime
  declare @ptd_alarma      datetime
  declare @ptd_id          int
  declare @meses           tinyint
  declare @ptd_recurrente  tinyint

  declare c_ptd insensitive cursor for
    select ptd_id,ptd_fechaini,ptd_fechafin,ptd_alarma,ptd_recurrente 
    from ParteDiario 
    where ptd_cumplida <> 1
      and ptd_recurrente not in(0,10)
      and ptdt_id in (3,5,6) /*vencimientos, tareas y alarmas*/
  
  open c_ptd
  fetch next from c_ptd into @ptd_id, @ptd_fechaini, @ptd_fechafin, @ptd_alarma, @ptd_recurrente
  while @@fetch_status = 0
  begin

    -- 1  > Semana
    if @ptd_recurrente = 1 begin
      set @ptd_fechaini = dateadd(wk,1,@ptd_fechaini)
      set @ptd_fechafin = dateadd(wk,1,@ptd_fechafin)
      set @ptd_alarma   = dateadd(wk,1,@ptd_alarma)
    end

    -- 2  > Todos los dias
    if @ptd_recurrente = 2 begin
      set @ptd_fechaini = dateadd(d,1,@ptd_fechaini)
      set @ptd_fechafin = dateadd(d,1,@ptd_fechafin)
      set @ptd_alarma   = dateadd(d,1,@ptd_alarma)
    end

    -- 3  > Año
    if @ptd_recurrente = 3 begin
      set @ptd_fechaini = dateadd(yy,1,@ptd_fechaini)
      set @ptd_fechafin = dateadd(yy,1,@ptd_fechafin)
      set @ptd_alarma   = dateadd(yy,1,@ptd_alarma)
    end

    if @ptd_recurrente in (4,6,7,8,9) begin
      -- 4  > Mes
      if @ptd_recurrente = 4 set @meses = 1
      -- 6  > Bimestre
      if @ptd_recurrente = 6 set @meses = 2
      -- 7  > Trimestre
      if @ptd_recurrente = 7 set @meses = 3
      -- 8  > Cuatrimestre
      if @ptd_recurrente = 8 set @meses = 4
      -- 9  > Semestre
      if @ptd_recurrente = 9 set @meses = 6
  
      set @ptd_fechaini = dateadd(m,@meses,@ptd_fechaini)
      set @ptd_fechafin = dateadd(m,@meses,@ptd_fechafin)
      set @ptd_alarma   = dateadd(m,@meses,@ptd_alarma)
    end 
  
    update ParteDiario set 
                            ptd_cumplida = case ptdt_id
                                                when 3 then 0
                                                else        1
                                           end, 
                            ptd_fechaini = @ptd_fechaini,
                            ptd_fechafin = @ptd_fechafin,
                            ptd_alarma   = @ptd_alarma
  
          
    where ptd_id = @ptd_id
  
    fetch next from c_ptd into @ptd_id, @ptd_fechaini, @ptd_fechafin, @ptd_alarma, @ptd_recurrente 
  end
  close c_ptd
  deallocate c_ptd

end
