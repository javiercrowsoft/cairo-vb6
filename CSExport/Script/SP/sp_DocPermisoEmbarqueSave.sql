if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPermisoEmbarqueSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPermisoEmbarqueSave]

/*

 sp_DocPermisoEmbarqueSave 2

*/

go
create procedure sp_DocPermisoEmbarqueSave (
	@@pembTMP_id int
)
as

begin

	set nocount on

	declare @pemb_id				int
	declare @pembi_id				int
  declare @IsNew          smallint
  declare @orden          smallint
	declare @mon_id     		int

	-- Si no existe chau
	if not exists (select pemb_id from PermisoEmbarqueTMP where pembTMP_id = @@pembTMP_id)
		return

-- Talonario
	declare	@pemb_nrodoc  	varchar (50) 
	declare	@doc_id     		int
	
	select @pemb_id 		= pemb_id, 

-- Talonario
				 @pemb_nrodoc = pemb_nrodoc,
				 @doc_id 			= doc_id

	from PermisoEmbarqueTMP where pembTMP_id = @@pembTMP_id
	
	set @pemb_id = isnull(@pemb_id,0)

	select @mon_id = mon_id from Documento where doc_id = @doc_id
	

-- Campos de las tablas

declare	@pemb_numero  		int 
declare	@pemb_descrip 		varchar (5000)
declare	@pemb_fecha   		datetime 
declare	@pemb_total     	decimal(18, 6)
declare @pemb_totalorigen decimal(18, 6)
declare	@pemb_pendiente 	decimal(18, 6)
declare	@pemb_cotizacion 	decimal(18, 6)

declare	@est_id     int
declare	@suc_id     int
declare	@doct_id    int
declare	@emb_id			int
declare	@bco_id			int
declare	@adu_id			int
declare	@lp_id      int 
declare	@ld_id      int 
declare @lgj_id     int
declare	@cpg_id     int
declare	@ccos_id    int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 


declare	@pembi_orden 							smallint 
declare	@pembi_cantidad 					decimal(18, 6) 
declare	@pembi_pendiente 					decimal(18, 6) 
declare	@pembi_descrip 						varchar(5000) 
declare	@pembi_fob 								decimal(18, 6) 
declare	@pembi_foborigen 					decimal(18, 6)
declare	@pembi_fobtotal 					decimal(18, 6)
declare @pembi_fobtotalorigen 		decimal(18, 6)
declare	@pr_id 										int

