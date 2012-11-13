if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockStockSave]

/*
 select * from RecuentoStock
 sp_DocRecuentoStockStockSave 26

*/

go
create procedure sp_DocRecuentoStockStockSave (
	@@rsTMP_id        				int,
	@@rs_id 									int,
	@@depl_id_origen         	int,
	@@depl_id_destino        	int,
  @@nTipo                   tinyint, /* 1 st_id1, 2 st_id2 */
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

	declare @rsi_id					int
  declare @IsNew          smallint

	declare @st_id						int
	declare @doc_id_recuento 	int
	declare @stl_fecha      	datetime
	declare	@modifico   			int 

	-- Si no existe chau
	if not exists (select rs_id from RecuentoStock where rs_id = @@rs_id)
		return
	
	select 
					@st_id= case @@nTipo
										when 1 then	st_id1 
										when 2 then	st_id2 
									end,
					@doc_id_recuento 	= doc_id,
					@modifico					= modifico,
					@stl_fecha				= rs_fecha

	from RecuentoStock where rs_id = @@rs_id
	
	set @st_id = isnull(@st_id,0)

-- Campos de las tablas
declare	@st_numero  int 
declare	@st_nrodoc  varchar (50) 
declare	@st_descrip varchar (5000)
declare	@st_fecha   datetime 
declare	@rs_fecha   datetime 
declare @suc_id     int

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 
declare	@modificado datetime 

declare	@sti_orden 							smallint 
declare	@sti_ingreso 						decimal(18, 6) 
declare	@sti_salida 						decimal(18, 6)

declare	@rsi_orden 							smallint 
declare @rsi_ajuste 					  decimal(18, 6)

declare @pr_id                  int
declare @sti_id                 int
declare @rsi_descrip            varchar(255)
declare @doct_id_recuento       int

declare @bError      tinyint

declare @bSuccess 							tinyint
declare @Message  							varchar(255)


	--////////////////////////////////////////////////
	-- Numero de lote
	--////////////////////////////////////////////////
	declare @pr_llevanrolote	tinyint
	declare @stl_id						int 
	declare @stl_codigo				varchar(50)

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
				 @doc_id 					= doc_id_Stock, 
				 @doct_id_recuento = RecuentoStock.doct_id

	from RecuentoStock inner join Documento on RecuentoStock.doc_id = Documento.doc_id

	where rs_id = @@rs_id

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
															rs_descrip,
															rs_fecha,
															'',
															suc_id,
															@doc_id,
															@doct_id,
															@doct_id_recuento,
															@@rs_id,
															@@depl_id_destino,
                              @@depl_id_origen,
															modifico
			from RecuentoStock
		  where rs_id = @@rs_id	

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
															@st_descrip							= rs_descrip,
															@st_fecha								= rs_fecha,
															@modificado             = modificado,
										          @suc_id           			= suc_id
		from RecuentoStock 
    where 
					rs_id = @@rs_id

		select 
															@doc_id									= doc_id,
															@doct_id								= doct_id
		from Stock
		where 
					st_id = @st_id

		update Stock set 
															st_descrip						= @st_descrip,
															st_fecha							= @st_fecha,
                              st_doc_cliente        = '',
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															doct_id_cliente				= @doct_id_recuento,
															id_cliente						= @@rs_id,
															depl_id_destino				= @@depl_id_destino,
                              depl_id_origen				= @@depl_id_origen,
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

		-- Borro todos los Kit de este movimiento
		delete StockItemKit where st_id = @st_id

	end

	set @sti_orden = 0

	if @@nTipo = 1 begin

		declare c_recuentoItemStock cursor for 
	
			select rsi.rsi_id, 
						 rsi_ajuste, 
						 rsi.pr_id, 
						 rsi.rsi_descrip, 
						 p.pr_llevanrolote,
						 rsi.stl_id,
						 rsit.stl_codigo

			from RecuentoStockItem rsi 		inner join RecuentoStockItemTMP rsit on 		rsi.rsi_id = rsit.rsi_id
																																					and	rsit.rsTMP_id = @@rsTMP_id
																		inner join Producto p on rsi.pr_id = p.pr_id

					where rs_id = @@rs_id	and rsi_ajuste > 0

	end else begin

		declare c_recuentoItemStock cursor for 
	
			select rsi.rsi_id, 
						 rsi.rsi_ajuste, 
						 rsi.pr_id, 
						 rsi.rsi_descrip, 
						 p.pr_llevanrolote,
						 rsi.stl_id,
						 rsit.stl_codigo

			from RecuentoStockItem rsi  	inner join RecuentoStockItemTMP rsit on 		rsi.rsi_id = rsit.rsi_id
																																					and	rsit.rsTMP_id = @@rsTMP_id
																		inner join Producto p on rsi.pr_id = p.pr_id

					where rs_id = @@rs_id and rsi_ajuste < 0

	end

	declare @bEsKit 				tinyint 
  declare @bLLevaNroSerie tinyint

	open c_recuentoItemStock

	fetch next from c_recuentoItemStock into @rsi_id, @rsi_ajuste, @pr_id, @rsi_descrip, @pr_llevanrolote,
																				 	 @stl_id, @stl_codigo
	while @@fetch_status = 0 
	begin

		select @bEsKit = pr_eskit, @bLlevaNroSerie = pr_llevanroserie from producto where pr_id = @pr_id

		-- Si es un kit hay que descomponerlo
		if 	@bEsKit <> 0 begin

			exec sp_DocRecuentoStockSaveItemKit 		@@rsTMP_id,
																							@rsi_id,
																							@st_id,
																							@sti_orden out,
																							@rsi_ajuste, -- El signo de @rsi_ajuste les permite saber 
																													 -- si estan agregando o sacando del deposito
																						  @rsi_descrip,
																						  @pr_id,
																						  @@depl_id_origen,
																						  @@depl_id_destino,
					
																							@bSuccess out,						
																							@Message out 

			if IsNull(@bSuccess,0) = 0 goto Validate

		end else begin

			-- Si tiene numero de serie hay que grabar un stockitem por cada uno.
			if @bLlevaNroSerie <> 0 begin	
					
				exec sp_DocRecuentoStockSaveNroSerie    @@rsTMP_id,
																								@rsi_id,
																								@st_id,
																								@sti_orden out,
																								@rsi_ajuste, 	-- El signo de @rsi_ajuste les permite saber 
																													 		-- si estan agregando o sacando del deposito
																							  @rsi_descrip,
																							  @pr_id,
																							  @@depl_id_origen,
																							  @@depl_id_destino,
																								null,
						
																								@bSuccess out,						
																								@Message out 

												
				if IsNull(@bSuccess,0) = 0 goto Validate
										
			-- Solo son simples stockitems (una pavada)
			end else begin


				--////////////////////////////////////////////////////////////////////////
				--
				--  LLEVA NRO DE LOTE
				--
				--////////////////////////////////////////////////////////////////////////
		
				if @pr_llevanrolote <> 0 begin
		
					if @stl_id is null begin
		
						select @stl_id = stl_id from StockLote 
						where stl_codigo = @stl_codigo and pr_id = @pr_id
		
						if @stl_id is null begin
		
							exec SP_DBGetNewId 'StockLote','stl_id',@stl_id out, 0
							if @@error <> 0 goto ControlError
		
							insert StockLote(stl_id, stl_codigo, stl_nrolote, pr_id, stl_fecha, modifico) 
												values(@stl_id, @stl_codigo, @stl_codigo, @pr_id, @stl_fecha, @modifico)
							if @@error <> 0 goto ControlError
		
						end

						update RecuentoStockItem set stl_id = @stl_id where rsi_id = @rsi_id
						if @@error <> 0 goto ControlError

					end
				end		
				
				-- Le paso la cantidad siempre en positivo			
				if @@nTipo <> 1 set @rsi_ajuste = @rsi_ajuste * -1

				exec sp_DocRecuentoStockStockItemSave 
																								0,
																								@st_id,
																								@sti_orden out,
																								@rsi_ajuste,
																							  @rsi_descrip,
																							  @pr_id,
																							  @@depl_id_origen,
																							  @@depl_id_destino,
																								null,
																							  null,
																								@stl_id,

																								@bSuccess out,						
																								@Message out 
									
				if IsNull(@bSuccess,0) = 0 goto Validate
									
			end
		end

		fetch next from c_recuentoItemStock into @rsi_id, @rsi_ajuste, @pr_id, @rsi_descrip, @pr_llevanrolote,
																				 		 @stl_id, @stl_codigo
  end -- While

	close c_recuentoItemStock
	deallocate c_recuentoItemStock

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
//                                Vinculo la recuento con su Stock                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @@nTipo = 1 begin
		update RecuentoStock set st_id1 = @st_id where rs_id = @@rs_id
	end else begin
		if @@nTipo = 2 begin
			update RecuentoStock set st_id2 = @st_id where rs_id = @@rs_id
		end
	end

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar el recuento de stock. sp_DocRecuentoStockStockSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar el recuento de stock. sp_DocRecuentoStockStockSave.'
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