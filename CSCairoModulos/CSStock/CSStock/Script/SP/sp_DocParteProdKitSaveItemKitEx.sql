if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitSaveItemKitEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitSaveItemKitEx]

/*
 select * from ParteProdKit
 sp_DocParteProdKitSaveItemKitEx 26

*/

go
create procedure sp_DocParteProdKitSaveItemKitEx (
	@@ppkTMP_id 			int,
  @@ppki_id         int,
	@@st_id 					int,
	@@sti_orden				int out,
	@@ppki_cantidad   decimal(18,6),
  @@ppki_descrip    varchar(255),
  @@pr_id           int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
	@@prfk_id         int,

	@@bDesarme        tinyint,

	@@bSuccess 				tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin

  set nocount on

	declare @stik_orden 				smallint
	declare @stik_llevanroserie int
	declare @stik_id 						int
	declare @pr_id_subKit       int -- Este es el id de un kit que compone al kit que estamos generando
																	-- Ejemplo:
																	-- 						Si tenemos el kit MM (Mother + Micro) y el
																	--						kit GF (Gabinete + Fuente) que componen al 
																	--						kit PC ( 	MM(Mother + Micro) + GF(Gabinete + Fuente)
																	--										+	Memoria + Disco + LectoraCD + etc
																	--										)
																	--            el @pr_id_subKit se refiere a MM y GF, mientras que
                                  --						@@pr_id es PC.

	--//////////////////////////////////////////////////////////////////////////
	--
	-- Obtengo los componentes del
	--
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

	exec sp_StockProductoGetKitInfo @@pr_id, 0, 0, 1, 1, 1, @@prfk_id, 1

	--///////////////////////////////////////////////////////////////////////////////////////////////////////
	--        Kit
	--///////////////////////////////////////////////////////////////////////////////////////////////////////

--///////////////////////
-- BUG

	--//////////////////////////////////////////////////////////////////////////////////
	-- Creo el StockItemKit


									-- 	-- Si el deposito destino es produccion es por que estoy consumiendo los componentes del kit
									-- 	-- por lo tanto el StockItemKit lo genero por cada item del kit que lleve nro de serie. Esto
									-- 	-- lo hacen los sp sp_DocParteProdKitSaveNroSerie y sp_DocParteProdKitStockItemSave.
									-- 	-- Aca solo genero StockItemKit cuando el deposito no es produccion o sea que estoy
									--   -- dando de alta el nuevo kit.
									-- 	--
									-- 	-- Si se trata de un desarme es a la inversa
									-- 	--
									-- 
									-- 	if    (@@bDesarme = 0  and @@depl_id_destino <> -2)  -- Produccion 
									--      or (@@bDesarme <> 0 and @@depl_id_destino = -2) 	 -- Desarme
									--   begin /* Interno select * from depositologico */
									-- 
									-- 		exec SP_DBGetNewId 'StockItemKit','stik_id',@stik_id out, 0
									-- 
									-- 		if exists(select * from #KitItemsSerie s inner join Producto p on s.pr_id = p.pr_id
									-- 											 where pr_llevanroserie <> 0) 
									-- 			
									-- 						set @stik_llevanroserie = 1
									-- 		else		set @stik_llevanroserie = 0 
									-- 	
									-- 		if @stik_llevanroserie = 0 begin
									-- 
									-- 			if exists(select pr_id from Producto where pr_llevanroserie <> 0 and pr_id = @@pr_id)
									-- 						set @stik_llevanroserie = 1
									-- 
									-- 		end
									-- 
									-- 		-- Este es el StockItemKit asociado al Kit que estamos produciendo o sea @@pr_id
									-- 		--
									-- 		insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
									-- 										values   (@stik_id,@@ppki_cantidad,@@pr_id,@@st_id,@stik_llevanroserie)
									-- 
									-- 	end


-- Fin BUG
--///////////////////////

	--///////////////////////////////////////////////////////////////////////////////////////////////////////
	--        Kit Items - Complejos
	--///////////////////////////////////////////////////////////////////////////////////////////////////////

	declare @ppkiTMP_id int
	select @ppkiTMP_id = ppkiTMP_id from ParteProdKitItemTMP where ppkTMP_id = @@ppkTMP_id and ppki_id = @@ppki_id

	exec sp_DocParteProdKitStockItemSaveEx 	@ppkiTMP_id,
																					@@ppki_id,
																				 	@@st_id,
																					@@sti_orden out,
																				  @@ppki_descrip,
																				  @@depl_id_origen,
																				  @@depl_id_destino,
	
																					@@bDesarme,
			
																					@@bSuccess out,						
																					@@MsgError out 


	-- Solo llevo insumos al deposito interno es decir que solo
	-- genero StockItem de Items simples en el stock de consumo
	--
	if 			(@@bDesarme = 0 and @@depl_id_destino = -2)    -- Produccion
			or	(@@bDesarme <> 0 and @@depl_id_destino <> -2)	 -- Desarme
	begin

		--///////////////////////////////////////////////////////////////////////////////////////////////////////
		--        Kit Items - Simples
		--///////////////////////////////////////////////////////////////////////////////////////////////////////
	
		declare c_KitItems insensitive cursor for select pr_id, cantidad, pr_id_kit, prk_id from #KitItemsSerie
	
		open c_KitItems
	
		declare @pr_id 						int
		declare @cantidad					decimal(18,6)
		declare @bLlevaNroSerie 	tinyint
		declare @bLlevaNroLote    tinyint
		declare @bAlt             tinyint
		declare @bVar             tinyint
		declare @prk_id           int
	
		fetch next from c_KitItems into @pr_id, @cantidad, @pr_id_subKit, @prk_id
		while @@fetch_status = 0 
		begin
	
			-- Cantidad de este componente del kit por la cantidad de kits que estoy 
			-- armando en este item del parte de produccion de kit
			--
			set @cantidad = @cantidad * @@ppki_cantidad 
	
			-- Si el item lleva numero de serie
			--
			select @bLlevaNroSerie 	= pr_llevanroserie,
						 @bLlevaNroLote		= pr_llevanrolote
	
			from Producto where pr_id = @pr_id
	
			select @bvar = prk_variable from ProductoKit where prk_id = @prk_id
	
			if exists(select * from ProductoKitItemA where prk_id = @prk_id)
				set @bAlt = 1
			else
				set @bAlt = 0
	
			-- Solo procesamos items que no llevan numero de sreie, ni lote, ni alternativas
			-- ni variables, es decir insumos simples que no exigen ningun tratamiento especial
			--
			if @bLlevaNroSerie = 0 and @bLlevaNroLote = 0 and @bAlt = 0 and @bvar = 0 begin
	
					-- Si el deposito es produccion es por que estoy consumiendo los items del kit
			    -- y para aquellos items que tambien son kit debo generar un StockItemKit y 
			    -- el movimiento de Stock debe estar vinculado con el pr_id_kit del item.
					--
					-- Si se trata de un desarme es a la inversa
					--
					if 			(@@bDesarme = 0 and @@depl_id_destino = -2)    -- Produccion
							or	(@@bDesarme <> 0 and @@depl_id_destino <> -2)	 -- Desarme
					begin
	
						-- Si es un sub kit
						--
						if @pr_id_subKit is not null begin	
	
							-- Este es el StockItemKit asociado al Sub Kit @pr_id_subKit
							--
							if @stik_id is null begin
			
								exec SP_DBGetNewId 'StockItemKit','stik_id',@stik_id out, 0
			
								insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
																values   (@stik_id,@cantidad,@pr_id_subKit,@@st_id,0)
	
							end
						end
	
					end
	
					exec sp_DocParteProdKitStockItemSave    
																									0,
																									@@st_id,
																									@@sti_orden out,
																									@cantidad,
																								  @@ppki_descrip,
																								  @pr_id,
																								  @@depl_id_origen,
																								  @@depl_id_destino,
																									null,
																								  @stik_id,
							
																									@@bSuccess out,
																									@@MsgError out 
										
					if IsNull(@@bSuccess,0) = 0 goto Validate
	
			end
	
			fetch next from c_KitItems into @pr_id, @cantidad, @pr_id_subKit, @prk_id
		end
	
		close c_KitItems
		deallocate c_KitItems

	end 

	set @@bSuccess = 1
	return

ControlError:
	set @@MsgError = 'Ha ocurrido un error al grabar el item de stock del recuento de stock. sp_DocParteProdKitSaveItemKitEx.'

Validate:

	set @@bSuccess = 0

end
go