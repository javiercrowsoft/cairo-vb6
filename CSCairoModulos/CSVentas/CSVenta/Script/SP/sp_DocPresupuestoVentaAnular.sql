if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaAnular]

go
create procedure sp_DocPresupuestoVentaAnular (
  @@us_id       int,
  @@prv_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@prv_id = 0 return

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

    update PresupuestoVenta set est_id = @estado_anulado, prv_pendiente = 0
    where prv_id = @@prv_id
    set @est_id = @estado_anulado

  end else begin

    update PresupuestoVenta set est_id = @estado_pendiente, prv_pendiente = prv_total
    where prv_id = @@prv_id

    exec sp_DocPresupuestoVentaSetEstado @@prv_id,0,@est_id out

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

  exec sp_AuditoriaAnularCheckDocPRV  @@prv_id,
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

  update PresupuestoVenta set modificado = getdate(), modifico = @@us_id where prv_id = @@prv_id

  if @@anular <> 0 exec sp_HistoriaUpdate 16004, @@prv_id, @@prv_id, 7
  else             exec sp_HistoriaUpdate 16004, @@prv_id, @@prv_id, 8

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado del presupuesto de venta. sp_DocPresupuestoVentaAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  

end