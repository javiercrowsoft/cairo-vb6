if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockProveedorSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockProveedorSave]

/*

begin transaction

 sp_DocStockProveedorSave 1

rollback transaction

*/

go
create procedure sp_DocStockProveedorSave (
	@@stprovTMP_id 	int,
	@@stTMP_id 			int
)
as

begin

	set nocount on

	declare @stprov_id			int
  declare @IsNew          smallint
  declare @orden          smallint

	-- Si no existe chau
	if not exists (select stprovTMP_id from StockProveedorTMP where stprovTMP_id = @@stprovTMP_id)
		return

-- Talonario
	declare	@stprov_nrodoc  varchar (50) 
	declare	@doc_id     		int
	
	select @stprov_id 		= stprov_id, 

-- Talonario
				 @stprov_nrodoc	= stprov_nrodoc,
				 @doc_id				= doc_id

	from StockProveedorTMP where stprovTMP_id = @@stprovTMP_id
	
	set @stprov_id = isnull(@stprov_id,0)
	

-- Campos de las tablas

declare	@stprov_numero  int 
declare	@stprov_descrip varchar (5000)
declare	@stprov_fecha   datetime 

declare @prov_id		int
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

	if @stprov_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'StockProveedor','stprov_id',@stprov_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'StockProveedor','stprov_numero',@stprov_numero out, 0
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

							set @stprov_nrodoc = @ta_nrodoc

						end
			
					end
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into StockProveedor (
															stprov_id,
															stprov_numero,
															stprov_nrodoc,
															stprov_descrip,
															stprov_fecha,
															prov_id,
															suc_id,
															doc_id,
															doct_id,
															lgj_id,
															depl_id_origen,
															depl_id_destino,
															modifico
														)
			select
															@stprov_id,
															@stprov_numero,
															@stprov_nrodoc,
															stprov_descrip,
															stprov_fecha,
															prov_id,
															suc_id,
															doc_id,
															doct_id,
															lgj_id,
															depl_id_origen,
															depl_id_destino,
															modifico
			from StockProveedorTMP
		  where stprovTMP_id = @@stprovTMP_id	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @stprov_nrodoc = stprov_nrodoc from StockProveedor where stprov_id = @stprov_id
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
															@stprov_id              = stprov_id,
															@stprov_nrodoc					= stprov_nrodoc,
															@stprov_descrip					= stprov_descrip,
															@stprov_fecha						= stprov_fecha,
															@prov_id								= prov_id,
															@suc_id									= suc_id,
															@doc_id									= doc_id,
															@doct_id								= doct_id,
															@lgj_id								  = lgj_id,
															@depl_id_origen         = depl_id_origen,
															@depl_id_destino        = depl_id_destino,
															@modifico							  = modifico,
															@modificado             = modificado
		from StockProveedorTMP 
    where 
					stprovTMP_id = @@stprovTMP_id
	
		update StockProveedor set 
															stprov_nrodoc					= @stprov_nrodoc,
															stprov_descrip				= @stprov_descrip,
															stprov_fecha					= @stprov_fecha,
															prov_id								= @prov_id,
															suc_id								= @suc_id,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															lgj_id								= @lgj_id,
															depl_id_origen        = @depl_id_origen,
															depl_id_destino       = @depl_id_destino,
															modifico							= @modifico,
															modificado            = @modificado
	
		where stprov_id = @stprov_id
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
	select @st_id = st_id from StockProveedor where stprov_id = @stprov_id
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

	exec sp_DocStockProveedorStockSave  @stprov_id,
																			@@stTMP_id,
																			@st_id 		out,
																			@bError 	out, 
																			@Message  out
	if @bError <> 0 goto Validate

	update StockProveedor set st_id = @st_id where stprov_id = @stprov_id
	if @@error <> 0 goto ControlError


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        TALONARIO                                                                   //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select @ta_id = ta_id from documento where doc_id = @doc_id

	exec sp_TalonarioSet @ta_id,@stprov_nrodoc
	if @@error <> 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        TEMPORALES                                                                  //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	delete StockProveedorTMP 			where stprovTMP_ID = @@stprovTMP_id

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select @modifico = modifico from StockProveedor where stprov_id = @stprov_id
	if @IsNew <> 0 exec sp_HistoriaUpdate 20004, @stprov_id, @modifico, 1
	else           exec sp_HistoriaUpdate 20004, @stprov_id, @modifico, 3

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	commit transaction

	select @stprov_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar la transferencia de stock a proveedor. sp_DocStockProveedorSave.', 16, 1)
	goto Roll

Validate:

	set @Message = '@@ERROR_SP:' + IsNull(@Message,'')
	raiserror (@Message, 16, 1)

Roll:
	rollback transaction	

end