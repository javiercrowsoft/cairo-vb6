if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaSaveAsiento]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaSaveAsiento]

/*
 select * from MovimientoCaja
 sp_MovimientoCajaSaveAsiento 26

*/

go
create procedure sp_MovimientoCajaSaveAsiento (
	@@mcj_id 					int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
	@@bSelect         smallint     = 0
)
as

begin

	set nocount on

	declare @mcji_id					int
  declare @IsNew          	smallint
	declare @mcj_tipo         tinyint

	declare @as_id					int

	set @@bError = 0

	-- Si no existe chau
	if not exists (select mcj_id from MovimientoCaja where mcj_id = @@mcj_id)
		return

	-- Si no hay fondos en items chau tambien
	if not exists (select mcj_id from MovimientoCajaItem where mcj_id = @@mcj_id and mcji_importe <> 0) begin

		if @@bSelect <> 0 select @as_id		
		return

	end

declare	@as_fecha   datetime 
	
	select 
					@as_id 						= as_id, 
					@as_fecha 				= mcj_fecha,
					@mcj_tipo         = mcj_tipo

	from MovimientoCaja mcj
	where mcj_id = @@mcj_id
	
	set @as_id = isnull(@as_id,0)
-- Campos de las tablas

declare	@as_numero  int 
declare	@as_nrodoc  varchar (50) 
declare	@as_descrip varchar (5000)

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare @cue_id                 int
declare	@asi_orden 							smallint 
declare	@asi_debe 							decimal(18, 6) 
declare	@asi_haber 							decimal(18, 6)
declare	@asi_origen 						decimal(18, 6)

declare	@mcji_orden 							smallint 
declare @mcji_importe 						decimal(18, 6)
declare @mcji_origen			  			decimal(18, 6)

declare @cue_id_trabajo           int
declare @cue_id_fondos            int

declare @mon_id int

declare @as_doc_cliente         varchar(5000)

declare @bError      tinyint

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
				 @doc_id 					= cj.doc_id, 
         @as_doc_cliente  = 'Movimiento de Caja ' + mcj_nrodoc

	from MovimientoCaja mcj inner join Caja cj on mcj.cj_id = cj.cj_id
	where mcj_id = @@mcj_id

	if @as_id = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'Asiento','as_id',@as_id out, 0
		exec SP_DBGetNewId 'Asiento','as_numero',@as_numero out, 0


		-- Obtengo el as_nrodoc
		declare @ta_ultimonro	int 
		declare @ta_mascara   varchar(50) 

		select @ta_ultimonro=ta_ultimonro, @ta_mascara=ta_mascara, @doct_id = doct_id
		from documento inner join talonario on documento.ta_id = talonario.ta_id 
    where doc_id = @doc_id

		set @ta_ultimonro = @ta_ultimonro + 1
    set @as_nrodoc = convert(varchar(50),@ta_ultimonro)
    set @as_nrodoc = substring(@ta_mascara,1,len(@ta_mascara) - len(@as_nrodoc)) + @as_nrodoc

		insert into Asiento (
															as_id,
															as_numero,
															as_nrodoc,
															as_descrip,
															as_fecha,
                              as_doc_cliente,
															doc_id,
															doct_id,
															doct_id_cliente,
															doc_id_cliente,
                              id_cliente,
															modifico
														)
			select
															@as_id,
															@as_numero,
															@as_nrodoc,
															mcj_descrip,
															@as_fecha,
															@as_doc_cliente,
															@doc_id,
															@doct_id,
															48,
															null,
															@@mcj_id,
															modifico
			from MovimientoCaja
		  where mcj_id = @@mcj_id	

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
															@as_descrip							= mcj_descrip,
															@modifico							  = modifico,
															@modificado             = modificado
		from MovimientoCaja 
    where 
					mcj_id = @@mcj_id

		select 
															@doc_id									= doc_id,
															@doct_id								= doct_id
		from Asiento
		where 
					as_id = @as_id

		update Asiento set 
															as_descrip						= @as_descrip,
															as_fecha							= @as_fecha,
                              as_doc_cliente        = @as_doc_cliente,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															doct_id_cliente				= 48,
															doc_id_cliente				=	null,
															id_cliente						= @@mcj_id,
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


	-- Borro todos los items y solo hago inserts que se mucho mas simple y rapido
  delete AsientoItem where as_id = @as_id

	set @asi_orden = 1

	declare c_CajaItemAsiento cursor for 

		select  mcji_importe, 
						mcji_origen, 
					  cue_id_trabajo,
						cue_id_fondos
	  from MovimientoCajaItem mcji 

	  where mcj_id = @@mcj_id
		order by mcji_orden

	open c_CajaItemAsiento

	fetch next from c_CajaItemAsiento into @mcji_importe, @mcji_origen, @cue_id_trabajo, @cue_id_fondos
	while @@fetch_status = 0 
	begin

		--////////////////////////////////////////////////////////////////////////////////////
		--
		-- Cuenta DEBE

		set @asi_debe 	= @mcji_importe
		set @asi_haber 	= 0
		set @asi_origen = @mcji_origen

		if @mcj_tipo = 1 begin

			set @cue_id = @cue_id_trabajo

		end else begin

			set @cue_id = @cue_id_fondos

		end

		select @mon_id = mon_id from Cuenta where cue_id = @cue_id

		exec sp_DocAsientoSaveItem 
																					  @IsNew,
																						0,
																						@as_id,
																					
																						@asi_orden,
																						@asi_debe,
																						@asi_haber,
																						@asi_origen,
																						0,
																						@mon_id,
																					
																						@cue_id,
																						null,
																						null,

																					  @bError out
	  if @bError <> 0 goto ControlError

		set @asi_orden = @asi_orden + 1

		--////////////////////////////////////////////////////////////////////////////////////
		--
		-- Cuenta HABER

		set @asi_debe 	= 0
		set @asi_haber 	= @mcji_importe
		set @asi_origen = @mcji_origen

		if @mcj_tipo = 1 begin

			set @cue_id = @cue_id_fondos

		end else begin

			set @cue_id = @cue_id_trabajo

		end

		select @mon_id = mon_id from Cuenta where cue_id = @cue_id

		exec sp_DocAsientoSaveItem 
																					  @IsNew,
																						0,
																						@as_id,
																					
																						@asi_orden,
																						@asi_debe,
																						@asi_haber,
																						@asi_origen,
																						0,
																						@mon_id,
																					
																						@cue_id,
																						null,
																						null,

																					  @bError out
	  if @bError <> 0 goto ControlError

		set @asi_orden = @asi_orden + 1

		--////////////////////////////////////////////////////////////////////////////////////

		fetch next from c_CajaItemAsiento into @mcji_importe, @mcji_origen, @cue_id_trabajo, @cue_id_fondos
  end -- While

	close c_CajaItemAsiento
	deallocate c_CajaItemAsiento

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Valido el Asiento                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocAsientoValidate @as_id, @bError out, @@MsgError out
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

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo la factura con su asiento                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	update MovimientoCaja set as_id = @as_id where mcj_id = @@mcj_id

	commit transaction

	set @@bError = 0

	if @@bSelect <> 0 select @as_id

	return
ControlError:

	set @@bError = -1

	if @@MsgError is not null set @@MsgError = @@MsgError + ';'

	set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar el movimiento de caja. sp_MovimientoCajaSaveAsiento.'
                          
  if @@bRaiseError <> 0 begin
		raiserror (@@MsgError, 16, 1)
	end

	rollback transaction	

end