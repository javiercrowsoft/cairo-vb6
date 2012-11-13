/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockCompensarGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockCompensarGet]

/*

sp_DocStockCompensarGet 1,2,5

*/

go
create procedure sp_DocStockCompensarGet (

  @@us_id     				int,
	@@depl_id_origen		int,
	@@depl_id_destino		int,
	@@pr_codigos        varchar(255)='',
	@@fecha             datetime

)as 
begin
set nocount on

	declare @pr_id 			int
	declare @prns_id  	decimal(18,6)

	create table #t_pr_ids (pr_id int)

	if @@pr_codigos <> '' 
		exec('insert into #t_pr_ids(pr_id) select pr_id from producto where pr_codigo in ('''+@@pr_codigos+''')')

	create table #t_Numeros ( prns_id int )

	declare c_prod insensitive cursor for

		select top 10000 ps.pr_id, prns_id

		from ProductoNumeroSerie ps inner join Producto pr on ps.pr_id = pr.pr_id

		where   exists (select * from StockItem sti inner join Stock st on sti.st_id = st.st_id
										where depl_id = @@depl_id_destino 
											and prns_id = ps.prns_id 
											and sti_salida  > 0
											and st_fecha <= @@fecha
										)
				and exists (select * from StockItem sti inner join Stock st on sti.st_id = st.st_id
										where depl_id = @@depl_id_origen 
											and prns_id = ps.prns_id 
											and sti_ingreso  > 0
											and st_fecha <= @@fecha
										)
				and 
							-- Existe en origen
							--
							exists(
				
							select prns_id from StockItem sti inner join Stock st on sti.st_id = st.st_id
							where depl_id = @@depl_id_origen
								and pr_id 	= ps.pr_id		
								and prns_id = ps.prns_id 
								and st_fecha <= @@fecha

							group by prns_id having sum(sti_ingreso)-sum(sti_salida) > 0
				
							)
				and
							-- Falta en destino
							--
							exists(
				
							select prns_id from StockItem sti inner join Stock st on sti.st_id = st.st_id
							where depl_id = @@depl_id_destino
								and pr_id 	= ps.pr_id		
								and prns_id = ps.prns_id 
								and st_fecha <= @@fecha
				
							group by prns_id having sum(sti_ingreso)-sum(sti_salida) < 0
				
							)

			and pr_llevanrolote = 0

			and (exists(select * from #t_pr_ids where pr_id = ps.pr_id) or @@pr_codigos = '')

		group by ps.pr_id,prns_id
	
	open c_prod

	fetch next from c_prod into @pr_id, @prns_id
	while @@fetch_status = 0
	begin	

		-- Si este numero de serie esta en negativo en destino
		-- y en positivo en origen y solo se ha movido dos veces
		-- (compra y venta) propongo hacer la transferencia
		-- para compensar
		--
		if exists (
						select *
						from ProductoNumeroSerie ps inner join producto pr on ps.pr_id = pr.pr_id
						where 
				
							prns_id = @prns_id
				
						and
						
							-- En negativo en destino
							--
							exists (
							
							select prns_id from StockItem sti inner join Stock st on sti.st_id = st.st_id
							where depl_id = @@depl_id_destino
								and pr_id 	= @pr_id		
								and prns_id = ps.prns_id 
								and st_fecha <= @@fecha

							group by prns_id having sum(sti_ingreso)-sum(sti_salida) < 0
							
							)
				
						and 
				
							-- Existe en origen
							--
							exists(
				
							select prns_id from StockItem sti inner join Stock st on sti.st_id = st.st_id
							where depl_id = @@depl_id_origen
								and pr_id 	= @pr_id		
								and prns_id = ps.prns_id 
								and st_fecha <= @@fecha
				
							group by prns_id having sum(sti_ingreso)-sum(sti_salida) > 0
				
							)
			) 
		begin

			insert into #t_Numeros (prns_id) values(@prns_id)

		end

		fetch next from c_prod into @pr_id, @prns_id	
	end	
	
	close c_prod
	deallocate c_prod

	-----------------------------------------------------------
	-- Items
	-----------------------------------------------------------
	select
						null st_id,  
						0        				as sti_orden,
						null						as sti_id, 					-- Cuando hay uno por grupo el id es unico
						count(*) 				as sti_salida,
						''			        as sti_descrip,			-- idem
						ps.pr_id        as sti_grupo,
						ps.pr_id,						
						@@depl_id_origen       as depl_id,
	 					pr_nombrecompra, 													
						pr.pr_eskit,
	          pr.pr_llevanroserie,
	          pr.pr_llevanrolote,
	          un_nombre				      as un_nombre,       -- idem
						null                  as stl_id,
						''                    as stl_codigo

	from #t_Numeros t inner join ProductoNumeroSerie ps on t.prns_id 			= ps.prns_id
										inner join Producto pr            on ps.pr_id  			= pr.pr_id
										inner join Unidad un              on pr.un_id_stock = un.un_id

	group by 	ps.pr_id, 
						pr_nombrecompra, 
						un_nombre,						
						pr.pr_eskit,
	          pr.pr_llevanroserie,
	          pr.pr_llevanrolote

	order by ps.pr_id, pr_nombrecompra

	-----------------------------------------------------------
	-- Series
	-----------------------------------------------------------
	select 
									ps.pr_id,
									ps.prns_id,
									prns_codigo,
									prns_descrip,
									prns_fechavto,
					  			ps.pr_id as sti_grupo,
                  pr_nombrecompra

	from #t_Numeros t inner join ProductoNumeroSerie ps on t.prns_id = ps.prns_id
                    inner join Producto p    					on ps.pr_id  = p.pr_id

	group by
					ps.pr_id,
					ps.prns_id,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
          pr_nombrecompra
	order by
					ps.pr_id


	-----------------------------------------------------------
	-- Info del Kit -- Por ahora siempre EOF
	-----------------------------------------------------------
	-- 	select 
	-- 					null 		as pr_id,
	-- 					null		as pr_id_item, 
	-- 					'' 			as pr_nombrecompra,
	-- 					''      as pr_llevanroserie,
	-- 					0       as cantidad 
	-- 	from #t_Numeros
	-- 
	-- 	where 1=2


	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  Info Kit
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

	create table #KitItems			(
																pr_id int not null, 
																nivel int not null
															)

	create table #KitItemsSerie(
																pr_id_kit 			int null,
																cantidad 				decimal(18,6) not null,
																pr_id 					int not null, 
                                prk_id 					int not null,
																nivel       		smallint not null default(0)
															)

	declare c_KitItem insensitive cursor for select distinct pr_id from #t_Numeros t inner join ProductoNumeroSerie ps on t.prns_id = ps.prns_id
	
	open c_KitItem

	fetch next from c_KitItem into @pr_id
	while @@fetch_status = 0 begin

		exec sp_StockProductoGetKitInfo @pr_id, 0

		update #KitItemsSerie set pr_id_kit = @pr_id where pr_id_kit is null

		fetch next from c_KitItem into @pr_id
	end

	close c_KitItem
	deallocate c_KitItem

	select 
					k.pr_id_kit 		as pr_id,
					k.pr_id 				as pr_id_item, 
					pr_nombrecompra,
					pr_llevanroserie,
					cantidad 
	from 
					#KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id


end