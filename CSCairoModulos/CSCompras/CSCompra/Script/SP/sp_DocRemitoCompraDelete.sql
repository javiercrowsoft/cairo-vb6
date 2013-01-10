if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraDelete]

go
/*

 sp_DocRemitoCompraDelete 93

*/

create procedure sp_DocRemitoCompraDelete (
  @@rc_id         int,
  @@emp_id        int,
  @@us_id          int,
  @@bSuccess      tinyint = 0 out,
  @@ErrorMsg       varchar(5000) = '' out
)
as

begin

  set nocount on

  set @@bSuccess = 0
  set @@ErrorMsg = ''

  if isnull(@@rc_id,0) = 0 return

  declare @bEditable     tinyint
  declare @editMsg       varchar(255)

  exec sp_DocRemitoCompraEditableGet  @@emp_id      ,
                                      @@rc_id       ,
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

  select @st_id = st_id from RemitoCompra where rc_id = @@rc_id
  update RemitoCompra set st_id = null where rc_id = @@rc_id

  --////////////////////////////////////////////////////////////////////////////////////////////////

  create table #NroSerieDelete (prns_id int)
  insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id and prns_id is not null

  exec sp_DocStockDelete @st_id, @@emp_id, @@us_id, 0, 1 -- No check access
  if @@error <> 0 goto ControlError

  delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
  if @@error <> 0 goto ControlError

  delete ProductoNumeroSerie 
  where prns_id in (select prns_id from #NroSerieDelete)
    and not exists(
                    select prns_id from StockItem sti inner join RemitoCompra rc on sti.st_id = rc.st_id
                    where prns_id = ProductoNumeroSerie.prns_id
                      and rc_id <> @@rc_id                    
                  )
  if @@error <> 0 goto ControlError

  --////////////////////////////////////////////////////////////////////////////////////////////////

  exec sp_DocRemitoCompraSetCredito @@rc_id,1
  if @@error <> 0 goto ControlError

  declare @dic_id int
  select @dic_id from RemitoCompra where rc_id = @@rc_id

  if @dic_id is not null begin

    delete DespachoImpCalculoItem where dic_id = @dic_id
    if @@error <> 0 goto ControlError

    delete DespachoImpCalculo where dic_id = @dic_id
    if @@error <> 0 goto ControlError

  end

  delete RemitoCompraItem where rc_id = @@rc_id
  if @@error <> 0 goto ControlError

  delete RemitoCompra where rc_id = @@rc_id
  if @@error <> 0 goto ControlError

  commit transaction

  set @@bSuccess = 1

  return
ControlError:

  set @@bSuccess = 0
  set @@ErrorMsg = 'Ha ocurrido un error al borrar el remito de compra. sp_DocRemitoCompraDelete.'

  raiserror (@@ErrorMsg, 16, 1)
  rollback transaction  

end