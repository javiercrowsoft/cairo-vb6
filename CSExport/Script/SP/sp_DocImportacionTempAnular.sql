if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempAnular]

go

create procedure sp_DocImportacionTempAnular (
  @@us_id         int,
  @@impt_id       int,
  @@anular        tinyint,
  @@Select        tinyint = 0
)
as

begin

  if @@impt_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0
  
  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7

  -- No se puede des-anular una factura que mueve Stock
  --
  if @@anular = 0 begin
    if exists(select impt_id from ImportacionTemp impt_id 
              inner join Documento d on impt_id.doc_id = d.doc_id 
              where impt_id = @@impt_id and doc_muevestock <> 0) 
    begin
      goto MueveStock
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    update ImportacionTemp set est_id = @estado_anulado
    where impt_id = @@impt_id
    set @est_id = @estado_anulado

    declare @st_id int
  
    select @st_id = st_id from ImportacionTemp where impt_id = @@impt_id
    update ImportacionTemp set st_id = null where impt_id = @@impt_id
  
    --////////////////////////////////////////////////////////////////////////////////////////////////
  
    create table #NroSerieDelete (prns_id int)
    insert #NroSerieDelete (prns_id) select prns_id from StockItem where st_id = @st_id
  
    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError
  
    delete StockCache where prns_id in (select prns_id from #NroSerieDelete)
    if @@error <> 0 goto ControlError
  
    delete ProductoNumeroSerie where prns_id in (select prns_id from #NroSerieDelete)
    if @@error <> 0 goto ControlError

  end else begin

    update ImportacionTemp set est_id = @estado_pendiente
    where impt_id = @@impt_id

    exec sp_DocImportacionTempSetEstado @@impt_id,0,@est_id out

  end
  
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     VALIDACIONES AL DOCUMENTO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @bSuccess tinyint
  declare @MsgError  varchar(5000) set @MsgError = ''

  exec sp_AuditoriaAnularCheckDocIMPT  @@impt_id,
                                      @bSuccess  out,
                                      @MsgError out

  -- Si el documento no es valido
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  update ImportacionTemp set modificado = getdate(), modifico = @@us_id where impt_id = @@impt_id

  if @@anular <> 0 exec sp_HistoriaUpdate 22007, @@impt_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 22007, @@impt_id, @@us_id, 8

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     FIN                                                                            //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  if @bInternalTransaction <> 0 
    commit transaction

  if @@Select <> 0 begin
    select est_id, est_nombre from Estado where est_id = @est_id
  end

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al actualizar el estado de la importación temporal. sp_DocImportacionTempAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  
  Goto fin

MueveStock:
  raiserror ('@@ERROR_SP:Los documentos que mueven stock no pueden des-anularce.', 16, 1)
  Goto fin

fin:

end