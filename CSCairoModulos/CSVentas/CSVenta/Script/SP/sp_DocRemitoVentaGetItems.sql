if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetItems]

go

/*

sp_DocRemitoVentaGetItems 

*/
create procedure sp_DocRemitoVentaGetItems (
	@@rv_id int
)
as

begin

  set nocount on

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  REMITO VENTA ITEMS
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

	declare @rv_desde_os tinyint

	select @rv_desde_os = doc_rv_desde_os 
	from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id
	where rv_id = @@rv_id

	declare @st_id 	int

	if @rv_desde_os <> 0 begin

		select @st_id = st_id from RemitoVenta where rv_id = @@rv_id
	
			select 	rvi.*, 
	
							case pr_sevende
								when 0 then pr_nombrecompra
								else      	pr_nombreventa
							end			as pr_nombreventa,
	 
							pr_llevanroserie,
							pr_lotefifo,
							pr_eskit,
	            pr_llevanrolote,
							isnull(tri.ti_porcentaje,tri2.ti_porcentaje)    as iva_ri_porcentaje,
							isnull(trni.ti_porcentaje,trni2.ti_porcentaje) as iva_rni_porcentaje,
		          ccos_nombre,
		          isnull(un.un_nombre,un2.un_nombre) as un_nombre,
							stl_codigo
		
			from 	RemitoVentaItem rvi
						inner join Producto pr						on rvi.pr_id 						= pr.pr_id

		        left join Unidad 	un						  on pr.un_id_venta 			= un.un_id
		        left join Unidad 	un2						  on pr.un_id_compra 			= un2.un_id

						left join tasaimpositiva as tri  	on pr.ti_id_ivariventa  = tri.ti_id
						left join tasaimpositiva as trni 	on pr.ti_id_ivarniventa = trni.ti_id

						left join tasaimpositiva as tri2 	on pr.ti_id_ivaricompra  = tri2.ti_id
						left join tasaimpositiva as trni2	on pr.ti_id_ivarnicompra = trni2.ti_id

		        left join centrocosto as ccos 		on rvi.ccos_id 					= ccos.ccos_id
	  				left join StockLote as stl        on rvi.stl_id      			= stl.stl_id
	
			where 
							rv_id 		= @@rv_id
				and		pr_eskit 	= 0
	
		union
	
			select 	rvi.*, 

							case pr_sevende
								when 0 then pr_nombrecompra
								else      	pr_nombreventa
							end			as pr_nombreventa,

							(
								select min(stik_llevanroserie) from StockItemKit where pr_id = rvi.pr_id and st_id = @st_id 
							) as pr_llevanroserie,
							pr_eskit,
	            pr_llevanrolote,
							pr_lotefifo,
							isnull(tri.ti_porcentaje,tri2.ti_porcentaje)   as iva_ri_porcentaje,
							isnull(trni.ti_porcentaje,trni2.ti_porcentaje) as iva_rni_porcentaje,
		          ccos_nombre,
		          isnull(un.un_nombre,un2.un_nombre) as un_nombre,
							stl_codigo
		
			from 	RemitoVentaItem rvi
						inner join Producto pr						on rvi.pr_id 						= pr.pr_id

		        left join Unidad 	un						  on pr.un_id_venta 			= un.un_id
		        left join Unidad 	un2						  on pr.un_id_compra 			= un2.un_id

						left join tasaimpositiva as tri  	on pr.ti_id_ivariventa  = tri.ti_id
						left join tasaimpositiva as trni 	on pr.ti_id_ivarniventa = trni.ti_id

						left join tasaimpositiva as tri2 	on pr.ti_id_ivaricompra  = tri2.ti_id
						left join tasaimpositiva as trni2	on pr.ti_id_ivarnicompra = trni2.ti_id

		        left join centrocosto as ccos 		on rvi.ccos_id 					= ccos.ccos_id
	  				left join StockLote as stl        on rvi.stl_id      			= stl.stl_id
	
			where 
							rv_id 		= @@rv_id
				and		pr_eskit 	<> 0
	
		order by rvi_orden

	end else begin

		select @st_id = st_id from RemitoVenta where rv_id = @@rv_id
	
			select 	rvi.*, 
							pr_nombreventa, 
							pr_llevanroserie,
							pr_lotefifo,
							pr_eskit,
	            pr_llevanrolote,
							tri.ti_porcentaje as iva_ri_porcentaje,
							trni.ti_porcentaje as iva_rni_porcentaje,
		          ccos_nombre,
		          un_nombre,
							stl_codigo
		
			from 	RemitoVentaItem rvi
						inner join Producto pr						on rvi.pr_id 						= pr.pr_id
		        inner join Unidad 	un						on pr.un_id_venta 			= un.un_id
						left join tasaimpositiva as tri  	on pr.ti_id_ivariventa  = tri.ti_id
						left join tasaimpositiva as trni 	on pr.ti_id_ivarniventa = trni.ti_id
		        left join centrocosto as ccos 		on rvi.ccos_id 					= ccos.ccos_id
	  				left join StockLote as stl        on rvi.stl_id      			= stl.stl_id
	
			where 
							rv_id 		= @@rv_id
				and		pr_eskit 	= 0
	
		union
	
			select 	rvi.*, 
							pr_nombreventa, 
							(
								select min(stik_llevanroserie) from StockItemKit where pr_id = rvi.pr_id and st_id = @st_id 
							) as pr_llevanroserie,
							pr_eskit,
	            pr_llevanrolote,
							pr_lotefifo,
							tri.ti_porcentaje as iva_ri_porcentaje,
							trni.ti_porcentaje as iva_rni_porcentaje,
		          ccos_nombre,
		          un_nombre,
							stl_codigo
		
			from 	RemitoVentaItem rvi
						inner join Producto pr						on rvi.pr_id 						= pr.pr_id
		        inner join Unidad 	un						on pr.un_id_venta 			= un.un_id
						left join tasaimpositiva as tri  	on pr.ti_id_ivariventa  = tri.ti_id
						left join tasaimpositiva as trni 	on pr.ti_id_ivarniventa = trni.ti_id
		        left join centrocosto as ccos 		on rvi.ccos_id 					= ccos.ccos_id
	  				left join StockLote as stl        on rvi.stl_id      			= stl.stl_id
	
			where 
							rv_id 		= @@rv_id
				and		pr_eskit 	<> 0
	
		order by rvi_orden

	end
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
					  			rvi_id

	from ProductoNumeroSerie prns inner join StockItem sti 						on prns.prns_id   = sti.prns_id
																inner join RemitoVentaItem rvi 			on sti.sti_grupo  = rvi.rvi_id
																inner join RemitoVenta rv          	on rvi.rv_id      = rv.rv_id
                                inner join Producto p               on prns.pr_id     = p.pr_id
	where rvi.rv_id = @@rv_id and sti.st_id = rv.st_id

	group by
					prns.prns_id,
          prns.pr_id,
          pr_nombrecompra,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
	  			rvi_id
	order by
					rvi_id

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