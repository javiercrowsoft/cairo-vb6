if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionSave]

/*

 sp_DocLiquidacionSave 124

*/

go
create procedure sp_DocLiquidacionSave (
	@@liqTMP_id 		int,
  @@bSelect				tinyint = 1,
  @@liq_id    		int 		= 0 out,
  @@bSuccess      tinyint = 0 out
)
as

begin

	set nocount on

	declare @liq_id					int
	declare @liqi_id				int
  declare @IsNew          smallint
  declare @orden          smallint
	declare	@doct_id    		int
	declare	@liq_total      decimal(18, 6)
	declare	@liq_fecha   		datetime 

	set @@bSuccess = 0

	-- Si no existe chau
	if not exists (select liqTMP_id from LiquidacionTMP where liqTMP_id = @@liqTMP_id)
		return
	
	select @liq_id = liq_id from LiquidacionTMP where liqTMP_id = @@liqTMP_id
	
	set @liq_id = isnull(@liq_id,0)
	

	-- La moneda y el talonario siempre salen del documento 
	declare @mon_id     		int
  declare @ta_id      		int
	declare @emp_id					int

-- Talonario
	declare	@doc_id     int
	declare	@liq_nrodoc  varchar (50) 

	select @mon_id 					= mon_id,
         @ta_id           = Documento.ta_id,
         @doct_id 				= Documento.doct_id,
				 @emp_id					= Documento.emp_id,
         @liq_total				= LiquidacionTMP.liq_total,
				 @liq_fecha				= LiquidacionTMP.liq_fecha,

-- Talonario
				 @liq_nrodoc  = liq_nrodoc,
				 @doc_id		  = LiquidacionTMP.doc_id


	from LiquidacionTMP inner join Documento on LiquidacionTMP.doc_id = Documento.doc_id
	where liqTMP_id = @@liqTMP_id

	if IsNull(@ta_id,0) = 0 begin
		select col1 = 'ERROR', col2 = 'El documento no tiene definido su talonario.'
		return
	end

-- Campos de las tablas

declare	@liq_numero  int 
declare	@liq_descrip varchar (5000)
declare	@liq_totalorigen   decimal(18, 6)
declare @liq_cotizacion    decimal(18, 6)
declare @liq_fechadesde    datetime
declare @liq_fechahasta    datetime
declare @liq_periodo    	 varchar(100)

declare @liq_grabarasiento tinyint

declare	@est_id     int
declare	@suc_id     int
declare	@ccos_id    int
declare @lgj_id     int
declare @liqp_id    int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare	@liqi_orden 							smallint 
declare	@liqi_descrip 						varchar (5000) 
declare	@liqi_nrodoc  						varchar (50)
declare @liqi_importe 						decimal(18, 6)
declare @liqi_importeorigen				decimal(18, 6)

declare @em_id      int

declare @bSuccess               int

