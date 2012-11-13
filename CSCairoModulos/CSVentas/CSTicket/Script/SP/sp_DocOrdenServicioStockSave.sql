if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioStockSave]

/*
 select * from OrdenServicio
 sp_DocOrdenServicioStockSave 26

*/

go
create procedure sp_DocOrdenServicioStockSave (
	@@osTMP_id        int,
	@@os_id 					int,
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
	declare	@cli_id     		int
	declare @doc_id_Remito  int
	declare	@modificado 		datetime 
	declare	@modifico   		int 
	declare @stl_fecha      datetime

	-- Si no existe chau
	if not exists (select os_id from OrdenServicio where os_id = @@os_id)
		return

	select 
					@st_id 						= st_id, 
					@cli_id 					= cli_id, 
					@doc_id_Remito 		= doc_id,
					@modifico					= modifico,
					@modificado       = modificado,
					@stl_fecha        = os_fecha

	from OrdenServicio where os_id = @@os_id
	
	set @st_id = isnull(@st_id,0)

-- Campos de las tablas
declare	@st_numero  int 
declare	@st_nrodoc  varchar (50) 
declare	@st_descrip varchar (5000)
declare	@st_fecha   datetime 
declare	@os_fecha   datetime 
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

declare	@osi_orden 							smallint 
declare @osi_cantidad 					decimal(18, 6)

declare @pr_id                  int
declare @sti_id                 int
declare @osi_descrip            varchar(255)

declare @doct_id_Remito         int

declare @st_doc_cliente         varchar(5000)

declare @bError                 tinyint

declare @bSuccess 							tinyint
declare @Message  							varchar(255)

declare @os_nrodoc              varchar(50)

-------------------------------------------------------------------------------
-- Detalle del Equipo
--
declare @prns_id_oss            int -- El que se almacena en las temporales
																		-- lo necesito para el detalle del equipo
declare @oss_id									int
declare @oss_valor							varchar(50)
declare @edi_id									int
-------------------------------------------------------------------------------

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
				 @doct_id_Remito  = OrdenServicio.doct_id, 
         @st_doc_cliente  = os_nrodoc + ' ' + cli_nombre,
				 @os_nrodoc       = os_nrodoc

	from OrdenServicio inner join Documento on OrdenServicio.doc_id  = Documento.doc_id
									  inner join Cliente on OrdenServicio.cli_id = Cliente.cli_id
	where os_id = @@os_id

	set @depl_id_origen   = @depl_id_tercero
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
															os_descrip,
															os_fecha,
															@st_doc_cliente,
															suc_id,
															@doc_id,
															@doct_id,
															@doct_id_Remito,
															@@os_id,
															@depl_id_destino,
                              @depl_id_origen,
															@modifico
			from OrdenServicio
		  where os_id = @@os_id	

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
		from Stockitem sti inner join OrdenServicioItemBorradoTMP osi
													on 		sti.st_id    	= @st_id 
														and	osi.os_id 	  = @@os_id
														and osi.osTMP_id  = @@osTMP_id
														and sti.sti_grupo =	osi.osi_id

		/* Ahora si el Update */

		set @IsNew = 0

		select
															@st_descrip							= os_descrip,
															@st_fecha								= os_fecha,
										          @suc_id           			= suc_id
		from OrdenServicio 
    where 
					os_id = @@os_id

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
															id_cliente						= @@os_id,
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

		delete OrdenServicioSerie where os_id = @@os_id
		if @@error <> 0 goto ControlError

	end
	
	set @sti_orden = 0

	--////////////////////////////////////////////////
	-- Numero de serie
	--////////////////////////////////////////////////
	declare @pr_llevanroserie tinyint
	declare @osi_id           int
	declare @prns_id					int	
	declare @prns_id_aux			int	
	declare @prns_codigo			varchar	(100)
	declare @prns_codigo2			varchar	(100)
	declare @prns_codigo3			varchar	(100)
	declare @prns_descrip		  varchar	(255)
	declare @prns_fechavto		datetime	

	--////////////////////////////////////////////////
	-- Numero de lote
	--////////////////////////////////////////////////
	declare @pr_llevanrolote	tinyint
	declare @pr_id_kit       	int
	declare @stl_id						int 
	declare @stl_codigo				varchar(50)

	--////////////////////////////////////////////////

	declare c_RemitoItemStock cursor for 

		select 	osi.osi_id, 
						case when pr_stockcompra <> 0 then osi.osi_cantidadaremitir / pr_stockcompra else 0 end, 
						osi.pr_id, 
						osi.osi_descrip, 
						p.pr_llevanroserie, 
						case p.pr_eskit when 0 then null else osi.pr_id end,
						p.pr_llevanrolote,
						osi.stl_id,
						osit.stl_codigo

					from OrdenServicioItem osi inner join OrdenServicioItemTMP osit on 		osi.osi_id = osit.osi_id
																																					and	osit.osTMP_id = @@osTMP_id
																		inner join Producto p on osi.pr_id = p.pr_id
					where os_id = @@os_id
						and pr_llevastock <> 0

	open c_RemitoItemStock

	fetch next from c_RemitoItemStock into @osi_id, @osi_cantidad, @pr_id, @osi_descrip, 
																				 @pr_llevanroserie, @pr_id_kit, @pr_llevanrolote,
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

				update OrdenServicioItem set stl_id = @stl_id where osi_id = @osi_id
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

					update OrdenServicioItem set stl_id = @stl_id where osi_id = @osi_id
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
											values(@st_id, @sti_id, @sti_orden, 0, @osi_cantidad, @osi_descrip, 
														 @pr_id, @depl_id_origen, @stl_id)
		  if @@error <> 0 goto ControlError
	
			set @sti_orden = @sti_orden + 1
	
			exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
			if @@error <> 0 goto ControlError

			insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
														 pr_id, depl_id, stl_id)
											values(@st_id, @sti_id, @sti_orden, @osi_cantidad, 0, @osi_descrip, 
														 @pr_id, @depl_id_destino, @stl_id)
		  if @@error <> 0 goto ControlError
	
			set @sti_orden = @sti_orden + 1

		--////////////////////////////////////////////////////////////////////////
		--
		--  LLEVA NRO DE SERIE
		--
		--////////////////////////////////////////////////////////////////////////
		end else begin

			declare c_nrosSerie insensitive cursor for select prns_id, 
																												prns_codigo, 
																												prns_codigo2, 
																												prns_codigo3, 
																												prns_descrip, 
																												prns_fechavto 
																									from OrdenServicioItemSerieTMP where osi_id = @osi_id
																																									and	osTMP_id = @@osTMP_id
			open c_nrosSerie

			fetch next from c_nrosSerie into @prns_id, @prns_codigo, @prns_codigo2, @prns_codigo3, @prns_descrip, @prns_fechavto
			while @@fetch_status = 0 
			begin

				set @prns_id_oss = @prns_id

				-- Si el numero ya existe lo reutilizamos
				-- ya que se trata de una reentrada de un
				-- equipo que debemos verificar.
				-- OJO: Solo si el numero no esta en la empresa
				--
				if @prns_id <= 0 begin
					set @prns_id_aux = null
					select @prns_id_aux = prns_id from ProductoNumeroSerie 
					where prns_codigo = @prns_codigo 
						and pr_id = @pr_id
						and depl_id in (-2,-3)
					if @prns_id_aux is not null set @prns_id = @prns_id_aux
				end

				--////////////////////////////////////////////////////////////////////////
				--  Numero de Serie
				if @prns_id <= 0 begin
	
					-- Si el codigo2 esta vacio ponemos el numero de serie. Esto es para que
					-- al cargar Ordenes de Servicio que sugieren como numero de serie una OT
					-- el numero se copie al codigo2 que es por ahora el campo reservado para OT
					--
					-- Talvez deberiamos ponerlo en funcion de un parametro de configuracion
					-- o incluso pasarlo a un sp de cliente Olaen.
					--
					-- Por ahora queda asi
					--
					if @prns_codigo2 = '' or @prns_codigo2 = @os_nrodoc set @prns_codigo2 = @prns_codigo

					exec SP_DBGetNewId 'ProductoNumeroSerie','prns_id',@prns_id out, 0				
					if @@error <> 0 goto ControlError

					insert into ProductoNumeroSerie (
																					 prns_id, 
																					 prns_codigo, 
																					 prns_codigo2, 
																					 prns_codigo3, 
																					 prns_descrip, 
																					 prns_fechavto, 
																					 pr_id, 
																					 pr_id_kit,
																					 depl_id,
																					 stl_id,
																					 modifico
																					 )
																		values(
																					 @prns_id, 
																					 @prns_codigo, 
																					 @prns_codigo2, 
																					 @prns_codigo3, 
																					 @prns_descrip, 
																					 @prns_fechavto, 
																					 @pr_id, 
																					 @pr_id_kit,
																					 @depl_id_destino,
																					 @stl_id,
																					 @modifico	
																					 )
			  	if @@error <> 0 goto ControlError

				end else begin

					Update ProductoNumeroSerie Set
																					prns_codigo		= @prns_codigo, 
																					prns_codigo2	= @prns_codigo2, 
																					prns_codigo3	= @prns_codigo3, 
																					prns_descrip	= @prns_descrip, 
																					prns_fechavto = @prns_fechavto, 
																					modificado 		= @modificado,
																					modifico 			= @modifico
									where prns_id = @prns_id
				  if @@error <> 0 goto ControlError

					Update ProductoNumeroSerie Set
																					doc_id_ingreso  = @@os_id,
																					doct_id_ingreso = 42,
																					cli_id					= @cli_id

									where prns_id = @prns_id
										and	doc_id_ingreso 	is null
										and doct_id_ingreso is null

				  if @@error <> 0 goto ControlError

				end
				--////////////////////////////////////////////////////////////////////////

				--////////////////////////////////////////////////////////////////////////
				-- Detalle del equipo

				declare c_DetalleEquipo insensitive cursor for
								select edi_id, oss_valor
								from OrdenServicioSerieTMP
								where osTMP_id = @@osTMP_id
									and prns_id  = @prns_id_oss

				open c_DetalleEquipo

				fetch next from c_DetalleEquipo into @edi_id, @oss_valor

				while @@fetch_status = 0
				begin

					exec SP_DBGetNewId 'OrdenServicioSerie','oss_id',@oss_id out, 0				
					if @@error <> 0 goto ControlError

					insert into OrdenServicioSerie (os_id,
																					oss_id,
																					oss_valor,
																					prns_id,
																					edi_id
																					)
																	values (@@os_id,
																					@oss_id,
																					@oss_valor,
																					@prns_id,
																					@edi_id
																					)

					fetch next from c_DetalleEquipo into @edi_id, @oss_valor
				end

				close c_DetalleEquipo
				deallocate c_DetalleEquipo
				

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
															 pr_id_kit,
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
															 @osi_descrip, 
															 @osi_id,
															 @pr_id, 
															 @pr_id_kit,
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
															 pr_id_kit,
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
															 @osi_descrip, 
															 @osi_id,
															 @pr_id, 
															 @pr_id_kit,
															 @depl_id_destino, 
															 @prns_id,
															 @stl_id
															)
			  if @@error <> 0 goto ControlError
		
				set @sti_orden = @sti_orden + 1
				--////////////////////////////////////////////////////////////////////////

				fetch next from c_nrosSerie into @prns_id, @prns_codigo, @prns_codigo2, @prns_codigo3, @prns_descrip, @prns_fechavto
			end

			close c_nrosSerie
			deallocate c_nrosSerie
		end

		fetch next from c_RemitoItemStock into @osi_id, @osi_cantidad, @pr_id, @osi_descrip, 
                                           @pr_llevanroserie, @pr_id_kit, @pr_llevanrolote,
																					 @stl_id, @stl_codigo
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
//                                Vinculo el Remito con su Stock                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	update OrdenServicio set st_id = @st_id where os_id = @@os_id

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//																Borro los números de serie                                                     //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete StockCache
  where prns_id in (select prns_id from OrdenServicioItemSerieBTMP where osTMP_id = @@osTMP_id)
	if @@error <> 0 goto ControlError

	delete ProductoNumeroSerie 
  where prns_id in (select prns_id from OrdenServicioItemSerieBTMP where osTMP_id = @@osTMP_id)
	if @@error <> 0 goto ControlError

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar la orden de servicio. sp_DocOrdenServicioStockSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar la orden de servicio. sp_DocOrdenServicioStockSave.'
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