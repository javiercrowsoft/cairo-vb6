if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockProductoGetKitInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockProductoGetKitInfo]

/*

 sp_StockProductoGetKitInfo 657,1,0,1,1,1

 exec sp_StockProductoGetKitInfo @pr_id_item, 0, @@bSoloStockXItem, 0, @prk_cantidad, 0, null, 0, @@bExpandKitAllLevels, @@bGetFomulaFromTableAux

*/

go
create procedure sp_StockProductoGetKitInfo (

	@@pr_id 				   int,
	@@bCreateTable     tinyint = 1,

  @@bSoloStockXItem  tinyint = 0, -- La recursividad se detiene en aquellos kits que no controlan stock por item

  @@bSetPrIdKit      tinyint = 0, -- Para aquellos items que tambien son kits les asigna el pr_id_kit 
                                  -- solo en el primer nivel es decir que deben producirse los kits que componen
                                  -- a este kit
	@@cantidad         tinyint = 1,

  @@bPPK             tinyint = 0, -- Cuando estoy armando el kit, no quiero que me exija que los componentes
                                  -- esten asociados al kit, por que en ese caso no puedo armar el kit

	@@prfk_id          int     = null, -- La formula a usar

	@@bExpandKit       tinyint = 0,     -- Cuando es cero, si el Kit es resumido, este sp no devuelve los items,
																	    -- sino que solo devuelve el pr_id del kit, para simular un kit que esta
																	    -- compuesto unicamente por un item, y de esta forma el kit sera manejado
																	    -- por todo el resto del codigo como un producto mas.
																	    --
																	    -- Por ahora el unico que llama a este sp con @@bExpandKit <> 0 es el
																	    -- parte de produccion para poder consumir los items del kit.
																	    --
																	    -- Esto SOLO se aplica a los kits que son RESUMIDOS
                                      --
                                      -- Ademas solo se aplica al primer nivel del Kit, es decir que si tenemos
                                      -- el kit A compuesto por 10 componentes y uno de ellos es un kit (el B),
                                      -- este sp devolvera solo 10 componentes, no desagrega los componentes del
                                      -- Kit B

  @@bExpandKitAllLevels tinyint = 0,  -- Expande al kit en todos sus niveles, es decir que recorre todos los items, 
                                      -- solo es llamado por ahora por dc_csc_stk_0180 y dc_csc_ven_0350

	@@bGetFomulaFromTableAux	tinyint = 0,-- Esta tabla contiene hasta diez formulas de kits que deben ser utilizadas
                                        -- para obtener la lista de insumos del kit
                                        -- solo es llamado por ahora por dc_csc_prd_0020

	@@bSetPrIdSubKit   				tinyint = 0, -- identifica cada item con el subkit al que pertence
                                         -- solo es llamado por ahora por dc_csc_prd_0020

	@@bAddPrIdKitToTable      tinyint = 0  -- Agrega el pr_id del kit dentro de la tabla #KitItemsSerie
																				 -- para poder incluirlo en el reporte de necesidad de compra
)
as

