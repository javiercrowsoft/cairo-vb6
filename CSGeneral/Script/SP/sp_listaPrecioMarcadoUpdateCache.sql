if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_listaPrecioMarcadoUpdateCache]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_listaPrecioMarcadoUpdateCache]

go
/*

*/
create Procedure sp_listaPrecioMarcadoUpdateCache(
  @@lpm_id         int
)
as
begin

	-- Obtengo todas las listas que utilizan este marcado y llamo
	-- a sp_listaPrecioUpdateCache para que las actualice
	-- 
	-- La eficiencia no me interesa demasiado, ya que damos prioridad
	-- a que no se nos escape ningun precio, asi que si una lista
	-- es actualizada dos veces no importa
	--

	create table #t_listas (lp_id int not null)

	insert into #t_listas (lp_id)
			select distinct lp_id from ListaPrecioItem where lpm_id = @@lpm_id

	insert into #t_listas (lp_id)
			select distinct lp_id from ListaPrecioLista where lpm_id = @@lpm_id

	declare @lp_id int

	declare c_listas2 insensitive cursor for

			select distinct lp_id from #t_listas

	open c_listas2

	fetch next from c_listas2 into @lp_id 
	while @@fetch_status = 0
	begin

		exec sp_listaPrecioUpdateCache @lp_id 

		fetch next from c_listas2 into @lp_id 
	end
	close c_listas2
	deallocate c_listas2

	exec sp_listaPrecioUpdateCache 0

end
