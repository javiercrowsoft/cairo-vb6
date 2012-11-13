if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSetItemStock]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSetItemStock]

/*

	exec	sp_DocPedidoVentaSetItemStock 38

*/

go
create procedure sp_DocPedidoVentaSetItemStock (
	@@pv_id 			int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	declare @est_id int

	select @est_id = est_id from PedidoVenta where pv_id = @@pv_id

	set @@bSuccess = 0

	begin transaction

	delete PedidoVentaItemStock where pv_id = @@pv_id

	if @est_id not in (5,7,6) begin

		declare @pr_id 									int
	  declare @pvi_pendiente 					decimal(18,6)
	  declare @pr_id_kit 							int
	  declare @cantidad               decimal(18,6)
		declare @pvist_id               int
		declare @pr_id_kit_padre        int

		-----------------------------------------------------------------------------------------------------
		-- Agrego los pendientes que no son kits
		--
		declare c_Items insensitive cursor for 
	
		select 
					pvi_pendiente, i.pr_id 
		from 
					PedidoVentaItem i inner join Producto p on i.pr_id = p.pr_id
		where 
					pv_id      		= @@pv_id
	    and pvi_pendiente > 0
			and (p.pr_eskit = 0 or p.pr_kitResumido <> 0)
	
		open c_Items
		fetch next from c_Items into @pvi_pendiente, @pr_id
		while @@fetch_status = 0 begin
	
			exec SP_DBGetNewId 'PedidoVentaItemStock','pvist_id',@pvist_id out, 0 
	
			insert into PedidoVentaItemStock (pv_id,   pvist_id,  pvi_pendiente,  pr_id) 
																values (@@pv_id, @pvist_id, @pvi_pendiente, @pr_id)
	
			if @@error <> 0 goto ControlError
	
			fetch next from c_Items into @pvi_pendiente, @pr_id
		end
		close c_Items
		deallocate c_Items
	
		-----------------------------------------------------------------------------------------------------
		-- Ahora los kits
		--
	
			----------------------------------------------------------------------------------------
			create table #KitItems			(
																		pr_id int not null, 
																		nivel int not null
																	)
		
			create table #KitItemsSerie(
																		pr_id_kit_padre int null,	 -- Id del kit solicitado en el PedidoVentaItem
																		pr_id_kit 			int null,
																		cantidad 				decimal(18,6) not null,
																		pr_id 					int not null, 
		                                prk_id 					int not null,
																		nivel       		smallint not null default(0)
																	)
			----------------------------------------------------------------------------------------
	
			declare c_itemskit insensitive cursor for 
	
				select 
								p.pr_id, sum(pvi_pendiente) 
				from 
								PedidoVentaItem i inner join Producto p on i.pr_id = p.pr_id
				where
								pv_id = @@pv_id
						and (p.pr_eskit <> 0 and p.pr_kitResumido = 0) -- Debe ser un kit
						and pvi_pendiente > 0
	
				group by p.pr_id
			----------------------------------------------------------------------------------------
	
			open c_itemsKit
	
			fetch next from c_itemsKit into @pr_id, @pvi_pendiente
			while @@fetch_status = 0 
			begin
	
				delete #KitItems
		
				exec sp_StockProductoGetKitInfo @pr_id, 0, 1 -- Solo quiero aquellos productos que llevan el stock por item
	
				-- Asocio los items con el kit padre
				update #KitItemsSerie set pr_id_kit_padre = @pr_id where pr_id_kit_padre is null
	
				fetch next from c_itemsKit into @pr_id, @pvi_pendiente
			end
			close c_itemsKit
			deallocate c_itemsKit
	
			-- Actualizo la tabla #KitItemsSerie cargando los items que deben estar asociados a un kit
	
			update #KitItemsSerie set pr_id_kit = 0 -- Para discriminar las nuevas filas
	
			----------------------------------------------------------------------------------------
			declare c_itemsKit insensitive cursor for 
	
				select 
								p.pr_id, sum(cantidad), i.pr_id_kit_padre
				from 
								#KitItemsSerie i inner join Producto p on i.pr_id = p.pr_id
				where
							  (p.pr_eskit <> 0 and p.pr_kitResumido = 0)-- Debe ser un kit
	
				group by p.pr_id, i.pr_id_kit_padre
			----------------------------------------------------------------------------------------
	
			open c_itemsKit
	
			fetch next from c_itemsKit into @pr_id, @pvi_pendiente, @pr_id_kit_padre
			while @@fetch_status = 0 
			begin
		
				delete #KitItems
	
				exec sp_StockProductoGetKitInfo @pr_id, 0, 0 -- Ahora quiero todos los componentes
	
				-- Asocio los items con el kit
				update #KitItemsSerie set pr_id_kit = @pr_id where pr_id_kit is null
	
				-- Asocio los items con el kit padre
				update #KitItemsSerie set pr_id_kit_padre = @pr_id_kit_padre where pr_id_kit_padre is null
	
				if exists(select * from Producto where pr_id = @pr_id_kit_padre and pr_eskit <> 0 and pr_kitStkItem = 0) begin
				
					update #KitItemsSerie set pr_id_kit = @pr_id_kit_padre where pr_id_kit_padre = @pr_id_kit_padre
				end
	
				-- Borro la fila que mensionaba al kit
				delete #KitItemsSerie where pr_id = @pr_id
	
				fetch next from c_itemsKit into @pr_id, @pvi_pendiente, @pr_id_kit_padre
			end
			close c_itemsKit
			deallocate c_itemsKit
	
			------------------------------------------------------------------------------------------
			-- Lo mismo para el Pedido de Venta en cuestion
			--
			declare c_itemskit insensitive cursor for 
	
				select k.pr_id, k.pr_id_kit, pvi_pendiente * cantidad, k.pr_id_kit_padre
				from 
								PedidoVentaItem i inner join Producto p 		  on i.pr_id           = p.pr_id
																	inner join #KitItemsSerie k on k.pr_id_kit_padre = i.pr_id
	      where 
							pv_id = @@pv_id
					and (pr_eskit <> 0 and p.pr_kitResumido = 0)
	
			open c_itemsKit
	
			fetch next from c_itemsKit into @pr_id, @pr_id_kit, @cantidad, @pr_id_kit_padre
			while @@fetch_status = 0 begin
	
				exec SP_DBGetNewId 'PedidoVentaItemStock','pvist_id',@pvist_id out, 0 
	
				if @pr_id_kit = 0 set @pr_id_kit = null
		
				-- Inserto la demanda de stock desagregada para este kit
				insert into PedidoVentaItemStock(pv_id,   pvist_id,  pvi_pendiente, pr_id,  pr_id_kit,  pr_id_kitpadre)
																	values(@@pv_id, @pvist_id, @cantidad,     @pr_id, @pr_id_kit, @pr_id_kit_padre)
	
				if @@error <> 0 goto ControlError
	
				fetch next from c_itemsKit into @pr_id, @pr_id_kit, @cantidad, @pr_id_kit_padre
			end
			close c_itemsKit
			deallocate c_itemsKit

	end

	commit transaction

	set @@bSuccess = 1

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el pendiente del pedido de venta. sp_DocPedidoVentaSetItemStock.', 16, 1)
	rollback transaction	

end 

go