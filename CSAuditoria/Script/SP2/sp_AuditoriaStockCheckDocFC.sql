-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockCheckDocFC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockCheckDocFC]

go

create procedure sp_AuditoriaStockCheckDocFC (

	@@fc_id       int,
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
	declare @fc_nrodoc 		varchar(50) 
	declare @fc_numero 		varchar(50) 
	declare @est_id       int
	declare @llevaStock   tinyint

	select 
						@doct_id 		= fc.doct_id,
						@st_id 			= st_id, 
						@fc_nrodoc  = fc_nrodoc,
						@fc_numero  = convert(varchar,fc_numero),
						@est_id     = est_id,
						@llevaStock	= doc_muevestock

	from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
	where fc_id = @@fc_id

	if @llevaStock <> 0 begin

		-- 1 Si esta anulado no tiene que tener stock
		--
		if @est_id = 7 begin
	
			if @st_id is not null begin
						
				if exists (select * from Stock where st_id = @st_id) begin
								
					set @bError = 1
					set @@bErrorMsg = @@bErrorMsg + 'La factura esta anulada y posee un movimiento de stock' + char(10)
	
				end else begin
									
					set @bError = 1
					set @@bErrorMsg = @@bErrorMsg + 'La factura esta anulada y posee st_id distinto de null pero este st_id no existe en la tabla stock' + char(10)
	
				end
			end
	
		-- 2 Si no esta anulado tiene que tener stock
		-- 
		end else begin
	
			declare @fci_id										int
			declare @fci_cantidad							decimal(18,6)
			declare @pr_id										int
			declare @pr_nombrecompra					varchar(255)
			declare @pr_llevastock						smallint
			declare @pr_llevanroserie					smallint
			declare @stl_id                   int	
			declare @sti_cantidad             decimal(18,6)
			declare @cant_kits                decimal(18,6)

			declare @pr_stockcompra           decimal(18,6)
	
			declare @pr_item                  varchar(255)
			declare @prns_cantidad            int
			declare @pr_id_item               int
	
			--//////////////////////////////
			--
			-- Sin numero de serie
			--
				declare c_fc_item insensitive cursor for
			
					select 
									sum(fci_cantidadaremitir),
									fci.pr_id,
									pr_nombrecompra,
									pr_llevastock,
									pr_llevanroserie,
									pr_stockcompra,
									stl_id
					from
								FacturaCompraItem fci inner join Producto pr on fci.pr_id = pr.pr_id
			
					where fc_id = @@fc_id and (pr_llevanroserie = 0 or pr_eskit <> 0)
	
					group by
									fci.pr_id,
									pr_nombrecompra,
									pr_llevastock,
									pr_llevanroserie,
									pr_stockcompra,
									stl_id
			
				open c_fc_item
			
				fetch next from c_fc_item into 
																				@fci_cantidad,
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
							and pr_id_kit is null
	
						set @sti_cantidad = IsNull(@sti_cantidad,0)
	
						if abs(@sti_cantidad - (case when @pr_stockcompra <> 0 then @fci_cantidad / @pr_stockcompra else 0 end)) > 0.01 begin
	
							set @bError = 1
							set @@bErrorMsg = @@bErrorMsg 
																+ 'La factura indica ' + convert(varchar,convert(decimal(18,2),@fci_cantidad))
															  + ' "' + @pr_nombrecompra + '" y el movimiento de stock indica '
															  + convert(varchar,convert(decimal(18,2),@sti_cantidad))
																+ ' y la ralacion stock-compra es '+ convert(varchar,convert(decimal(18,2),@pr_stockcompra))
																+ char(10)
	
						end
		
					end else begin
		
						if exists(select * from StockItem where st_id = @st_id and pr_id = @pr_id) begin
	
							set @bError = 1
							set @@bErrorMsg = @@bErrorMsg 
																+ 'La factura indica el producto "' + @pr_nombrecompra 
		                            + '" que no mueve stock pero esta incluido en el movimiento '
		                            + 'de stock asociado a esta factura '
																+ char(10)
	
						end
		
					end
			
					fetch next from c_fc_item into 
																					@fci_cantidad,
																					@pr_id,
																					@pr_nombrecompra,
																					@pr_llevastock,
																					@pr_llevanroserie,
																					@pr_stockcompra,
																					@stl_id
				end
			
				close c_fc_item
			
				deallocate c_fc_item
	
	
			--//////////////////////////////
			--
			-- Con numero de serie
			--
				declare c_fc_item insensitive cursor for
			
					select 
									fci_id,
									fci_cantidadaremitir,
									fci.pr_id,
									pr_nombrecompra,
									pr_stockcompra,
									stl_id
					from
								FacturaCompraItem fci inner join Producto pr on fci.pr_id = pr.pr_id
			
					where fc_id = @@fc_id and pr_llevanroserie <> 0
			
				open c_fc_item
			
				fetch next from c_fc_item into 
																				@fci_id,
																				@fci_cantidad,
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
						and sti_grupo        = @fci_id
	
					set @sti_cantidad = IsNull(@sti_cantidad,0)
	
					if abs(@sti_cantidad - (case when @pr_stockcompra <> 0 then @fci_cantidad / @pr_stockcompra else 0 end)) > 0.01 begin
	
						set @bError = 1
						set @@bErrorMsg = @@bErrorMsg 
															+ 'La factura indica ' + convert(varchar,convert(decimal(18,2),@fci_cantidad))
															+ ' "' + @pr_nombrecompra + '" y el movimiento de stock indica '
															+ convert(varchar,convert(decimal(18,2),@sti_cantidad))
															+ ' y la ralacion stock-compra es '+ convert(varchar,convert(decimal(18,2),@pr_stockcompra))
															+ char(10)
	
					end
	
					fetch next from c_fc_item into 
																					@fci_id,
																					@fci_cantidad,
																					@pr_id,
																					@pr_nombrecompra,
																					@pr_stockcompra,
																					@stl_id
				end
			
				close c_fc_item
			
				deallocate c_fc_item
	
		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end
GO