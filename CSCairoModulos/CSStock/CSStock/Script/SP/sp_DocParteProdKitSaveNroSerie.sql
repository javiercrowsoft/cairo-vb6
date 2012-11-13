if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitSaveNroSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitSaveNroSerie]

/*
 select * from ParteProdKit
 sp_DocParteProdKitSaveNroSerie 26
*/

go
create procedure sp_DocParteProdKitSaveNroSerie (
	@@ppkTMP_id 			int,
	@@ppki_id         int,
	@@st_id 					int,
	@@sti_orden				int out,
	@@ppki_cantidad   decimal(18,6),
  @@ppki_descrip    varchar(255),
  @@pr_id           int,
  @@depl_id_origen  int,
  @@depl_id_destino int,
	@@stik_id         int out,
	@@bDesarme        tinyint,

	@@bSuccess 				tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin

	declare @prns_descrip 		varchar(255)
	declare @prns_fechavto 		datetime
	declare @pr_id_kit        int
	declare @pr_id_subKit     int
	declare @prns_id 					int
	declare @n 								int
	declare @stik_cantidad    int

	set @n = 1

	if @@stik_id is not null 	select @pr_id_kit = pr_id from StockItemKit where stik_id = @@stik_id
	else set @pr_id_kit = null

	while @n <= @@ppki_cantidad begin
		select 
					top 1 @prns_id        = prns_id, 
                @prns_descrip   = prns_descrip, 
                @prns_fechavto  = prns_fechavto, 
                @pr_id_subKit   = pr_id_kit
		from 
					ParteProdKitItemSerieTMP 
		where 
							ppki_id    = @@ppki_id 
					and pr_id_item = @@pr_id
					and ppkTMP_id  = @@ppkTMP_id

		order by 
							ppkis_orden asc

		--/////////////////////////////////////////////////////////////////////////
		-- Consumo de items que son kit
		--

		-- Si el deposito es produccion es por que estoy consumiendo los items del kit
    -- y para aquellos items que tambien son kit debo generar un StockItemKit y 
    -- el movimiento de Stock debe estar vinculado con el pr_id_kit del item.
		--
		if 		(@@bDesarme = 0  and @@depl_id_destino = -2)		-- Produccion
			or	(@@bDesarme <> 0 and @@depl_id_destino <> -2)		-- Desarme
	  begin

			-- Si es un sub kit
			--
			if @pr_id_subKit is not null begin	

				-- Si es un sub kit
				--
				if @@stik_id is null begin

					select @stik_cantidad = count(*) 
					from ParteProdKitItemSerieTMP 
					where pr_id_kit = @pr_id_subKit 
						and ppki_id 	= @@ppki_id 
						and ppkTMP_id =	@@ppkTMP_id

					exec SP_DBGetNewId 'StockItemKit','stik_id',@@stik_id out, 0

					insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
													values   (@@stik_id,@stik_cantidad,@pr_id_subKit,@@st_id,1)
					if @@error <> 0 goto ControlError

				end
			end
		end

		--/////////////////////////////////////////////////////////////////////////

		exec sp_DocParteProdKitStockItemSave 	
																						@@ppki_id,
																						@@st_id,
																						@@sti_orden out,
																						1,
																					  @@ppki_descrip,
																					  @@pr_id,
																					  @@depl_id_origen,
																					  @@depl_id_destino,
																						@prns_id,
																					  @@stik_id,
				
																						@@bSuccess out,
																						@@MsgError out 

		if IsNull(@@bSuccess,0) = 0 goto Validate

		--/////////////////////////////////////////////////////////////////////////
		-- Actualizo el numero de serie
		--
		-- Solo si se trata del movimiento de produccion,
		-- cuando consumo no es necesario actualizar el numero de serie
		--
		if @@depl_id_destino <> -2	begin
																		                     
				Update ProductoNumeroSerie Set
																				prns_descrip	= @prns_descrip, 
																				prns_fechavto = @prns_fechavto, 
																				pr_id_kit     = (select top 1 pr_id_kit 
																		                     from StockItem 
																		                     where prns_id = @prns_id
																		                     order by st_id desc
																		                     )
								where prns_id = @prns_id
			  if @@error <> 0 goto ControlError
		end

		update ParteProdKitItemSerieTMP set ppkis_orden = ppkis_orden + 10000 
		where prns_id = @prns_id and 	ppkTMP_id = @@ppkTMP_id

		set @n = @n + 1
	end

	set @@bSuccess = 1
	return

ControlError:
	set @@MsgError = 'Ha ocurrido un error al grabar el item de stock del recuento de stock. sp_DocParteProdKitSaveNroSerie.'

Validate:

	set @@bSuccess = 0

end
go