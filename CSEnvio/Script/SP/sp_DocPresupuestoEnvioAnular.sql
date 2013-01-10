if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioAnular]

go

create procedure sp_DocPresupuestoEnvioAnular (
  @@us_id       int,
  @@pree_id     int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@pree_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    update PresupuestoEnvio set est_id = @estado_anulado, pree_pendiente = 0
    where pree_id = @@pree_id
    set @est_id = @estado_anulado

  end else begin

    update PresupuestoEnvio set est_id = @estado_pendiente, pree_pendiente = pree_total
    where pree_id = @@pree_id

    exec sp_DocPresupuestoEnvioSetEstado @@pree_id,0,@est_id out

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

  exec sp_AuditoriaAnularCheckDocPREE  @@pree_id,
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

  update PresupuestoEnvio set modificado = getdate(), modifico = @@us_id  where pree_id = @@pree_id

  if @@anular <> 0 exec sp_HistoriaUpdate 15009, @@pree_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 15009, @@pree_id, @@us_id, 8

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado del presupuesto. sp_DocPresupuestoEnvioAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  

end