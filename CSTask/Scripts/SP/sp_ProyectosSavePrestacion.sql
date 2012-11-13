if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProyectosSavePrestacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProyectosSavePrestacion]

go
create procedure sp_ProyectosSavePrestacion 
as

begin
	declare c_depto insensitive cursor for select proy_id from Proyecto
	declare @proy_id int
	
	open c_depto
	
	fetch next from c_depto into @proy_id
	while @@fetch_status=0
	begin
	
		exec sp_ProyectoSavePrestacion @proy_id
		fetch next from c_depto into @proy_id
	end
	
	close c_depto
	deallocate c_depto
end