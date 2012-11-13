if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitSave]

/*

 sp_DocParteProdKitSave 93

*/

go
create procedure sp_DocParteProdKitSave (
	@@ppkTMP_id int
)
as

begin

	set nocount on

	declare @ppk_id					int
	declare @ppki_id				int
	declare	@doct_id    		int
  declare @IsNew          smallint
  declare @orden          smallint
	declare @bSuccess 			tinyint
	declare @MsgError  			varchar(5000) set @MsgError = ''

	-- Si no existe chau
	if not exists (select ppkTMP_id from ParteProdKitTMP where ppkTMP_id = @@ppkTMP_id)
		return

-- Talonario
	declare	@ppk_nrodoc  	varchar (50) 
	declare	@doc_id     	int
	
	select @ppk_id 	= ppk_id, 
				 @doct_id = doct_id, 

-- Talonario
				 @ppk_nrodoc = ppk_nrodoc,
				 @doc_id		 = doc_id

	from ParteProdKitTMP where ppkTMP_id = @@ppkTMP_id
	
	set @ppk_id = isnull(@ppk_id,0)
	
-- Campos de las tablas

declare	@ppk_numero  int 
declare	@ppk_descrip varchar (5000)
declare	@ppk_fecha   datetime 

declare	@suc_id     int
declare @ta_id      int
declare @lgj_id     int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare @ppkiTMP_id             int
declare	@ppki_orden 						smallint 
declare	@ppki_cantidad 					decimal(18, 6) 
declare	@ppki_descrip 					varchar (5000) 
declare	@pr_id 									int
declare @depl_id								int
declare @prfk_id                int

	begin transaction

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @ppk_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'ParteProdKit','ppk_id',@ppk_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'ParteProdKit','ppk_numero',@ppk_numero out, 0
		if @@error <> 0 goto ControlError

		-- //////////////////////////////////////////////////////////////////////////////////
		--
		-- Talonario
		--
					declare @ta_propuesto tinyint
					declare @ta_tipo      smallint
			
					exec sp_talonarioGetPropuesto @doc_id, 0, @ta_propuesto out, 0, 0, @ta_id out, @ta_tipo out
					if @@error <> 0 goto ControlError
			
					if @ta_propuesto = 0 begin
			
						if @ta_tipo = 3 /*Auto Impresor*/ begin

							declare @ta_nrodoc varchar(100)

							exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
							if @@error <> 0 goto ControlError

							-- Con esto evitamos que dos tomen el mismo número
							--
							exec sp_TalonarioSet @ta_id, @ta_nrodoc
							if @@error <> 0 goto ControlError

							set @ppk_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into ParteProdKit (
															ppk_id,
															ppk_numero,
															ppk_nrodoc,
															ppk_descrip,
															ppk_fecha,
															suc_id,
															lgj_id,
															doc_id,
															doct_id,
															depl_id,
															modifico
														)
			select
															@ppk_id,
															@ppk_numero,
															@ppk_nrodoc,
															ppk_descrip,
															ppk_fecha,
															suc_id,
															lgj_id,
															doc_id,
															doct_id,
															depl_id,
															modifico
			from ParteProdKitTMP
		  where ppkTMP_id = @@ppkTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @ppk_nrodoc = ppk_nrodoc from ParteProdKit where ppk_id = @ppk_id
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
															@ppk_id                 = ppk_id,
															@ppk_nrodoc							= ppk_nrodoc,
															@ppk_descrip						= ppk_descrip,
															@ppk_fecha							= ppk_fecha,
															@suc_id									= suc_id,
															@lgj_id									= lgj_id,
															@doc_id									= doc_id,
															@doct_id								= doct_id,
															@depl_id								= depl_id,
															@modifico							  = modifico,
															@modificado             = modificado
		from ParteProdKitTMP 
    where 
					ppkTMP_id = @@ppkTMP_id
	
		update ParteProdKit set 
															ppk_nrodoc						= @ppk_nrodoc,
															ppk_descrip						= @ppk_descrip,
															ppk_fecha							= @ppk_fecha,
															suc_id								= @suc_id,
															lgj_id								= lgj_id,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															depl_id								= @depl_id,
															modifico							= @modifico,
															modificado            = @modificado
	
		where ppk_id = @ppk_id
  	if @@error <> 0 goto ControlError
	end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	set @orden = 1
	while exists(select ppki_orden from ParteProdKitItemTMP where ppkTMP_id = @@ppkTMP_id and ppki_orden = @orden) 
	begin

		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@ppki_id										= ppki_id,
						@ppki_orden									= ppki_orden,
						@ppki_cantidad							= ppki_cantidad,
						@ppki_descrip								= ppki_descrip,
						@pr_id											= pr_id,
            @depl_id                    = depl_id,
						@prfk_id                    = prfk_id,
						@ppkiTMP_id                 = ppkiTMP_id

		from ParteProdKitItemTMP where ppkTMP_id = @@ppkTMP_id and ppki_orden = @orden

		if @IsNew <> 0 or @ppki_id = 0 begin

				exec SP_DBGetNewId 'ParteProdKitItem','ppki_id',@ppki_id out, 0
				if @@error <> 0 goto ControlError
		
				insert into ParteProdKitItem (
																			ppk_id,
																			ppki_id,
																			ppki_orden,
																			ppki_cantidad,
																			ppki_descrip,
																			pr_id,
																			depl_id,
																			prfk_id
																)
														Values(
																			@ppk_id,
																			@ppki_id,
																			@ppki_orden,
																			@ppki_cantidad,
																			@ppki_descrip,
																			@pr_id,
																			@depl_id,
																			@prfk_id
																)

				if @@error <> 0 goto ControlError

				update ParteProdKitItemTMP set ppki_id = @ppki_id where ppkiTMP_id = @ppkiTMP_id

		end -- Insert

		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        UPDATE                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/
		else begin

					update ParteProdKitItem set

									ppk_id										= @ppk_id,
									ppki_orden								= @ppki_orden,
									ppki_cantidad							= @ppki_cantidad,
									ppki_descrip							= @ppki_descrip,
									pr_id											= @pr_id,
									depl_id										= @depl_id,
									prfk_id                   = @prfk_id

				where ppk_id = @ppk_id and ppki_id = @ppki_id 
  			if @@error <> 0 goto ControlError
		end -- Update

		update ParteProdKitItemSerieTMP set ppki_id = @ppki_id where ppkiTMP_id = @ppkiTMP_id

	  set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     DELETE                                                                         //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados del pedido
	if @IsNew = 0 begin

		delete ParteProdKitItem 
						where exists (select ppki_id 
                          from ParteProdKitItemBorradoTMP 
                          where ppk_id 		= @ppk_id 
														and ppkTMP_id = @@ppkTMP_id
														and ppki_id 	= ParteProdKitItem.ppki_id
													)
		if @@error <> 0 goto ControlError

		delete ParteProdKitItemBorradoTMP where ppk_id = @ppk_id and ppkTMP_id = @@ppkTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	declare @bError 	 			smallint

	select 
					@ta_id 						= ta_id,
          @depl_id          = ParteProdKitTMP.depl_id

	from ParteProdKitTMP inner join documento on ParteProdKitTMP.doc_id = documento.doc_id
	where ppkTMP_id = @@ppkTMP_id

	exec sp_TalonarioSet @ta_id, @ppk_nrodoc
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     STOCK                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	declare @depl_id_interno		int

	set @depl_id_interno = -2 /*select * from depositologico*/


	-- 
	declare @bDesarme tinyint

	if @doct_id = 34 /*produccion de kit*/ set @bDesarme = 1
	else             /*produccion de kit*/ set @bDesarme = 0

	--//////////////////////////////////////////////////////////////////////
	-- Consumo los componentes enviandolos al deposito interno

		exec sp_DocParteProdKitStockSave 	@@ppkTMP_id,
																			@ppk_id, 
																		 	@depl_id, 				-- Origen
																			@depl_id_interno, -- Destino		     
																			2, 								-- 2 -> Salida de Stock
																			@bDesarme, 
																			0, 
																			@bError out, 
																			@MsgError out
		if @bError <> 0 goto Validate
	
		--//////////////////////////////////////////////////////////////////////
		-- Doy de alta los nuevos kits en el deposito donde estaban los insumos
	
		exec sp_DocParteProdKitStockSave 	@@ppkTMP_id,
																			@ppk_id, 
																			@depl_id_interno, -- Origen
																			@depl_id, 				-- Destino
																			1, 								-- 1 -> Ingreso a Stock
																			@bDesarme, 
																			0, 
																			@bError out, 
																			@MsgError out
		if @bError <> 0 goto Validate

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//               		ACTUALIZO LOS NUMEROS DE SERIE 																																		//
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

