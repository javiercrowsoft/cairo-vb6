if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoSave]

/*
 select * from Asiento
 select * from Asientoitem

 sp_col Asientoitem

delete Asientoitemtmp
delete Asientotmp

select * from clientecachecredito


 select * from Asientotmp
 select * from Asientoitemtmp
 sp_DocAsientoSave 93
*/

go
create procedure sp_DocAsientoSave (
	@@asTMP_id int,
	@@as_id    int = 0 out,
	@@show     tinyint = 1
)
as

begin

	set nocount on

	-- Antes que nada valido que este el centro de costo
	--

	declare @cfg_valor varchar(5000) 

	exec sp_Cfg_GetValor  'Compras-General',
											  'Exigir Centro Costo',
											  @cfg_valor out,
											  0
  set @cfg_valor = IsNull(@cfg_valor,0)
	if convert(int,@cfg_valor) <> 0 begin

		if exists(select asi.ccos_id 
							from AsientoItemTMP asi inner join cuenta cue on asi.cue_id = cue.cue_id
							where asi.ccos_id is null 
								and asTMP_id = @@asTMP_id
								and cue_llevacentrocosto <> 0)
		begin

			declare @cue_nombre varchar(255)
			declare @cuentas    varchar(5000)
			declare @error_msg  varchar(5000)

			set @cuentas = ''
		
			declare c_cuentas insensitive cursor for
					select distinct cue_nombre
					from AsientoItemTMP asi inner join cuenta cue on asi.cue_id = cue.cue_id
					where asi.ccos_id is null 
					and asTMP_id = @@asTMP_id
					and cue_llevacentrocosto <> 0

			open c_cuentas
			fetch next from c_cuentas into @cue_nombre
			while @@fetch_status=0
			begin

				set @cuentas = @cuentas + @cue_nombre +', '

				fetch next from c_cuentas into @cue_nombre
			end

			if len(@cuentas)>0 set @cuentas = substring(@cuentas,1,len(@cuentas)-1)

			close c_cuentas
			deallocate c_cuentas

			set @error_msg = '@@ERROR_SP:Debe indicar un centro de costo en cada las cuentas que exigen centro de costo.'
												+ char(10) + char(13) + char(10) + char(13) +
												+ 'Cuentas:' + char(10) + char(13) +
												@cuentas

			raiserror (@error_msg, 16, 1)
			return
		end
		
	end
	
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @as_id					int
	declare @asi_id					int
  declare @IsNew          smallint
  declare @orden          smallint

	-- Si no existe chau
	if not exists (select asTMP_id from AsientoTMP where asTMP_id = @@asTMP_id)
		return

-- Talonario
	declare	@doc_id     int
	declare	@as_nrodoc  varchar (50) 
	
	select @as_id = as_id,

-- Talonario
				 @as_nrodoc	= as_nrodoc,
				 @doc_id		= doc_id

	from AsientoTMP where asTMP_id = @@asTMP_id
	
	set @as_id = isnull(@as_id,0)

declare @MsgError    varchar(255)
declare @bError      tinyint

-- Campos de las tablas

declare	@as_numero  int 
declare	@as_descrip varchar (5000)
declare	@as_fecha   datetime 

declare @ta_id      int
declare	@doct_id    int

declare	@ccos_id    int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 