declare @MsgError  varchar(5000) set @MsgError = ''

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @liq_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'Liquidacion','liq_id',@liq_id out,0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'Liquidacion','liq_numero',@liq_numero out,0
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

							set @liq_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into Liquidacion (
															liq_id,
															liq_numero,
															liq_nrodoc,
															liq_descrip,
															liq_fecha,
															liq_fechadesde,
															liq_fechahasta,
															liq_periodo,
															liq_total,
															liq_totalorigen,
                              liq_grabarasiento,
                              liq_cotizacion,
															mon_id,
															est_id,
															suc_id,
															doc_id,
															doct_id,
															ccos_id,
                              lgj_id,
															liqp_id,
															modifico
														)
			select
															@liq_id,
															@liq_numero,
															@liq_nrodoc,
															liq_descrip,
															liq_fecha,
															liq_fechadesde,
															liq_fechahasta,
															liq_periodo,
															liq_total,
															liq_totalorigen,
														  liq_grabarasiento,
                              liq_cotizacion,
                              @mon_id,
															est_id,
															suc_id,
															doc_id,
															@doct_id,
															ccos_id,
                              lgj_id,
															liqp_id,
															modifico
			from LiquidacionTMP
		  where liqTMP_id = @@liqTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @liq_nrodoc = liq_nrodoc from Liquidacion where liq_id = @liq_id
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
															@liq_nrodoc							= liq_nrodoc,
															@liq_descrip						= liq_descrip,
															@liq_totalorigen				= liq_totalorigen,
                              @liq_cotizacion         = liq_cotizacion,
														  @liq_grabarasiento      = liq_grabarasiento,

															@liq_fechadesde					= liq_fechadesde,
															@liq_fechahasta					= liq_fechahasta,
															@liq_periodo						= liq_periodo,

															@est_id									= est_id,
															@suc_id									= suc_id,
															@doc_id									= doc_id,
															@ccos_id								= ccos_id,
                              @lgj_id                 = lgj_id,
															@liqp_id								= liqp_id,
															@modifico							  = modifico,
															@modificado             = modificado
		from LiquidacionTMP 
    where 
					liqTMP_id = @@liqTMP_id
	
		update Liquidacion set 
															liq_nrodoc						= @liq_nrodoc,
															liq_descrip						= @liq_descrip,
															liq_fecha							= @liq_fecha,
															liq_fechadesde				= @liq_fechadesde,
															liq_fechahasta				= @liq_fechahasta,
															liq_periodo						= @liq_periodo,
															liq_total							= @liq_total,
															liq_totalorigen				= @liq_totalorigen,
                              liq_cotizacion        = @liq_cotizacion,
														  liq_grabarasiento     = @liq_grabarasiento,
                              mon_id                = @mon_id,
															est_id								= @est_id,
															suc_id								= @suc_id,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
                              lgj_id                = @lgj_id,
															liqp_id								= @liqp_id,
															ccos_id								= @ccos_id,
															modifico							= @modifico,
															modificado            = @modificado
	
		where liq_id = @liq_id
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
	while exists(select liqi_orden from LiquidacionItemTMP where liqTMP_id = @@liqTMP_id and liqi_orden = @orden) 
	begin

		-- Cargo todo el registro de liquidacion item en variables
		--
		select
						@liqi_id										= liqi_id,
						@liqi_orden									= liqi_orden,
						@liqi_descrip								= liqi_descrip,
						@liqi_nrodoc								= liqi_nrodoc,
						@liqi_importe								= liqi_importe,
						@liqi_importeorigen					= liqi_importeorigen,
						@em_id											= em_id

		from LiquidacionItemTMP where liqTMP_id = @@liqTMP_id and liqi_orden = @orden

		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/
		if @IsNew <> 0 or @liqi_id = 0 begin

				exec SP_DBGetNewId 'LiquidacionItem','liqi_id',@liqi_id out,0
				if @@error <> 0 goto ControlError

				insert into LiquidacionItem (
																			liq_id,
																			liqi_id,
																			liqi_orden,
																			liqi_descrip,
																			liqi_nrodoc,
																			liqi_importe,
																			liqi_importeorigen,
																			em_id
																)
														Values(
																			@liq_id,
																			@liqi_id,
																			@liqi_orden,
																			@liqi_descrip,
																			@liqi_nrodoc,
																			@liqi_importe,
																			@liqi_importeorigen,
																			@em_id
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

					update LiquidacionItem set

									liq_id										= @liq_id,
									liqi_orden								= @liqi_orden,
									liqi_descrip							= @liqi_descrip,
									liqi_nrodoc								= @liqi_nrodoc,
									-- Ojo el importe no se actuliza por medio de este SP
									--
									-- liqi_importe						= @liqi_importe,
									--
									liqi_importeorigen				= @liqi_importeorigen,
									em_id											= @em_id

				where liq_id = @liq_id and liqi_id = @liqi_id 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ITEMS BORRADOS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar los items borrados del pedido
	if @IsNew = 0 begin

		delete LiquidacionItem 
						where exists (select liqi_id 
                          from LiquidacionItemBorradoTMP 
                          where liq_id 		= @liq_id 
														and liqTMP_id	= @@liqTMP_id
														and liqi_id 	= LiquidacionItem.liqi_id
													)
		if @@error <> 0 goto ControlError

		delete LiquidacionItemBorradoTMP where liq_id = @liq_id and liqTMP_id = @@liqTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        EXCEPCIONES                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @liqe_id 				int
	declare @liqfi_id 			int
	declare @liqe_orden			smallint
	declare	@liqe_descrip 	varchar (5000)

	set @orden = 1
	while exists(select liqe_orden from LiquidacionExcepcionTMP where liqTMP_id = @@liqTMP_id and liqe_orden = @orden) 
	begin

		-- Cargo todo el registro de liquidacion item en variables
		--
		select
						@liqe_id										= liqe_id,
						@liqe_orden									= liqe_orden,
						@liqe_descrip								= liqe_descrip,
						@em_id											= em_id,
						@liqfi_id										= liqfi_id,
						@ccos_id										= ccos_id

		from LiquidacionExcepcionTMP where liqTMP_id = @@liqTMP_id and liqe_orden = @orden

		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/
		if @IsNew <> 0 or @liqe_id = 0 begin

				exec SP_DBGetNewId 'LiquidacionExcepcion','liqe_id',@liqe_id out,0
				if @@error <> 0 goto ControlError

				insert into LiquidacionExcepcion (
																			liq_id,
																			liqe_id,
																			liqe_orden,
																			liqe_descrip,
																			em_id,
																			liqfi_id,
																			ccos_id
																)
														Values(
																			@liq_id,
																			@liqe_id,
																			@liqe_orden,
																			@liqe_descrip,
																			@em_id,
																			@liqfi_id,
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

					update LiquidacionExcepcion set

									liq_id										= @liq_id,
									liqe_orden								= @liqe_orden,
									liqe_descrip							= @liqe_descrip,
									em_id											= @em_id,
									liqfi_id									= @liqfi_id,
									ccos_id										= @ccos_id


				where liq_id = @liq_id and liqe_id = @liqe_id 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     EXCEPCIONES BORRADAS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar las excepciones borradas del pedido
	if @IsNew = 0 begin

		delete LiquidacionExcepcion 
						where exists (select liqe_id 
                          from LiquidacionExcepcionBorradoTMP 
                          where liq_id 		= @liq_id 
														and liqTMP_id	= @@liqTMP_id
														and liqe_id 	= LiquidacionExcepcion.liqe_id
													)
		if @@error <> 0 goto ControlError

		delete LiquidacionExcepcionBorradoTMP where liq_id = @liq_id and liqTMP_id = @@liqTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        CONCEPTOS ADMINISTRATIVOS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @liqca_id 			int
	declare @liqca_orden		Smallint
	declare	@liqca_importe 	decimal (18,6)
	declare	@liqca_descrip 	varchar (5000)

	set @orden = 1
	while exists(select liqca_orden from LiquidacionConceptoAdmTMP where liqTMP_id = @@liqTMP_id and liqca_orden = @orden) 
	begin

		-- Cargo todo el registro de liquidacion conceptoadm en variables
		--
		select
						@liqca_id										= liqca_id,
						@liqca_orden								= liqca_orden,
						@liqca_importe							= liqca_importe,
						@liqca_descrip							= liqca_descrip,
						@em_id											= em_id,
						@liqfi_id										= liqfi_id,
						@ccos_id										= ccos_id

		from LiquidacionConceptoAdmTMP where liqTMP_id = @@liqTMP_id and liqca_orden = @orden

		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/
		if @IsNew <> 0 or @liqca_id = 0 begin

				exec SP_DBGetNewId 'LiquidacionConceptoAdm','liqca_id',@liqca_id out,0
				if @@error <> 0 goto ControlError

				insert into LiquidacionConceptoAdm (
																			liq_id,
																			liqca_id,
																			liqca_orden,
																			liqca_importe,
																			liqca_descrip,
																			em_id,
																			liqfi_id,
																			ccos_id
																)
														Values(
																			@liq_id,
																			@liqca_id,
																			@liqca_orden,
																			@liqca_importe,
																			@liqca_descrip,
																			@em_id,
																			@liqfi_id,
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

					update LiquidacionConceptoAdm set

									liq_id										= @liq_id,
									liqca_orden								= @liqca_orden,
									liqca_importe							= @liqca_importe,
									liqca_descrip							= @liqca_descrip,
									em_id											= @em_id,
									liqfi_id									= @liqfi_id,
									ccos_id										= @ccos_id


				where liq_id = @liq_id and liqca_id = @liqca_id 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ConceptoAdmES BORRADAS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar las ConceptoAdmes borradas del pedido
	if @IsNew = 0 begin

		delete LiquidacionConceptoAdm 
						where exists (select liqca_id 
                          from LiquidacionConceptoAdmBorradoTMP 
                          where liq_id 		= @liq_id 
														and liqTMP_id	= @@liqTMP_id
														and liqca_id 	= LiquidacionConceptoAdm.liqca_id
													)
		if @@error <> 0 goto ControlError

		delete LiquidacionConceptoAdmBorradoTMP where liq_id = @liq_id and liqTMP_id = @@liqTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete LiquidacionItemTMP where liqTMP_id = @@liqTMP_id
	delete LiquidacionExcepcionTMP where liqTMP_id = @@liqTMP_id
	delete LiquidacionConceptoAdmTMP where liqTMP_id = @@liqTMP_id
	delete LiquidacionTMP where liqTMP_id = @@liqTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_TalonarioSet @ta_id,@liq_nrodoc
	if @@error <> 0 goto ControlError

	exec sp_DocLiquidacionSetEstado @liq_id
	if @@error <> 0 goto ControlError

	declare @cfg_valor varchar(5000) 
	declare @bError 	 smallint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ASIENTO                                                                        //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_Cfg_GetValor  'Personal-General',
											  'Liquidacion-Grabar Asiento',
											  @cfg_valor out,
											  0
	if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
	if convert(int,@cfg_valor) <> 0 begin

		exec sp_DocLiquidacionAsientoSave @liq_id,0,@bError out, @MsgError out
	  if @bError <> 0 goto ControlError

	end else begin

		if not exists (select liq_id from LiquidacionAsiento where liq_id = @liq_id) begin
			insert into LiquidacionAsiento (liq_id,liq_fecha) 
				     select liq_id,liq_fecha from Liquidacion 
		 				 where liq_grabarAsiento <> 0 and liq_id = @liq_id
    end
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from Liquidacion where liq_id = @liq_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 35012, @liq_id, @modifico, 1
	else           exec sp_HistoriaUpdate 35012, @liq_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	set @@liq_id = @liq_id
	set @@bSuccess = 1

	if @@bSelect <> 0 select @liq_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la liquidación de haberes. sp_DocLiquidacionSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

	return

end