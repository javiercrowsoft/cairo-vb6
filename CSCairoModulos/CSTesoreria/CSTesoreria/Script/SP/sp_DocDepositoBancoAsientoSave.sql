if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoAsientoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoAsientoSave]

/*
 select * from DepositoBanco
 sp_DocDepositoBancoAsientoSave 26

*/

go
create procedure sp_DocDepositoBancoAsientoSave (
	@@dbco_id 					int,
  @@bRaiseError 		smallint     = -1,
  @@bError          smallint     = 0  out,
  @@MsgError        varchar(5000)= '' out,
	@@bSelect         smallint     = 0
)
as

begin

	set nocount on

	declare @dbcoi_id				int
  declare @IsNew          smallint

	declare @as_id					int
	declare	@bco_id     		int
	declare @doc_id_DepositoBanco int

	set @@bError = 0

	-- Si no existe chau
	if not exists (select dbco_id from DepositoBanco where dbco_id = @@dbco_id and est_id <> 7)
		return

	select 
					@as_id 										= as_id, 
					@bco_id 									= bco_id, 
					@doc_id_DepositoBanco 	  = doc_id

	from DepositoBanco where dbco_id = @@dbco_id
	
	set @as_id = isnull(@as_id,0)
-- Campos de las tablas

declare	@as_numero  	int 
declare	@as_nrodoc  	varchar (50) 
declare	@as_descrip 	varchar (5000)
declare	@as_fecha   	datetime 
declare	@dbco_fecha   datetime 

declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int

declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 

declare	@asi_orden 							smallint 
declare	@asi_debe 							decimal(18, 6) 
declare	@asi_haber 							decimal(18, 6)
declare	@asi_origen 						decimal(18, 6)
declare @mon_id                 int

declare	@dbcoi_orden 							smallint 

declare @cue_id												int
declare @cheq_id                      int
declare @doct_id_DepositoBanco        int
declare @doc_id_cliente         			int

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
				 @doct_id_DepositoBanco 	= DepositoBanco.doct_id, 
				 @doc_id_cliente    			= Documento.doc_id,
         @as_doc_cliente  				= dbco_nrodoc + ' ' + IsNull(bco_nombre,'')

	from DepositoBanco inner join Documento on DepositoBanco.doc_id = Documento.doc_id
										   left  join Banco   on DepositoBanco.bco_id = Banco.bco_id
	where dbco_id = @@dbco_id

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
															dbco_descrip,
															dbco_fecha,
															@as_doc_cliente,
															@doc_id,
															@doct_id,
															@doct_id_DepositoBanco,
															@doc_id_cliente,
															@@dbco_id,
															modifico
			from DepositoBanco
		  where dbco_id = @@dbco_id	

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
															@as_descrip							= dbco_descrip,
															@as_fecha								= dbco_fecha,
															@modifico							  = modifico,
															@modificado             = modificado
		from DepositoBanco 
    where 
					dbco_id = @@dbco_id

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
															doct_id_cliente				= @doct_id_DepositoBanco,
															doc_id_cliente				=	@doc_id_cliente,
															id_cliente						= @@dbco_id,
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

/*
///////////////////////////////////////////////////////////////
//
//           DEBE
//
///////////////////////////////////////////////////////////////
*/

	select @cue_id = DepositoBanco.cue_id, @mon_id = mon_id 
		from DepositoBanco inner join Cuenta on DepositoBanco.cue_id = Cuenta.cue_id
		where dbco_id = @@dbco_id

	declare c_DepositoBancoItemAsiento cursor for 

		select 
						dbcoi_importe, 
						dbcoi_importeorigen,
						dbcoi.cheq_id
	
		  from DepositoBancoItem dbcoi left join Cheque cheq on dbcoi.cheq_id = cheq.cheq_id
		
		  where dbcoi.dbco_id = @@dbco_id
				and IsNull(cheq_anulado,0) = 0	

	open c_DepositoBancoItemAsiento

	fetch next from c_DepositoBancoItemAsiento into @asi_debe, @asi_origen, @cheq_id
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
																						null,
																						@cheq_id,

																					  @bError out
	  if @bError <> 0 goto ControlError
	
		set @asi_orden = @asi_orden + 1

		fetch next from c_DepositoBancoItemAsiento into @asi_debe, @asi_origen, @cheq_id
  end -- While

	close c_DepositoBancoItemAsiento
	deallocate c_DepositoBancoItemAsiento

