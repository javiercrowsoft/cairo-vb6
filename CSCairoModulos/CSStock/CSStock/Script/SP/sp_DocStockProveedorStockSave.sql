if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockProveedorStockSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockProveedorStockSave]

/*

begin transaction

 sp_DocStockProveedorStockSave 1

rollback transaction

*/

go
create procedure sp_DocStockProveedorStockSave (
	@@stprov_id       int,
	@@stTMP_id 				int,
	@@st_id           int out,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

	declare @st_id					int
	declare @sti_id					int
  declare @IsNew          smallint
  declare @orden          smallint

	-- Si no existe chau
	if not exists (select stTMP_id from StockTMP where stTMP_id = @@stTMP_id)
		return


	declare @doct_id_cliente	int
	declare @id_cliente				int
	declare @st_doc_cliente		varchar(255)

	select  @st_doc_cliente 	= stprov_nrodoc + ' ' + prov_nombre,
				  @doct_id_cliente 	= stprov.doct_id,
					@id_cliente       = stprov.stprov_id
	from StockProveedor stprov inner join Proveedor prov on stprov.prov_id = prov.prov_id
	where stprov_id = @@stprov_id

-- Talonario
	declare	@st_nrodoc  varchar (50) 
	declare	@doc_id     int
	
	select @st_id = st_id, 

-- Talonario
				 @doc_id		= doc_id

	from StockTMP where stTMP_id = @@stTMP_id
	
	set @st_id = isnull(@st_id,0)
	

-- Campos de las tablas

declare	@st_numero  int 
declare	@st_descrip varchar (5000)
declare	@st_fecha   datetime 

declare	@suc_id     int
declare @ta_id      int
declare	@doct_id    int
declare	@lgj_id     int
declare @depl_id_origen  int
declare @depl_id_destino int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare	@sti_orden 							smallint 
declare	@sti_ingreso 						decimal(18, 6) 
declare	@sti_salida 						decimal(18, 6) 
declare	@sti_descrip 						varchar (5000) 
declare @sti_grupo              int
declare	@depl_id    						int
declare	@pr_id 									int
declare @prns_id                int
declare @pr_id_kit              int
declare @prns_descrip           varchar(255)
declare @prns_fechavto          datetime
declare @stl_id                 int
declare @bSuccess 							tinyint
declare @Message  							varchar(255)

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

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
															suc_id,
															doc_id,
															doct_id,
															doct_id_cliente,
															id_cliente,
															st_doc_cliente,	
															lgj_id,
															depl_id_origen,
															depl_id_destino,
															modifico
														)
			select
															@st_id,
															@st_numero,
															@st_nrodoc,
															st_descrip,
															st_fecha,
															suc_id,
															doc_id,
															doct_id,
															@doct_id_cliente,
															@id_cliente,
															@st_doc_cliente,
															lgj_id,
															depl_id_origen,
															depl_id_destino,
															modifico
			from StockTMP
		  where stTMP_id = @@stTMP_id	

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
															@st_id                 	= st_id,
															@st_descrip							= st_descrip,
															@st_fecha								= st_fecha,
															@suc_id									= suc_id,
															@doc_id									= doc_id,
															@doct_id								= doct_id,
															@lgj_id								  = lgj_id,
															@depl_id_origen         = depl_id_origen,
															@depl_id_destino        = depl_id_destino,
															@modifico							  = modifico,
															@modificado             = modificado
		from StockTMP 
    where 
					stTMP_id = @@stTMP_id
	
		update Stock set 
															st_descrip						= @st_descrip,
															st_fecha							= @st_fecha,
															suc_id								= @suc_id,
															doc_id								= @doc_id,
															doct_id								= @doct_id,

															doct_id_cliente				= @doct_id_cliente,
															id_cliente						= @id_cliente,
															st_doc_cliente				= @st_doc_cliente,

															lgj_id								= @lgj_id,
															depl_id_origen        = @depl_id_origen,
															depl_id_destino       = @depl_id_destino,
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
		if @@error <> 0 goto ControlError

		-- Borro todos los Kit de este movimiento
		delete StockItemKit where st_id = @st_id
		if @@error <> 0 goto ControlError

	end

	exec Sp_DocStockValidateFisico @Message out, @bSuccess out, @@stTMP_id
	if IsNull(@bSuccess,0) = 0 goto Validate

	--///////////////////////////////////////////////////////////////////////////////
	-- Kits
	declare @stik_orden 				smallint
	declare @stik_llevanroserie int
	declare @stik_id 						int
  declare @stik_cantidad      int
	declare @lastStik_orden 		smallint

	set @lastStik_orden = 0
	set @orden = 1

	while exists(select sti_orden from StockItemTMP where stTMP_id = @@stTMP_id and sti_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@sti_id										  = sti_id,
						@sti_orden									= sti_orden,
						@sti_ingreso							  = sti_ingreso,
						@sti_salida									= sti_salida,
            @sti_grupo                  = sti_grupo,
						@pr_id											= pr_id,
						@pr_id_kit                  = pr_id_kit,
						@depl_id										= depl_id,
						@prns_id                    = prns_id,
            @prns_descrip               = prns_descrip,
            @prns_fechavto              = prns_fechavto,
						@stik_orden                 = stik_orden,
            @stik_cantidad              = stik_cantidad,
						@stl_id                     = stl_id

		from StockItemTMP where stTMP_id = @@stTMP_id and sti_orden = @orden


		--///////////////////////////////////////////////////////////////////////////////
		-- Kits

		if @stik_orden <> 0 begin

			if @stik_orden <> @lastStik_orden begin

				exec SP_DBGetNewId 'StockItemKit','stik_id',@stik_id out, 0
				if @@error <> 0 goto ControlError

				if exists(select * from StockItemTMP 
													 where 	stTMP_id = @@stTMP_id 
															and stik_orden = @stik_orden
															and prns_id is not null) 
					
								set @stik_llevanroserie = 1
				else		set @stik_llevanroserie = 0 

				insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
												values   (@stik_id,@stik_cantidad,@pr_id_kit,@st_id,@stik_llevanroserie)
	
				set @lastStik_orden = @Stik_orden 
			end

		end 
		else set @stik_id = null
		

		--///////////////////////////////////////////////////////////////////////////////


		exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
		if @@error <> 0 goto ControlError

		insert into StockItem (
																	st_id,
																	sti_id,
																	sti_orden,
																	sti_ingreso,
																	sti_salida,
																	sti_grupo,
																	pr_id,
																	stik_id,
																	depl_id,
																	prns_id,
																	pr_id_kit,
																	stl_id
														)
												Values(
																	@st_id,
																	@sti_id,
																	@sti_orden,
																	@sti_ingreso,
																	@sti_salida,
																	@sti_grupo,
																	@pr_id,
																	@stik_id,
																	@depl_id,
                                  @prns_id,
																	@pr_id_kit,
																	@stl_id
														)

		if @@error <> 0 goto ControlError

		if IsNull(@prns_id,0) <> 0 begin
			update ProductoNumeroSerie set prns_descrip = @prns_descrip, prns_fechavto = @prns_fechavto 
					where prns_id = @prns_id
		end

	  set @orden = @orden + 1
  end -- While

	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Agrego a StockCache lo que se movio con los items de este movimiento
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @st_id, 0 -- Sumar
	if IsNull(@bSuccess,0) = 0 goto Validate
	--
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////

	delete StockItemTMP where stTMP_ID = @@stTMP_id
	delete StockTMP where stTMP_ID = @@stTMP_id

	set @@st_id = @st_id

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

	set @@MsgError = 'Ha ocurrido un error al grabar la transferencia de stock a proveedor. sp_DocStockProveedorStockSave.'

	goto Roll

Validate:

	set @@bError = -1

	set @Message = IsNull(@Message,'')

	set @@MsgError = @Message

Roll:

	-- El rollback lo hace sp_DocStockProveedorSave

end