------------------------------------------------------------------------------------------------------------------------
	if @IsNew = 0 begin

	  -- Actualizo en los numerso de serie el kit asociado
	  --
	  update ProductoNumeroSerie 

				  -- Vinculo con el kit que le corresponde
					--
	    set pr_id_kit = (select top 1 pr_id_kit 
	                     from StockCache 
	                     where prns_id = ProductoNumeroSerie.prns_id and stc_cantidad > 0 
	                     order by stc_id desc
	                     ),

				  -- Vinculo con el ppk_id que le corresponde
					--
					ppk_id 		= (select top 1 ppk_id
		                   from ParteProdKit p inner join StockItem s on p.st_id1 = s.st_id
		                   where prns_id = ProductoNumeroSerie.prns_id
		                   order by ppk_id desc
		                   )
	  where ppk_id = @ppk_id
		if @@error <> 0 goto ControlError

	end
------------------------------------------------------------------------------------------------------------------------

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- FECHAS

-- STOCK
	exec sp_AuditoriaStockCheckDocPPK		@ppk_id,
																			@bSuccess	out,
																			@MsgError out,
																			@bDesarme

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete ProductoSerieKitItemTMP where ppkTMP_id = @@ppkTMP_id
	delete ProductoSerieKitTMP where ppkTMP_id = @@ppkTMP_id
	delete ParteProdKitItemATMP where ppkTMP_id = @@ppkTMP_id
	delete ParteProdKitItemSerieTMP where ppkTMP_id = @@ppkTMP_id
	delete ParteProdKitItemTMP where ppkTMP_id = @@ppkTMP_id
	delete ParteProdKitTMP where ppkTMP_id = @@ppkTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from ParteProdKit where ppk_id = @ppk_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 20003, @ppk_id, @modifico, 1
	else           exec sp_HistoriaUpdate 20003, @ppk_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	select @ppk_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar el parte de produccion de kit. sp_DocParteProdKitSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	goto Roll

Validate:

	raiserror (@MsgError, 16, 1)

Roll:

	if @@trancount > 0 begin
		rollback transaction	
  end

end