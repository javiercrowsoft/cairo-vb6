-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockCheckDocRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockCheckDocRC]

go

create procedure sp_AuditoriaStockCheckDocRC (

	@@rc_id       int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	declare @bError tinyint

	set @bError     = 0
	set @@bSuccess 	= 0
	set @@bErrorMsg = '@@ERROR_SP:'

	declare @st_id 				int
	declare @doct_id      int
	declare @rc_nrodoc 		varchar(50) 
	declare @rc_numero 		varchar(50) 
	declare @est_id       int
	declare @llevaStock   tinyint

	select 
						@doct_id 		= rc.doct_id,
						@st_id 			= st_id, 
						@rc_nrodoc  = rc_nrodoc,
						@rc_numero  = convert(varchar,rc_numero),
						@est_id     = est_id,
						@llevaStock	= doc_muevestock

	from RemitoCompra rc inner join Documento doc on rc.doc_id = doc.doc_id
	where rc_id = @@rc_id

	if @llevaStock <> 0 begin

		-- 1 Si esta anulado no tiene que tener stock
		--
		if @est_id = 7 begin
	
			if @st_id is not null begin
						
				if exists (select * from Stock where st_id = @st_id) begin
								
					set @bError = 1
					set @@bErrorMsg = @@bErrorMsg + 'El remito esta anulado y posee un movimiento de stock' + char(10)
	
				end else begin
									
					set @bError = 1
					set @@bErrorMsg = @@bErrorMsg + 'El remito esta anulado y posee st_id distinto de null pero este st_id no existe en la tabla stock' + char(10)
					
				end
			end
	
		-- 2 Si no esta anulado tiene que tener stock
		-- 
		end else begin
	
			declare @rci_id										int
			declare @rci_cantidad							decimal(18,6)
			declare @pr_id										int
			declare @pr_nombrecompra					varchar(255)
			declare @pr_llevastock						smallint
			declare @pr_llevanroserie					smallint
			declare @stl_id                   int	
			declare @sti_cantidad             decimal(18,6)

			declare @pr_stockcompra           decimal(18,6)
	
			declare @pr_item                  varchar(255)
			declare @prns_cantidad            int
			declare @pr_id_item               int
	
			--//////////////////////////////
			--
			-- Sin numero de serie
			--
				declare c_rc_item insensitive cursor for
			
					select 
									sum(rci_cantidadaremitir),
									rci.pr_id,
									pr_nombrecompra,
									pr_llevastock,
									pr_llevanroserie,
									pr_stockcompra,
									stl_id
					from
								RemitoCompraItem rci inner join Producto pr on rci.pr_id = pr.pr_id
			
					where rc_id = @@rc_id and pr_llevanroserie = 0
	
					group by
									rci.pr_id,
									pr_nombrecompra,
									pr_llevastock,
									pr_llevanroserie,
									pr_stockcompra,
									stl_id
			
				open c_rc_item
			
				fetch next from c_rc_item into 
																				@rci_cantidad,
																				@pr_id,
																				@pr_nombrecompra,
																				@pr_llevastock,
																				@pr_llevanroserie,
																				@pr_stockcompra,
																				@stl_id
			
				while @@fetch_status = 0
				begin
	
					set @sti_cantidad = 0
		
					if @pr_llevastock <> 0 begin
		
						set @pr_stockcompra = IsNull(@pr_stockcompra,0)

	  				select @sti_cantidad = sum(sti_ingreso) 
						from 
									StockItem 
						where 
									st_id 					 = @st_id
							and pr_id 					 = @pr_id
							and (			IsNull(stl_id,0) = IsNull(@stl_id,0) 
										or 	prns_id is not null
									)
	
						set @sti_cantidad = IsNull(@sti_cantidad,0)
	
						if abs(@sti_cantidad - (case when @pr_stockcompra <> 0 then @rci_cantidad / @pr_stockcompra else 0 end)) > 0.01 begin
	
							set @bError = 1
							set @@bErrorMsg = @@bErrorMsg 
																+ 'El remito indica ' + convert(varchar,convert(decimal(18,2),@rci_cantidad))
																+ ' "' + @pr_nombrecompra + '" y el movimiento de stock indica '
																+ convert(varchar,convert(decimal(18,2),@sti_cantidad))
																+ ' y la ralacion stock-compra es '+ convert(varchar,convert(decimal(18,2),@pr_stockcompra))
																+ char(10)
						end
		
					end else begin
		
						if exists(select * from StockItem where st_id = @st_id and pr_id = @pr_id) begin
		
							set @bError = 1
							set @@bErrorMsg = @@bErrorMsg 
																+ 'Este remito indica el producto "' + @pr_nombrecompra 
		                            + '" que no mueve stock pero esta incluido en el movimiento '
		                            + 'de stock asociado a este remito'
																+ char(10)
						end
		
					end
			
					fetch next from c_rc_item into 
																					@rci_cantidad,
																					@pr_id,
																					@pr_nombrecompra,
																					@pr_llevastock,
																					@pr_llevanroserie,
																					@pr_stockcompra,
																					@stl_id
				end
			
				close c_rc_item
			
				deallocate c_rc_item
	
	
			--//////////////////////////////
			--
			-- Con numero de serie
			--
				declare c_rc_item insensitive cursor for
			
					select 
									rci_id,
									rci_cantidadaremitir,
									rci.pr_id,
									pr_nombrecompra,
									pr_stockcompra,
									stl_id
					from
								RemitoCompraItem rci inner join Producto pr on rci.pr_id = pr.pr_id
			
					where rc_id = @@rc_id and pr_llevanroserie <> 0
			
				open c_rc_item
			
				fetch next from c_rc_item into 
																				@rci_id,
																				@rci_cantidad,
																				@pr_id,
																				@pr_nombrecompra,
																				@pr_stockcompra,
																				@stl_id
			
				while @@fetch_status = 0
				begin
	
					set @sti_cantidad = 0

					set @pr_stockcompra = IsNull(@pr_stockcompra,0)
		
					select @sti_cantidad = sum(sti_ingreso) 
					from 
								StockItem 
					where 
								st_id 					 = @st_id
						and pr_id 					 = @pr_id
						and (			IsNull(stl_id,0) = IsNull(@stl_id,0) 
									or 	prns_id is not null
								)
						and sti_grupo        = @rci_id
						and pr_id_kit is null
	
					set @sti_cantidad = IsNull(@sti_cantidad,0)
	
					if abs(@sti_cantidad - (case when @pr_stockcompra <> 0 then @rci_cantidad / @pr_stockcompra else 0 end)) > 0.01 begin
	
						set @bError = 1
						set @@bErrorMsg = @@bErrorMsg 
															+ 'El remito indica ' + convert(varchar,convert(decimal(18,2),@rci_cantidad))
															+ ' "' + @pr_nombrecompra + '" y el movimiento de stock indica '
															+ convert(varchar,convert(decimal(18,2),@sti_cantidad)) 
															+ ' y la ralacion stock-compra es '+ convert(varchar,convert(decimal(18,2),@pr_stockcompra))
															+ char(10)
	
					end
	
					fetch next from c_rc_item into 
																					@rci_id,
																					@rci_cantidad,
																					@pr_id,
																					@pr_nombrecompra,
																					@pr_stockcompra,
																					@stl_id
				end
			
				close c_rc_item
			
				deallocate c_rc_item
	
		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO