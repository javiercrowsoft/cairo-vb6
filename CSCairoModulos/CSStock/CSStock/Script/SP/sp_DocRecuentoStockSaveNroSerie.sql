if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockSaveNroSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockSaveNroSerie]

/*
 select * from RecuentoStocktmp
 select * from RecuentoStockItemSerieTMP

begin transaction
exec	sp_docrecuentostocksave 5
select * from productonumeroserie
rollback transaction

 sp_DocRecuentoStockSaveNroSerie 26

*/

go
create procedure sp_DocRecuentoStockSaveNroSerie (
	@@rsTMP_id        int,
	@@rsi_id          int,
	@@st_id 					int,
	@@sti_orden				int out,
	@@rsi_ajuste      decimal(18,6),
  @@rsi_descrip     varchar(255),
  @@pr_id           int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
	@@stik_id         int,

	@@bSuccess 				tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin

	declare @prns_descrip 		varchar(255)
	declare @prns_fechavto 		datetime
	declare @prns_codigo			varchar	(100)
	declare @pr_id            int
	declare @modifico         int
	declare @bAgregando       tinyint
	declare @prns_id 					int
	declare @n 								int
	declare @pr_id_kit        int

	if @@rsi_ajuste < 0 begin 
											set @@rsi_ajuste = @@rsi_ajuste * -1
											set @bAgregando = 0
	end
  else                set @bAgregando = 1

	if @@stik_id is not null 	select @pr_id_kit = pr_id from StockItemKit where stik_id = @@stik_id
	else 												 set @pr_id_kit = null

	set @n = 1

	select @modifico = modifico from Stock where st_id = @@st_id

	while @n <= @@rsi_ajuste begin

		select 
					top 1 @prns_id 				= prns_id, 
							  @prns_descrip 	= prns_descrip, 
								@prns_fechavto 	= prns_fechavto,
								@prns_codigo		= prns_codigo,

								--/////////////////////////////////////////////////
								--
								--	Si el item del recuento es un Kit, el id del numero de serie
								--  es sobre el item del kit, sino es sobre el pr_id del item
								--
								--/////////////////////////////////////////////////
								@pr_id          = IsNull(pr_id_item,pr_id)
		from 
					RecuentoStockItemSerieTMP 
		where 
							rsi_id     							 = @@rsi_id 
					--/////////////////////////////////////////////////
					--
					--	Si el item del recuento es un Kit, el id del numero de serie
					--  es sobre el item del kit, sino es sobre el pr_id del item
					--
					--/////////////////////////////////////////////////
					and IsNull(pr_id_item,pr_id) = @@pr_id

					and rsTMP_id = @@rsTMP_id

		order by 
							rsis_orden asc

		--/////////////////////////////////////////////////////////////////////////
		-- Actualizo el numero de serie
		--
				-- Averiguo si el numero de serie ya existe en el sistema y talvez lo
				-- envie a un deposito interno por algun motivo.
				--
				if @prns_id <= 0 begin

					select @prns_id = prns_id from ProductoNumeroSerie 
					where prns_codigo = @prns_codigo 
						and pr_id = @pr_id 
						and depl_id in (-2)
					set @prns_id = IsNull(@prns_id,0)

				end

				--////////////////////////////////////////////////////////////////////////
				--  Numero de Serie

				-- UNICAMENTE cuando estoy agregando puedo insertar nuevos numeros de serie
				-- (queda por comprobar si debe dispararce un error cuando no estoy agregando y no me dan un nro de serie
        --  o el codigo de validacion de stock se encarga solo de impedirlo)
				--
				if @prns_id <= 0 and @bAgregando <> 0 begin

					exec SP_DBGetNewId 'ProductoNumeroSerie','prns_id',@prns_id out, 0				

					insert into ProductoNumeroSerie (
																					 prns_id, 
																					 prns_codigo, 
																					 prns_descrip, 
																					 prns_fechavto, 
																					 pr_id, 
																					 depl_id,
																					 pr_id_kit,
																					 modifico
																					 )
																		values(
																					 @prns_id, 
																					 @prns_codigo, 
																					 @prns_descrip, 
																					 @prns_fechavto, 
																					 @pr_id, 
																					 @@depl_id_destino,
                                           @pr_id_kit,
																					 @modifico	
																					 )
			  	if @@error <> 0 goto ControlError

					update RecuentoStockItemSerieTMP 
								set prns_id = @prns_id 
					where 
									prns_codigo 							= @prns_codigo 
							and rsi_id 										= @@rsi_id 
							--/////////////////////////////////////////////////
							--
							--	Si el item del recuento es un Kit, el id del numero de serie
							--  es sobre el item del kit, sino es sobre el pr_id del item
							--
							--/////////////////////////////////////////////////
							and IsNull(pr_id_item,pr_id) 	= @@pr_id

							and rsTMP_id = @@rsTMP_id

				end else begin

					Update ProductoNumeroSerie Set
																					prns_descrip	= @prns_descrip, 
																					prns_fechavto = @prns_fechavto, 
																					depl_id 			= @@depl_id_destino,
																					pr_id_kit     = @pr_id_kit
									where prns_id = @prns_id
				  if @@error <> 0 goto ControlError

					update RecuentoStockItemSerieTMP 
								set prns_id = @prns_id 
					where 
									prns_codigo 							= @prns_codigo 
							and rsi_id 										= @@rsi_id 
							--/////////////////////////////////////////////////
							--
							--	Si el item del recuento es un Kit, el id del numero de serie
							--  es sobre el item del kit, sino es sobre el pr_id del item
							--
							--/////////////////////////////////////////////////
							and IsNull(pr_id_item,pr_id) 	= @@pr_id

							and rsTMP_id = @@rsTMP_id
				end

		--/////////////////////////////////////////////////////////////////////////

		exec sp_DocRecuentoStockStockItemSave 	
																						@@rsi_id,
																						@@st_id,
																						@@sti_orden out,
																						1,
																					  @@rsi_descrip,
																					  @@pr_id,
																					  @@depl_id_origen,
																					  @@depl_id_destino,
																						@prns_id,
																					  @@stik_id,
																						null,
				
																						@@bSuccess out,
																						@@MsgError out 

		if IsNull(@@bSuccess,0) = 0 goto Validate
		
		delete RecuentoStockItemSerieTMP where prns_id = @prns_id and rsTMP_id = @@rsTMP_id

		set @n = @n + 1

	end

	set @@bSuccess = 1
	return

ControlError:
	set @@MsgError = 'Ha ocurrido un error al grabar el item de stock del recuento de stock. sp_DocRecuentoStockSaveNroSerie.'

Validate:

	set @@bSuccess = 0

end
go