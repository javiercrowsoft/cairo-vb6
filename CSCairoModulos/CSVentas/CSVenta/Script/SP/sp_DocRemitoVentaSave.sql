if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSave]

/*

begin transaction

exec sp_DocRemitoVentaSave 4

rollback transaction

*/

go
create procedure sp_DocRemitoVentaSave (
	@@rvTMP_ID int,
  @@rv_id    int = 0 out,
	@@bSelect  tinyint = 1
)
as

begin

	set nocount on

	declare @rv_id					int
  declare @IsNew          smallint
  declare @orden          smallint
	declare	@doct_id    		int
	declare @emp_id         int
	declare @doc_rv_bom     tinyint

	-- Si no existe chau
	if not exists (select rvTMP_ID from RemitoVentaTMP where rvTMP_ID = @@rvTMP_ID)
		return

-- Talonario
	declare	@doc_id     	int
	declare	@rv_nrodoc  	varchar (50) 
	
	select 
					@rv_id 			= rv_id,
					@doct_id 		= Documento.doct_id,
					@emp_id   	= emp_id,
					@doc_rv_bom	= doc_rv_bom,

-- Talonario
				 @rv_nrodoc = rv_nrodoc,
				 @doc_id		= RemitoVentaTMP.doc_id
	
	from RemitoVentaTMP inner join Documento on RemitoVentaTMP.doc_id = Documento.doc_id
  where rvTMP_ID = @@rvTMP_ID
	
	set @rv_id = isnull(@rv_id,0)
	

-- Campos de las tablas

declare	@rv_numero  			int 
declare	@rv_descrip 			varchar (5000)
declare	@rv_fecha   			datetime 
declare	@rv_fechaentrega 	datetime 
declare	@rv_neto      		decimal(18, 6) 
declare	@rv_ivari     		decimal(18, 6)
declare	@rv_ivarni    		decimal(18, 6)
declare	@rv_total     		decimal(18, 6)
declare	@rv_subtotal  		decimal(18, 6)
declare	@rv_pendiente 		decimal(18, 6)
declare	@rv_descuento1    decimal(18, 6)
declare	@rv_descuento2    decimal(18, 6)
declare	@rv_importedesc1  decimal(18, 6)
declare	@rv_importedesc2  decimal(18, 6)
declare	@rv_cotizacion  	decimal(18, 6)
declare @rv_retiro        varchar (255)
declare @rv_guia          varchar (255)
declare @rv_destinatario  varchar (1000)
declare @rv_ordencompra   varchar (255)

declare	@est_id     				int
declare	@suc_id     				int
declare	@cli_id     				int
declare @ta_id      				int
declare	@lp_id      				int 
declare	@ld_id      				int 
declare	@cpg_id     				int
declare	@ccos_id    				int
declare @stl_id             int
declare @lgj_id     				int
declare @ven_id     				int
declare @pro_id_origen     	int
declare @pro_id_destino    	int
declare @trans_id   				int
declare @clis_id    				int
declare @chof_id						int
declare @cam_id						  int
declare @cam_id_semi			  int
declare	@creado     				datetime 
declare	@modificado 				datetime 
declare	@modifico   				int 

