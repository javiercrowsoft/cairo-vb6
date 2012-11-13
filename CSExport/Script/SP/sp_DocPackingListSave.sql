if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListSave]

/*

begin transaction

exec sp_DocPackingListSave 4

rollback transaction

*/

go
create procedure sp_DocPackingListSave (
	@@pklstTMP_ID int
)
as

begin

	set nocount on

	declare @pklst_id				int
	declare @pklsti_id			int
  declare @IsNew          smallint
  declare @orden          smallint
	declare	@doc_id     		int
	declare	@doct_id    		int
	declare	@pklst_nrodoc  	varchar (50) 

	-- Si no existe chau
	if not exists (select pklstTMP_ID from PackingListTMP where pklstTMP_ID = @@pklstTMP_ID)
		return
	
	select @pklst_id 			= pklst_id, 

-- Talonario
				 @pklst_nrodoc	= pklst_nrodoc,
				 @doc_id 				= doc_id 

	from PackingListTMP where pklstTMP_ID = @@pklstTMP_ID

	set @pklst_id = isnull(@pklst_id,0)
	
	select @doct_id = doct_id from Documento where doc_id = @doc_id

-- Campos de las tablas
declare	@pklst_numero  									int 
declare	@pklst_descrip 									varchar (5000)
declare	@pklst_marca  									varchar (255)
declare	@pklst_fecha   									datetime 
declare	@pklst_fechaentrega 						datetime 

declare	@pklst_cantidad									int 
declare	@pklst_pallets 									int 

declare	@pklst_neto      								decimal(18, 6) 
declare	@pklst_ivari     								decimal(18, 6)
declare	@pklst_ivarni    								decimal(18, 6)
declare	@pklst_total     								decimal(18, 6)
declare	@pklst_subtotal  								decimal(18, 6)
declare	@pklst_pendiente 								decimal(18, 6)
declare	@pklst_descuento1    						decimal(18, 6)
declare	@pklst_descuento2    						decimal(18, 6)
declare	@pklst_importedesc1  						decimal(18, 6)
declare	@pklst_importedesc2  						decimal(18, 6)

declare	@est_id     			int
declare	@suc_id     			int
declare	@cli_id     			int
declare @ta_id      			int
declare	@lp_id      			int 
declare	@ld_id      			int 
declare	@cpg_id     			int
declare @pue_id_origen    int
declare @pue_id_destino   int
declare @barc_id          int
declare	@ccos_id    			int
declare	@creado     			datetime 
declare	@modificado 			datetime 
declare	@modifico   			int 


