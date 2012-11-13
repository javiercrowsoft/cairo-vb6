if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockClienteSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockClienteSave]

/*

begin transaction

 sp_DocStockClienteSave 1

rollback transaction

*/

go
create procedure sp_DocStockClienteSave (
	@@stcliTMP_id 	int,
	@@stTMP_id 			int
)
as

begin

	set nocount on

	declare @stcli_id			  int
  declare @IsNew          smallint
  declare @orden          smallint

	-- Si no existe chau
	if not exists (select stcliTMP_id from StockClienteTMP where stcliTMP_id = @@stcliTMP_id)
		return

-- Talonario
	declare	@stcli_nrodoc  varchar (50) 
	declare	@doc_id     		int
	
	select @stcli_id 		= stcli_id, 

-- Talonario
				 @stcli_nrodoc	= stcli_nrodoc,
				 @doc_id				= doc_id

	from StockClienteTMP where stcliTMP_id = @@stcliTMP_id
	
	set @stcli_id = isnull(@stcli_id,0)
	

-- Campos de las tablas

declare	@stcli_numero  int 
declare	@stcli_descrip varchar (5000)
declare	@stcli_fecha   datetime 

declare @cli_id		  int
declare	@suc_id     int
declare @ta_id      int
declare	@doct_id    int
declare	@lgj_id     int
declare @depl_id_origen  int
declare @depl_id_destino int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

	begin transaction

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @stcli_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'StockCliente','stcli_id',@stcli_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'StockCliente','stcli_numero',@stcli_numero out, 0
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

							set @stcli_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into StockCliente (
															stcli_id,
															stcli_numero,
															stcli_nrodoc,
															stcli_descrip,
															stcli_fecha,
															cli_id,
															suc_id,
															doc_id,
															doct_id,
															lgj_id,
															depl_id_origen,
															depl_id_destino,
															modifico
														)
			select
															@stcli_id,
															@stcli_numero,
															@stcli_nrodoc,
															stcli_descrip,
															stcli_fecha,
															cli_id,
															suc_id,
															doc_id,
															doct_id,
															lgj_id,
															depl_id_origen,
															depl_id_destino,
															modifico
			from StockClienteTMP
		  where stcliTMP_id = @@stcliTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @stcli_nrodoc = stcli_nrodoc from StockCliente where stcli_id = @stcli_id
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
															@stcli_id               = stcli_id,
															@stcli_nrodoc					  = stcli_nrodoc,
															@stcli_descrip					= stcli_descrip,
															@stcli_fecha						= stcli_fecha,
															@cli_id								  = cli_id,
															@suc_id									= suc_id,
															@doc_id									= doc_id,
															@doct_id								= doct_id,
															@lgj_id								  = lgj_id,
															@depl_id_origen         = depl_id_origen,
															@depl_id_destino        = depl_id_destino,
															@modifico							  = modifico,
															@modificado             = modificado
		from StockClienteTMP 
    where 
					stcliTMP_id = @@stcliTMP_id
	
		update StockCliente set 
															stcli_nrodoc					= @stcli_nrodoc,
															stcli_descrip				  = @stcli_descrip,
															stcli_fecha					  = @stcli_fecha,
															cli_id								= @cli_id,
															suc_id								= @suc_id,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															lgj_id								= @lgj_id,
															depl_id_origen        = @depl_id_origen,
															depl_id_destino       = @depl_id_destino,
															modifico							= @modifico,
															modificado            = @modificado
	
		where stcli_id = @stcli_id
  	if @@error <> 0 goto ControlError
	end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        STOCK                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	declare @st_id int
	select @st_id = st_id from StockCliente where stcli_id = @stcli_id
	if @st_id is not null begin

		update StockTMP set st_nrodoc = st.st_nrodoc, 
												st_numero = st.st_numero 
		From Stock st 
		where StockTMP.stTMP_id = @@stTMP_id
			and st.st_id          = @st_id
		if @@error <> 0 goto ControlError

	end

	declare @bError 	 			smallint
	declare @Message  			varchar(5000) set @Message = ''

	exec sp_DocStockClienteStockSave  @stcli_id,
																			@@stTMP_id,
																			@st_id 		out,
																			@bError 	out, 
																			@Message  out
	if @bError <> 0 goto Validate

	update StockCliente set st_id = @st_id where stcli_id = @stcli_id
	if @@error <> 0 goto ControlError


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        TALONARIO                                                                   //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select @ta_id = ta_id from documento where doc_id = @doc_id

	exec sp_TalonarioSet @ta_id,@stcli_nrodoc
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        TEMPORALES                                                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	delete StockClienteTMP 			where stcliTMP_ID = @@stcliTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from StockCliente where stcli_id = @stcli_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 20005, @stcli_id, @modifico, 1
	else           exec sp_HistoriaUpdate 20005, @stcli_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	select @stcli_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar la transferencia de stock a cliente. sp_DocStockClienteSave.', 16, 1)
	goto Roll

Validate:

	set @Message = '@@ERROR_SP:' + IsNull(@Message,'')
	raiserror (@Message, 16, 1)

Roll:
	rollback transaction	

end