declare @rvi_id									int
declare @rviTMP_id      				int
declare	@rvi_orden 							smallint 
declare	@rvi_cantidad 					decimal(18, 6) 
declare	@rvi_cantidadaremitir 	decimal(18, 6) 
declare	@rvi_pendiente 					decimal(18, 6) 
declare @rvi_pendientefac				decimal(18, 6)
declare	@rvi_descrip 						varchar (5000) 
declare	@rvi_precio 						decimal(18, 6) 
declare	@rvi_precioUsr 					decimal(18, 6)
declare	@rvi_precioLista 				decimal(18, 6)
declare	@rvi_descuento 					varchar (100) 
declare	@rvi_neto 							decimal(18, 6) 
declare	@rvi_ivari 							decimal(18, 6)
declare	@rvi_ivarni 						decimal(18, 6)
declare	@rvi_ivariporc 					decimal(18, 6)
declare	@rvi_ivarniporc 				decimal(18, 6)
declare @rvi_importe 						decimal(18, 6)
declare @rvi_importCodigo				varchar(255)
declare	@pr_id 									int

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @rv_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'RemitoVenta','rv_id',@rv_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'RemitoVenta','rv_numero',@rv_numero out, 0
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

							set @rv_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into RemitoVenta (
															rv_id,
															rv_numero,
															rv_nrodoc,
															rv_descrip,
															rv_fecha,
															rv_fechaentrega,
															rv_neto,
															rv_ivari,
															rv_ivarni,
															rv_total,
															rv_subtotal,
														  rv_descuento1,
														  rv_descuento2,
														  rv_importedesc1,
														  rv_importedesc2,
															rv_cotizacion,
															rv_retiro,
															rv_guia,
															rv_destinatario,
															rv_ordencompra,
															est_id,
															suc_id,
															cli_id,
															emp_id,
															doc_id,
															doct_id,
															lp_id,
															ld_id,
															cpg_id,
															ccos_id,
                              lgj_id,
															ven_id,
                              pro_id_origen,
                              pro_id_destino,
															trans_id,
															clis_id,
															chof_id,
															cam_id,
															cam_id_semi,
															modifico
														)
			select
															@rv_id,
															@rv_numero,
															@rv_nrodoc,
															rv_descrip,
															rv_fecha,
															rv_fechaentrega,
															rv_neto,
															rv_ivari,
															rv_ivarni,
															rv_total,
															rv_subtotal,
														  rv_descuento1,
														  rv_descuento2,
														  rv_importedesc1,
														  rv_importedesc2,
															rv_cotizacion,
															rv_retiro,
															rv_guia,
															rv_destinatario,
															rv_ordencompra,
															est_id,
															suc_id,
															cli_id,
															@emp_id,
															doc_id,
															@doct_id,
															lp_id,
															ld_id,
															cpg_id,
															ccos_id,
                              lgj_id,
															ven_id,
                              pro_id_origen,
                              pro_id_destino,
															trans_id,
															clis_id,
															chof_id,
															cam_id,
															cam_id_semi,
															modifico
			from RemitoVentaTMP
		  where rvTMP_ID = @@rvTMP_ID	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @rv_nrodoc = rv_nrodoc from RemitoVenta where rv_id = @rv_id
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
															@rv_id                 	= rv_id,
															@rv_nrodoc							= rv_nrodoc,
															@rv_descrip							= rv_descrip,
															@rv_fecha								= rv_fecha,
															@rv_fechaentrega				= rv_fechaentrega,
															@rv_neto								= rv_neto,
															@rv_ivari								= rv_ivari,
															@rv_ivarni							= rv_ivarni,
															@rv_total								= rv_total,
														  @rv_descuento1          = rv_descuento1,
														  @rv_descuento2          = rv_descuento2,
															@rv_subtotal						= rv_subtotal,
														  @rv_importedesc1        = rv_importedesc1,
														  @rv_importedesc2        = rv_importedesc2,
															@rv_cotizacion					= rv_cotizacion,
															@rv_retiro							= rv_retiro,
															@rv_guia                = rv_guia,
															@rv_destinatario				= rv_destinatario,
															@rv_ordencompra					= rv_ordencompra,
															@est_id									= est_id,
															@suc_id									= suc_id,
															@cli_id									= cli_id,
															@doc_id									= doc_id,
															@lp_id									= lp_id,
															@ld_id									= ld_id,
															@cpg_id								  = cpg_id,
															@ccos_id								= ccos_id,
                              @lgj_id                 = lgj_id,
															@ven_id                 = ven_id,
															@pro_id_origen					= pro_id_origen,
															@pro_id_destino					= pro_id_destino,
															@trans_id								= trans_id,
															@clis_id                = clis_id,
															@chof_id								= chof_id,
															@cam_id								  = cam_id,
															@cam_id_semi            = cam_id_semi,
															@modifico							  = modifico,
															@modificado             = modificado
		from RemitoVentaTMP 
    where 
					rvTMP_ID = @@rvTMP_ID
	
		update RemitoVenta set 
															rv_nrodoc							= @rv_nrodoc,
															rv_descrip						= @rv_descrip,
															rv_fecha							= @rv_fecha,
															rv_fechaentrega				= @rv_fechaentrega,
															rv_neto								= @rv_neto,
															rv_ivari							= @rv_ivari,
															rv_ivarni							= @rv_ivarni,
															rv_total							= @rv_total,
														  rv_descuento1         = @rv_descuento1,
														  rv_descuento2         = @rv_descuento2,
															rv_subtotal						= @rv_subtotal,
														  rv_importedesc1       = @rv_importedesc1,
														  rv_importedesc2       = @rv_importedesc2,
															rv_cotizacion					= @rv_cotizacion,
															rv_retiro							= @rv_retiro,
															rv_guia								= @rv_guia,
															rv_destinatario				= @rv_destinatario,
															rv_ordencompra				= @rv_ordencompra,
															est_id								= @est_id,
															suc_id								= @suc_id,
															cli_id								= @cli_id,
															emp_id                = @emp_id,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															lp_id									= @lp_id,
															ld_id									= @ld_id,
															cpg_id								= @cpg_id,
															ccos_id								= @ccos_id,
                              lgj_id                = @lgj_id,
															ven_id                = @ven_id,
															pro_id_origen					= @pro_id_origen,
															pro_id_destino				= @pro_id_destino,
															trans_id							= @trans_id,
															clis_id               = @clis_id,
															chof_id								= @chof_id,
															cam_id								= @cam_id,
															cam_id_semi						= @cam_id_semi,
															modifico							= @modifico,
															modificado            = @modificado

															-- Firma (cuando se modifica se elimina la firma)
															--
															,rv_firmado = 0
	
		where rv_id = @rv_id
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
	while exists(select rvi_orden from RemitoVentaItemTMP where rvTMP_ID = @@rvTMP_ID and rvi_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@rviTMP_id									= rviTMP_id,
						@rvi_id										  = rvi_id,
						@rvi_orden									= rvi_orden,
						@rvi_cantidad							  = rvi_cantidad,
						@rvi_cantidadaremitir			  = rvi_cantidadaremitir,
						@rvi_pendiente							= rvi_pendiente,
						@rvi_pendientefac						= rvi_pendientefac,
						@rvi_descrip								= rvi_descrip,
						@rvi_precio								  = rvi_precio,
						@rvi_precioUsr							= rvi_precioUsr,
						@rvi_precioLista						= rvi_precioLista,
						@rvi_descuento							= rvi_descuento,
						@rvi_neto									  = rvi_neto,
						@rvi_ivari									= rvi_ivari,
						@rvi_ivarni								  = rvi_ivarni,
						@rvi_ivariporc							= rvi_ivariporc,
						@rvi_ivarniporc						  = rvi_ivarniporc,
						@rvi_importe								= rvi_importe,
						@rvi_importCodigo						= rvi_importCodigo,
						@pr_id											= pr_id,
						@ccos_id										= ccos_id,
            @stl_id                     = stl_id

		from RemitoVentaItemTMP where rvTMP_ID = @@rvTMP_ID and rvi_orden = @orden

		-- Cuando se inserta se indica 
		-- como cantidad a remitir la cantidad (Por ahora)
		set @rvi_cantidadaremitir = @rvi_cantidad

		if @IsNew <> 0 or @rvi_id = 0 begin

				-- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
				set @rvi_pendiente 		= @rvi_cantidadaremitir
				set @rvi_pendientefac = @rvi_cantidadaremitir

				exec SP_DBGetNewId 'RemitoVentaItem','rvi_id',@rvi_id out, 0
				if @@error <> 0 goto ControlError

				insert into RemitoVentaItem (
																			rv_id,
																			rvi_id,
																			rvi_orden,
																			rvi_cantidad,
																			rvi_cantidadaremitir,
																			rvi_pendiente,
																			rvi_pendientefac,
																			rvi_descrip,
																			rvi_precio,
																			rvi_precioUsr,
																			rvi_precioLista,
																			rvi_descuento,
																			rvi_neto,
																			rvi_ivari,
																			rvi_ivarni,
																			rvi_ivariporc,
																			rvi_ivarniporc,
																			rvi_importe,
																			rvi_importCodigo,
																			pr_id,
																			ccos_id,
																			stl_id
																)
														Values(
																			@rv_id,
																			@rvi_id,
																			@rvi_orden,
																			@rvi_cantidad,
																			@rvi_cantidadaremitir,
																			@rvi_pendiente,
																			@rvi_pendientefac,
																			@rvi_descrip,
																			@rvi_precio,
																			@rvi_precioUsr,
																			@rvi_precioLista,
																			@rvi_descuento,
																			@rvi_neto,
																			@rvi_ivari,
																			@rvi_ivarni,
																			@rvi_ivariporc,
																			@rvi_ivarniporc,
																			@rvi_importe,
																			@rvi_importCodigo,
																			@pr_id,
																			@ccos_id,
																			@stl_id
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
					select @rvi_pendiente = sum(pvrv_cantidad) from PedidoRemitoVenta where rvi_id = @rvi_id
					select @rvi_pendiente = isnull(@rvi_pendiente,0) 
                                 +sum(osrv_cantidad) from OrdenRemitoVenta where rvi_id = @rvi_id
					set @rvi_pendiente = @rvi_cantidadaremitir - isnull(@rvi_pendiente,0)

					-- Cuando se actualiza se indica 
					-- como pendiente la cantidad a remitir menos lo aplicado
					select @rvi_pendientefac = sum(rvfv_cantidad) from RemitoFacturaVenta where rvi_id = @rvi_id
					set @rvi_pendientefac = @rvi_cantidadaremitir - isnull(@rvi_pendientefac,0)

					update RemitoVentaItem set

									rv_id											= @rv_id,
									rvi_orden									= @rvi_orden,
									rvi_cantidad							= @rvi_cantidad,
									rvi_cantidadaremitir			= @rvi_cantidadaremitir,
									rvi_pendiente							= @rvi_pendiente,
									rvi_pendientefac					= @rvi_pendientefac,
									rvi_descrip								= @rvi_descrip,
									rvi_precio								= @rvi_precio,
									rvi_precioUsr							= @rvi_precioUsr,
									rvi_precioLista						= @rvi_precioLista,
									rvi_descuento							= @rvi_descuento,
									rvi_neto									= @rvi_neto,
									rvi_ivari									= @rvi_ivari,
									rvi_ivarni								= @rvi_ivarni,
									rvi_ivariporc							= @rvi_ivariporc,
									rvi_ivarniporc						= @rvi_ivarniporc,
									rvi_importe								= @rvi_importe,
									rvi_importCodigo					= @rvi_importCodigo,
									pr_id											= @pr_id,
									ccos_id										= @ccos_id,
									stl_id										= @stl_id

				where rv_id = @rv_id and rvi_id = @rvi_id 
  			if @@error <> 0 goto ControlError
		end -- Update

		update RemitoVentaItemSerieTMP set rvi_id = @rvi_id where rviTMP_id = @rviTMP_id 
		if @@error <> 0 goto ControlError

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
		
		delete RemitoVentaItem 
						where exists (select rvi_id 
                          from RemitoVentaItemBorradoTMP 
                          where rv_id 		= @rv_id 
														and rvTMP_id	= @@rvTMP_id
														and rvi_id 		= RemitoVentaItem.rvi_id
													)
		if @@error <> 0 goto ControlError

		delete RemitoVentaItemBorradoTMP where rv_id = @rv_id and rvTMP_id = @@rvTMP_id

  end

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                             APLICACION PEDIDO - REMITO                                                        //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @bSuccess  tinyint

	exec sp_DocRemitoVtaSaveAplic @rv_id, @@rvTMP_id, 0, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TALONARIO                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @bError 	 			smallint
	declare @doc_mueveStock tinyint
  declare @depl_id        int

	select 
					@ta_id 						= ta_id,
          @depl_id          = RemitoVentaTMP.depl_id,
          @doc_mueveStock   = Documento.doc_muevestock

	from RemitoVentaTMP inner join documento on RemitoVentaTMP.doc_id = documento.doc_id
	where rvTMP_id = @@rvTMP_id

	exec sp_TalonarioSet @ta_id,@rv_nrodoc
	if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- PENDIENTE

	-- Actualizo la deuda de la Pedido
	exec sp_DocRemitoVentaSetPendiente @rv_id, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	exec sp_DocRemitoVentaSetCredito @rv_id
	if @@error <> 0 goto ControlError

	exec sp_DocRemitoVentaSetEstado @rv_id
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

		-- Descarga de Temporales por BOM
		--
		if @doc_rv_bom <> 0 begin

			-- Consumo los insumos
			--
			exec sp_DocRemitoVentaBOMStockSave 	
																					@@rvTMP_id, 
																					@rv_id, 
																					0, 
																					@bError out, 
																					@MsgError out
	  	if @bError <> 0 goto ControlError

			-- Alta de lo producido
			--
			exec sp_DocRemitoVentaStockSave 		@@rvTMP_id,
																					@rv_id, 
																					@depl_id, 
																					1, 
																					0, 
																					@bError out, 
																					@MsgError out
	  	if @bError <> 0 goto ControlError

		end

		-- Stock Tradicional
		--
		exec sp_DocRemitoVentaStockSave 	@@rvTMP_id,
																			@rv_id, 
																			@depl_id, 
																			0, 
																			0, 
																			@bError out, 
																			@MsgError out
  	if @bError <> 0 goto ControlError

	end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
	exec sp_AuditoriaEstadoCheckDocRV		@rv_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- STOCK
	exec sp_AuditoriaStockCheckDocRV		@rv_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

-- TOTALES
	exec sp_AuditoriaTotalesCheckDocRV	@rv_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

-- CREDITO
	exec sp_AuditoriaCreditoCheckDocRV	@rv_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError


/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 PARTICULARIDADES DE LOS CLIENTES                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocRemitoVentaSaveCliente @rv_id, @@rvTMP_ID,
																		@bSuccess	out,
																		@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                 BORRAR TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	delete PedidoRemitoVentaTMP where rvTMP_ID = @@rvTMP_ID
  delete RemitoVentaItemSerieTMP where rvTMP_id = @@rvTMP_ID
	delete RemitoVentaItemInsumoTMP where rvTMP_ID = @@rvTMP_ID
	delete RemitoVentaItemTMP where rvTMP_ID = @@rvTMP_ID
	delete RemitoVentaTMP where rvTMP_ID = @@rvTMP_ID

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from RemitoVenta where rv_id = @rv_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 16002, @rv_id, @modifico, 1
	else           exec sp_HistoriaUpdate 16002, @rv_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	set @@rv_id = @rv_id

	if @@bSelect <> 0 select @rv_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar el remito de venta. sp_DocRemitoVentaSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end