if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaStockSave]

/*
 select * from Remitoventa
 sp_DocRemitoVentaStockSave 26

*/

go
create procedure sp_DocRemitoVentaStockSave (
	@@rvTMP_id        int,
	@@rv_id 					int,
  @@depl_id         int,
	@@bTemp           tinyint,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out	
)
as

begin

	set nocount on

  declare @IsNew          smallint

	declare @st_id					int
	declare	@cli_id     		int
	declare @doc_id_Remito  int
	declare	@modificado 		datetime 
	declare	@modifico   		int 

	-- Si no existe chau
	if not exists (select rv_id from RemitoVenta where rv_id = @@rv_id)
		return
	
	select 
					@st_id 						= st_id, 
					@cli_id 					= cli_id, 
					@doc_id_Remito 		= doc_id,
					@modifico					= modifico,
					@modificado       = modificado

	from RemitoVenta where rv_id = @@rv_id
	
	set @st_id = isnull(@st_id,0)

-- Campos de las tablas
declare	@st_numero  int 
declare	@st_nrodoc  varchar (50) 
declare	@st_descrip varchar (5000)
declare	@st_fecha   datetime 
declare	@rv_fecha   datetime 
declare @suc_id     int

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 

declare	@sti_orden 							smallint 
declare	@sti_ingreso 						decimal(18, 6) 
declare	@sti_salida 						decimal(18, 6)

declare @depl_id                int
declare @depl_id_origen         int
declare @depl_id_destino        int
declare @depl_id_tercero        int set @depl_id_tercero = -3 /*select * from depositologico*/

declare	@rvi_orden 							smallint 
declare @rvi_cantidad 					decimal(18, 6)

declare @pr_id                  int
declare @stl_id                 int
declare @sti_id                 int
declare @rvi_descrip            varchar(255)

declare @doct_id_Remito        int

declare @st_doc_cliente        varchar(5000)

declare @rv_desde_os      		 int

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
				 @doct_id_Remito  = RemitoVenta.doct_id, 
         @st_doc_cliente  = rv_nrodoc + ' ' + cli_nombre,
				 @rv_desde_os     = doc_rv_desde_os

	from RemitoVenta inner join Documento on RemitoVenta.doc_id = Documento.doc_id
									 inner join Cliente   on RemitoVenta.cli_id = Cliente.cli_id
	where rv_id = @@rv_id

	if @doct_id_Remito = 3 /* Remito */ begin

		-- Si es un movimiento de alta de produccion por Remito Venta BOM
		-- Saco de produccio y llevo al deposito indicado
		--
		if @@bTemp <> 0 begin

			set @depl_id_destino = @@depl_id
			set @depl_id_origen  = -2 -- Produccion

		end else begin

			set @depl_id_destino = @depl_id_tercero
			set @depl_id_origen  = @@depl_id

		end

	end else begin

    if @doct_id_Remito = 24 /* Devolucion Remito Venta */ begin

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
															rv_descrip,
															rv_fecha,
															@st_doc_cliente,
															suc_id,
															@doc_id,
															@doct_id,
															@doct_id_Remito,
															@@rv_id,
															@depl_id_origen,
                              @depl_id_destino,
															modifico
			from RemitoVenta
		  where rv_id = @@rv_id	

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
															@st_descrip							= rv_descrip,
															@st_fecha								= rv_fecha,
										          @suc_id           			= suc_id
		from RemitoVenta 
    where 
					rv_id = @@rv_id

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
															doct_id_cliente				= @doct_id_Remito,
															id_cliente						= @@rv_id,
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

 	declare @rvi_id           int

	declare c_RemitoItemStock cursor for 

		select 	rvi_id, 
						rvi_cantidadaremitir * pr_ventastock, 
						rvi.pr_id, 
						rvi.stl_id, 
						rvi_descrip, 
						p.pr_llevanroserie, 
						p.pr_eskit,
						p.pr_lotefifo

				 	from RemitoVentaItem rvi inner join Producto p on rvi.pr_id = p.pr_id
					where rv_id = @@rv_id
						and pr_llevastock <> 0 
						and (pr_esrepuesto = 0 or @rv_desde_os = 0)

	declare @bEsKit 				tinyint 
  declare @bLLevaNroSerie tinyint
	declare @bLoteFifo      tinyint
	declare @cant_lote      decimal(18,6)
	declare @cant_aux       decimal(18,6)

	open c_RemitoItemStock

	fetch next from c_RemitoItemStock into @rvi_id, @rvi_cantidad, @pr_id, @stl_id, 
																				 @rvi_descrip, @bLLevaNroSerie, @bEsKit,
																				 @bLoteFifo
	while @@fetch_status = 0 
	begin

		-- Si es un kit hay que descomponerlo
		if 	@bEsKit <> 0 begin

			exec sp_DocRemitoVentaSaveItemKit 			@@rvTMP_id,
																							@rvi_id,
																							@st_id,
																							@sti_orden out,
																							@rvi_cantidad,
																						  @rvi_descrip,
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
					
				exec sp_DocRemitoVentaSaveNroSerie 			@@rvTMP_id,
																								@rvi_id,
																								@st_id,
																								@sti_orden out,
																								@rvi_cantidad,
																							  @rvi_descrip,
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
					while @rvi_cantidad > 0 begin 
							
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
										insert into #t_fifo_stocklote (stl_id, stl_cantidad) values(@stl_id, @rvi_cantidad)
						
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
										set @cant_lote = @rvi_cantidad
			
						if @cant_lote < @rvi_cantidad set @cant_aux = @cant_lote
						else                          set @cant_aux = @rvi_cantidad
			
						set @rvi_cantidad = @rvi_cantidad - @cant_aux

						exec sp_DocRemitoVentaStockItemSave 
																										0,
																										@st_id,
																										@sti_orden out,
																										@cant_aux,
																									  @rvi_descrip,
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
								
					exec sp_DocRemitoVentaStockItemSave 
																									0,
																									@st_id,
																									@sti_orden out,
																									@rvi_cantidad,
																								  @rvi_descrip,
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

		fetch next from c_RemitoItemStock into @rvi_id, @rvi_cantidad, @pr_id, @stl_id, 
																					 @rvi_descrip, @bLLevaNroSerie, @bEsKit,
																					 @bLoteFifo
  end -- While

	close c_RemitoItemStock
	deallocate c_RemitoItemStock

	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Agrego a StockCache lo que se movio con los items de este movimiento
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @st_id, 0 -- Sumar
	if IsNull(@bSuccess,0) = 0 goto Validate
	--
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo el remito con su Stock                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @@bTemp <> 0 begin

		update RemitoVenta set st_id_producido = @st_id where rv_id = @@rv_id

	end else begin

		update RemitoVenta set st_id = @st_id where rv_id = @@rv_id

	end

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar el remito de venta. sp_DocRemitoVentaStockSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar el remito de venta. sp_DocRemitoVentaStockSave.'
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