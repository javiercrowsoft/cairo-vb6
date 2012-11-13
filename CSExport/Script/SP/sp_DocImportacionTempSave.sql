if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempSave]

/*

 sp_DocImportacionTempSave 93

*/

go
create procedure sp_DocImportacionTempSave (
	@@imptTMP_id int
)
as

begin

	set nocount on

	declare @impt_id					int
  declare @IsNew          smallint
  declare @orden          smallint

	-- Si no existe chau
	if not exists (select imptTMP_id from ImportacionTempTMP where imptTMP_id = @@imptTMP_id)
		return

-- Talonario
	declare	@impt_nrodoc  varchar (50) 
	declare	@doc_id     	int
	
	select @impt_id = impt_id,

-- Talonario
				 @impt_nrodoc	= impt_nrodoc,
				 @doc_id 			= doc_id 

	from ImportacionTempTMP where imptTMP_id = @@imptTMP_id
	
	set @impt_id = isnull(@impt_id,0)
	

-- Campos de las tablas

declare	@impt_numero  int 
declare	@impt_descrip varchar (5000)
declare	@impt_fecha   datetime 
declare	@impt_fechaentrega datetime 
declare @impt_fechaoficial datetime
declare @impt_despachonro  varchar(50)
declare	@impt_neto      decimal(18, 6) 
declare	@impt_ivari     decimal(18, 6)
declare	@impt_ivarni    decimal(18, 6)
declare	@impt_total     decimal(18, 6)
declare	@impt_subtotal  decimal(18, 6)
declare	@impt_descuento1    decimal(18, 6)
declare	@impt_descuento2    decimal(18, 6)
declare	@impt_importedesc1  decimal(18, 6)
declare	@impt_importedesc2  decimal(18, 6)
declare @impt_flete         decimal(18, 6)
declare @impt_seguro        decimal(18, 6)

declare	@est_id     int
declare	@suc_id     int
declare	@prov_id    int
declare @ta_id      int
declare	@doct_id    int
declare	@lp_id      int 
declare	@ld_id      int 
declare	@cpg_id     int
declare	@ccos_id    int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare @impti_id									int
declare @imptiTMP_id      				int
declare	@impti_orden 							smallint 
declare	@impti_cantidad 					decimal(18, 6) 
declare	@impti_cantidadaremitir 	decimal(18, 6) 
declare	@impti_descrip 						varchar (5000) 
declare	@impti_precio 						decimal(18, 6) 
declare	@impti_precioUsr 					decimal(18, 6)
declare	@impti_precioLista 				decimal(18, 6)
declare	@impti_descuento 					varchar (100) 
declare	@impti_neto 							decimal(18, 6) 
declare	@impti_ivari 							decimal(18, 6)
declare	@impti_ivarni 						decimal(18, 6)
declare	@impti_ivariporc 					decimal(18, 6)
declare	@impti_ivarniporc 				decimal(18, 6)
declare @impti_importe 						decimal(18, 6)
declare @impti_seguro 						decimal(18, 6)
declare @impti_flete  						decimal(18, 6)

declare @imptg_id									int
declare @imptgTMP_id      				int
declare	@imptg_orden 							smallint 

