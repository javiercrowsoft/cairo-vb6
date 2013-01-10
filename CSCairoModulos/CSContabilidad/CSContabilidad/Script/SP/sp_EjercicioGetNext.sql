
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioGetNext]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioGetNext]

go
create procedure sp_EjercicioGetNext (

  @@emp_id       varchar(50),
  @@cico_id     varchar(50),
  @@fechaFin     datetime,
  @@ejc_id      int = 0 out,
  @@show        int = 1

)as 
begin

  create table #t_ejercicios (ejc_id int)

  exec sp_EjercicioGetAux @@emp_id, @@cico_id

  select @@ejc_id = ejc_id 

  from EjercicioContable 

  where ejc_fechaini = (select min(ejc_fechaini) 
                        from EjercicioContable 
                        where ejc_id in (select ejc_id from #t_ejercicios)
                          and ejc_fechaini > @@fechaFin)
    and ejc_id in (select ejc_id from #t_ejercicios)

  if @@show <> 0 select @@ejc_id as ejc_id
end
GO