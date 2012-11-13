if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitStockSave]

/*
 select * from ParteProdKit
 sp_DocParteProdKitStockSave 26

*/

go
create procedure sp_DocParteProdKitStockSave (
	@@ppkTMP_id 							int,
	@@ppk_id 									int,
	@@depl_id_origen         	int,
	@@depl_id_destino        	int,
  @@nTipo                   tinyint, /* 1 st_id1, 2 st_id2 */
	@@bDesarme                int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

	declare @ppki_id					int
  declare @IsNew            smallint

	declare @st_id					  int
	declare @doc_id_partepkit int

	-- Si no existe chau
	if not exists (select ppk_id from ParteProdKit where ppk_id = @@ppk_id)
		return
	
	select 
					@st_id= case @@nTipo
										when 1 then	st_id1 
										when 2 then	st_id2 
									end,
					@doc_id_partepkit 	= doc_id

	from ParteProdKit where ppk_id = @@ppk_id
	
	set @st_id = isnull(@st_id,0)

-- Campos de las tablas
declare	@st_numero  int 
declare	@st_nrodoc  varchar (50) 
declare	@st_descrip varchar (5000)
declare	@st_fecha   datetime 
declare	@ppk_fecha  datetime 
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

declare	@ppki_orden 						smallint 
declare @ppki_cantidad 					decimal(18, 6)
declare @prfk_id                int
declare @bIdentidad							tinyint
declare @tiene_alternativas			tinyint
declare @bResumido							tinyint

declare @pr_id                  int
declare @sti_id                 int
declare @ppki_descrip           varchar(255)
declare @doct_id_partepkit      int

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
				 @doc_id 					  = doc_id_Stock, 
				 @doct_id_partepkit = ParteProdKit.doct_id

	from ParteProdKit inner join Documento on ParteProdKit.doc_id = Documento.doc_id

	where ppk_id = @@ppk_id

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
															ppk_descrip,
															ppk_fecha,
															'',
															suc_id,
															@doc_id,
															@doct_id,
															@doct_id_partepkit,
															@@ppk_id,
															@@depl_id_destino,
                              @@depl_id_origen,
															modifico
			from ParteProdKit
		  where ppk_id = @@ppk_id	

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
															@st_descrip							= ppk_descrip,
															@st_fecha								= ppk_fecha,
															@modifico							  = modifico,
															@modificado             = modificado,
										          @suc_id           			= suc_id
		from ParteProdKit 
    where 
					ppk_id = @@ppk_id

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
															doct_id_cliente				= @doct_id_partepkit,
															id_cliente						= @@ppk_id,
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

	declare c_partepkitItemStock cursor for 

		select 
						ppki.ppki_id, 
						ppki.ppki_cantidad, 
						ppki.pr_id, 
						ppki_descrip,
						ppki.prfk_id,
						pr_kitIdentidad,
						pr_kitresumido,
						case when exists(select prka_id 
														 from ProductoKitItemA pka 
																	inner join ProductoKit pk on 		pka.prk_id = pk.prk_id
																															and prfk_id = ppki.prfk_id)
								 then		1
								 else		0
						end	as tiene_alternativas


		from ParteProdKitItem ppki inner join Producto pr on ppki.pr_id = pr.pr_id
		where ppk_id = @@ppk_id

	open c_partepkitItemStock

	fetch next from c_partepkitItemStock into @ppki_id, @ppki_cantidad, @pr_id, @ppki_descrip, 
																						@prfk_id, @bIdentidad, @tiene_alternativas, @bResumido
	while @@fetch_status = 0 
	begin

		if 			@bIdentidad <> 0 
				or 	@tiene_alternativas <> 0 
				or  @bResumido <> 0
		begin

			exec sp_DocParteProdKitSaveItemKitEx		@@ppkTMP_id,
																							@ppki_id,
																							@st_id,
																							@sti_orden out,
																							@ppki_cantidad,
																						  @ppki_descrip,
																						  @pr_id,
																						  @@depl_id_origen,
																						  @@depl_id_destino,
																							@prfk_id,

																							@@bDesarme,
					
																							@bSuccess out,						
																							@Message out 

		end else begin

			exec sp_DocParteProdKitSaveItemKit 			@@ppkTMP_id,
																							@ppki_id,
																							@st_id,
																							@sti_orden out,
																							@ppki_cantidad,
																						  @ppki_descrip,
																						  @pr_id,
																						  @@depl_id_origen,
																						  @@depl_id_destino,
																							@prfk_id,

																							@@bDesarme,
					
																							@bSuccess out,						
																							@Message out 
		end

		if IsNull(@bSuccess,0) = 0 goto Validate

		fetch next from c_partepkitItemStock into @ppki_id, @ppki_cantidad, @pr_id, @ppki_descrip, 
																							@prfk_id, @bIdentidad, @tiene_alternativas, @bResumido
  end -- While

	close c_partepkitItemStock
	deallocate c_partepkitItemStock

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
//                                Vinculo el Parte de Produccion de Kit con su Stock                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @@nTipo = 1 begin
		update ParteProdKit set st_id1 = @st_id where ppk_id = @@ppk_id
	end else begin
		if @@nTipo = 2 begin
			update ParteProdKit set st_id2 = @st_id where ppk_id = @@ppk_id

      --////////////////////////////////////////////////////////////////////////////////////////////////////////////
      -- Vinculo todos los numeros de serie utilizados en este parte con el ppk_id
			-- Esto es muy importante ya que me permite actualizar el pr_id_kit y el ppk_id en el
			-- sp {sp_DocParteProdKitSave}
			--
      update ProductoNumeroSerie set ppk_id = @@ppk_id 
      where   exists(select prns_id from StockItem
                                    where st_id = @st_id and prns_id = ProductoNumeroSerie.prns_id)

							-- Esto dice: No debe existir un movimiento de stock con st_id mayor al st_id
							-- 						vinculado a este parte de produccion, ya que si existe, significa
							--            que lo producido por este parte fue utilizado por otro parte
							--            posterior a este.
							--            Por ejemplo: Creo el parte 1 que produce una placa madre mas sus
							--                         memorias y procesador.
							--
							--                         Luego creo el parte 2 que le agrega disco, placa de video
							--                         gabinete y todo lo demas para tener lista una pc
							--
							--                         Ahora modifico el parte 1 por que algun numero de serie estaba
							--                         mal.
							--
							--												 EN ESTE CASO LOS NUMEROS DE SERIE VINCULADOS CON EL PARTE 2 NO DEBEN
							--                         VINCULARSE CON EL PARTE 1                         
							--
         and  not exists(select st_id 
                         from StockItem s
																					inner join ParteProdKit p on s.st_id = p.st_id2
                         where st_id > @st_id 
                           and prns_id = ProductoNumeroSerie.prns_id 
                         )
		end
	end

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar el parte de produccion de kit de stock. sp_DocParteProdKitStockSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar el parte de produccion de kit de stock. sp_DocParteProdKitStockSave.'
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

 	if @@trancount > 0 begin
 		rollback transaction	
  end

end