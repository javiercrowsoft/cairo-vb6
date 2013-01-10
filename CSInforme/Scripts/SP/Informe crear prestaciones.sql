declare @inf_nombre varchar(255)
declare @inf_modulo varchar(255)
declare @inf_id     int
declare @pre_id     int
declare @min int set @min = 10000000
declare @max int set @max = 10999999

declare c_inf insensitive cursor for select inf_id, inf_nombre, inf_modulo from informe where pre_id is null

open c_inf
fetch next from c_inf into @inf_id,@inf_nombre, @inf_modulo
while @@fetch_status=0
begin

  exec sp_dbgetnewid2 'Prestacion', 'pre_id', @min, @max, @pre_id out, 0

  insert Prestacion (pre_id,pre_nombre,pre_grupo,pre_grupo1,activo)
              values(@pre_id,@inf_nombre,'Informes',@inf_modulo,1)

  update informe set pre_id = @pre_id where inf_id = @inf_id

  fetch next from c_inf into @inf_id,@inf_nombre, @inf_modulo
end
close c_inf
deallocate c_inf