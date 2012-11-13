if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockGetItems]

go

/*

select * from stockitemkit where st_id = 10514

exec sp_DocStockGetItems 10518

*/
create procedure sp_DocStockGetItems (
	@@st_id int
)
as

begin

  set nocount on

	declare @depl_id_origen int

	select @depl_id_origen = depl_id_origen from Stock where st_id = @@st_id

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  STOCK ITEMS AGRUPADOS POR GRUPO
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

		select 	
						st_id,  
						min(sti_orden)        as sti_orden,
						min(sti_id)						as sti_id, 					-- Cuando hay uno por grupo el id es unico
						sum(sti_salida)			  as sti_salida,
						min(sti_descrip)			as sti_descrip,			-- idem
						sti_grupo,
						sti.pr_id,						
						@depl_id_origen       as depl_id,
	 					pr_nombrecompra, 													
						0 										as pr_eskit,
	          min(pr_llevanroserie) as pr_llevanroserie,-- idem
	          min(pr_llevanrolote)  as pr_llevanrolote,-- idem
	          min(un_nombre)        as un_nombre,       -- idem
						min(sti.stl_id)       as stl_id,
						min(stl_codigo)       as stl_codigo
	
		from 	StockItem	sti												
					inner join Producto 							on 	sti.pr_id = Producto.pr_id
																							and st_id 	= @@st_id
	        inner join Unidad 								on Producto.un_id_stock = unidad.un_id

					left join StockLote stl           on sti.stl_id = stl.stl_id
	
		where 
					depl_id = @depl_id_origen
			and stik_id is null         -- Solo producos que no pertenecen a un kit

		group by 	
						st_id,
						sti.pr_id,
						pr_nombrecompra,
						pr_eskit,
						sti_grupo,
						sti.stl_id,
						stl_codigo

	union

		select 	
						k.st_id,  
						min(sti_orden)        as sti_orden,
						k.stik_id							as sti_id, 					-- Cuando hay uno por grupo el id es unico
						stik_cantidad 			  as sti_salida,
						min(sti_descrip)			as sti_descrip,			-- idem
						max(sti_grupo),
						k.pr_id  							as pr_id,						
						@depl_id_origen       as depl_id,
	 					prk.pr_nombrecompra,
						1 											as pr_eskit,
	          min(stik_llevanroserie) as pr_llevanroserie,-- idem
						0                       as pr_llevanrolote,
	          min(un_nombre)        	as un_nombre,        -- idem
						min(stl.stl_id) as stl_id,
						min(stl_codigo) as stl_codigo
	
		from 	(StockItemKit k
						inner join StockItem sti        on 		k.stik_id	= sti.stik_id
																							and	k.st_id 	= @@st_id
																							and	sti.st_id = @@st_id
																							and	depl_id 	= @depl_id_origen
					)

					inner join producto prk						on k.pr_id   						= prk.pr_id
	        inner join Unidad 								on prk.un_id_stock 			= unidad.un_id

					left join StockLote stl           on sti.stl_id = stl.stl_id
	

		group by 	
						k.st_id,
						k.stik_id,
						k.pr_id,
						stik_cantidad,
						prk.pr_nombrecompra
	
		order by sti_orden

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  NUMEROS DE SERIE
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

	select 
									sti.pr_id,
									prns.prns_id,
									prns_codigo,
									prns_descrip,
									prns_fechavto,
					  			sti_grupo,
                  pr_nombrecompra

	from (ProductoNumeroSerie prns inner join StockItem sti on prns.prns_id = sti.prns_id
																													and  sti.st_id = @@st_id
				)
                                inner join Producto p    on prns.pr_id   = p.pr_id

	group by
					sti.pr_id,
					prns.prns_id,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
	  			sti_grupo,
          pr_nombrecompra
	order by
					sti_grupo

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  Info Kit
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////
	declare @pr_id int

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

	declare c_KitItem insensitive cursor for select pr_id from StockItemKit where st_id = @@st_id
	
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
go