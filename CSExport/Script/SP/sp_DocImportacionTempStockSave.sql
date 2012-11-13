if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempStockSave]

/*
 select * from ImportacionTemp
 sp_DocImportacionTempStockSave 26

*/

go
create procedure sp_DocImportacionTempStockSave (
	@@imptTMP_id			int,
	@@impt_id 				int,
  @@depl_id         int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

  declare @IsNew          smallint

	declare @st_id										int
	declare	@prov_id     							int
	declare @doc_id_ImportacionTemp  	int
	declare	@modificado 							datetime 
	declare	@modifico   							int 
	declare @stl_fecha      					datetime
	declare @stl_codigo								varchar(50)

	-- Si no existe chau
	if not exists (select impt_id from ImportacionTemp where impt_id = @@impt_id)
		return

	select 
					@st_id 											= st_id, 
					@prov_id 										= prov_id, 
					@doc_id_ImportacionTemp 		= doc_id,
					@modifico										= modifico,
					@modificado       					= modificado,
					@stl_fecha        					= impt_fecha,
					@stl_codigo									= impt_despachonro

	from ImportacionTemp where impt_id = @@impt_id
	
	set @st_id = isnull(@st_id,0)

-- Campos de las tablas
declare	@st_numero  	int 
declare	@st_nrodoc  	varchar (50) 
declare	@st_descrip 	varchar (5000)
declare	@st_fecha   	datetime 
declare	@impt_fecha   datetime 
declare @suc_id     	int

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 

declare	@sti_orden 							smallint 
declare	@sti_ingreso 						decimal(18, 6) 
declare	@sti_salida 						decimal(18, 6)

declare @depl_id                int
declare @depl_id_destino        int
declare @depl_id_origen         int
declare @depl_id_tercero        int set @depl_id_tercero = -3 /*select * from depositologico*/

declare	@impti_orden 							smallint 
declare @impti_cantidad 					decimal(18, 6)

declare @pr_id                  int
declare @sti_id                 int
declare @impti_descrip          varchar(255)

declare @doct_id_ImportacionTemp        int

declare @st_doc_cliente        	varchar(5000)

declare @bError      						tinyint

declare @bSuccess 							tinyint
declare @Message  							varchar(255)

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	-- Obtengo el documento @doc_id
	select 
				 @doc_id 									 = doc_id_Stock, 
				 @doct_id_ImportacionTemp  = ImportacionTemp.doct_id, 
         @st_doc_cliente  				 = impt_nrodoc + ' ' + prov_nombre

	from ImportacionTemp inner join Documento  on ImportacionTemp.doc_id  = Documento.doc_id
											 inner join Proveedor  on ImportacionTemp.prov_id = Proveedor.prov_id
	where impt_id = @@impt_id

	set @depl_id_origen 	= @depl_id_tercero
	set @depl_id_destino  = @@depl_id

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
															depl_id_destino,
                              depl_id_origen,
															modifico
														)
			select
															@st_id,
															@st_numero,
															@st_nrodoc,
															impt_descrip,
															impt_fecha,
															@st_doc_cliente,
															suc_id,
															@doc_id,
															@doct_id,
															@doct_id_ImportacionTemp,
															@@impt_id,
															@depl_id_destino,
                              @depl_id_origen,
															@modifico
			from ImportacionTemp
		  where impt_id = @@impt_id	

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

		/*
			Si es una modificacion, lo primero que hago es borrar
			los numeros de serie asociados a los renglones borrados
		*/

		create table #productoNroSerieDel (prns_id int)
		insert into #productoNroSerieDel 
		select prns_id 
		from Stockitem sti inner join ImportacionTempItemTMP impti
													on 		sti.st_id    	    = @st_id 
														and impti.imptTMP_id  = @@imptTMP_id
														and sti.sti_grupo     =	impti.impti_id

		/* Ahora si el Update */

		set @IsNew = 0

		select
															@st_descrip							= impt_descrip,
															@st_fecha								= impt_fecha,
										          @suc_id           			= suc_id
		from ImportacionTemp 
    where 
					impt_id = @@impt_id

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
															doct_id_cliente				= @doct_id_ImportacionTemp,
															id_cliente						= @@impt_id,
															depl_id_destino				= @depl_id_destino,
                              depl_id_origen				= @depl_id_origen,
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
	
		-- Borro todos los items y solo hago inserts que es mucho mas simple y rapido
	  delete StockItem where st_id = @st_id

		delete StockCache
	  where prns_id in (select prns_id from #productoNroSerieDel)
		if @@error <> 0 goto ControlError

		delete ProductoNumeroSerie 
		where prns_id in (select prns_id from #productoNroSerieDel)
		if @@error <> 0 goto ControlError

	end
	
	set @sti_orden = 0

	--////////////////////////////////////////////////
	-- Numero de serie
	--////////////////////////////////////////////////
	declare @pr_llevanroserie tinyint
	declare @impti_id         int
	declare @prns_id					int	
	declare @prns_codigo			varchar	(100)
	declare @prns_descrip		  varchar	(255)
	declare @prns_fechavto		datetime	

	--////////////////////////////////////////////////
	-- Numero de lote
	--////////////////////////////////////////////////
	declare @stl_id						int 

	--////////////////////////////////////////////////

	declare c_ImpTempItemStock cursor for 

		select 	impti_id, 
						impti_cantidadaremitir * pr_stockcompra, 
						impti.pr_id, 
						impti_descrip, 
					 	p.pr_llevanroserie, stl_id

					from ImportacionTempItem impti inner join Producto p on impti.pr_id = p.pr_id
					where impt_id = @@impt_id
						and pr_llevastock <> 0

	open c_ImpTempItemStock

	fetch next from c_ImpTempItemStock into @impti_id, @impti_cantidad, @pr_id, @impti_descrip, 
																					@pr_llevanroserie, @stl_id
	while @@fetch_status = 0 
	begin

		--////////////////////////////////////////////////////////////////////////
		--
		--  NRO DE LOTE
		--
		--////////////////////////////////////////////////////////////////////////

		-- Todas las importaciones temporales llevan numero de lote
		-- que coincide con el numero de la DIT
		--

		if @stl_id is null begin

			select @stl_id = stl_id from StockLote 
			where stl_codigo = @stl_codigo and pr_id = @pr_id

			if @stl_id is null begin

				exec SP_DBGetNewId 'StockLote','stl_id',@stl_id out, 0
				if @@error <> 0 goto ControlError

				insert StockLote(stl_id, stl_codigo, stl_nrolote, pr_id, stl_fecha, modifico) 
									values(@stl_id, @stl_codigo, @stl_codigo, @pr_id, @stl_fecha, @modifico)
				if @@error <> 0 goto ControlError

				update ImportacionTempItem set stl_id = @stl_id where impti_id = @impti_id
				if @@error <> 0 goto ControlError

			end

		end else begin

			update StockLote set  stl_codigo = @stl_codigo, 
														stl_nrolote = @stl_codigo
			where stl_id = @stl_id
			if @@error <> 0 goto ControlError

		end

		--////////////////////////////////////////////////////////////////////////
		--
		--  NO LLEVA NRO DE SERIE
		--
		--////////////////////////////////////////////////////////////////////////
		if @pr_llevanroserie = 0 begin
			exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
			if @@error <> 0 goto ControlError

			insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
														 pr_id, depl_id, stl_id)
											values(@st_id, @sti_id, @sti_orden, 0, @impti_cantidad, @impti_descrip, 
														 @pr_id, @depl_id_origen, @stl_id)
		  if @@error <> 0 goto ControlError
	
			set @sti_orden = @sti_orden + 1
	
			exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
			if @@error <> 0 goto ControlError

			insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
														 pr_id, depl_id, stl_id)
											values(@st_id, @sti_id, @sti_orden, @impti_cantidad, 0, @impti_descrip, 
														 @pr_id, @depl_id_destino, @stl_id)
		  if @@error <> 0 goto ControlError
	
			set @sti_orden = @sti_orden + 1

		--////////////////////////////////////////////////////////////////////////
		--
		--  LLEVA NRO DE SERIE
		--
		--////////////////////////////////////////////////////////////////////////
		end else begin

			declare c_nrosSerie insensitive cursor for select prns_id, prns_codigo, prns_descrip, prns_fechavto 
																									from ImportacionTempItemSerieTMP where  impti_id = @impti_id
																																											and imptTMP_id = @@imptTMP_id
			open c_nrosSerie

			fetch next from c_nrosSerie into @prns_id, @prns_codigo, @prns_descrip, @prns_fechavto
			while @@fetch_status = 0 
			begin

				--////////////////////////////////////////////////////////////////////////
				--  Numero de Serie
				if @prns_id <= 0 begin
	
					exec SP_DBGetNewId 'ProductoNumeroSerie','prns_id',@prns_id out, 0				
					if @@error <> 0 goto ControlError

					insert into ProductoNumeroSerie (
																					 prns_id, 
																					 prns_codigo, 
																					 prns_descrip, 
																					 prns_fechavto, 
																					 pr_id, 
																					 depl_id,
																					 stl_id,
																					 modifico
																					 )
																		values(
																					 @prns_id, 
																					 @prns_codigo, 
																					 @prns_descrip, 
																					 @prns_fechavto, 
																					 @pr_id, 
																					 @depl_id_destino,
																					 @stl_id,
																					 @modifico	
																					 )
			  	if @@error <> 0 goto ControlError

				end else begin

					Update ProductoNumeroSerie Set
																					prns_codigo		= @prns_codigo, 
																					prns_descrip	= @prns_descrip, 
																					prns_fechavto = @prns_fechavto, 
																					pr_id 				= @pr_id, 
																					modificado 		= @modificado,
																					modifico 			= @modifico
									where prns_id = @prns_id
				  if @@error <> 0 goto ControlError

				end
				--////////////////////////////////////////////////////////////////////////
	
				--////////////////////////////////////////////////////////////////////////
				-- Movimiento de stock
				exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
				if @@error <> 0 goto ControlError

				insert into StockItem (
															 st_id,  
															 sti_id,  
															 sti_orden,  
															 sti_ingreso, 
															 sti_salida, 
															 sti_descrip,  
															 sti_grupo,
															 pr_id,  
															 depl_id,         
															 prns_id,
															 stl_id
															)
												values
															(
															 @st_id, 
															 @sti_id, 
															 @sti_orden,           
															 0,          
															 1, 
															 @impti_descrip, 
															 @impti_id,
															 @pr_id, 
															 @depl_id_origen, 
															 @prns_id,
															 @stl_id
															 )
			  if @@error <> 0 goto ControlError
		
				set @sti_orden = @sti_orden + 1
		
				exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
				if @@error <> 0 goto ControlError

				insert into StockItem (
															 st_id,  
															 sti_id,  
															 sti_orden, 
															 sti_ingreso, 
															 sti_salida, 
															 sti_descrip,  
															 sti_grupo,
															 pr_id,  
															 depl_id, 					
															 prns_id,
															 stl_id
															)
												values
															(
															 @st_id, 
															 @sti_id, 
															 @sti_orden,          
															 1,          
															 0, 
															 @impti_descrip, 
															 @impti_id,
															 @pr_id, 
															 @depl_id_destino, 
															 @prns_id,
															 @stl_id
															)
			  if @@error <> 0 goto ControlError
		
				set @sti_orden = @sti_orden + 1
				--////////////////////////////////////////////////////////////////////////

				fetch next from c_nrosSerie into @prns_id, @prns_codigo, @prns_descrip, @prns_fechavto
			end

			close c_nrosSerie
			deallocate c_nrosSerie
		end

		fetch next from c_ImpTempItemStock into @impti_id, @impti_cantidad, @pr_id, @impti_descrip, 
																						@pr_llevanroserie, @stl_id
  end -- While

	close c_ImpTempItemStock
	deallocate c_ImpTempItemStock

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
//                                Vinculo la Importacion Temporal con su Stock                                   //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	update ImportacionTemp set st_id = @st_id where impt_id = @@impt_id

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar el importación temporal. sp_DocImportacionTempStockSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar el importación temporal. sp_DocImportacionTempStockSave.'
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