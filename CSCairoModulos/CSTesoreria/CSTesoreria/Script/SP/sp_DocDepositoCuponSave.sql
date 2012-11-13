if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponSave]

/*

 sp_DocDepositoCuponSave 124

*/

go
create procedure sp_DocDepositoCuponSave (
	@@dcupTMP_id 			int,
  @@bSelect					tinyint = 1,
  @@dcup_id    			int 		= 0 out,
  @@bSuccess      	tinyint = 0 out
)
as

begin

	set nocount on

	declare @dcup_id					int
	declare @dcupi_id					int
  declare @IsNew          	smallint
  declare @orden          	smallint
	declare	@doct_id    			int
	declare	@dcup_total       decimal(18, 6)
	declare	@dcup_fecha   		datetime 

	set @@bSuccess = 0

	-- Si no existe chau
	if not exists (select dcupTMP_id from DepositoCuponTMP where dcupTMP_id = @@dcupTMP_id)
		return
	
	select @dcup_id = dcup_id from DepositoCuponTMP where dcupTMP_id = @@dcupTMP_id
	
	set @dcup_id = isnull(@dcup_id,0)
	

	-- La moneda y el talonario siempre salen del documento 
  declare @ta_id      		int

-- Talonario
	declare	@doc_id     int
	declare	@dcup_nrodoc  varchar (50) 

	select @ta_id           	= Documento.ta_id,
         @doct_id 					= Documento.doct_id,
         @dcup_total				= DepositoCuponTMP.dcup_total,
				 @dcup_fecha				= DepositoCuponTMP.dcup_fecha,

-- Talonario
				 @dcup_nrodoc = dcup_nrodoc,
				 @doc_id			= DepositoCuponTMP.doc_id

	from DepositoCuponTMP inner join Documento on DepositoCuponTMP.doc_id = Documento.doc_id
	where dcupTMP_id = @@dcupTMP_id

	if IsNull(@ta_id,0) = 0 begin
		select col1 = 'ERROR', col2 = 'El documento no tiene definido su talonario.'
		return
	end

-- Campos de las tablas

declare	@dcup_numero  int 
declare	@dcup_descrip varchar (5000)

declare @dcup_grabarasiento tinyint

declare	@est_id     int
declare	@suc_id     int
declare	@cue_id     int
declare @tjcc_id    int
declare @lgj_id     int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 


declare	@dcupi_orden 						smallint 
declare	@dcupi_descrip 					varchar (5000) 
declare @dcupi_importe 					decimal(18, 6)
declare @dcupi_importeorigen		decimal(18, 6)

