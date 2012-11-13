if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaStockSave]

/*
 select * from facturaventa
 sp_DocFacturaVentaStockSave 26

*/

go
create procedure sp_DocFacturaVentaStockSave (
	@@fvTMP_id 				int,
	@@fv_id 					int,
  @@depl_id         int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

	declare @fvi_id					int
  declare @IsNew          smallint

	declare @st_id					int
	declare	@cli_id     		int
	declare @doc_id_factura int

	-- Si no existe chau
	if not exists (select fv_id from FacturaVenta where fv_id = @@fv_id)
		return
	
	select 
					@st_id 						= st_id, 
					@cli_id 					= cli_id, 
					@doc_id_factura 	= doc_id

	from FacturaVenta where fv_id = @@fv_id
	
	set @st_id = isnull(@st_id,0)

-- Campos de las tablas
declare	@st_numero  int 
declare	@st_nrodoc  varchar (50) 
declare	@st_descrip varchar (5000)
declare	@st_fecha   datetime 
declare	@fv_fecha   datetime 
declare @suc_id     int

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare	@sti_orden 							smallint 
declare	@sti_ingreso 						decimal(18, 6) 
declare	@sti_salida 						decimal(18, 6)

declare @depl_id_origen         int
declare @depl_id_destino        int
declare @depl_id_tercero        int set @depl_id_tercero = -3 /*select * from depositologico*/

declare	@fvi_orden 							smallint 
declare @fvi_cantidad 					decimal(18, 6)

declare @pr_id                  int
declare @stl_id                 int
declare @sti_id                 int
declare @fvi_descrip            varchar(255)

declare @doct_id_factura        int

declare @st_doc_cliente         varchar(5000)

declare @bError      tinyint

declare @bSuccess 							tinyint
declare @Message  							varchar(255)

	begin transaction

	create table #t_fifo_stocklote (stl_id int not null, stl_cantidad decimal(18,6) not null)

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	-- Obtengo el documento @doc_id
	select 
				 @doc_id 					= doc_id_Stock, 
				 @doct_id_factura = FacturaVenta.doct_id, 
         @st_doc_cliente  = fv_nrodoc + ' ' + cli_nombre

	from FacturaVenta inner join Documento on FacturaVenta.doc_id = Documento.doc_id
										inner join Cliente   on FacturaVenta.cli_id = Cliente.cli_id
	where fv_id = @@fv_id


	if @doct_id_factura = 1 /* Factura */ or @doct_id_factura = 9 /* Nota de Debito*/ begin

		set @depl_id_destino = @depl_id_tercero
		set @depl_id_origen  = @@depl_id

	end else begin

    if @doct_id_factura = 7 /* Nota de Credito */ begin

			set @depl_id_destino = @@depl_id
			set @depl_id_origen  = @depl_id_tercero
		end
	end

	if @st_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'Stock','st_id',@st_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'Stock','st_numero',@st_numero out, 0
		if @@error <> 0 goto ControlError

		-- //////////////////////////////////////////////////////////////////////////////////
		--
		-- Talonario
		--
					declare @ta_nrodoc varchar(100)
			
					select @doct_id = doct_id,
								 @ta_id   = ta_id
					from documento where doc_id = @doc_id
			
					exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out, 0
					if @@error <> 0 goto ControlError
			
					set @st_nrodoc = @ta_nrodoc
			
					-- Con esto evitamos que dos tomen el mismo número
					--
					exec sp_TalonarioSet @ta_id, @ta_nrodoc
					if @@error <> 0 goto ControlError
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into Stock (
															st_id,
															st_numero,
															st_nrodoc,
															st_descrip,
															st_fecha,
                              st_doc_cliente,
															suc_id,
															doc_id,
															doct_id,
															doct_id_cliente,
                              id_cliente,
															depl_id_origen,
                              depl_id_destino,
															modifico
														)
			select
															@st_id,
															@st_numero,
															@st_nrodoc,
															fv_descrip,
															fv_fecha,
															@st_doc_cliente,
															suc_id,
															@doc_id,
															@doct_id,
															@doct_id_factura,
															@@fv_id,
															@depl_id_origen,
                              @depl_id_destino,
															modifico
			from FacturaVenta
		  where fv_id = @@fv_id	

			if @@error <> 0 goto ControlError
	end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        UPDATE                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	else begin

		set @IsNew = 0

		select
															@st_descrip							= fv_descrip,
															@st_fecha								= fv_fecha,
															@modifico							  = modifico,
															@modificado             = modificado,
										          @suc_id           			= suc_id
		from FacturaVenta 
    where 
					fv_id = @@fv_id

		select 
															@doc_id									= doc_id,
															@doct_id								= doct_id
		from Stock
		where 
					st_id = @st_id

		update Stock set 
															st_descrip						= @st_descrip,
															st_fecha							= @st_fecha,
                              st_doc_cliente        = @st_doc_cliente,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															doct_id_cliente				= @doct_id_factura,
															id_cliente						= @@fv_id,
															depl_id_origen				= @depl_id_origen,
                              depl_id_destino				= @depl_id_destino,
															modifico							= @modifico,
															modificado            = @modificado
	
		where st_id = @st_id
  	if @@error <> 0 goto ControlError
	end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @IsNew = 0 begin

		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
		-- Quito de StockCache lo que se movio con los items de este movimiento
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
		--
		exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @st_id, 1 /*Restar*/, 1 /*bNotUpdatePrns*/
		if IsNull(@bSuccess,0) = 0 goto Validate
		--
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////

		-- Borro todos los items y solo hago inserts que se mucho mas simple y rapido
	  delete StockItem where st_id = @st_id

		-- Borro todos los Kit de este movimiento
		delete StockItemKit where st_id = @st_id

	end

	set @sti_orden = 0

	declare c_FacturaItemStock cursor for 

		select 	fvi_id, 
						fvi_cantidadaremitir * pr_ventastock, 
						fvi.pr_id, 
						fvi.stl_id, 
						fvi_descrip, 
						p.pr_llevanroserie, 
						p.pr_eskit,
						p.pr_lotefifo

				from FacturaVentaItem fvi inner join Producto p on fvi.pr_id = p.pr_id
				where fv_id = @@fv_id
					and pr_llevastock <> 0
					and fvi_nostock = 0

	declare @bEsKit 				tinyint 
  declare @bLLevaNroSerie tinyint
	declare @bLoteFifo      tinyint
	declare @cant_lote      decimal(18,6)
	declare @cant_aux       decimal(18,6)

	open c_FacturaItemStock

	fetch next from c_FacturaItemStock into @fvi_id, @fvi_cantidad, @pr_id, @stl_id, 
                                          @fvi_descrip, @bLlevaNroSerie, @bEsKit,
																					@bLoteFifo
	while @@fetch_status = 0 
	begin

		-- Si es un kit hay que descomponerlo
		if 	@bEsKit <> 0 begin

			exec sp_DocFacturaVentaSaveItemKit 			@@fvTMP_id,
																							@fvi_id,
																							@st_id,
																							@sti_orden out,
																							@fvi_cantidad,
																						  @fvi_descrip,
																						  @pr_id,
																						  @depl_id_origen,
																						  @depl_id_destino,
																							@stl_id,
					
																							@bSuccess out,						
																							@Message out 

			if IsNull(@bSuccess,0) = 0 goto Validate

		end else begin

			-- Si tiene numero de serie hay que grabar un stockitem por cada uno.
			if @bLlevaNroSerie <> 0 begin	

				exec sp_DocFacturaVentaSaveNroSerie     @@fvTMP_id,
																								@fvi_id,
																								@st_id,
																								@sti_orden out,
																								@fvi_cantidad,
																							  @fvi_descrip,
																							  @pr_id,
																							  @depl_id_origen,
																							  @depl_id_destino,
																								null,
						
																								@bSuccess out,						
																								@Message out 

												
				if IsNull(@bSuccess,0) = 0 goto Validate
										
			end else begin

				-- Consumo de lote por fifo
				if @stl_id is null and @bLoteFifo <> 0 begin

-------------------------------------------------------------------------------------------------------------------
					while @fvi_cantidad > 0 begin 
							
						-- Obtengo por Fifo el lote a descargar
						--
						set @stl_id = null
			
						select 
									top 1 @stl_id = stc.stl_id, @cant_lote = stc_cantidad
						from 
									StockCache stc inner join StockLote stl on stc.stl_id = stl.stl_id
						where 
									stc.pr_id = @pr_id
							and	depl_id 	= @@depl_id
							and stc_cantidad > 0
						
							and not exists(select stl_id from #t_fifo_stocklote 
														 where stl_id = stc.stl_id 
															group by stl_id having stc_cantidad-sum(stl_cantidad)<=0 )
											
						order by stl_fecha asc
						
						-- Si tengo un lote lo agrego a la lista de lotes usados
						--				
						if @stl_id is not null 
										insert into #t_fifo_stocklote (stl_id, stl_cantidad) values(@stl_id, @fvi_cantidad)
						
						-- Si no hay lote le asigno como cantidad lo pendiente
						-- esto va a generar stock negativo en el deposito
						-- de la temporal forzando el mensaje de error.
						--
						-- En una version futura vamos a lanzar el error desde aca
						-- ya que si hay stock sin lote en el deposito temporal para
						-- este producto, el sistema lo usaria, y no notificaria al usuario
						-- que no hay lotes de DIT para consumir.
						--
						-- Hay que tener en cuenta que no deberia haber productos sin
						-- lote en este deposito, con lo cual el caso que menciono arriba
						-- no deberia darse.
						--
						else
										set @cant_lote = @fvi_cantidad
			
						if @cant_lote < @fvi_cantidad set @cant_aux = @cant_lote
						else                          set @cant_aux = @fvi_cantidad
			
						set @fvi_cantidad = @fvi_cantidad - @cant_aux

						exec sp_DocFacturaVentaStockItemSave 
																										0,
																										@st_id,
																										@sti_orden out,
																										@cant_aux,
																									  @fvi_descrip,
																									  @pr_id,
																									  @depl_id_origen,
																									  @depl_id_destino,
																										null,
																									  null,
																										@stl_id,
													
																										@bSuccess out,						
																										@Message out 
																		
						if IsNull(@bSuccess,0) = 0 goto Validate

					end
-------------------------------------------------------------------------------------------------------------------

				-- Solo son simples stockitems (una pavada)
				end else begin
							
					exec sp_DocFacturaVentaStockItemSave 
																									0,
																									@st_id,
																									@sti_orden out,
																									@fvi_cantidad,
																								  @fvi_descrip,
																								  @pr_id,
																								  @depl_id_origen,
																								  @depl_id_destino,
																									null,
																								  null,
																									@stl_id, 
	
																									@bSuccess out,						
																									@Message out 
										
					if IsNull(@bSuccess,0) = 0 goto Validate

				end
									
			end
		end

		fetch next from c_FacturaItemStock into @fvi_id, @fvi_cantidad, @pr_id, @stl_id, 
                                            @fvi_descrip, @bLlevaNroSerie, @bEsKit,
																						@bLoteFifo
  end -- While

	close c_FacturaItemStock
	deallocate c_FacturaItemStock

	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Agrego a StockCache lo que se movio con los items de este movimiento
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	--

	exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @st_id, 0 -- Sumar
	if IsNull(@bSuccess,0) = 0 goto Validate

	--
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////


	-- Valido que no quede nada en interno por culpa de este movimiento
	--
	if @doct_id_factura = 7 /* Nota de Credito */ begin	
		if exists(select * 
							from productoNumeroSerie prns inner join stockItem sti on prns.prns_id = sti.prns_id
							where sti.st_id = @st_id
								and prns.depl_id = -2) begin

				set @Message = 'Esta nota de credito esta enviando numeros de serie al deposito interno. Debe comunicarse con soporte de CrowSoft para solucionar el problema.'
				goto Validate
		end
	end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo la factura con su Stock                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	update FacturaVenta set st_id = @st_id where fv_id = @@fv_id

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar la factura de venta. sp_DocFacturaVentaStockSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar la factura de venta. sp_DocFacturaVentaStockSave.'
	end

	goto Roll

Validate:

	set @@bError = -1

	set @Message = '@@ERROR_SP:' + IsNull(@Message,'')
  if @@bRaiseError <> 0 begin
		raiserror (@Message, 16, 1)
  end else begin
		set @@MsgError = @Message 
	end
	

Roll:
	rollback transaction	

end