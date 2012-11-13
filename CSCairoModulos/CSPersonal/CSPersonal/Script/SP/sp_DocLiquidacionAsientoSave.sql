if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionAsientoSave]

/*
 select * from Liquidacion
 sp_DocLiquidacionAsientoSave 26

*/

go
create procedure sp_DocLiquidacionAsientoSave (
	@@liq_id 					int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
	@@bSelect         smallint     = 0
)
as

begin

	set nocount on

	if not exists(select * from LiquidacionItem where liqi_importe <> 0 and liq_id = @@liq_id) return

	declare @liqi_id					int
  declare @IsNew          smallint

	declare @as_id					int
	declare	@cli_id     		int
	declare @doc_id_liquidacion int

	set @@bError = 0

	-- Si no existe chau
	if not exists (select liq_id from Liquidacion where liq_id = @@liq_id and est_id <> 7)
		return

	select 
					@as_id 								= as_id, 
					@doc_id_liquidacion 	= doc_id

	from Liquidacion where liq_id = @@liq_id
	
	set @as_id = isnull(@as_id,0)
-- Campos de las tablas

declare	@as_numero  int 
declare	@as_nrodoc  varchar (50) 
declare	@as_descrip varchar (5000)
declare	@as_fecha   datetime 
declare	@liq_fecha  datetime 

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare @ccos_id_cliente int
declare	@ccos_id    int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare	@asi_orden 							smallint 
declare	@asi_debe 							decimal(18, 6) 
declare	@asi_haber 							decimal(18, 6)
declare	@asi_origen 						decimal(18, 6)
declare @mon_id                 int

declare	@liqi_orden 							smallint 

declare @cue_id											int
declare @doct_id_liquidacion        int
declare @doc_id_cliente         		int

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
				 @doc_id 									= doc_id_asiento, 
				 @doct_id_liquidacion 		= Liquidacion.doct_id, 
				 @doc_id_cliente    			= Documento.doc_id,
         @mon_id 									= Documento.mon_id,
         @ccos_id_cliente 				= ccos_id,
         @as_doc_cliente  				= liq_nrodoc

	from Liquidacion inner join Documento on Liquidacion.doc_id = Documento.doc_id
	where liq_id = @@liq_id

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
															liq_descrip,
															liq_fecha,
															@as_doc_cliente,
															@doc_id,
															@doct_id,
															@doct_id_liquidacion,
															@doc_id_cliente,
															@@liq_id,
															modifico
			from Liquidacion
		  where liq_id = @@liq_id	

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
															@as_descrip							= liq_descrip,
															@as_fecha								= liq_fecha,
															@modifico							  = modifico,
															@modificado             = modificado
		from Liquidacion 
    where 
					liq_id = @@liq_id

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
															doct_id_cliente				= @doct_id_liquidacion,
															doc_id_cliente				=	@doc_id_cliente,
															id_cliente						= @@liq_id,
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

	set @asi_orden = 2

/*
///////////////////////////////////////////////////////////////
//
//           DEBE
//
///////////////////////////////////////////////////////////////
*/

	declare c_LiquidacionItemAsiento cursor for 

		select liqi_importe, liqi_importeorigen, 1 as cue_id_debe
	  from LiquidacionItem 
	  where liq_id = @@liq_id

	open c_LiquidacionItemAsiento

	fetch next from c_LiquidacionItemAsiento into @asi_debe, @asi_origen, @cue_id
	while @@fetch_status = 0 
	begin

		set  @asi_haber = 0

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
																						@ccos_id,
																						null,

																					  @bError out
	  if @bError <> 0 goto ControlError

		set @asi_orden = @asi_orden + 1
		fetch next from c_LiquidacionItemAsiento into @asi_debe, @asi_origen, @cue_id
  end -- While

	close c_LiquidacionItemAsiento
	deallocate c_LiquidacionItemAsiento

/*
///////////////////////////////////////////////////////////////
//
//           HABER
//
///////////////////////////////////////////////////////////////
*/

	declare c_LiquidacionItemAsiento cursor for 

		select liqi_importe, liqi_importeorigen, 1 as cue_id_haber
	  from LiquidacionItem 
	  where liq_id = @@liq_id

	open c_LiquidacionItemAsiento

	fetch next from c_LiquidacionItemAsiento into @asi_haber, @asi_origen, @cue_id
	while @@fetch_status = 0 
	begin

		set  @asi_debe = 0

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
																						@ccos_id,
																						null,

																					  @bError out
	  if @bError <> 0 goto ControlError

		set @asi_orden = @asi_orden + 1
		fetch next from c_LiquidacionItemAsiento into @asi_haber, @asi_origen, @cue_id
  end -- While

	close c_LiquidacionItemAsiento
	deallocate c_LiquidacionItemAsiento

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
//                                Vinculo la liquidacion con su asiento                                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	update Liquidacion set as_id = @as_id, liq_grabarasiento = 0 where liq_id = @@liq_id

	commit transaction

	set @@bError = 0

	if @@bSelect <> 0 select @as_id

	return
ControlError:

	set @@bError = -1

	if @@MsgError is not null set @@MsgError = @@MsgError + ';'

	set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la liquidación de haberes. sp_DocLiquidacionAsientoSave.'

  if @@bRaiseError <> 0 begin
		raiserror (@@MsgError, 16, 1)
	end

	rollback transaction	

end