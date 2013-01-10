if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DepartamentosSavePrestacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DepartamentosSavePrestacion]

go
create procedure sp_DepartamentosSavePrestacion 
as

begin
  declare c_depto insensitive cursor for select dpto_id from departamento
  declare @dpto_id int
  
  open c_depto
  
  fetch next from c_depto into @dpto_id
  while @@fetch_status=0
  begin
  
    exec sp_DepartamentoSavePrestacion @dpto_id
    fetch next from c_depto into @dpto_id
  end
  
  close c_depto
  deallocate c_depto
end