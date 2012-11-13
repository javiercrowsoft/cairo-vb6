if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCSave]

/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej @@pvTMP_id  (incluir arrobas)
CAMPO_ID                     reemplazar por el nombre del campo id de la tabla tmp ej. pvTMP_id
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
TEXTO_ERROR                  reemplazar por el texto de error ej. el pedido de venta
PREFIJO_TABLA                reemplazar por el prefijo de la tabla ej. pv_
PREFIJO_TBL_ITEM             reemplazar por el prefijo de la tabla item ej. pvi_
TABLA_CLIENTE_PROVEEDOR      reemplazar por Cliente o Proveedor segun el circuito
CAMPO_CLIENTE_PROVEEDOR      reemplazar por cli_ o prov_ segun el circuito

 select * from NOMBRE_TABLA
 select * from NOMBRE_TABLAitem

 sp_col NOMBRE_TABLAitem

delete NOMBRE_TABLAitemtmp
delete NOMBRE_TABLAtmp

select * from TABLA_CLIENTE_PROVEEDORcachecredito


 select * from NOMBRE_TABLAtmp
 select * from NOMBRE_TABLAitemtmp
 sp_DocNOMBRE_DOCSave 93
*/

go
create procedure sp_DocNOMBRE_DOCSave (
	PARAM_ID int
)
as

begin

	set nocount on

	declare @PREFIJO_TABLAid					int
	declare @PREFIJO_TBL_ITEMid					int
  declare @IsNew          smallint
  declare @orden          smallint

	-- Si no existe chau
	if not exists (select CAMPO_ID from NOMBRE_TABLATMP where CAMPO_ID = PARAM_ID)
		return
	
	select @PREFIJO_TABLAid = PREFIJO_TABLAid from NOMBRE_TABLATMP where CAMPO_ID = PARAM_ID
	
	set @PREFIJO_TABLAid = isnull(@PREFIJO_TABLAid,0)
	

-- Campos de las tablas

declare	@PREFIJO_TABLAnumero  int 
declare	@PREFIJO_TABLAnrodoc  varchar (50) 
declare	@PREFIJO_TABLAdescrip varchar (5000)
declare	@PREFIJO_TABLAfecha   datetime 
declare	@PREFIJO_TABLAfechaentrega datetime 
declare	@PREFIJO_TABLAneto      decimal(18, 6) 
declare	@PREFIJO_TABLAivari     decimal(18, 6)
declare	@PREFIJO_TABLAivarni    decimal(18, 6)
declare	@PREFIJO_TABLAtotal     decimal(18, 6)
declare	@PREFIJO_TABLAsubtotal  decimal(18, 6)
declare	@PREFIJO_TABLApendiente decimal(18, 6)
declare	@PREFIJO_TABLAdescuento1    decimal(18, 6)
declare	@PREFIJO_TABLAdescuento2    decimal(18, 6)
declare	@PREFIJO_TABLAimportedesc1  decimal(18, 6)
declare	@PREFIJO_TABLAimportedesc2  decimal(18, 6)

declare	@est_id     int
declare	@suc_id     int
declare	@CAMPO_CLIENTE_PROVEEDORid     int
declare	@doc_id     int
declare @ta_id      int
declare	@doct_id    int
declare	@lp_id      int 
declare	@ld_id      int 
declare	@cpg_id     int
declare	@ccos_id    int
declare	@creado     datetime 
declare	@modificado datetime 
declare	@modifico   int 