declare	@pklsti_orden 							smallint 
declare	@pklsti_cantidad 					  decimal(18, 6) 
declare @pklsti_pallets              int
declare	@pklsti_pendiente 					decimal(18, 6) 
declare @pklsti_pendientefac				decimal(18, 6)
declare	@pklsti_descrip 						varchar (5000) 
declare	@pklsti_precio 						  decimal(18, 6) 
declare	@pklsti_precioUsr 					decimal(18, 6)
declare	@pklsti_precioLista 				decimal(18, 6)
declare	@pklsti_descuento 					varchar (100) 
declare	@pklsti_neto 							  decimal(18, 6) 
declare	@pklsti_ivari 							decimal(18, 6)
declare	@pklsti_ivarni 						  decimal(18, 6)
declare	@pklsti_ivariporc 					decimal(18, 6)
declare	@pklsti_ivarniporc 				  decimal(18, 6)
declare @pklsti_importe 						decimal(18, 6)
declare	@pr_id 									    int
declare @pklsti_cajadesde           smallint
declare @pklsti_cajahasta           smallint
declare @pklsti_pesoneto           	decimal(18,6)
declare @pklsti_pesototal						decimal(18,6)
declare @pklsti_grupoexpo           varchar(100)

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @pklst_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'PackingList','pklst_id',@pklst_id out,0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'PackingList','pklst_numero',@pklst_numero out,0
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

							set @pklst_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into PackingList (
															pklst_id,
															pklst_numero,
															pklst_nrodoc,
															pklst_descrip,
                              pklst_marca,
															pklst_fecha,
															pklst_fechaentrega,
															pklst_cantidad,
															pklst_pallets,
															pklst_neto,
															pklst_ivari,
															pklst_ivarni,
															pklst_total,
															pklst_subtotal,
														  pklst_descuento1,
														  pklst_descuento2,
														  pklst_importedesc1,
														  pklst_importedesc2,
															est_id,
															suc_id,
															cli_id,
															doc_id,
															doct_id,
															lp_id,
															ld_id,
															cpg_id,
															pue_id_origen,
															pue_id_destino,
															barc_id,
															ccos_id,
															modifico
														)
			select
															@pklst_id,
															@pklst_numero,
															@pklst_nrodoc,
															pklst_descrip,
                              pklst_marca,
															pklst_fecha,
															pklst_fechaentrega,
															pklst_cantidad,
															pklst_pallets,
															pklst_neto,
															pklst_ivari,
															pklst_ivarni,
															pklst_total,
															pklst_subtotal,
														  pklst_descuento1,
														  pklst_descuento2,
														  pklst_importedesc1,
														  pklst_importedesc2,
															est_id,
															suc_id,
															cli_id,
															doc_id,
															@doct_id,
															lp_id,
															ld_id,
															cpg_id,
															pue_id_origen,
															pue_id_destino,
															barc_id,
															ccos_id,
															modifico
			from PackingListTMP
		  where pklstTMP_ID = @@pklstTMP_ID	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @pklst_nrodoc = pklst_nrodoc from PackingList where pklst_id = @pklst_id
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
															@pklst_id                 	= pklst_id,
															@pklst_nrodoc							  = pklst_nrodoc,
															@pklst_descrip							= pklst_descrip,
															@pklst_marca  							= pklst_marca,
															@pklst_fecha								= pklst_fecha,
															@pklst_fechaentrega				  = pklst_fechaentrega,
															@pklst_cantidad             = pklst_cantidad,
															@pklst_pallets              = pklst_pallets,
															@pklst_neto								  = pklst_neto,
															@pklst_ivari								= pklst_ivari,
															@pklst_ivarni							  = pklst_ivarni,
															@pklst_total								= pklst_total,
														  @pklst_descuento1           = pklst_descuento1,
														  @pklst_descuento2           = pklst_descuento2,
															@pklst_subtotal						  = pklst_subtotal,
														  @pklst_importedesc1         = pklst_importedesc1,
														  @pklst_importedesc2         = pklst_importedesc2,
															@est_id									    = est_id,
															@suc_id									    = suc_id,
															@cli_id									    = cli_id,
															@doc_id									    = doc_id,

															@lp_id											= lp_id,
															@ld_id											= ld_id,
															@cpg_id								  		= cpg_id,

															@pue_id_origen  			  		= pue_id_origen,
															@pue_id_destino				  		= pue_id_destino,
															@barc_id      				  		= barc_id,

															@ccos_id										= ccos_id,
															@modifico							  		= modifico,
															@modificado             		= modificado
		from PackingListTMP 
    where 
					pklstTMP_ID = @@pklstTMP_ID
	
		update PackingList set 
															pklst_nrodoc							= @pklst_nrodoc,
															pklst_descrip							= @pklst_descrip,
															pklst_marca 							= @pklst_marca,
															pklst_fecha								= @pklst_fecha,
															pklst_fechaentrega				= @pklst_fechaentrega,
															pklst_cantidad  					= @pklst_cantidad,
															pklst_pallets							= @pklst_pallets,
															pklst_neto								= @pklst_neto,
															pklst_ivari								= @pklst_ivari,
															pklst_ivarni							= @pklst_ivarni,
															pklst_total								= @pklst_total,
														  pklst_descuento1         	= @pklst_descuento1,
														  pklst_descuento2         	= @pklst_descuento2,
															pklst_subtotal						= @pklst_subtotal,
														  pklst_importedesc1       	= @pklst_importedesc1,
														  pklst_importedesc2       	= @pklst_importedesc2,
															est_id										= @est_id,
															suc_id										= @suc_id,
															cli_id										= @cli_id,
															doc_id										= @doc_id,
															doct_id										= @doct_id,
															lp_id											= @lp_id,
															ld_id											= @ld_id,
															cpg_id										= @cpg_id,

															pue_id_origen  			  		= @pue_id_origen,
															pue_id_destino				  	= @pue_id_destino,
															barc_id      				  		= @barc_id,

															ccos_id										= @ccos_id,
															modifico									= @modifico,
															modificado            		= @modificado
	
		where pklst_id = @pklst_id
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
	while exists(select pklsti_orden from PackingListItemTMP where pklstTMP_ID = @@pklstTMP_ID and pklsti_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@pklsti_id										  = pklsti_id,
						@pklsti_orden									  = pklsti_orden,
						@pklsti_cantidad							  = pklsti_cantidad,
						@pklsti_pallets  							  = pklsti_pallets,
						@pklsti_pendiente							  = pklsti_pendiente,
						@pklsti_pendientefac						= pklsti_pendientefac,
						@pklsti_descrip								  = pklsti_descrip,
						@pklsti_precio								  = pklsti_precio,
						@pklsti_precioUsr							  = pklsti_precioUsr,
						@pklsti_precioLista						  = pklsti_precioLista,
						@pklsti_descuento							  = pklsti_descuento,
						@pklsti_neto									  = pklsti_neto,
						@pklsti_ivari									  = pklsti_ivari,
						@pklsti_ivarni								  = pklsti_ivarni,
						@pklsti_ivariporc							  = pklsti_ivariporc,
						@pklsti_ivarniporc						  = pklsti_ivarniporc,
						@pklsti_importe								  = pklsti_importe,
						@pklsti_cajadesde							  = pklsti_cajadesde,
						@pklsti_cajahasta							  = pklsti_cajahasta,
						@pklsti_pesoneto							  = pklsti_pesoneto,
						@pklsti_pesototal							  = pklsti_pesototal,
						@pklsti_grupoexpo							  = pklsti_grupoexpo,
						@pr_id											    = pr_id,
						@ccos_id										    = ccos_id

		from PackingListItemTMP where pklstTMP_ID = @@pklstTMP_ID and pklsti_orden = @orden

		if @IsNew <> 0 or @pklsti_id = 0 begin

				-- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
				set @pklsti_pendiente 		= @pklsti_cantidad
				set @pklsti_pendientefac  = @pklsti_cantidad

				exec SP_DBGetNewId 'PackingListItem','pklsti_id',@pklsti_id out,0
				if @@error <> 0 goto ControlError

				insert into PackingListItem (
																			pklst_id,
																			pklsti_id,
																			pklsti_orden,
																			pklsti_cantidad,
																			pklsti_pallets,
																			pklsti_pendiente,
																			pklsti_pendientefac,
																			pklsti_descrip,
																			pklsti_precio,
																			pklsti_precioUsr,
																			pklsti_precioLista,
																			pklsti_descuento,
																			pklsti_neto,
																			pklsti_ivari,
																			pklsti_ivarni,
																			pklsti_ivariporc,
																			pklsti_ivarniporc,
																			pklsti_importe,
																			pklsti_cajadesde,
																			pklsti_cajahasta,
																			pklsti_pesoneto,
																			pklsti_pesototal,
																			pklsti_grupoexpo,
																			pr_id,
																			ccos_id
																)
														Values(
																			@pklst_id,
																			@pklsti_id,
																			@pklsti_orden,
																			@pklsti_cantidad,
																			@pklsti_pallets,
																			@pklsti_pendiente,
																			@pklsti_pendientefac,
																			@pklsti_descrip,
																			@pklsti_precio,
																			@pklsti_precioUsr,
																			@pklsti_precioLista,
																			@pklsti_descuento,
																			@pklsti_neto,
																			@pklsti_ivari,
																			@pklsti_ivarni,
																			@pklsti_ivariporc,
																			@pklsti_ivarniporc,
																			@pklsti_importe,
																			@pklsti_cajadesde,
																			@pklsti_cajahasta,
																			@pklsti_pesoneto,
																			@pklsti_pesototal,
																			@pklsti_grupoexpo,
																			@pr_id,
																			@ccos_id
																)

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

					-- Cuando se actualiza se indica 
					-- como pendiente la cantidad a remitir menos lo aplicado
					select @pklsti_pendiente = sum(pvpklst_cantidad) from PedidoPackingList where pklsti_id = @pklsti_id
					select @pklsti_pendiente = isnull(@pklsti_pendiente,0)
																		 + sum(mfcpklst_cantidad) 
																													 from ManifiestoPackingList where pklsti_id = @pklsti_id
					set @pklsti_pendiente = @pklsti_cantidad - isnull(@pklsti_pendiente,0)

					-- Cuando se actualiza se indica 
					-- como pendiente la cantidad a remitir menos lo aplicado
					select @pklsti_pendientefac = sum(pklstfv_cantidad) from PackingListFacturaVenta where pklsti_id = @pklsti_id
					set @pklsti_pendientefac = @pklsti_cantidad - isnull(@pklsti_pendientefac,0)

					update PackingListItem set

									pklst_id											= @pklst_id,
									pklsti_orden									= @pklsti_orden,
									pklsti_cantidad							  = @pklsti_cantidad,
									pklsti_pallets  							= @pklsti_pallets,
									pklsti_pendiente							= @pklsti_pendiente,
									pklsti_pendientefac					  = @pklsti_pendientefac,
									pklsti_descrip								= @pklsti_descrip,
									pklsti_precio								  = @pklsti_precio,
									pklsti_precioUsr							= @pklsti_precioUsr,
									pklsti_precioLista						= @pklsti_precioLista,
									pklsti_descuento							= @pklsti_descuento,
									pklsti_neto									  = @pklsti_neto,
									pklsti_ivari									= @pklsti_ivari,
									pklsti_ivarni								  = @pklsti_ivarni,
									pklsti_ivariporc							= @pklsti_ivariporc,
									pklsti_ivarniporc						  = @pklsti_ivarniporc,
									pklsti_importe								= @pklsti_importe,
									pklsti_cajadesde							= @pklsti_cajadesde,
									pklsti_cajahasta							= @pklsti_cajahasta,
									pklsti_pesoneto							  = @pklsti_pesoneto,
									pklsti_pesototal							= @pklsti_pesototal,
									pklsti_grupoexpo							= @pklsti_grupoexpo,
									pr_id											    = @pr_id,
									ccos_id										    = @ccos_id

				where pklst_id = @pklst_id and pklsti_id = @pklsti_id 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION-PEDIDO                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @pvpklst_id 						int
declare @pvpklst_cantidad				decimal(18,6)
declare @pvi_cancelado          decimal(18,6)
declare @pvi_id                 int
declare @iOrden                 int set @iOrden = 0

	-- Creo un cursor sobre los registros de aplicacion entre el PackingList
	-- y los pedidos
	declare c_aplicacion insensitive cursor for

  			select 
								pvpklst_id, 
								pvi_id, 
								pvpklst_cantidad

				 from PedidoPackingListTMP where pklstTMP_id = @@pklstTMP_id

	open c_aplicacion

  fetch next from c_aplicacion into @pvpklst_id, @pvi_id, @pvpklst_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el rvi que le corresponde a este pvi
		set @iOrden = @iOrden + 1
		select @pklsti_id = pklsti_id from PackingListItem where pklst_id = @pklst_id and pklsti_orden = @iOrden

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'PedidoPackingList','pvpklst_id',@pvpklst_id out,0
		if @@error <> 0 goto ControlError

		insert into PedidoPackingList (
																				pvpklst_id,
																				pvpklst_cantidad,
																				pklsti_id,
																				pvi_id
																			)
                            	values (
																				@pvpklst_id,
																				@pvpklst_cantidad,
																				@pklsti_id,		
																				@pvi_id
																			)
		if @@error <> 0 goto ControlError

		-- Pendiente en packinglist item	
		update PackingListItem set pklsti_pendiente = pklsti_cantidad - @pvpklst_cantidad
    where pklsti_id = @pklsti_id
		if @@error <> 0 goto ControlError

		---------------------------------------------------------------------------------------------------
		-- Pendiente en pedido item	
		select @pvi_cancelado = sum(pvpklst_cantidad) from PedidoPackingList where pvi_id = @pvi_id
		select @pvi_cancelado = IsNull(@pvi_cancelado,0) +  IsNull(sum(pvfv_cantidad),0) 
																																					 from PedidoFacturaVenta 
																																					 where pvi_id = @pvi_id
		set @pvi_cancelado = IsNull(@pvi_cancelado,0)

		update PedidoVentaItem set pvi_pendientepklst = pvi_cantidadaremitir - @pvi_cancelado
    where pvi_id = @pvi_id
		if @@error <> 0 goto ControlError
		---------------------------------------------------------------------------------------------------

	  fetch next from c_aplicacion into @pvpklst_id, @pvi_id, @pvpklst_cantidad
	end

  close c_aplicacion
  deallocate c_aplicacion

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        APLICACION-MANIFIESTO                                                  //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

declare @mfcpklst_id 						int
declare @mfcpklst_cantidad			decimal(18,6)
declare @mfci_cancelado         decimal(18,6)
declare @mfci_id                int
--declare @iOrden                 int set @iOrden = 0

	-- Creo un cursor sobre los registros de aplicacion entre el PackingList
	-- y los Manifiestos
	declare c_aplicacion insensitive cursor for

  			select 
								mfcpklst_id, 
								mfci_id, 
								mfcpklst_cantidad

				 from ManifiestoPackingListTMP where pklstTMP_id = @@pklstTMP_id

	open c_aplicacion

  fetch next from c_aplicacion into @mfcpklst_id, @mfci_id, @mfcpklst_cantidad

	while @@fetch_status = 0 begin

		-- Obtengo por el orden el rvi que le corresponde a este mfci
		set @iOrden = @iOrden + 1
		select @pklsti_id = pklsti_id from PackingListItem where pklst_id = @pklst_id and pklsti_orden = @iOrden

		-- Finalmente grabo la vinculacion
		--
		exec SP_DBGetNewId 'ManifiestoPackingList','mfcpklst_id',@mfcpklst_id out,0
		if @@error <> 0 goto ControlError

		insert into ManifiestoPackingList (
																				mfcpklst_id,
																				mfcpklst_cantidad,
																				pklsti_id,
																				mfci_id
																			)
                            	values (
																				@mfcpklst_id,
																				@mfcpklst_cantidad,
																				@pklsti_id,		
																				@mfci_id
																			)
		if @@error <> 0 goto ControlError

		-- Pendiente en packinglist item	
		update PackingListItem set pklsti_pendiente = pklsti_cantidad - @mfcpklst_cantidad
    where pklsti_id = @pklsti_id
		if @@error <> 0 goto ControlError

		---------------------------------------------------------------------------------------------------
		-- Pendiente en manifiesto item	
		select @mfci_cancelado = sum(mfcpklst_cantidad) from ManifiestoPackingList where mfci_id = @mfci_id
		set @mfci_cancelado = IsNull(@mfci_cancelado,0)

		update ManifiestoCargaItem set mfci_pendiente = mfci_cantidad - @mfci_cancelado
    where mfci_id = @mfci_id
		if @@error <> 0 goto ControlError
		---------------------------------------------------------------------------------------------------

	  fetch next from c_aplicacion into @mfcpklst_id, @mfci_id, @mfcpklst_cantidad
	end

  close c_aplicacion
  deallocate c_aplicacion

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ITEM'S BORRADOS                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  -- Hay que borrar los items borrados del pedido
	if @IsNew = 0 begin
		
		delete PackingListItem 
						where exists (select pklsti_id 
                          from PackingListItemBorradoTMP 
                          where pklst_id 		= @pklst_id 
														and pklstTMP_id = @@pklstTMP_id
														and pklsti_id 	= PackingListItem.pklsti_id
													)
		if @@error <> 0 goto ControlError

		delete PackingListItemBorradoTMP where pklst_id = @pklst_id and pklstTMP_id = @@pklstTMP_id

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	delete PedidoPackingListTMP where pklstTMP_ID = @@pklstTMP_ID
	delete PackingListItemTMP where pklstTMP_ID = @@pklstTMP_ID
	delete PackingListTMP where pklstTMP_ID = @@pklstTMP_ID

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PENDIENTE                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @pklst_pendiente = sum(pklsti_pendientefac * (pklsti_importe / pklsti_cantidad)) from PackingListItem where pklst_id = @pklst_id
	select @pklst_pendiente = pklst_total - @pklst_pendiente from PackingList where pklst_id = @pklst_id

	update PackingList set pklst_pendiente = @pklst_pendiente where pklst_id = @pklst_id
	if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        UPDATE PENDIENTE EN PEDIDOS                                            //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	-- Finalmente actualizo el pendiente de los pedidos
	--
	declare @pv_id int
  declare @bSuccess tinyint

	declare c_pedidoPendiente insensitive cursor for 
		select distinct pv_id 
		from PedidoPackingList pvpklst inner join PackingListItem pklsti on pvpklst.pklsti_id = pklsti.pklsti_id
															     inner join PedidoVentaItem pvi on pvpklst.pvi_id = pvi.pvi_id
		where pklst_id = @pklst_id
	
	open c_pedidoPendiente
	fetch next from c_pedidoPendiente into @pv_id
	while @@fetch_status = 0 begin

		-- Actualizo la deuda de la factura
		exec sp_DocPedidoVentaSetPendiente @pv_id, @bSuccess out
	
		-- Si fallo al guardar
		if IsNull(@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocPedidoVentaSetCredito @pv_id
		if @@error <> 0 goto ControlError

		exec sp_DocPedidoVentaSetEstado @pv_id
		if @@error <> 0 goto ControlError

		fetch next from c_pedidoPendiente into @pv_id
	end
	close c_pedidoPendiente
	deallocate c_pedidoPendiente
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TALONARIO                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select @ta_id = ta_id from documento where doc_id = @doc_id
	exec sp_TalonarioSet @ta_id,@pklst_nrodoc
	if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	exec sp_DocPackingListSetCredito @pklst_id
	if @@error <> 0 goto ControlError

	exec sp_DocPackingListSetEstado @pklst_id
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from PackingList where pklst_id = @pklst_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 22005, @pklst_id, @modifico, 1
	else           exec sp_HistoriaUpdate 22005, @pklst_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	select @pklst_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar del packing list. sp_DocPackingListSave.', 16, 1)
	rollback transaction	

end