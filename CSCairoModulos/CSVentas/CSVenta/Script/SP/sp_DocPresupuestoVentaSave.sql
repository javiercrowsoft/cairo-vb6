if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaSave]

/*

 sp_DocPresupuestoVentaSave 93

*/

go
create procedure sp_DocPresupuestoVentaSave (
	@@prvTMP_id int
)
as

begin

	set nocount on

	declare @prv_id					int
	declare @prvi_id				int
  declare @IsNew          smallint
  declare @orden          smallint
	declare @emp_id         int

	-- Si no existe chau
	if not exists (select prvTMP_id from PresupuestoVentaTMP where prvTMP_id = @@prvTMP_id)
		return

	declare	@doct_id    int
	declare	@doc_id     int
	declare	@prv_nrodoc  varchar (50) 
	
	select 	@prv_id 			= prv_id, 
					@doct_id 			= doct_id, 
					@doc_id 			= Documento.doc_id, 
					@prv_nrodoc 	= prv_nrodoc,
					@emp_id				= emp_id
	from 
				PresupuestoVentaTMP inner join Documento on PresupuestoVentaTMP.doc_id = Documento.doc_id
	where 
				prvTMP_id = @@prvTMP_id
	
	set @prv_id = isnull(@prv_id,0)
	

-- Campos de las tablas

declare	@prv_numero  int 
declare	@prv_descrip varchar (5000)
declare	@prv_fecha   datetime 
declare	@prv_fechaentrega datetime 
declare	@prv_neto      decimal(18, 6) 
declare	@prv_ivari     decimal(18, 6)
declare	@prv_ivarni    decimal(18, 6)
declare	@prv_total     decimal(18, 6)
declare	@prv_subtotal  decimal(18, 6)
declare	@prv_descuento1    decimal(18, 6)
declare	@prv_descuento2    decimal(18, 6)
declare	@prv_importedesc1  decimal(18, 6)
declare	@prv_importedesc2  decimal(18, 6)

declare	@est_id     int
declare	@suc_id     int
declare	@cli_id     int
declare @ta_id      int
declare	@lp_id      int 
declare	@ld_id      int 
declare	@cpg_id     int
declare	@ccos_id    int
declare @lgj_id     int
declare @ven_id     int
declare @pro_id_origen     int
declare @pro_id_destino    int
declare @trans_id   int
declare @clis_id    int
declare @prov_id    int
declare @cont_id    int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico     int 

declare	@prvi_orden 						smallint 
declare	@prvi_cantidad 					decimal(18, 6) 
declare	@prvi_cantidadaremitir 	decimal(18, 6) 
declare	@prvi_pendiente 				decimal(18, 6) 
declare	@prvi_descrip 					varchar (5000) 
declare	@prvi_precio 						decimal(18, 6) 
declare	@prvi_precioUsr 				decimal(18, 6)
declare	@prvi_precioLista 			decimal(18, 6)
declare	@prvi_descuento 				varchar (100) 
declare	@prvi_neto 							decimal(18, 6) 
declare	@prvi_ivari 						decimal(18, 6)
declare	@prvi_ivarni 						decimal(18, 6)
declare	@prvi_ivariporc 				decimal(18, 6)
declare	@prvi_ivarniporc 				decimal(18, 6)
declare @prvi_importe 					decimal(18, 6)
declare	@pr_id 									int

declare @bSuccess tinyint