declare	@PREFIJO_TBL_ITEMorden 							smallint 
declare	@PREFIJO_TBL_ITEMcantidad 					decimal(18, 6) 
declare	@PREFIJO_TBL_ITEMcantidadaremitir 	decimal(18, 6) 
declare	@PREFIJO_TBL_ITEMpendiente 					decimal(18, 0) 
declare	@PREFIJO_TBL_ITEMdescrip 						varchar (5000) 
declare	@PREFIJO_TBL_ITEMprecio 						decimal(18, 6) 
declare	@PREFIJO_TBL_ITEMprecioUsr 					decimal(18, 6)
declare	@PREFIJO_TBL_ITEMprecioLista 				decimal(18, 6)
declare	@PREFIJO_TBL_ITEMdescuento 					varchar (100) 
declare	@PREFIJO_TBL_ITEMneto 							decimal(18, 6) 
declare	@PREFIJO_TBL_ITEMivari 							decimal(18, 6)
declare	@PREFIJO_TBL_ITEMivarni 						decimal(18, 6)
declare	@PREFIJO_TBL_ITEMivariporc 					decimal(18, 6)
declare	@PREFIJO_TBL_ITEMivarniporc 				decimal(18, 6)
declare @PREFIJO_TBL_ITEMimporte 						decimal(18, 6)
declare	@pr_id 									int


	begin transaction


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                        INSERT                                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @PREFIJO_TABLAid = 0 begin

		set @IsNew = -1
	
		exec SP_DBGetNewId 'NOMBRE_TABLA','PREFIJO_TABLAid',@PREFIJO_TABLAid out
		exec SP_DBGetNewId 'NOMBRE_TABLA','PREFIJO_TABLAnumero',@PREFIJO_TABLAnumero out

		insert into NOMBRE_TABLA (
															PREFIJO_TABLAid,
															PREFIJO_TABLAnumero,
															PREFIJO_TABLAnrodoc,
															PREFIJO_TABLAdescrip,
															PREFIJO_TABLAfecha,
															PREFIJO_TABLAfechaentrega,
															PREFIJO_TABLAneto,
															PREFIJO_TABLAivari,
															PREFIJO_TABLAivarni,
															PREFIJO_TABLAtotal,
															PREFIJO_TABLAsubtotal,
														  PREFIJO_TABLAdescuento1,
														  PREFIJO_TABLAdescuento2,
														  PREFIJO_TABLAimportedesc1,
														  PREFIJO_TABLAimportedesc2,
															est_id,
															suc_id,
															CAMPO_CLIENTE_PROVEEDORid,
															doc_id,
															doct_id,
															lp_id,
															ld_id,
															cpg_id,
															ccos_id,
															modifico
														)
			select
															@PREFIJO_TABLAid,
															@PREFIJO_TABLAnumero,
															PREFIJO_TABLAnrodoc,
															PREFIJO_TABLAdescrip,
															PREFIJO_TABLAfecha,
															PREFIJO_TABLAfechaentrega,
															PREFIJO_TABLAneto,
															PREFIJO_TABLAivari,
															PREFIJO_TABLAivarni,
															PREFIJO_TABLAtotal,
															PREFIJO_TABLAsubtotal,
														  PREFIJO_TABLAdescuento1,
														  PREFIJO_TABLAdescuento2,
														  PREFIJO_TABLAimportedesc1,
														  PREFIJO_TABLAimportedesc2,
															est_id,
															suc_id,
															CAMPO_CLIENTE_PROVEEDORid,
															doc_id,
															doct_id,
															lp_id,
															ld_id,
															cpg_id,
															ccos_id,
															modifico
			from NOMBRE_TABLATMP
		  where CAMPO_ID = PARAM_ID	

			if @@error <> 0 goto ControlError
		
			select @doc_id = doc_id, @PREFIJO_TABLAnrodoc = PREFIJO_TABLAnrodoc from NOMBRE_TABLA where PREFIJO_TABLAid = @PREFIJO_TABLAid
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
															@PREFIJO_TABLAid                 	= PREFIJO_TABLAid,
															@PREFIJO_TABLAnrodoc							= PREFIJO_TABLAnrodoc,
															@PREFIJO_TABLAdescrip							= PREFIJO_TABLAdescrip,
															@PREFIJO_TABLAfecha								= PREFIJO_TABLAfecha,
															@PREFIJO_TABLAfechaentrega				= PREFIJO_TABLAfechaentrega,
															@PREFIJO_TABLAneto								= PREFIJO_TABLAneto,
															@PREFIJO_TABLAivari								= PREFIJO_TABLAivari,
															@PREFIJO_TABLAivarni							= PREFIJO_TABLAivarni,
															@PREFIJO_TABLAtotal								= PREFIJO_TABLAtotal,
														  @PREFIJO_TABLAdescuento1          = PREFIJO_TABLAdescuento1,
														  @PREFIJO_TABLAdescuento2          = PREFIJO_TABLAdescuento2,
															@PREFIJO_TABLAsubtotal						= PREFIJO_TABLAsubtotal,
														  @PREFIJO_TABLAimportedesc1        = PREFIJO_TABLAimportedesc1,
														  @PREFIJO_TABLAimportedesc2        = PREFIJO_TABLAimportedesc2,
															@est_id									= est_id,
															@suc_id									= suc_id,
															@CAMPO_CLIENTE_PROVEEDORid									= CAMPO_CLIENTE_PROVEEDORid,
															@doc_id									= doc_id,
															@doct_id								= doct_id,
															@lp_id									= lp_id,
															@ld_id									= ld_id,
															@cpg_id								  = cpg_id,
															@ccos_id								= ccos_id,
															@modifico							  = modifico,
															@modificado             = modificado
		from NOMBRE_TABLATMP 
    where 
					CAMPO_ID = PARAM_ID
	
		update NOMBRE_TABLA set 
															PREFIJO_TABLAnrodoc							= @PREFIJO_TABLAnrodoc,
															PREFIJO_TABLAdescrip						= @PREFIJO_TABLAdescrip,
															PREFIJO_TABLAfecha							= @PREFIJO_TABLAfecha,
															PREFIJO_TABLAfechaentrega				= @PREFIJO_TABLAfechaentrega,
															PREFIJO_TABLAneto								= @PREFIJO_TABLAneto,
															PREFIJO_TABLAivari							= @PREFIJO_TABLAivari,
															PREFIJO_TABLAivarni							= @PREFIJO_TABLAivarni,
															PREFIJO_TABLAtotal							= @PREFIJO_TABLAtotal,
														  PREFIJO_TABLAdescuento1         = @PREFIJO_TABLAdescuento1,
														  PREFIJO_TABLAdescuento2         = @PREFIJO_TABLAdescuento2,
															PREFIJO_TABLAsubtotal						= @PREFIJO_TABLAsubtotal,
														  PREFIJO_TABLAimportedesc1       = @PREFIJO_TABLAimportedesc1,
														  PREFIJO_TABLAimportedesc2       = @PREFIJO_TABLAimportedesc2,
															est_id								= @est_id,
															suc_id								= @suc_id,
															CAMPO_CLIENTE_PROVEEDORid								= @CAMPO_CLIENTE_PROVEEDORid,
															doc_id								= @doc_id,
															doct_id								= @doct_id,
															lp_id									= @lp_id,
															ld_id									= @ld_id,
															cpg_id								= @cpg_id,
															ccos_id								= @ccos_id,
															modifico							= @modifico,
															modificado            = @modificado
	
		where PREFIJO_TABLAid = @PREFIJO_TABLAid
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
	while exists(select PREFIJO_TBL_ITEMorden from NOMBRE_TABLAItemTMP where CAMPO_ID = PARAM_ID and PREFIJO_TBL_ITEMorden = @orden) 
	begin


		/*
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//                                                                                                               //
		//                                        INSERT                                                                 //
		//                                                                                                               //
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		*/

		select
						@PREFIJO_TBL_ITEMid										  = PREFIJO_TBL_ITEMid,
						@PREFIJO_TBL_ITEMorden									= PREFIJO_TBL_ITEMorden,
						@PREFIJO_TBL_ITEMcantidad							  = PREFIJO_TBL_ITEMcantidad,
						@PREFIJO_TBL_ITEMcantidadaremitir			  = PREFIJO_TBL_ITEMcantidadaremitir,
						@PREFIJO_TBL_ITEMpendiente							= PREFIJO_TBL_ITEMpendiente,
						@PREFIJO_TBL_ITEMdescrip								= PREFIJO_TBL_ITEMdescrip,
						@PREFIJO_TBL_ITEMprecio								  = PREFIJO_TBL_ITEMprecio,
						@PREFIJO_TBL_ITEMprecioUsr							= PREFIJO_TBL_ITEMprecioUsr,
						@PREFIJO_TBL_ITEMprecioLista						= PREFIJO_TBL_ITEMprecioLista,
						@PREFIJO_TBL_ITEMdescuento							= PREFIJO_TBL_ITEMdescuento,
						@PREFIJO_TBL_ITEMneto									  = PREFIJO_TBL_ITEMneto,
						@PREFIJO_TBL_ITEMivari									= PREFIJO_TBL_ITEMivari,
						@PREFIJO_TBL_ITEMivarni								  = PREFIJO_TBL_ITEMivarni,
						@PREFIJO_TBL_ITEMivariporc							= PREFIJO_TBL_ITEMivariporc,
						@PREFIJO_TBL_ITEMivarniporc						  = PREFIJO_TBL_ITEMivarniporc,
						@PREFIJO_TBL_ITEMimporte								= PREFIJO_TBL_ITEMimporte,
						@pr_id											= pr_id,
						@ccos_id										= ccos_id

		from NOMBRE_TABLAItemTMP where CAMPO_ID = PARAM_ID and PREFIJO_TBL_ITEMorden = @orden

		if @IsNew <> 0 or @PREFIJO_TBL_ITEMid = 0 begin

				exec SP_DBGetNewId 'NOMBRE_TABLAItem','PREFIJO_TBL_ITEMid',@PREFIJO_TBL_ITEMid out
		
				insert into NOMBRE_TABLAItem (
																			PREFIJO_TABLAid,
																			PREFIJO_TBL_ITEMid,
																			PREFIJO_TBL_ITEMorden,
																			PREFIJO_TBL_ITEMcantidad,
																			PREFIJO_TBL_ITEMcantidadaremitir,
																			PREFIJO_TBL_ITEMpendiente,
																			PREFIJO_TBL_ITEMdescrip,
																			PREFIJO_TBL_ITEMprecio,
																			PREFIJO_TBL_ITEMprecioUsr,
																			PREFIJO_TBL_ITEMprecioLista,
																			PREFIJO_TBL_ITEMdescuento,
																			PREFIJO_TBL_ITEMneto,
																			PREFIJO_TBL_ITEMivari,
																			PREFIJO_TBL_ITEMivarni,
																			PREFIJO_TBL_ITEMivariporc,
																			PREFIJO_TBL_ITEMivarniporc,
																			PREFIJO_TBL_ITEMimporte,
																			pr_id,
																			ccos_id
																)
														Values(
																			@PREFIJO_TABLAid,
																			@PREFIJO_TBL_ITEMid,
																			@PREFIJO_TBL_ITEMorden,
																			@PREFIJO_TBL_ITEMcantidad,
																			@PREFIJO_TBL_ITEMcantidadaremitir,
																			@PREFIJO_TBL_ITEMpendiente,
																			@PREFIJO_TBL_ITEMdescrip,
																			@PREFIJO_TBL_ITEMprecio,
																			@PREFIJO_TBL_ITEMprecioUsr,
																			@PREFIJO_TBL_ITEMprecioLista,
																			@PREFIJO_TBL_ITEMdescuento,
																			@PREFIJO_TBL_ITEMneto,
																			@PREFIJO_TBL_ITEMivari,
																			@PREFIJO_TBL_ITEMivarni,
																			@PREFIJO_TBL_ITEMivariporc,
																			@PREFIJO_TBL_ITEMivarniporc,
																			@PREFIJO_TBL_ITEMimporte,
																			@pr_id,
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

					update NOMBRE_TABLAItem set

									PREFIJO_TABLAid											= @PREFIJO_TABLAid,
									PREFIJO_TBL_ITEMorden									= @PREFIJO_TBL_ITEMorden,
									PREFIJO_TBL_ITEMcantidad							= @PREFIJO_TBL_ITEMcantidad,
									PREFIJO_TBL_ITEMcantidadaremitir			= @PREFIJO_TBL_ITEMcantidadaremitir,
									PREFIJO_TBL_ITEMpendiente							= @PREFIJO_TBL_ITEMpendiente,
									PREFIJO_TBL_ITEMdescrip								= @PREFIJO_TBL_ITEMdescrip,
									PREFIJO_TBL_ITEMprecio								= @PREFIJO_TBL_ITEMprecio,
									PREFIJO_TBL_ITEMprecioUsr							= @PREFIJO_TBL_ITEMprecioUsr,
									PREFIJO_TBL_ITEMprecioLista						= @PREFIJO_TBL_ITEMprecioLista,
									PREFIJO_TBL_ITEMdescuento							= @PREFIJO_TBL_ITEMdescuento,
									PREFIJO_TBL_ITEMneto									= @PREFIJO_TBL_ITEMneto,
									PREFIJO_TBL_ITEMivari									= @PREFIJO_TBL_ITEMivari,
									PREFIJO_TBL_ITEMivarni								= @PREFIJO_TBL_ITEMivarni,
									PREFIJO_TBL_ITEMivariporc							= @PREFIJO_TBL_ITEMivariporc,
									PREFIJO_TBL_ITEMivarniporc						= @PREFIJO_TBL_ITEMivarniporc,
									PREFIJO_TBL_ITEMimporte								= @PREFIJO_TBL_ITEMimporte,
									pr_id											= @pr_id,
									ccos_id										= @ccos_id

				where PREFIJO_TABLAid = @PREFIJO_TABLAid and PREFIJO_TBL_ITEMid = @PREFIJO_TBL_ITEMid 
  			if @@error <> 0 goto ControlError
		end -- Update

	  set @orden = @orden + 1
  end -- While

  -- Hay que borrar los items borrados del pedido
	if @IsNew = 0 begin
		
		delete NOMBRE_TABLAItem 
						where exists (select PREFIJO_TBL_ITEMid 
                          from NOMBRE_TABLAItemBorradoTMP 
                          where PREFIJO_TABLAid = @PREFIJO_TABLAid and PREFIJO_TBL_ITEMid = NOMBRE_TABLAItem.PREFIJO_TBL_ITEMid)
		if @@error <> 0 goto ControlError

		delete NOMBRE_TABLAItemBorradoTMP where PREFIJO_TABLAid = @PREFIJO_TABLAid

  end

	delete NOMBRE_TABLAItemTMP where CAMPO_ID = PARAM_ID
	delete NOMBRE_TABLATMP where CAMPO_ID = PARAM_ID

	select @PREFIJO_TABLApendiente = sum(PREFIJO_TBL_ITEMpendiente) from NOMBRE_TABLAItem where PREFIJO_TABLAid = @PREFIJO_TABLAid
	select @PREFIJO_TABLApendiente = PREFIJO_TABLAtotal - @PREFIJO_TABLApendiente from NOMBRE_TABLA where PREFIJO_TABLAid = @PREFIJO_TABLAid

	update NOMBRE_TABLA set PREFIJO_TABLApendiente = @PREFIJO_TABLApendiente where PREFIJO_TABLAid = @PREFIJO_TABLAid
	if @@error <> 0 goto ControlError

	select @ta_id = ta_id from documento where doc_id = @doc_id

	exec sp_TalonarioSet @ta_id,@PREFIJO_TABLAnrodoc
	exec sp_DocNOMBRE_TABLASetCredito @PREFIJO_TABLAid
	exec sp_DocNOMBRE_TABLASetEstado @PREFIJO_TABLAid

	commit transaction

	select @PREFIJO_TABLAid

	return
ControlError:

	raiserror ('Ha ocurrido un error al grabar TEXTO_ERROR. sp_DocNOMBRE_DOCSave.', 16, 1)
	rollback transaction	

end