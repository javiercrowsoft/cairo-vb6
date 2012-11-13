if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockCompensarSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockCompensarSave]

/*
 select * from Compensar
 sp_DocStockCompensarSave 26

*/

go
create procedure sp_DocStockCompensarSave (
	@@us_id 					int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
	@@doc_id          int,
	@@suc_id          int,
	@@st_fecha				datetime,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out
)
as

begin

	set nocount on

  declare @IsNew          smallint

	declare @st_id					int
	declare	@modificado 		datetime 
	declare	@modifico   		int 
	declare	@st_fecha   		datetime 
	declare @suc_id     		int

	select	@modifico			= @@us_id,
					@modificado   = getdate(),
			    @st_id 				= 0,
					@st_fecha     = @@st_fecha,
					@suc_id       = @@suc_id


-- Campos de las tablas
declare	@st_numero  int 
declare	@st_nrodoc  varchar (50) 
declare	@st_descrip varchar (5000)

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 

declare	@sti_orden 							smallint 
declare	@sti_ingreso 						decimal(18, 6) 
declare	@sti_salida 						decimal(18, 6)

declare @depl_id                int
declare @depl_id_origen         int
declare @depl_id_destino        int

declare @pr_id                  int
declare @sti_id                 int

declare @compi_id               int
declare @compi_cantidad         decimal(18,6)
declare @compi_descrip          varchar(255)

declare @st_doc_cliente         varchar(5000)

declare @bError      	tinyint

declare @bSuccess 		tinyint
declare @Message  		varchar(255)

	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	-- Obtengo el documento @doc_id
	select 
				 @doc_id 					= @@doc_id, 
         @st_doc_cliente  = 'Compensación de Stock'

	set @depl_id_destino = @@depl_id_destino
	set @depl_id_origen  = @@depl_id_origen


		set @IsNew = -1
	
		exec SP_DBGetNewId 'Stock','st_id',@st_id out, 0
		if @@error <> 0 goto ControlError

		exec SP_DBGetNewId 'Stock','st_numero',@st_numero out, 0
		if @@error <> 0 goto ControlError

		-- //////////////////////////////////////////////////////////////////////////////////
		--
		-- Talonario
		--
					declare @ta_nrodoc varchar(100)
			
					select @doct_id = doct_id,
								 @ta_id   = ta_id
					from documento where doc_id = @doc_id
			
					exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out, 0
					if @@error <> 0 goto ControlError
			
					set @st_nrodoc = @ta_nrodoc
			
					-- Con esto evitamos que dos tomen el mismo número
					--
					exec sp_TalonarioSet @ta_id, @ta_nrodoc
					if @@error <> 0 goto ControlError
		--
		-- Fin Talonario
		--
		-- //////////////////////////////////////////////////////////////////////////////////

		insert into Stock (
															st_id,
															st_numero,
															st_nrodoc,
															st_descrip,
															st_fecha,
                              st_doc_cliente,
															suc_id,
															doc_id,
															doct_id,
															doct_id_cliente,
                              id_cliente,
															depl_id_origen,
                              depl_id_destino,
															modifico
														)
			values (
															@st_id,
															@st_numero,
															@st_nrodoc,
															'',
															@st_fecha,
															@st_doc_cliente,
															@suc_id,
															@doc_id,
															@doct_id,
															null,
															0,
															@depl_id_origen,
                              @depl_id_destino,
															@modifico
							)

			if @@error <> 0 goto ControlError
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        ITEMS                                                                       //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	set @sti_orden = 0

	declare c_CompensarItemStock cursor for 

		select top 100 id, cantidad, compi.pr_id, '', p.pr_llevanroserie, p.pr_eskit
		from #sp_DocStockCompensar compi inner join Producto p on compi.pr_id = p.pr_id
		where depl_id_origen = @@depl_id_origen
		order by id

	declare @bEsKit 				tinyint 
  declare @bLLevaNroSerie tinyint

	open c_CompensarItemStock

	fetch next from c_CompensarItemStock into @compi_id, @compi_cantidad, @pr_id, @compi_descrip, @bLLevaNroSerie, @bEsKit 
	while @@fetch_status = 0 
	begin

		-- Si es un kit hay que descomponerlo
		if 	@bEsKit <> 0 begin

			exec sp_DocStockCompensarSaveItemKit 
																							@compi_id,
																							@st_id,
																							@sti_orden out,
																							@compi_cantidad,
																						  @compi_descrip,
																						  @pr_id,
																						  @depl_id_origen,
																						  @depl_id_destino,
					
																							@bSuccess out,						
																							@Message out 

			if IsNull(@bSuccess,0) = 0 goto Validate

		end else begin

			-- Si tiene numero de serie hay que grabar un stockitem por cada uno.
			if @bLlevaNroSerie <> 0 begin	
					
				exec sp_DocStockCompensarSaveNroSerie 
																								@compi_id,
																								@st_id,
																								@sti_orden out,
																								@compi_cantidad,
																							  @compi_descrip,
																							  @pr_id,
																							  @depl_id_origen,
																							  @depl_id_destino,
																								null,
						
																								@bSuccess out,						
																								@Message out 

												
				if IsNull(@bSuccess,0) = 0 goto Validate
										
			-- Solo son simples stockitems (una pavada)
			end else begin
							
				exec sp_DocStockCompensarStockItemSave 
																								0,
																								@st_id,
																								@sti_orden out,
																								@compi_cantidad,
																							  @compi_descrip,
																							  @pr_id,
																							  @depl_id_origen,
																							  @depl_id_destino,
																								null,
																							  null,

																								@bSuccess out,						
																								@Message out 
									
				if IsNull(@bSuccess,0) = 0 goto Validate
									
			end
		end

		fetch next from c_CompensarItemStock into @compi_id, @compi_cantidad, @pr_id, @compi_descrip, @bLLevaNroSerie, @bEsKit 
  end -- While

	close c_CompensarItemStock
	deallocate c_CompensarItemStock

	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	-- Agrego a StockCache lo que se movio con los items de este movimiento
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////
	--
	exec Sp_DocStockCacheUpdate @Message out, @bSuccess out, @st_id, 0 -- Sumar
	if IsNull(@bSuccess,0) = 0 goto Validate
	--
	--////////////////////////////////////////////////////////////////////////////////////////////////////////////

	delete #sp_DocStockCompensar 
	where id in(select top 100 id	from #sp_DocStockCompensar 
							where depl_id_origen = @@depl_id_origen
							order by id
							)

	commit transaction

	set @@bError = 0

	return
ControlError:

	set @@bError = -1

  if @@bRaiseError <> 0 begin
		raiserror ('Ha ocurrido un error al grabar la transferencia de stock. sp_DocStockCompensarSave.', 16, 1)
  end else begin
		set @@MsgError = 'Ha ocurrido un error al grabar la transferencia de stock. sp_DocStockCompensarSave.'
	end
	goto Roll

Validate:

	set @@bError = -1

	set @Message = '@@ERROR_SP:' + IsNull(@Message,'')
  if @@bRaiseError <> 0 begin
		raiserror (@Message, 16, 1)
  end else begin
		set @@MsgError = @Message 
	end

Roll:

	rollback transaction	

end