/*
///////////////////////////////////////////////////////////////
//
//           HABER
//
///////////////////////////////////////////////////////////////
*/

	declare c_DepositoBancoItemAsiento cursor for 

		select dbcoi_importe, dbcoi_importeorigen, dbcoi.cue_id, cue.mon_id, dbcoi.cheq_id

	  from DepositoBancoItem dbcoi inner join Cuenta cue 	on dbcoi.cue_id  = cue.cue_id
												         left  join Cheque cheq on dbcoi.cheq_id = cheq.cheq_id

	  where dbcoi.dbco_id = @@dbco_id
			and IsNull(cheq_anulado,0) = 0

	open c_DepositoBancoItemAsiento

	fetch next from c_DepositoBancoItemAsiento into @asi_haber, @asi_origen, @cue_id, @mon_id, @cheq_id
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
																						null,
																						@cheq_id,

																					  @bError out
	  if @bError <> 0 goto ControlError

		set @asi_orden = @asi_orden + 1
		fetch next from c_DepositoBancoItemAsiento into @asi_haber, @asi_origen, @cue_id, @mon_id, @cheq_id

  end -- While

	close c_DepositoBancoItemAsiento
	deallocate c_DepositoBancoItemAsiento

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Valido el Asiento                                                              //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	exec sp_DocAsientoValidate @as_id, @bError out, @@MsgError out
	if @bError <> 0 goto ControlError


	-- Valido que el asiento tenga al menos un item
	-- ya que si se trata de un deposito de cheques
	-- y estos son rechazados, el asiento queda sin 
	-- items y en este caso hago dos cosas:
	-- Si el asiento es nuevo no lo guardo, sino
	-- le agrego una descripcion indicando el
	-- motivo por el que quedo sin items
	declare @bUpdateTalonario tinyint

	if not exists(select * from AsientoItem where as_id = @as_id)
	begin

		if @IsNew <> 0 begin
			
			set @bUpdateTalonario = 0

			delete Asiento where as_id = @as_id
			if @@error <> 0 goto ControlError

			set @as_id = null

		end else begin

			if exists(select cheq.cheq_id 
								from DepositoBancoItem dbcoi 
												inner join Cheque cheq 
															on dbcoi.cheq_id = cheq.cheq_id 
								where dbcoi.dbco_id = @@dbco_id
									and	cheq_anulado <> 0
							)
				update Asiento 
						set as_descrip = 'Este asiento no posee items por que los cheques de la '
															+ 'orden de pago que lo genero han sido anulados'
				where as_id = @as_id
				if @@error <> 0 goto ControlError

			set @bUpdateTalonario = 1

		end

	end
	else set @bUpdateTalonario = 1

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Talonario                                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @bUpdateTalonario <> 0 begin

		select @ta_id = ta_id from documento where doc_id = @doc_id
	
		exec sp_TalonarioSet @ta_id,@as_nrodoc
	end
/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                Vinculo el deposito bancario con su asiento                                    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	update DepositoBanco set as_id = @as_id, dbco_grabarasiento = 0 where dbco_id = @@dbco_id

	commit transaction

	set @@bError = 0

	if @@bSelect <> 0 select @as_id

	return
ControlError:

	set @@bError = -1

	if @@MsgError is not null set @@MsgError = @@MsgError + ';;'

	set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar el deposito bancario. sp_DocDepositoBancoAsientoSave.'

  if @@bRaiseError <> 0 begin
		raiserror (@@MsgError, 16, 1)
	end

	rollback transaction	

end