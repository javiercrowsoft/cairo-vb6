if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockDelete]

go
/*

 sp_DocRecuentoStockDelete 93

*/

create procedure sp_DocRecuentoStockDelete (
  @@rs_id         int,
  @@emp_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if isnull(@@rs_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocRecuentoStockEditableGet  @@emp_id      ,
                                      @@rs_id       ,
                                      @@us_id       ,
                                      @bEditable     out,
                                      @editMsg       out,
                                      0              , --@@ShowMsg
                                      0              ,  --@@bNoAnulado
                                      1                --@@bDelete

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

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Obtengo el primer movimiento de stock
  --
  select @st_id = st_id1 from RecuentoStock where rs_id = @@rs_id
  update RecuentoStock set st_id1 = null where rs_id = @@rs_id

  -- Inserto los numeros de serie del primer nomvimiento de stock
  --
  insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id and prns_id is not null
  
  -- Borro el movimiento de stock
  --
  exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
  if @@error <> 0 goto ControlError
  
  -- Borro del cache los numeros de serie que se mensionaban en este recuento
  --
  delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
  if @@error <> 0 goto ControlError

  -- Borro los numeros de serie unicamente mencionados por el movimiento de stock
  -- que acabo de borrar
  --
  delete ProductoNumeroSerie where   prns_id in (select prns_id from #NroSerieDelete)
                                and  not exists(select prns_id from StockItem where prns_id = ProductoNumeroSerie.prns_id)
  if @@error <> 0 goto ControlError

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Segundo movimiento
  --
  select @st_id = st_id2 from RecuentoStock where rs_id = @@rs_id
  update RecuentoStock set st_id2 = null where rs_id = @@rs_id

  -- Inserto los numeros de serie del primer nomvimiento de stock
  --
  delete #NroSerieDelete
  insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id

  -- Borro el movimiento de stock
  --
  exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
  if @@error <> 0 goto ControlError

  -- Borro del cache los numeros de serie que se mensionaban en este recuento
  --
  delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
  if @@error <> 0 goto ControlError

  -- Borro los numeros de serie unicamente mencionados por el movimiento de stock
  -- que acabo de borrar
  --
  delete ProductoNumeroSerie where   prns_id in (select prns_id from #NroSerieDelete)
                                and  not exists(select prns_id from StockItem where prns_id = ProductoNumeroSerie.prns_id)
  if @@error <> 0 goto ControlError

  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Finalmente borro el recuento de stock
  --
  delete RecuentoStockItem where rs_id = @@rs_id
  if @@error <> 0 goto ControlError

  delete RecuentoStock where rs_id = @@rs_id
  if @@error <> 0 goto ControlError

  commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al borrar el recuento de stock. sp_DocRecuentoStockDelete.', 16, 1)
  rollback transaction  

end