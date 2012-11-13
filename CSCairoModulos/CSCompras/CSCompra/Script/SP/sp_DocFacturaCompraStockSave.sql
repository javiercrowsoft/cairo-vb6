if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraStockSave]

/*
 select * from facturaCompra
 sp_DocFacturaCompraStockSave 26

*/

go
create procedure sp_DocFacturaCompraStockSave (
	@@fcTMP_id        int,
	@@fc_id 					int,
  @@depl_id         int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

  declare @IsNew          smallint

	declare @st_id					int
	declare	@prov_id     		int
	declare @doc_id_factura int
	declare	@modificado 		datetime 
	declare	@modifico   		int 
	declare @stl_fecha      datetime

	-- Si no existe chau
	if not exists (select fc_id from FacturaCompra where fc_id = @@fc_id)
		return
	
	select 
					@st_id 						= st_id, 
					@prov_id 					= prov_id, 
					@doc_id_factura 	= doc_id,
					@modifico					= modifico,
					@modificado       = modificado,
					@stl_fecha        = fc_fecha

	from FacturaCompra where fc_id = @@fc_id
	
	set @st_id = isnull(@st_id,0)

-- Campos de las tablas
declare	@st_numero  int 
declare	@st_nrodoc  varchar (50) 
declare	@st_descrip varchar (5000)
declare	@st_fecha   datetime 
declare	@fc_fecha   datetime 
declare @suc_id     int

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 

declare	@sti_orden 							smallint 
declare	@sti_ingreso 						decimal(18, 6) 
declare	@sti_salida 						decimal(18, 6)

declare @depl_id_destino        int
declare @depl_id_origen         int
declare @depl_id_tercero        int set @depl_id_tercero = -3 /*select * from depositologico*/

declare	@fci_orden 							smallint 
declare @fci_cantidad 					decimal(18, 6)

declare @pr_id                  int
declare @sti_id                 int
declare @fci_descrip            varchar(255)

declare @doct_id_factura        int

declare @st_doc_cliente         varchar(5000)

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
				 @doc_id 					= doc_id_Stock, 
				 @doct_id_factura = FacturaCompra.doct_id, 
         @st_doc_cliente  = fc_nrodoc + ' ' + prov_nombre

	from FacturaCompra inner join Documento on FacturaCompra.doc_id = Documento.doc_id
										 inner join Proveedor   on FacturaCompra.prov_id = Proveedor.prov_id
	where fc_id = @@fc_id

	if @doct_id_factura = 2 /* Factura */ or @doct_id_factura = 10 /* Nota de Debito*/ begin

		set @depl_id_origen   = @depl_id_tercero
		set @depl_id_destino  = @@depl_id

	end else begin

    if @doct_id_factura = 8 /* Nota de Credito */ begin

			set @depl_id_origen   = @@depl_id
			set @depl_id_destino  = @depl_id_tercero
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
															depl_id_destino,
                              depl_id_origen,
															modifico
														)
			select
															@st_id,
															@st_numero,
															@st_nrodoc,
															fc_descrip,
															fc_fecha,
															@st_doc_cliente,
															suc_id,
															@doc_id,
															@doct_id,
															@doct_id_factura,
															@@fc_id,
															@depl_id_destino,
                              @depl_id_origen,
															@modifico
			from FacturaCompra
		  where fc_id = @@fc_id	

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
		from Stockitem sti inner join FacturaCompraItemBorradoTMP fci
													on 		sti.st_id    	= @st_id 
														and	fci.fc_id 	  = @@fc_id
														and fci.fcTMP_id  = @@fcTMP_id
														and sti.sti_grupo =	fci.fci_id

		/* Ahora si el Update */

		set @IsNew = 0

		select
															@st_descrip							= fc_descrip,
															@st_fecha								= fc_fecha,
										          @suc_id           			= suc_id
		from FacturaCompra 
    where 
					fc_id = @@fc_id

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
															id_cliente						= @@fc_id,
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
	
		-- Borro todos los items y solo hago inserts que se mucho mas simple y rapido
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
	declare @fci_id           int
	declare @prns_id					int	
	declare @prns_codigo			varchar	(100)
	declare @prns_descrip		  varchar	(255)
	declare @prns_fechavto		datetime	

	--////////////////////////////////////////////////
	-- Numero de lote
	--////////////////////////////////////////////////
	declare @pr_llevanrolote	tinyint
	declare @stl_id						int 
	declare @stl_codigo				varchar(50)

	--////////////////////////////////////////////////

	declare c_FacturaItemStock cursor for 

		select 	fci.fci_id, 
						case when pr_stockcompra <> 0 then fci.fci_cantidadaremitir / pr_stockcompra else 0 end, 
						fci.pr_id, 
						fci.fci_descrip, 
						p.pr_llevanroserie,
						p.pr_llevanrolote,
						fci.stl_id,
						fcit.stl_codigo

					from FacturaCompraItem fci inner join FacturaCompraItemTMP fcit on 		fci.fci_id    = fcit.fci_id
																																						and fcit.fcTMP_id = @@fcTMP_id
																		 inner join Producto p on fci.pr_id = p.pr_id
					where fc_id = @@fc_id
						and pr_llevastock <> 0

	open c_FacturaItemStock

	fetch next from c_FacturaItemStock into @fci_id, @fci_cantidad, @pr_id, @fci_descrip, 
                                          @pr_llevanroserie, @pr_llevanrolote,
                                          @stl_id, @stl_codigo
	while @@fetch_status = 0 
	begin

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

				update FacturaCompraItem set stl_id = @stl_id where fci_id = @fci_id
				if @@error <> 0 goto ControlError

			end else begin

				-- Si ya existe un lote para este articulo con este codigo
				-- cambio el stl_id, La tarea de validacion de lotes se encargara de 
				-- eliminar lotes que no figuran en StockItem
				--
				if exists(select * from StockLote where stl_id <> @stl_id and stl_codigo = @stl_codigo and pr_id = @pr_id) begin

					select @stl_id = min(stl_id) 
					from StockLote 
					where stl_id <> @stl_id 
						and stl_codigo = @stl_codigo 
						and pr_id = @pr_id

					update FacturaCompraItem set stl_id = @stl_id where fci_id = @fci_id
					if @@error <> 0 goto ControlError

				-- Actualizo el codigo del lote
				--
				end else begin

					update StockLote set stl_codigo = @stl_codigo where stl_id = @stl_id
					if @@error <> 0 goto ControlError
				end
			end				

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
											values(@st_id, @sti_id, @sti_orden, 0, @fci_cantidad, @fci_descrip, 
                             @pr_id, @depl_id_origen, @stl_id)
		  if @@error <> 0 goto ControlError
	
			set @sti_orden = @sti_orden + 1
	
			exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
			if @@error <> 0 goto ControlError
	
			insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip,
                             pr_id, depl_id, stl_id)
											values(@st_id, @sti_id, @sti_orden, @fci_cantidad, 0, @fci_descrip, 
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
																									from FacturaCompraItemSerieTMP where 	fci_id 	 = @fci_id
																																										and fcTMP_id = @@fcTMP_id
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
															 @fci_descrip, 
															 @fci_id,
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
															 @fci_descrip, 
															 @fci_id,
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

		fetch next from c_FacturaItemStock into @fci_id, @fci_cantidad, @pr_id, @fci_descrip, 
                                            @pr_llevanroserie, @pr_llevanrolote,
																					  @stl_id, @stl_codigo
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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo la factura con su Stock                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	update FacturaCompra set st_id = @st_id where fc_id = @@fc_id

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//																Borro los números de serie                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete StockCache
  where prns_id in (select prns_id from FacturaCompraItemSerieBTMP where fcTMP_id = @@fcTMP_id)
	if @@error <> 0 goto ControlError

	delete ProductoNumeroSerie 
  where prns_id in (select prns_id from FacturaCompraItemSerieBTMP where fcTMP_id = @@fcTMP_id)
	if @@error <> 0 goto ControlError

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar la factura de compra. sp_DocFacturaCompraStockSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar la factura de compra. sp_DocFacturaCompraStockSave.'
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