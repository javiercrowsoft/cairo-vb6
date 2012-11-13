if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaBOMStockSave2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaBOMStockSave2]

/*
 select * from Remitoventa
 sp_DocRemitoVentaBOMStockSave2 26

*/

go
create procedure sp_DocRemitoVentaBOMStockSave2 (
	@@bTemp           tinyint,

	@@rvTMP_id				int,
	@@rv_id 					int,

	@@depl_id         int,
	@@doc_id_Remito   int,
	@@modificado 		  datetime, 
	@@modifico   		  int, 
	@@st_id           int,

  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

  declare @IsNew          smallint
	
	set @@st_id = isnull(@@st_id,0)

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
declare @depl_id_interno        int set @depl_id_interno = -2 /*select * from depositologico*/

declare	@rvi_orden 							smallint 
declare @rvi_cantidad 					decimal(18, 6)

declare @pr_id                  int
declare @sti_id                 int

declare @doct_id_Remito         int

declare @st_doc_cliente         varchar(5000)

declare @bSuccess 							tinyint
declare @Message  							varchar(255)

	begin transaction

	create table #t_bom_stocklote (stl_id int not null)

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
				 @doct_id_Remito = RemitoVenta.doct_id, 
         @st_doc_cliente  = rv_nrodoc + ' ' + cli_nombre

	from RemitoVenta inner join Documento on RemitoVenta.doc_id = Documento.doc_id
									 inner join Cliente   on RemitoVenta.cli_id = Cliente.cli_id
	where rv_id = @@rv_id

	if @doct_id_Remito = 3 /* Remito */ begin

		set @depl_id_destino = @depl_id_interno
		set @depl_id_origen  = @@depl_id

	end else begin

    if @doct_id_Remito = 24 /* Devolucion Remito Venta */ begin

			set @depl_id_destino = @@depl_id
			set @depl_id_origen  = @depl_id_interno
		end
	end

	if @@st_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'Stock','st_id',@@st_id out, 0
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
															@@st_id,
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
					st_id = @@st_id

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
															modifico							= @@modifico,
															modificado            = @@modificado
	
		where st_id = @@st_id
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
		exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @@st_id, 1 /*Restar*/, 1 /*bNotUpdatePrns*/
		if IsNull(@bSuccess,0) = 0 goto Validate
		--
		--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
		-- Borro todos los items y solo hago inserts que se mucho mas simple y rapido
	  delete StockItem where st_id = @@st_id

		-- Borro todos los Kit de este movimiento
		delete StockItemKit where st_id = @@st_id

	end

	set @sti_orden = 0

 	declare @rvi_id           int

	declare c_RemitoItemStock cursor for 

		select 	rviiTMP_cantidad * pr_ventastock, 
						rvi.pr_id, 
						p.pr_llevanroserie, 
						p.pr_eskit, 
						p.pr_llevanrolote

				 	from RemitoVentaItemInsumoTMP rvi inner join Producto p on rvi.pr_id = p.pr_id

					where rvTMP_id = @@rvTMP_id
						and (
											(rviiTMP_temp <> 0 and @@bTemp <> 0)
									or 	(rviiTMP_temp =  0 and @@bTemp = 0)
								)
						and pr_llevastock <> 0

		union

		select 	rviiTMP_cantidadAux * pr_ventastock, 
						rvi.pr_id, 
						p.pr_llevanroserie, 
						p.pr_eskit, 
						p.pr_llevanrolote

				 	from RemitoVentaItemInsumoTMP rvi inner join Producto p on rvi.pr_id = p.pr_id

					where rvTMP_id = @@rvTMP_id
						and (rviiTMP_temp <> 0 and @@bTemp = 0)
						and rviiTMP_cantidadAux > 0
						and pr_llevastock <> 0

	declare @bEsKit 				tinyint 
  declare @bLLevaNroSerie tinyint
	declare @bLlevaNroLote  tinyint
	declare @stl_id         int
	declare @cant_lote      decimal(18,6)
	declare @cant_aux       decimal(18,6)

	open c_RemitoItemStock

	fetch next from c_RemitoItemStock into @rvi_cantidad, @pr_id, @bLLevaNroSerie, @bEsKit, @bLlevaNroLote
	while @@fetch_status = 0 
	begin

		while @rvi_cantidad > 0 begin 
				
			-- Obtengo por Fifo el lote "DIT" a descargar
			--
			if @@bTemp <> 0 begin
								
				set @stl_id = null

				select 
							top 1 @stl_id = stc.stl_id, @cant_lote = stc_cantidad
				from 
							StockCache stc inner join StockLote stl on stc.stl_id = stl.stl_id
				where 
							stc.pr_id = @pr_id
					and	depl_id 	= @@depl_id
				
					and not exists(select * from #t_bom_stocklote where stl_id = stc.stl_id)
									
				order by stl_fecha asc
				
				-- Si tengo un lote lo agrego a la lista de lotes usados
				--				
				if @stl_id is not null 
								insert into #t_bom_stocklote (stl_id) values(@stl_id)
				
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
			end

			if @cant_lote < @rvi_cantidad set @cant_aux = @cant_lote
			else                          set @cant_aux = @rvi_cantidad

			set @rvi_cantidad = @rvi_cantidad - @cant_aux
								
			-- Si es un kit hay que descomponerlo
			if 	@bEsKit <> 0 begin
							
				exec sp_DocRemitoVentaSaveItemKit 			@@rvTMP_id,
																								@rvi_id,
																								@@st_id,
																								@sti_orden out,
																								@cant_aux,
																							  '',
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
						
					exec sp_DocRemitoVentaSaveNroSerie      @@rvTMP_id,
																									@rvi_id,
																									@@st_id,
																									@sti_orden out,
																									@cant_aux,
																								  '',
																								  @pr_id,
																								  @depl_id_origen,
																								  @depl_id_destino,
																									null,
											
																									@bSuccess out,						
																									@Message out 
										
													
					if IsNull(@bSuccess,0) = 0 goto Validate
																	
				-- Solo son simples stockitems (una pavada)
				end else begin
								
					exec sp_DocRemitoVentaStockItemSave 
																									0,
																									@@st_id,
																									@sti_orden out,
																									@cant_aux,
																								  '',
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

		fetch next from c_RemitoItemStock into @rvi_cantidad, @pr_id, @bLLevaNroSerie, @bEsKit, @bLlevaNroLote
  end -- While

	close c_RemitoItemStock
	deallocate c_RemitoItemStock

	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Agrego a StockCache lo que se movio con los items de este movimiento
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @@st_id, 0 -- Sumar
	if IsNull(@bSuccess,0) = 0 goto Validate
	--
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo la Remito con su Stock                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @@bTemp <> 0 begin

		update RemitoVenta set st_id_consumoTemp = @@st_id where rv_id = @@rv_id

	end else begin

		update RemitoVenta set st_id_consumo = @@st_id where rv_id = @@rv_id

	end

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar el remito de venta. sp_DocRemitoVentaBOMStockSave2.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar el remito de venta. sp_DocRemitoVentaBOMStockSave2.'
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