begin

	set nocount on

  if @@bExpandKitAllLevels <> 0 set @@bExpandKit = 1

	-- Si es un kit la cosa se pone mas complicada ya que hay que fijarse
	-- si las componentes del kit llevan stock y numero de serie
	--
	declare @bLlevaNroSerie tinyint
	declare @Unidad         varchar(255)
	declare @nivel 					int
	declare @prk_cantidad   decimal(18,6)
  declare @pr_id_item     int

	if @@prfk_id is null begin

		if @@bGetFomulaFromTableAux <> 0 begin

			select @@prfk_id = t.prfk_id 
			from #FormulasKit t inner join ProductoFormulaKit prfk
								on t.prfk_id = prfk.prfk_id
			where pr_id = @@pr_id

		end

		if @@prfk_id is null 

			select @@prfk_id = prfk_id 
			from ProductoFormulaKit 
			where pr_id = @@pr_id and prfk_default <> 0

	end

	-- Solo se crea la tabla en la primera llamada
	if @@bCreateTable <> 0 begin
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
	end

	declare @pr_kitResumido tinyint
	select @pr_kitResumido = pr_kitResumido from Producto where pr_id = @@pr_id

	if @@bExpandKit = 0 and @pr_kitResumido <> 0 begin

		insert into #KitItemsSerie(
																pr_id, 
																cantidad,
                                prk_id
															) 
												values (
																@@pr_id,
																1,
                                0
																)

	end else begin

		-- Si solo quiere los componentes de kits que controlan stock por item, y este kit no controla stock por item,
		-- (son aquellos que debe ser fabricados previamente), solo agrego este producto y listo
		--
		if exists(select pr_id from Producto where pr_id = @@pr_id and pr_kitStkItem = 0 and @@bSoloStockXItem <> 0) begin

			insert into #KitItemsSerie(
																	pr_id, 
																	cantidad,
	                                prk_id
																) 
													values (
																	@@pr_id,
																	@@cantidad,
	                                0
																	)
		end
		else begin	
	
			-- Agrego los items de este kit
			select @nivel = max(nivel) from #KitItems
			set @nivel = IsNull(@nivel,0)+1
		
			-- Agrego todos los items de este kit que son kit
			insert into #KitItems(
															pr_id, 
															nivel
														) 
			select 
															pr_id_item, 
															@nivel 
			from 
							ProductoKit k inner join Producto p on k.pr_id_item = p.pr_id 
			where 
						k.prfk_id = @@prfk_id
	      and p.pr_eskit <> 0
		
		
			-- Agrego todos los items de este Kit que no sean kit
			insert into #KitItemsSerie(
																	pr_id, 
																	cantidad,
																	prk_id
																) 
			select 
																	pr_id_item, 
																	prk_cantidad * @@cantidad,
																	prk_id
		
			from 
						ProductoKit k inner join Producto p on k.pr_id_item = p.pr_id
			where 
						k.prfk_id  = @@prfk_id
				and (pr_eskit = 0 or (pr_kitStkItem = 0 and @@bSoloStockXItem <> 0))

			-- Actualizo el pr_id_kit para definir a que kit pertenecen estos insumos	
			--
			if @@bSetPrIdSubKit <> 0 begin

				update #KitItemsSerie set pr_id_kit = @@pr_id where pr_id_kit is null

			end else begin

				if @@bSetPrIdKit <> 0 update #KitItemsSerie set pr_id_kit = 0 -- Para diferenciarlos de los Items de Kits

			end
	
			-- Para cada item de este kit que tambien es kit
			while exists(select * from #KitItems where nivel = @nivel) begin
	
				select @pr_id_item = min(pr_id) from #KitItems where nivel = @nivel
		
				-- Solo los que son kit
				if exists(select * from Producto 
                  where pr_id = @pr_id_item 
                    and pr_eskit <> 0 
                    and (     pr_kitStkItem <> 0 
                          or  @@bSoloStockXItem = 0
                        )
                  ) begin
		
					select @prk_cantidad = prk_cantidad from ProductoKit where prfk_id = @@prfk_id and pr_id_item = @pr_id_item
					set @prk_cantidad = @prk_cantidad * @@cantidad

					exec sp_StockProductoGetKitInfo @pr_id_item, 					--@@pr_id
																					0, 										--@@bCreateTable
																					@@bSoloStockXItem, 
																					0, 										--@@bSetPrIdKit
																					@prk_cantidad, 
																					0, 										--@@bPPK
																					null, 								--@@prfk_id
																					0, 										--@@bExpandKit
																					@@bExpandKitAllLevels, 
																					@@bGetFomulaFromTableAux,
																					@@bSetPrIdSubKit,
																					@@bAddPrIdKitToTable

				end

				-- Identifico a que kit pertenecen estos items
				-- Observen que cuando se utiliza @@bSetPrIdKit todos los insumos
				-- quedan asociados con al primer nivel de sub kits
				--		
				if @@bSetPrIdKit <> 0 begin
					update #KitItemsSerie set pr_id_kit = @pr_id_item where pr_id_kit is null
				end

				-- Este ya lo procese asi que lo borro
				delete #KitItems where pr_id = @pr_id_item

				if @@bAddPrIdKitToTable <> 0 begin

					declare @cantidad_kit int

					select @cantidad_kit = prk_cantidad * @@cantidad
					from ProductoKit k 
					where k.prfk_id  = @@prfk_id
						and pr_id_item = @pr_id_item

					insert into #KitItemsSerie(
																			pr_id, 
																			cantidad,
			                                prk_id,
																			pr_id_kit,
																			nivel
																		) 
															values (
																			@pr_id_item,
																			@cantidad_kit,
			                                0,
																			@@pr_id,
																			@nivel
																			)
				end
			end
	    
	    -- Pongo en null para que no se confunda el 0 con un id de producto y
	    -- fallen otros sp que llaman a este y luego utilizan el pr_id_kit para
	    -- insertarlo en alguna tabla, como es el caso de sp_DocParteProdKitSaveItemKit
	    --
	    if @@bSetPrIdKit <> 0 update #KitItemsSerie set pr_id_kit = null where pr_id_kit = 0

		end
	
	                            -- Solo si no estoy produciendo el kit
	                            --
		if @@bSetPrIdKit <> 0 and @@bPPK = 0 and @@bSetPrIdSubKit = 0 begin
	
			if exists(select * from Producto where pr_id = @@pr_id and pr_eskit <> 0 and pr_kitStkItem = 0) begin
			
				update #KitItemsSerie set pr_id_kit = @@pr_id
			end
		end

	end
	
	-- Solo la primera llamada devuelve datos
	if @@bCreateTable <> 0 begin

		if @@bSetPrIdKit <> 0

			select 
							k.pr_id, 
							pr_nombrecompra,
							pr_llevanroserie,
							k.pr_id_kit,
							sum(cantidad) as cantidad
			from 
							#KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id
			group by
							k.pr_id, 
							pr_nombrecompra,
							pr_llevanroserie,
              k.pr_id_kit

		else

			select 
							k.pr_id, 
							pr_nombrecompra,
							pr_llevanroserie,
							sum(cantidad) as cantidad
			from 
							#KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id
			group by
							k.pr_id, 
							pr_nombrecompra,
							pr_llevanroserie

	end

end
GO