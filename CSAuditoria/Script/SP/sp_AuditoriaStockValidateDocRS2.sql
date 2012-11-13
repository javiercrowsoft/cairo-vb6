-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockValidateDocRS2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockValidateDocRS2]

go

create procedure sp_AuditoriaStockValidateDocRS2 (

	@@rs_id       int,
	@@aud_id 			int,
	@@st_id       int

)
as

begin

  set nocount on

	declare @st_id 				int
	declare @audi_id 			int
	declare @doct_id      int
	declare @rs_nrodoc 		varchar(50) 
	declare @rs_numero 		varchar(50) 

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

	set @st_id = @@st_id

	select 
						@doct_id 		= doct_id,
						@rs_nrodoc  = rs_nrodoc,
						@rs_numero  = convert(varchar,rs_numero)

	from RecuentoStock where rs_id = @@rs_id


	declare @rsi_id										int
	declare @rsi_cantidad							decimal(18,6)
	declare @pr_id										int
	declare @pr_nombreventa						varchar(255)
	declare @pr_llevastock						smallint
	declare @pr_eskit									smallint
	declare @pr_kitItems              decimal(18,6)
	declare @pr_llevanroserie					smallint
	declare @stl_id                   int	
	declare @sti_cantidad             decimal(18,6)
	declare @cant_kits                decimal(18,6)

	declare @pr_item                  varchar(255)
	declare @prns_cantidad            int
	declare @pr_id_item               int

	--//////////////////////////////
	--
	-- Sin numero de serie
	--
		declare c_rs_item insensitive cursor for
	
			select 
							sum(rsi_cantidad),
							rsi.pr_id,
							pr_nombreventa,
							pr_llevastock,
							pr_eskit,
							pr_kitItems,
							pr_llevanroserie,
							stl_id
			from
						RecuentoStockItem rsi inner join Producto pr on rsi.pr_id = pr.pr_id
	
			where rs_id = @@rs_id and (pr_llevanroserie = 0 or pr_eskit <> 0)

			group by
							rsi.pr_id,
							pr_nombreventa,
							pr_llevastock,
							pr_eskit,
							pr_kitItems,
							pr_llevanroserie,
							stl_id
	
		open c_rs_item
	
		fetch next from c_rs_item into 
																		@rsi_cantidad,
																		@pr_id,
																		@pr_nombreventa,
																		@pr_llevastock,
																		@pr_eskit,
																		@pr_kitItems,
																		@pr_llevanroserie,
																		@stl_id
	
		while @@fetch_status = 0
		begin

			set @sti_cantidad = 0

			if @pr_llevastock <> 0 begin

				if @pr_eskit <> 0 begin
					set @cant_kits     = @rsi_cantidad
					set @rsi_cantidad  = @rsi_cantidad * @pr_kitItems

  				select @sti_cantidad = sum(sti_ingreso) 
					from 
								StockItem 
					where 
								st_id 					 = @st_id
						and pr_id_kit				 = @pr_id
						and IsNull(stl_id,0) = IsNull(@stl_id,0)

				end else begin

  				select @sti_cantidad = sum(sti_ingreso) 
					from 
								StockItem 
					where 
								st_id 					 = @st_id
						and pr_id 					 = @pr_id
						and IsNull(stl_id,0) = IsNull(@stl_id,0)
						and pr_id_kit is null

				end

				set @sti_cantidad = IsNull(@sti_cantidad,0)

				if @sti_cantidad <> @rsi_cantidad begin

					exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
					if @@error <> 0 goto ControlError	

					if @pr_eskit <> 0 begin

						insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
															 values (@@aud_id, 
			                                 @audi_id,
			                                 'El recuento de stock indica ' + convert(varchar,convert(decimal(18,2),@cant_kits)) 
																			 + ' Kit "' + @pr_nombreventa + '" compuesto(s) en total por '
																			 + convert(varchar,convert(decimal(18,2),@rsi_cantidad)) + ' items'
																			 + ' y el movimiento de stock indica ' + convert(varchar,convert(decimal(18,2),@sti_cantidad))
			                                 + ' (comp.:' + @rs_nrodoc + ' nro.: '+ @rs_numero + ')',
																			 3,
																			 1,
																			 @doct_id,
																			 @@rs_id
																			)

					end else begin

						insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
															 values (@@aud_id, 
			                                 @audi_id,
			                                 'El recuento de stock indica ' + convert(varchar,convert(decimal(18,2),@rsi_cantidad))
																			 + ' "' + @pr_nombreventa + '" y el movimiento de stock indica '
																			 + convert(varchar,convert(decimal(18,2),@sti_cantidad))
			                                 + ' (comp.:' + @rs_nrodoc + ' nro.: '+ @rs_numero + ')',
																			 3,
																			 1,
																			 @doct_id,
																			 @@rs_id
																			)
					end
				end

				-- Ahora los numeros de serie de los que son kit
				--
				if @pr_llevanroserie <> 0 and @pr_eskit <> 0 begin

					delete #KitItems
					delete #KitItemsSerie

					exec sp_StockProductoGetKitInfo @pr_id, 0

					declare c_rs_itemKit insensitive cursor for

						select 
										k.pr_id,
										pr_nombrecompra,
										cantidad 
						from 
										#KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id

						where pr_llevanroserie <> 0

					open c_rs_itemKit

					fetch next from c_rs_itemKit into @pr_id_item, @pr_item, @prns_cantidad

					while @@fetch_status=0
					begin

						set @prns_cantidad = @prns_cantidad * @cant_kits
						set @sti_cantidad  = 0

	  				select @sti_cantidad = sum(sti_ingreso) 
						from 
									StockItem 
						where 
									st_id 					 = @st_id
							and pr_id 					 = @pr_id_item
							and IsNull(stl_id,0) = IsNull(@stl_id,0)
							and pr_id_kit 			 = @pr_id

						set @sti_cantidad = IsNull(@sti_cantidad,0)
	
						if @sti_cantidad <> @prns_cantidad begin
	
							exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
							if @@error <> 0 goto ControlError	
	
							insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
																 values (@@aud_id, 
				                                 @audi_id,
				                                 'El recuento de stock indica que el Kit "' + @pr_nombreventa +
																				 + '" lleva ' + convert(varchar,convert(decimal(18,2),@prns_cantidad))
																				 + ' "' + @pr_item
																				 + '" y el movimiento de stock indica ' + convert(varchar,convert(decimal(18,2),@sti_cantidad))
				                                 + ' (comp.:' + @rs_nrodoc + ' nro.: '+ @rs_numero + ')',
																				 3,
																				 1,
																				 @doct_id,
																				 @@rs_id
																				)
						end

						fetch next from c_rs_itemKit into @pr_id_item, @pr_item, @prns_cantidad
					end

					close c_rs_itemKit

					deallocate c_rs_itemKit									

				end

			end else begin

				if exists(select * from StockItem where st_id = @st_id and pr_id = @pr_id) begin

					exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
					if @@error <> 0 goto ControlError	

					insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
														 values (@@aud_id, 
		                                 @audi_id,
		                                 'Este recuento de stock indica el producto "' + @pr_nombreventa 
                                     + '" que no mueve stock pero esta incluido en el movimiento '
                                     + 'de stock asociado a Este recuento de stock '
		                                 + '(comp.:' + @rs_nrodoc + ' nro.: '+ @rs_numero + ')',
																		 3,
																		 1,
																		 @doct_id,
																		 @@rs_id
																		)
				end

			end
	
			fetch next from c_rs_item into 
																			@rsi_cantidad,
																			@pr_id,
																			@pr_nombreventa,
																			@pr_llevastock,
																			@pr_eskit,
																			@pr_kitItems,
																			@pr_llevanroserie,
																			@stl_id
		end
	
		close c_rs_item
	
		deallocate c_rs_item


	--//////////////////////////////
	--
	-- Con numero de serie
	--
		declare c_rs_item insensitive cursor for
	
			select 
							rsi_id,
							rsi_cantidad,
							rsi.pr_id,
							pr_nombreventa,
							pr_eskit,
							pr_kitItems,
							stl_id
			from
						RecuentoStockItem rsi inner join Producto pr on rsi.pr_id = pr.pr_id
	
			where rs_id = @@rs_id and pr_llevanroserie <> 0 and pr_eskit = 0
	
		open c_rs_item
	
		fetch next from c_rs_item into 
																		@rsi_id,
																		@rsi_cantidad,
																		@pr_id,
																		@pr_nombreventa,
																		@pr_eskit,
																		@pr_kitItems,
																		@stl_id
	
		while @@fetch_status = 0
		begin

			set @sti_cantidad = 0

			select @sti_cantidad = sum(sti_ingreso) 
			from 
						StockItem 
			where 
						st_id 					 = @st_id
				and pr_id 					 = @pr_id
				and IsNull(stl_id,0) = IsNull(@stl_id,0)
				and sti_grupo        = @rsi_id
				and pr_id_kit is null

			set @sti_cantidad = IsNull(@sti_cantidad,0)

			if @sti_cantidad <> @rsi_cantidad begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	

				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El recuento de stock indica ' + convert(varchar,convert(decimal(18,2),@rsi_cantidad))
																	 + ' "' + @pr_nombreventa + '" y el movimiento de stock indica '
																	 + convert(varchar,convert(decimal(18,2),@sti_cantidad))
	                                 + ' (comp.:' + @rs_nrodoc + ' nro.: '+ @rs_numero + ')',
																	 3,
																	 1,
																	 @doct_id,
																	 @@rs_id
																	)
			end

			fetch next from c_rs_item into 
																			@rsi_id,
																			@rsi_cantidad,
																			@pr_id,
																			@pr_nombreventa,
																			@pr_eskit,
																			@pr_kitItems,
																			@stl_id
		end
	
		close c_rs_item
	
		deallocate c_rs_item

ControlError:

	drop table #KitItems
	drop table #KitItemsSerie

end
GO