declare @ta_id      int

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @pemb_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'PermisoEmbarque','pemb_id',@pemb_id out
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'PermisoEmbarque','pemb_numero',@pemb_numero out
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

							set @pemb_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into PermisoEmbarque (
															pemb_id,
															pemb_numero,
															pemb_nrodoc,
															pemb_descrip,
															pemb_fecha,
															pemb_total,
															pemb_totalorigen,
															pemb_cotizacion,
															mon_id,
															est_id,
															suc_id,
															doc_id,
															doct_id,
															emb_id,
															bco_id,
                              adu_id,
															lp_id,
															lgj_id,
															ccos_id,
															modifico
														)
			select
															@pemb_id,
															@pemb_numero,
															@pemb_nrodoc,
															pemb_descrip,
															pemb_fecha,
															pemb_total,
															pemb_totalorigen,
															pemb_cotizacion,
															@mon_id,
															est_id,
															suc_id,
															doc_id,
															doct_id,
															emb_id,
															bco_id,
                              adu_id,
															lp_id,
															lgj_id,
															ccos_id,
															modifico
			from PermisoEmbarqueTMP
		  where pembTMP_id = @@pembTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @pemb_nrodoc = pemb_nrodoc from PermisoEmbarque where pemb_id = @pemb_id
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
															@pemb_id                = pemb_id,
															@pemb_nrodoc						= pemb_nrodoc,
															@pemb_descrip						= pemb_descrip,
															@pemb_fecha							= pemb_fecha,
															@pemb_total							= pemb_total,
															@pemb_totalorigen				= pemb_totalorigen,
															@pemb_cotizacion  			= pemb_cotizacion,
															@est_id									= est_id,
															@suc_id									= suc_id,
															@doc_id									= doc_id,
															@doct_id								= doct_id,
															@emb_id								  = emb_id,
															@bco_id								  = bco_id,
															@adu_id								  = adu_id,
															@lp_id									= lp_id,
															@lgj_id									= lgj_id,
															@ccos_id								= ccos_id,
															@modifico							  = modifico,
															@modificado             = modificado
		from PermisoEmbarqueTMP 
    where 
					pembTMP_id = @@pembTMP_id
	
		update PermisoEmbarque set 
															pemb_nrodoc						= @pemb_nrodoc,
															pemb_descrip					= @pemb_descrip,
															pemb_fecha						= @pemb_fecha,
															pemb_total						= @pemb_total,
															pemb_totalorigen			= @pemb_totalorigen,
															pemb_cotizacion  			= @pemb_cotizacion,
															mon_id								=	@mon_id,
															est_id								= @est_id,
															suc_id								= @suc_id,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															emb_id								= @emb_id,
															bco_id								= @bco_id,
															adu_id								= @adu_id,
															lp_id									= @lp_id,
															lgj_id								= @lgj_id,
															ccos_id								= @ccos_id,
															modifico							= @modifico,
															modificado            = @modificado
	
		where pemb_id = @pemb_id
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
	while exists(select pembi_orden from PermisoEmbarqueItemTMP where pembTMP_id = @@pembTMP_id and pembi_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@pembi_id										  = pembi_id,
						@pembi_orden									= pembi_orden,
						@pembi_cantidad							  = pembi_cantidad,
						@pembi_pendiente							= pembi_pendiente,
						@pembi_descrip								= pembi_descrip,
						@pembi_fob								  	= pembi_fob,
						@pembi_foborigen							= pembi_foborigen,
						@pembi_fobtotal						  	= pembi_fobtotal,
						@pembi_fobtotalorigen					= pembi_fobtotalorigen,
						@pr_id											  = pr_id

		from PermisoEmbarqueItemTMP where pembTMP_id = @@pembTMP_id and pembi_orden = @orden

		if @IsNew <> 0 or @pembi_id = 0 begin

				exec SP_DBGetNewId 'PermisoEmbarqueItem','pembi_id',@pembi_id out
				if @@error <> 0 goto ControlError

				insert into PermisoEmbarqueItem (
																			pemb_id,
																			pembi_id,
																			pembi_orden,
																			pembi_cantidad,
																			pembi_pendiente,
																			pembi_descrip,
																			pembi_fob,
																			pembi_foborigen,
																			pembi_fobtotal,
																			pembi_fobtotalorigen,
																			pr_id
																)
														Values(
																			@pemb_id,
																			@pembi_id,
																			@pembi_orden,
																			@pembi_cantidad,
																			@pembi_pendiente,
																			@pembi_descrip,
																			@pembi_fob,
																			@pembi_foborigen,
																			@pembi_fobtotal,
																			@pembi_fobtotalorigen,
																			@pr_id
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

					update PermisoEmbarqueItem set

									pemb_id											= @pemb_id,
									pembi_orden									= @pembi_orden,
									pembi_cantidad							= @pembi_cantidad,
									pembi_pendiente							= @pembi_pendiente,
									pembi_descrip								= @pembi_descrip,
									pembi_fob										= @pembi_fob,
									pembi_foborigen							= @pembi_foborigen,
									pembi_fobtotal							= @pembi_fobtotal,
									pembi_fobtotalorigen				= @pembi_fobtotalorigen,
									pr_id												= @pr_id

				where pemb_id = @pemb_id and pembi_id = @pembi_id 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While

  -- Hay que borrar los items borrados del pedido
	if @IsNew = 0 begin
		
		delete PermisoEmbarqueItem 
						where exists (select pembi_id 
                          from PermisoEmbarqueItemBorradoTMP 
                          where pemb_id 		= @pemb_id 
														and pembTMP_id 	= @@pembTMP_id
														and pembi_id 		= PermisoEmbarqueItem.pembi_id
													)
		if @@error <> 0 goto ControlError

		delete PermisoEmbarqueItemBorradoTMP where pemb_id = @pemb_id and pembTMP_id = @@pembTMP_id

  end

	delete PermisoEmbarqueItemTMP where pembTMP_id = @@pembTMP_id
	delete PermisoEmbarqueTMP where pembTMP_id = @@pembTMP_id

	select @pemb_pendiente = sum(pembi_pendiente) from PermisoEmbarqueItem where pemb_id = @pemb_id
	select @pemb_pendiente = pemb_total - @pemb_pendiente from PermisoEmbarque where pemb_id = @pemb_id

	update PermisoEmbarque set pemb_pendiente = @pemb_pendiente where pemb_id = @pemb_id
	if @@error <> 0 goto ControlError

	exec sp_DocPermisoEmbarqueSetEstado @pemb_id
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from PermisoEmbarque where pemb_id = @pemb_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 22004, @pemb_id, @modifico, 1
	else           exec sp_HistoriaUpdate 22004, @pemb_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	select @pemb_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar el permiso de embarque. sp_DocPermisoEmbarqueSave.', 16, 1)
	rollback transaction	

end