declare @MsgError  varchar(5000) set @MsgError = ''

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @dcup_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'DepositoCupon','dcup_id',@dcup_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'DepositoCupon','dcup_numero',@dcup_numero out, 0
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

							set @dcup_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into DepositoCupon (
															dcup_id,
															dcup_numero,
															dcup_nrodoc,
															dcup_descrip,
															dcup_fecha,
															dcup_total,
                              dcup_grabarasiento,
															est_id,
															suc_id,
															doc_id,
															doct_id,
                              lgj_id,
															modifico
														)
			select
															@dcup_id,
															@dcup_numero,
															@dcup_nrodoc,
															dcup_descrip,
															dcup_fecha,
															dcup_total,
														  dcup_grabarasiento,
															est_id,
															suc_id,
															doc_id,
															@doct_id,
                              lgj_id,
															modifico
			from DepositoCuponTMP
		  where dcupTMP_id = @@dcupTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @dcup_nrodoc = dcup_nrodoc from DepositoCupon where dcup_id = @dcup_id
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
															@dcup_id                 	= dcup_id,
															@dcup_nrodoc							= dcup_nrodoc,
															@dcup_descrip							= dcup_descrip,
														  @dcup_grabarasiento       = dcup_grabarasiento,
															@est_id										= est_id,
															@suc_id										= suc_id,
															@doc_id										= doc_id,
                              @lgj_id                 	= lgj_id,
															@modifico							  	=	modifico,
															@modificado             	= modificado
		from DepositoCuponTMP 
    where 
					dcupTMP_id = @@dcupTMP_id
	
		update DepositoCupon set 
															dcup_nrodoc							= @dcup_nrodoc,
															dcup_descrip						= @dcup_descrip,
															dcup_fecha							= @dcup_fecha,
															dcup_total							= @dcup_total,
														  dcup_grabarasiento      = @dcup_grabarasiento,
															est_id									=	@est_id,
															suc_id									= @suc_id,
															doc_id									= @doc_id,
															doct_id									= @doct_id,
                              lgj_id                	= @lgj_id,
															modifico								= @modifico,
															modificado            	= @modificado
	
		where dcup_id = @dcup_id
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
	while exists(select dcupi_orden from DepositoCuponItemTMP where dcupTMP_id = @@dcupTMP_id and dcupi_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@dcupi_id										  = dcupi_id,
						@dcupi_orden									= dcupi_orden,
						@dcupi_descrip								= dcupi_descrip,
						@dcupi_importe								= dcupi_importe,
						@dcupi_importeorigen					= dcupi_importeorigen,
						@tjcc_id											= tjcc_id,
            @cue_id                       = cue_id

		from DepositoCuponItemTMP where dcupTMP_id = @@dcupTMP_id and dcupi_orden = @orden

		if not exists (select * from DepositoCuponItem where tjcc_id = @tjcc_id and dcup_id <> @dcup_id) begin

			if @IsNew <> 0 or @dcupi_id = 0 begin
	
					exec SP_DBGetNewId 'DepositoCuponItem','dcupi_id',@dcupi_id out, 0
					if @@error <> 0 goto ControlError

					insert into DepositoCuponItem (
																				dcup_id,
																				dcupi_id,
																				dcupi_orden,
																				dcupi_descrip,
																				dcupi_importe,
																				dcupi_importeorigen,
																				tjcc_id,
	                                      cue_id
																	)
															Values(
																				@dcup_id,
																				@dcupi_id,
																				@dcupi_orden,
																				@dcupi_descrip,
																				@dcupi_importe,
																				@dcupi_importeorigen,
																				@tjcc_id,
	                                      @cue_id
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
	
						update DepositoCuponItem set
	
										dcup_id											= @dcup_id,
										dcupi_orden									= @dcupi_orden,
										dcupi_descrip								= @dcupi_descrip,
										dcupi_importe								= @dcupi_importe,
										dcupi_importeorigen					= @dcupi_importeorigen,
										tjcc_id											= @tjcc_id,
	                  cue_id                      = @cue_id
	
					where dcup_id = @dcup_id and dcupi_id = @dcupi_id 
	  			if @@error <> 0 goto ControlError
			end -- Update

			update TarjetaCreditoCupon set cue_id = @cue_id	where tjcc_id = @tjcc_id
			if @@error <> 0 goto ControlError

		end

	  set @orden = @orden + 1
  end -- While

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     ITEMS BORRADOS                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  -- Hay que borrar los items borrados de la presentacion de cupones
	if @IsNew = 0 begin
		
		delete DepositoCuponItem 
						where exists (select *
                          from DepositoCuponItemBorradoTMP db inner join DepositoCuponItemTMP d on db.dcupi_id = d.dcupi_id
                          where db.dcup_id  	= @dcup_id 
                            and db.dcupi_id 	= DepositoCuponItem.dcupi_id
														and db.dcupTMP_id	= @@dcupTMP_id
                            and not exists (select * from ResolucionCuponItem where tjcc_id = d.tjcc_id)
                          )
		if @@error <> 0 goto ControlError

    -- Actualizo todos los cupones
		update TarjetaCreditoCupon set cue_id = cbi.cue_id from CobranzaItem cbi
		where 
          TarjetaCreditoCupon.tjcc_id = cbi.tjcc_id
          and exists (select * 
                      from DepositoCuponItemBorradoTMP db inner join DepositoCuponItemTMP d on db.dcupi_id = d.dcupi_id
                      where db.dcup_id 		= @dcup_id 
												and db.dcupTMP_id	= @@dcupTMP_id
                        and tjcc_id = TarjetaCreditoCupon.tjcc_id
                        and not exists (select * from ResolucionCuponItem where tjcc_id = d.tjcc_id)
                      )
		if @@error <> 0 goto ControlError

		delete DepositoCuponItemBorradoTMP where dcup_id = @dcup_id and dcupTMP_id = @@dcupTMP_id

  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     BORRAR TEMPORALES                                                              //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	delete DepositoCuponItemTMP where dcupTMP_id = @@dcupTMP_id
	delete DepositoCuponTMP where dcupTMP_id = @@dcupTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     TALONARIOS                                                                     //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_TalonarioSet @ta_id,@dcup_nrodoc
	if @@error <> 0 goto ControlError

	exec sp_DocDepositoCuponSetEstado @dcup_id
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

	exec sp_Cfg_GetValor  'Tesoreria-General',
											  'DepositoCupon-Grabar Asiento',
											  @cfg_valor out,
											  0
	if @@error <> 0 goto ControlError

  set @cfg_valor = IsNull(@cfg_valor,0)
	if convert(int,@cfg_valor) <> 0 begin

		select dcup_id=@dcup_id

		exec sp_DocDepositoCuponAsientoSave @dcup_id,0,@bError out, @MsgError out
	  if @bError <> 0 goto ControlError

	end else begin

		if not exists (select dcup_id from DepositoCuponAsiento where dcup_id = @dcup_id) begin
			insert into DepositoCuponAsiento (dcup_id,dcup_fecha) 
				     select dcup_id,dcup_fecha from DepositoCupon 
		 				 where dcup_grabarAsiento <> 0 and dcup_id = @dcup_id
    end
  end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from DepositoCupon where dcup_id = @dcup_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 18008, @dcup_id, @modifico, 1
	else           exec sp_HistoriaUpdate 18008, @dcup_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	set @@dcup_id = @dcup_id
	set @@bSuccess = 1

	if @@bSelect <> 0 select @dcup_id

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al grabar la presentacion de cupones. sp_DocDepositoCuponSave. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

	if @@trancount > 0 begin
		rollback transaction	
  end

end