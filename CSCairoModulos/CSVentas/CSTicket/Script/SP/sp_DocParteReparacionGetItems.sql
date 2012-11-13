if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionGetItems]

go

/*

sp_DocParteReparacionGetItems 

*/
create procedure sp_DocParteReparacionGetItems (
	@@prp_id int
)
as

begin

  set nocount on

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  PARTE REPARACION ITEMS
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

	declare @st_id 	int

	select @st_id = st_id from ParteReparacion where prp_id = @@prp_id

		select 	prpi.*, 
						pr_nombrecompra, 
						pr_llevanroserie,
						pr_lotefifo,
						pr_eskit,
            pr_llevanrolote,
						tri.ti_porcentaje  as iva_ri_porcentaje,
						trni.ti_porcentaje as iva_rni_porcentaje,
	          ccos_nombre,
	          isnull(un.un_nombre,unv.un_nombre) as un_nombre,
						stl_codigo
	
		from 	ParteReparacionItem prpi
					inner join Producto pr						on prpi.pr_id 						= pr.pr_id
	        left  join Unidad 	un						on pr.un_id_stock 				= un.un_id
					left  join Unidad   unv           on pr.un_id_venta         = unv.un_id

					left join tasaimpositiva as tri  	on isnull(pr.ti_id_ivaricompra,pr.ti_id_ivariventa)  	= tri.ti_id
					left join tasaimpositiva as trni 	on isnull(pr.ti_id_ivarnicompra,pr.ti_id_ivarniventa) = trni.ti_id


	        left join centrocosto as ccos 		on prpi.ccos_id 					= ccos.ccos_id
  				left join StockLote as stl        on prpi.stl_id      			= stl.stl_id

		where 
						prp_id 		= @@prp_id
			and		pr_eskit 	= 0

	union

		select 	prpi.*, 
						pr_nombrecompra, 
						(
							select min(stik_llevanroserie) from StockItemKit where pr_id = prpi.pr_id and st_id = @st_id 
						) as pr_llevanroserie,
						pr_eskit,
            pr_llevanrolote,
						pr_lotefifo,
						tri.ti_porcentaje  as iva_ri_porcentaje,
						trni.ti_porcentaje as iva_rni_porcentaje,
	          ccos_nombre,
	          un_nombre,
						stl_codigo
	
		from 	ParteReparacionItem prpi
					inner join Producto pr						on prpi.pr_id 						= pr.pr_id
	        inner join Unidad 	un						on pr.un_id_stock 				= un.un_id
					left join tasaimpositiva as tri  	on pr.ti_id_ivariventa  	= tri.ti_id
					left join tasaimpositiva as trni 	on pr.ti_id_ivarniventa 	= trni.ti_id
	        left join centrocosto as ccos 		on prpi.ccos_id 					= ccos.ccos_id
  				left join StockLote as stl        on prpi.stl_id      			= stl.stl_id

		where 
						prp_id 		= @@prp_id
			and		pr_eskit 	<> 0

	order by prpi_orden

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  NUMEROS DE SERIE
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

	select 
									prns.pr_id,
                  pr_nombrecompra,
									prns.prns_id,
									prns_codigo,
									prns_descrip,
									prns_fechavto,
					  			prpi_id

	from ProductoNumeroSerie prns inner join StockItem sti 							on prns.prns_id   = sti.prns_id
																inner join ParteReparacionItem prpi 	on sti.sti_grupo  = prpi.prpi_id
																inner join ParteReparacion prp        on prpi.prp_id    = prp.prp_id
                                inner join Producto p               	on prns.pr_id     = p.pr_id
	where prpi.prp_id = @@prp_id and sti.st_id = prp.st_id

	group by
					prns.prns_id,
          prns.pr_id,
          pr_nombrecompra,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
	  			prpi_id
	order by
					prpi_id

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

	declare c_KitItem insensitive cursor for select pr_id from StockItemKit where st_id = @st_id
	
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