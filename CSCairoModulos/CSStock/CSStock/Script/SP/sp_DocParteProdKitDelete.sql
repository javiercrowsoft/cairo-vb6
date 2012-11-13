if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitDelete]

go
/*

 sp_DocParteProdKitDelete 93

*/

create procedure sp_DocParteProdKitDelete (
	@@ppk_id 				int,
	@@emp_id    		int,
	@@us_id					int
)
as

begin

	set nocount on

	if isnull(@@ppk_id,0) = 0 return

	declare @bEditable 		tinyint
	declare @editMsg   		varchar(255)

	exec sp_DocParteProdKitEditableGet	@@emp_id    	,
																			@@ppk_id 			,
																		  @@us_id     	,
																			@bEditable 		out,
																			@editMsg   		out,
																		  0							, --@@ShowMsg
																			0  						,	--@@bNoAnulado
																			1							  --@@bDelete

	if @bEditable = 0 begin

		set @editMsg = '@@ERROR_SP:' + @editMsg
		raiserror (@editMsg, 16, 1)

		return
	end

	begin transaction

	declare @st_id int

  -- Creo una tabla para guardar los numeros de serie
  --
	create table #NroSerieDelete (prns_id int)

  -- Obtengo el movimiento de stock de produccion
  --
	select @st_id = st_id1 from ParteProdKit where ppk_id = @@ppk_id

  -- Inserto los numeros de serie (en ambos movimientos de stock se menciona a los mismos numeros de serie)
  --
	insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id and prns_id is not null

  -- Borro el movimiento de produccion
  --
  update ParteProdKit set st_id1 = null where ppk_id = @@ppk_id
	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 1, 1 -- @@bNotUpdatePrns = false, No check access
	if @@error <> 0 goto ControlError

  -- Borro el movimiento de consumo
  --
	select @st_id = st_id2 from ParteProdKit where ppk_id = @@ppk_id
  update ParteProdKit set st_id2 = null where ppk_id = @@ppk_id
	exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- @@bNotUpdatePrns = true, No check access
	if @@error <> 0 goto ControlError

  -- Actualizo en los numerso de serie el kit asociado
  --
  update ProductoNumeroSerie 
    set pr_id_kit = (select top 1 pr_id_kit 
                     from StockCache 
                     where prns_id = ProductoNumeroSerie.prns_id and stc_cantidad > 0 
                     order by stc_id desc
                     )
  where exists(select prns_id from #NroSerieDelete where prns_id = ProductoNumeroSerie.prns_id)
	if @@error <> 0 goto ControlError

  --////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Vinculo todos los numeros de serie utilizados en este parte con el ppk_id
  update ProductoNumeroSerie set ppk_id = (select top 1 ppk_id
                                                  from ParteProdKit p inner join StockItem s on p.st_id2 = s.st_id
                                                  where prns_id = ProductoNumeroSerie.prns_id
                                                    and ppk_id <> @@ppk_id
                                                  order by ppk_id desc
                                           )
  where ppk_id = @@ppk_id
	if @@error <> 0 goto ControlError

	delete ProductoSerieKitItem where prsk_id in (select prsk_id 
																								from ProductoSerieKit 
																								where ppki_id in (select ppki_id 
																																 from ParteProdKitItem 
																																 where ppk_id = @@ppk_id))
	if @@error <> 0 goto ControlError
	
	delete #NroSerieDelete
	insert #NroSerieDelete (prns_id) 
	select prns_id 
	from ProductoSerieKit 
	where ppki_id  in (select ppki_id 
										 from ParteProdKitItem 
										 where ppk_id = @@ppk_id
										)

	update ProductoNumeroSerie 
	set prsk_id = null 
	where prns_id in (select prns_id from #NroSerieDelete)
	if @@error <> 0 goto ControlError

	delete ProductoSerieKit where ppki_id  in (select ppki_id 
																						 from ParteProdKitItem 
																						 where ppk_id = @@ppk_id)
	if @@error <> 0 goto ControlError

	update ProductoSerieKit set ppki_id_desarme = null
	where ppki_id_desarme in (select ppki_id 
														from ParteProdKitItem 
														where ppk_id = @@ppk_id)

	if @@error <> 0 goto ControlError

	delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
	if @@error <> 0 goto ControlError

	delete ProductoNumeroSerie where prns_id in (select prns_id from #NroSerieDelete)
	if @@error <> 0 goto ControlError

	delete ParteProdKitItemA where ppki_id in (select ppki_id from ParteProdKitItem where ppk_id = @@ppk_id)
	if @@error <> 0 goto ControlError

	delete ParteProdKitItem where ppk_id = @@ppk_id
	if @@error <> 0 goto ControlError

	delete ParteProdKit where ppk_id = @@ppk_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el parte de desarme de kit. sp_DocParteProdKitDelete.', 16, 1)
	rollback transaction	

end