declare @MsgError  varchar(5000) set @MsgError = ''

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @prv_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'PresupuestoVenta','prv_id',@prv_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'PresupuestoVenta','prv_numero',@prv_numero out, 0
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

							set @prv_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into Presupuestoventa (
															prv_id,
															prv_numero,
															prv_nrodoc,
															prv_descrip,
															prv_fecha,
															prv_fechaentrega,
															prv_neto,
															prv_ivari,
															prv_ivarni,
															prv_total,
															prv_subtotal,
														  prv_descuento1,
														  prv_descuento2,
														  prv_importedesc1,
														  prv_importedesc2,
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
															prov_id,
															cont_id,
															modifico
														)
			select
															@prv_id,
															@prv_numero,
															@prv_nrodoc,
															prv_descrip,
															prv_fecha,
															prv_fechaentrega,
															prv_neto,
															prv_ivari,
															prv_ivarni,
															prv_total,
															prv_subtotal,
														  prv_descuento1,
														  prv_descuento2,
														  prv_importedesc1,
														  prv_importedesc2,
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
															prov_id,
															cont_id,
															modifico
			from PresupuestoVentaTMP
		  where prvTMP_id = @@prvTMP_id	

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
															@prv_id                 = prv_id,
															@prv_nrodoc							= prv_nrodoc,
															@prv_descrip						= prv_descrip,
															@prv_fecha							= prv_fecha,
															@prv_fechaentrega				= prv_fechaentrega,
															@prv_neto								= prv_neto,
															@prv_ivari							= prv_ivari,
															@prv_ivarni							= prv_ivarni,
															@prv_total							= prv_total,
														  @prv_descuento1         = prv_descuento1,
														  @prv_descuento2         = prv_descuento2,
															@prv_subtotal						= prv_subtotal,
														  @prv_importedesc1       = prv_importedesc1,
														  @prv_importedesc2       = prv_importedesc2,
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
															@prov_id								= prov_id,
															@cont_id								= cont_id,
															@modifico							  = modifico,
															@modificado             = modificado
		from PresupuestoVentaTMP 
    where 
					prvTMP_id = @@prvTMP_id
	
		update PresupuestoVenta set 
															prv_nrodoc						= @prv_nrodoc,
															prv_descrip						= @prv_descrip,
															prv_fecha							= @prv_fecha,
															prv_fechaentrega			= @prv_fechaentrega,
															prv_neto							= @prv_neto,
															prv_ivari							= @prv_ivari,
															prv_ivarni						= @prv_ivarni,
															prv_total							= @prv_total,
														  prv_descuento1        = @prv_descuento1,
														  prv_descuento2        = @prv_descuento2,
															prv_subtotal					= @prv_subtotal,
														  prv_importedesc1      = @prv_importedesc1,
														  prv_importedesc2      = @prv_importedesc2,
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
															prov_id								= @prov_id,
															cont_id								= @cont_id,
															modifico							= @modifico,
															modificado            = @modificado
	
		where prv_id = @prv_id
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
	while exists(select prvi_orden from PresupuestoVentaItemTMP where prvTMP_id = @@prvTMP_id and prvi_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@prvi_id										  = prvi_id,
						@prvi_orden										= prvi_orden,
						@prvi_cantidad							  = prvi_cantidad,
						@prvi_cantidadaremitir			  = prvi_cantidadaremitir,
						@prvi_descrip									= prvi_descrip,
						@prvi_precio								  = prvi_precio,
						@prvi_precioUsr								= prvi_precioUsr,
						@prvi_precioLista							= prvi_precioLista,
						@prvi_descuento								= prvi_descuento,
						@prvi_neto									  = prvi_neto,
						@prvi_ivari										= prvi_ivari,
						@prvi_ivarni								  = prvi_ivarni,
						@prvi_ivariporc								= prvi_ivariporc,
						@prvi_ivarniporc						  = prvi_ivarniporc,
						@prvi_importe									= prvi_importe,
						@pr_id												= pr_id,
						@ccos_id											= ccos_id

		from PresupuestoVentaItemTMP where prvTMP_id = @@prvTMP_id and prvi_orden = @orden

		-- Cuando se inserta se indica 
		-- como cantidad a remitir la cantidad (Por ahora)
		set @prvi_cantidadaremitir = @prvi_cantidad

		if @IsNew <> 0 or @prvi_id = 0 begin

				-- Cuando se inserta se toma la cantidad a remitir
        -- como el pendiente
				set @prvi_pendiente 				= @prvi_cantidadaremitir 		

				exec SP_DBGetNewId 'PresupuestoVentaItem','prvi_id',@prvi_id out, 0 
				if @@error <> 0 goto ControlError
		
				insert into PresupuestoventaItem (
																			prv_id,
																			prvi_id,
																			prvi_orden,
																			prvi_cantidad,
																			prvi_cantidadaremitir,
																			prvi_pendiente,
																			prvi_descrip,
																			prvi_precio,
																			prvi_precioUsr,
																			prvi_precioLista,
																			prvi_descuento,
																			prvi_neto,
																			prvi_ivari,
																			prvi_ivarni,
																			prvi_ivariporc,
																			prvi_ivarniporc,
																			prvi_importe,
																			pr_id,
																			ccos_id
																)
														Values(
																			@prv_id,
																			@prvi_id,
																			@prvi_orden,
																			@prvi_cantidad,
																			@prvi_cantidadaremitir, 
																			@prvi_pendiente, 
																			@prvi_descrip,
																			@prvi_precio,
																			@prvi_precioUsr,
																			@prvi_precioLista,
																			@prvi_descuento,
																			@prvi_neto,
																			@prvi_ivari,
																			@prvi_ivarni,
																			@prvi_ivariporc,
																			@prvi_ivarniporc,
																			@prvi_importe,
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

					-- Cuando se actualiza se encarga el sp sp_DocPresupuestoVentaSetPendiente de actulizar
					-- prvi_pendiente y prv_pendiente

					update PresupuestoVentaItem set

									prv_id											= @prv_id,
									prvi_orden									= @prvi_orden,
									prvi_cantidad								= @prvi_cantidad,
									prvi_cantidadaremitir				= @prvi_cantidadaremitir,
									prvi_descrip								= @prvi_descrip,
									prvi_precio									= @prvi_precio,
									prvi_precioUsr							= @prvi_precioUsr,
									prvi_precioLista						= @prvi_precioLista,
									prvi_descuento							= @prvi_descuento,
									prvi_neto										= @prvi_neto,
									prvi_ivari									= @prvi_ivari,
									prvi_ivarni									= @prvi_ivarni,
									prvi_ivariporc							= @prvi_ivariporc,
									prvi_ivarniporc							= @prvi_ivarniporc,
									prvi_importe								= @prvi_importe,
									pr_id												= @pr_id,
									ccos_id											= @ccos_id

				where prv_id = @prv_id and prvi_id = @prvi_id 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While

  -- Hay que borrar los items borrados del Presupuesto
	if @IsNew = 0 begin
		
		delete PresupuestoVentaItem 
						where exists (select prvi_id 
                          from PresupuestoVentaItemBorradoTMP 
                          where prv_id 		= @prv_id 
														and prvTMP_id	= @@prvTMP_id
														and prvi_id 	= PresupuestoVentaItem.prvi_id
													)
		if @@error <> 0 goto ControlError

		delete PresupuestoVentaItemBorradoTMP where prv_id = @prv_id and prvTMP_id = @@prvTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select @ta_id = ta_id from documento where doc_id = @doc_id

	exec sp_TalonarioSet @ta_id,@prv_nrodoc
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ESTADO                                                               					//
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	-- Actualizo la deuda de la Presupuesto
	exec sp_DocPresupuestoVentaSetPendiente @prv_id, @bSuccess out

	-- Si fallo al guardar
	if IsNull(@bSuccess,0) = 0 goto ControlError

	exec sp_DocPresupuestoVentaSetEstado @prv_id
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

-- ESTADO
	exec sp_AuditoriaEstadoCheckDocPRV	@prv_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

-- FECHAS

-- TOTALES
	exec sp_AuditoriaTotalesCheckDocPRV	@prv_id,
																			@bSuccess	out,
																			@MsgError out

	-- Si el documento no es valido
	if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete PresupuestoVentaItemTMP where prvTMP_ID = @@prvTMP_id
	delete PresupuestoVentaTMP where prvTMP_ID = @@prvTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from PresupuestoVenta where prv_id = @prv_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 16004, @prv_id, @modifico, 1
	else           exec sp_HistoriaUpdate 16004, @prv_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	commit transaction

	select @prv_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar el presupuesto de venta. sp_DocPresupuestoVentaSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end