declare	@asi_orden 							smallint 
declare	@asi_descrip 						varchar (5000) 
declare	@asi_debe 							decimal(18, 6) 
declare	@asi_haber 							decimal(18, 6)
declare	@asi_origen 						decimal(18, 6)
declare	@cue_id									int
declare @mon_id                 int

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @as_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'Asiento','as_id',@as_id out,0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'Asiento','as_numero',@as_numero out, 0
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

							set @as_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into Asiento (
															as_id,
															as_numero,
															as_nrodoc,
															as_descrip,
															as_fecha,
															doc_id,
															doct_id,
															modifico
														)
			select
															@as_id,
															@as_numero,
															@as_nrodoc,
															as_descrip,
															as_fecha,
															doc_id,
															doct_id,
															modifico
			from AsientoTMP
		  where asTMP_id = @@asTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @as_nrodoc = as_nrodoc from Asiento where as_id = @as_id
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
															@as_id                 	= as_id,
															@as_nrodoc							= as_nrodoc,
															@as_descrip							= as_descrip,
															@as_fecha								= as_fecha,
															@doc_id									= doc_id,
															@doct_id								= doct_id,
															@modifico							  = modifico,
															@modificado             = modificado
		from AsientoTMP 
    where 
					asTMP_id = @@asTMP_id
	
		update Asiento set 
															as_nrodoc							= @as_nrodoc,
															as_descrip						= @as_descrip,
															as_fecha							= @as_fecha,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															modifico							= @modifico,
															modificado            = @modificado
	
		where as_id = @as_id
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
	while exists(select asi_orden from AsientoItemTMP where asTMP_id = @@asTMP_id and asi_orden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@asi_id										  = asi_id,
						@asi_orden									= asi_orden,
						@asi_descrip								= asi_descrip,
						@asi_debe	      					  = asi_debe,
						@asi_haber			  					= asi_haber,
						@asi_origen			  					= asi_origen,
						@cue_id											= AsientoItemTmp.cue_id,
						@ccos_id										= ccos_id,
            @mon_id                     = mon_id

		from AsientoItemTMP 		inner join Cuenta on AsientoItemTMP.cue_id = Cuenta.cue_id

		where asTMP_id = @@asTMP_id and asi_orden = @orden

		if @IsNew <> 0 or @asi_id = 0 begin

				exec SP_DBGetNewId 'AsientoItem','asi_id',@asi_id out, 0
				if @@error <> 0 goto ControlError

				insert into AsientoItem (
																			as_id,
																			asi_id,
																			asi_orden,
																			asi_descrip,
																			asi_debe,
																			asi_haber,
																			asi_origen,
																			cue_id,
																			ccos_id,
                                      mon_id
																)
														Values(
																			@as_id,
																			@asi_id,
																			@asi_orden,
																			@asi_descrip,
																			@asi_debe,
																			@asi_haber,
																			@asi_origen,
																			@cue_id,
																			@ccos_id,
                                      @mon_id
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

					update AsientoItem set

									as_id											= @as_id,
									asi_orden									= @asi_orden,
									asi_descrip								= @asi_descrip,
									asi_debe									= @asi_debe,
									asi_haber									= @asi_haber,
									asi_origen								= @asi_origen,
									cue_id										= @cue_id,
									ccos_id										= @ccos_id,
									mon_id										= @mon_id

				where as_id = @as_id and asi_id = @asi_id 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While

  -- Hay que borrar los items borrados del pedido
	if @IsNew = 0 begin
		
		delete AsientoItem 
						where exists (select asi_id 
                          from AsientoItemBorradoTMP 
                          where as_id 		= @as_id 
														and asTMP_id	= @@asTMP_id
														and asi_id 		= AsientoItem.asi_id
													)
		if @@error <> 0 goto ControlError

		delete AsientoItemBorradoTMP where as_id = @as_id and asTMP_id = @@asTMP_id

  end

	delete AsientoItemTMP where asTMP_ID = @@asTMP_id
	delete AsientoTMP where asTMP_ID = @@asTMP_id

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Valido el Asiento                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocAsientoValidate @as_id, @bError out, @MsgError out
	if @bError <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Talonario                                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select @ta_id = ta_id from documento where doc_id = @doc_id

	exec sp_TalonarioSet @ta_id,@as_nrodoc
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from Asiento where as_id = @as_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 19001, @as_id, @modifico, 1
	else           exec sp_HistoriaUpdate 19001, @as_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	set @@as_id = @as_id

	if @@show <> 0 select @as_id

	return
ControlError:

	if @MsgError is not null set @MsgError = @MsgError + ';'

	set @MsgError = IsNull(@MsgError,'') + 'Ha ocurrido un error al grabar el asiento. sp_DocAsientoSave.'
                          
	raiserror (@MsgError, 16, 1)

	rollback transaction	

end