declare	@pr_id 									int
declare @gar_id     						int

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @impt_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'ImportacionTemp','impt_id',@impt_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'ImportacionTemp','impt_numero',@impt_numero out, 0
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

							set @impt_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into ImportacionTemp (
															impt_id,
															impt_numero,
															impt_nrodoc,
															impt_despachonro,
															impt_descrip,
															impt_fecha,
															impt_fechaentrega,
															impt_fechaoficial,
															impt_neto,
															impt_ivari,
															impt_ivarni,
															impt_total,
															impt_subtotal,
														  impt_descuento1,
														  impt_descuento2,
														  impt_importedesc1,
														  impt_importedesc2,
															impt_flete,
                              impt_seguro,
															est_id,
															suc_id,
															prov_id,
															doc_id,
															doct_id,
															lp_id,
															ld_id,
															cpg_id,
															ccos_id,
															modifico
														)
			select
															@impt_id,
															@impt_numero,
															@impt_nrodoc,
															impt_despachonro,
															impt_descrip,
															impt_fecha,
															impt_fechaentrega,
															impt_fechaoficial,
															impt_neto,
															impt_ivari,
															impt_ivarni,
															impt_total,
															impt_subtotal,
														  impt_descuento1,
														  impt_descuento2,
														  impt_importedesc1,
														  impt_importedesc2,
															impt_flete,
															impt_seguro,
															est_id,
															suc_id,
															prov_id,
															doc_id,
															doct_id,
															lp_id,
															ld_id,
															cpg_id,
															ccos_id,
															modifico
			from ImportacionTempTMP
		  where imptTMP_id = @@imptTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @impt_nrodoc = impt_nrodoc from ImportacionTemp where impt_id = @impt_id
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
															@impt_id                 	= impt_id,
															@impt_nrodoc							= impt_nrodoc,
															@impt_despachonro					= impt_despachonro,
															@impt_descrip							= impt_descrip,
															@impt_fecha								= impt_fecha,
															@impt_fechaentrega				= impt_fechaentrega,
															@impt_fechaoficial				= impt_fechaoficial,
															@impt_neto								= impt_neto,
															@impt_ivari								= impt_ivari,
															@impt_ivarni							= impt_ivarni,
															@impt_total								= impt_total,
														  @impt_descuento1          = impt_descuento1,
														  @impt_descuento2          = impt_descuento2,
														  @impt_flete 		          = impt_flete,
														  @impt_seguro     		      = impt_seguro,
															@impt_subtotal						= impt_subtotal,
														  @impt_importedesc1        = impt_importedesc1,
														  @impt_importedesc2        = impt_importedesc2,
															@est_id										= est_id,
															@suc_id										= suc_id,
															@prov_id									= prov_id,
															@doc_id										= doc_id,
															@doct_id									= doct_id,
															@lp_id										= lp_id,
															@ld_id										= ld_id,
															@cpg_id								  	= cpg_id,
															@ccos_id									= ccos_id,
															@modifico							  	= modifico,
															@modificado             	= modificado
		from ImportacionTempTMP 
    where 
					imptTMP_id = @@imptTMP_id
	
		update ImportacionTemp set 
															impt_nrodoc							= @impt_nrodoc,
															impt_despachonro				= @impt_despachonro,
															impt_descrip						= @impt_descrip,
															impt_fecha							= @impt_fecha,
															impt_fechaentrega				= @impt_fechaentrega,
															impt_neto								= @impt_neto,
															impt_ivari							= @impt_ivari,
															impt_ivarni							= @impt_ivarni,
															impt_total							= @impt_total,
														  impt_descuento1         = @impt_descuento1,
														  impt_descuento2         = @impt_descuento2,
															impt_subtotal						= @impt_subtotal,
														  impt_importedesc1       = @impt_importedesc1,
														  impt_importedesc2       = @impt_importedesc2,
															impt_flete              = @impt_flete,
                              impt_seguro             = @impt_seguro,
															est_id								  = @est_id,
															suc_id								  = @suc_id,
															prov_id								  = @prov_id,
															doc_id								  = @doc_id,
															doct_id								  = @doct_id,
															lp_id									  = @lp_id,
															ld_id									  = @ld_id,
															cpg_id								  = @cpg_id,
															ccos_id								  = @ccos_id,
															modifico							  = @modifico,
															modificado              = @modificado
	
		where impt_id = @impt_id
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
	while exists(select impti_orden from ImportacionTempItemTMP where imptTMP_id = @@imptTMP_id and impti_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@imptiTMP_id									= imptiTMP_id,
						@impti_id										  = impti_id,
						@impti_orden									= impti_orden,
						@impti_cantidad							  = impti_cantidad,
						@impti_cantidadaremitir			  = impti_cantidadaremitir,
						@impti_descrip								= impti_descrip,
						@impti_precio								  = impti_precio,
						@impti_precioUsr							= impti_precioUsr,
						@impti_precioLista						= impti_precioLista,
						@impti_descuento							= impti_descuento,
						@impti_neto									  = impti_neto,
						@impti_ivari									= impti_ivari,
						@impti_ivarni								  = impti_ivarni,
						@impti_ivariporc							= impti_ivariporc,
						@impti_ivarniporc						  = impti_ivarniporc,
						@impti_importe								= impti_importe,
						@impti_seguro								  = impti_seguro,
						@impti_flete								  = impti_flete,
						@pr_id												= pr_id,
						@ccos_id											= ccos_id

		from ImportacionTempItemTMP where imptTMP_id = @@imptTMP_id and impti_orden = @orden

		-- Cuando se inserta se indica 
		-- como cantidad a remitir la cantidad (Por ahora)
		set @impti_cantidadaremitir = @impti_cantidad

		if @IsNew <> 0 or @impti_id = 0 begin

				exec SP_DBGetNewId 'ImportacionTempItem','impti_id',@impti_id out, 0
				if @@error <> 0 goto ControlError

				insert into ImportacionTempItem (
																			impt_id,
																			impti_id,
																			impti_orden,
																			impti_cantidad,
																			impti_cantidadaremitir,
																			impti_descrip,
																			impti_precio,
																			impti_precioUsr,
																			impti_precioLista,
																			impti_descuento,
																			impti_neto,
																			impti_ivari,
																			impti_ivarni,
																			impti_ivariporc,
																			impti_ivarniporc,
																			impti_importe,
																			impti_seguro,
																			impti_flete,
																			pr_id,
																			ccos_id
																)
														Values(
																			@impt_id,
																			@impti_id,
																			@impti_orden,
																			@impti_cantidad,
																			@impti_cantidadaremitir,
																			@impti_descrip,
																			@impti_precio,
																			@impti_precioUsr,
																			@impti_precioLista,
																			@impti_descuento,
																			@impti_neto,
																			@impti_ivari,
																			@impti_ivarni,
																			@impti_ivariporc,
																			@impti_ivarniporc,
																			@impti_importe,
																			@impti_seguro,
																			@impti_flete,
																			@pr_id,
																			@ccos_id
																)

				if @@error <> 0 goto ControlError

				update ImportacionTempItemSerieTMP set impti_id = @impti_id where imptiTMP_id = @imptiTMP_id 
				if @@error <> 0 goto ControlError

		end -- Insert

		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        UPDATE                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/
		else begin

					update ImportacionTempItem set

									impt_id											= @impt_id,
									impti_orden									= @impti_orden,
									impti_cantidad							= @impti_cantidad,
									impti_cantidadaremitir			= @impti_cantidadaremitir,
									impti_descrip								= @impti_descrip,
									impti_precio								= @impti_precio,
									impti_precioUsr							= @impti_precioUsr,
									impti_precioLista						= @impti_precioLista,
									impti_descuento							= @impti_descuento,
									impti_neto									= @impti_neto,
									impti_ivari									= @impti_ivari,
									impti_ivarni								= @impti_ivarni,
									impti_ivariporc							= @impti_ivariporc,
									impti_ivarniporc						= @impti_ivarniporc,
									impti_importe								= @impti_importe,
									impti_seguro								= @impti_seguro,
									impti_flete								  = @impti_flete,
									pr_id												= @pr_id,
									ccos_id											= @ccos_id

				where impt_id = @impt_id and impti_id = @impti_id 
  			if @@error <> 0 goto ControlError

				update ImportacionTempItemSerieTMP set impti_id = @impti_id where imptiTMP_id = @imptiTMP_id 
				if @@error <> 0 goto ControlError

		end -- Update

	  set @orden = @orden + 1
  end -- While

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ITEM'S BORRADOS                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados del pedido
	if @IsNew = 0 begin
		
		delete ImportacionTempItem 
						where exists (select impti_id 
                          from ImportacionTempItemBorradoTMP 
                          where impt_id 		= @impt_id 
														and	imptTMP_id	= @@imptTMP_id
														and impti_id 		= ImportacionTempItem.impti_id
													)
		if @@error <> 0 goto ControlError

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        GARANTIAS                                                                   //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @IsNew = 0 begin
 		delete ImportacionTempGarantia where impt_id = @impt_id
	end

	set @orden = 1
	while exists(select imptg_orden from ImportacionTempGarantiaTMP where imptTMP_id = @@imptTMP_id and imptg_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@imptgTMP_id									= imptgTMP_id,
						@imptg_orden									= imptg_orden,
						@gar_id       							  = gar_id

		from ImportacionTempGarantiaTMP where imptTMP_id = @@imptTMP_id and imptg_orden = @orden

		exec SP_DBGetNewId 'ImportacionTempGarantia','imptg_id',@imptg_id out, 0
		if @@error <> 0 goto ControlError

		insert into ImportacionTempGarantia (
																	impt_id,
																	imptg_id,
																	imptg_orden,
																	gar_id
														)
												Values(
																	@impt_id,
																	@imptg_id,
																	@imptg_orden,
																	@gar_id
														)

		if @@error <> 0 goto ControlError

	  set @orden = @orden + 1
  end -- While

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Talonario                                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	declare @bError 	 			smallint
	declare @doc_mueveStock tinyint
  declare @depl_id        int

	select 
					@ta_id 						= ta_id,
          @depl_id          = ImportacionTempTMP.depl_id,
          @doc_mueveStock   = Documento.doc_muevestock

	from ImportacionTempTMP inner join documento on ImportacionTempTMP.doc_id = documento.doc_id
	where imptTMP_id = @@imptTMP_id


	exec sp_TalonarioSet @ta_id,@impt_nrodoc
	if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	exec sp_DocImportacionTempSetEstado @impt_id
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     STOCK                                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	declare @MsgError  varchar(5000) set @MsgError = ''

	if IsNull(@doc_mueveStock,0) <> 0 begin

		exec sp_DocImportacionTempStockSave @@imptTMP_id, @impt_id, @depl_id, 0, @bError out, @MsgError out
  	if @bError <> 0 goto ControlError

	end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  delete ImportacionTempItemSerieTMP where imptTMP_id = @@imptTMP_ID
  delete ImportacionTempGarantiaTMP where imptTMP_id = @@imptTMP_ID
	delete ImportacionTempItemTMP where imptTMP_id = @@imptTMP_id

	/*OJO: Esta aca y no en el if (if @IsNew = 0 begin)
				 como estaba antes, por que necesito usar
				 los registros de esta tabla en 
				 sp_DocRemitoCompraStockSave para borrar los 
	       numeros de serie asociados al rénglon
	*/
	delete ImportacionTempItemBorradoTMP where impt_id = @impt_id 
																				 and imptTMP_id = @@imptTMP_id
	delete ImportacionTempTMP where imptTMP_id = @@imptTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from ImportacionTemp where impt_id = @impt_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 22007, @impt_id, @modifico, 1
	else           exec sp_HistoriaUpdate 22007, @impt_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	select @impt_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar de la importación temporal. sp_DocImportacionTempSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end
end