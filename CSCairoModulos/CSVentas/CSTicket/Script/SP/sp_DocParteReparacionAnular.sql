if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionAnular]

go

create procedure sp_DocParteReparacionAnular (
  @@us_id       int,
  @@prp_id       int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

  if @@prp_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id           int
  declare @estado_pendiente int set @estado_pendiente = 1
  declare @estado_anulado   int set @estado_anulado   = 7

  -- No se puede des-anular un parte de reparación que mueve Stock
  --
  if @@anular = 0 begin
    if exists(select prp_id from ParteReparacion prp 
              inner join Documento d on prp.doc_id = d.doc_id 
              where prp_id = @@prp_id and doc_muevestock <> 0) 
    begin
      goto MueveStock
    end
  end

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@anular <> 0 begin

    update ParteReparacion set est_id = @estado_anulado
    where prp_id = @@prp_id
    set @est_id = @estado_anulado

    -- Borro el movimiento de stock asociado a este parte de reparación
    declare @st_id int
  
    select @st_id = st_id from ParteReparacion where prp_id = @@prp_id
    update ParteReparacion set st_id = null where prp_id = @@prp_id
    exec sp_DocStockDelete @st_id,0,0,0,1
    if @@error <> 0 goto ControlError

  end else begin

    update ParteReparacion set est_id = @estado_pendiente
    where prp_id = @@prp_id

    exec sp_DocParteReparacionSetEstado @@prp_id,0,@est_id out

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

  exec sp_AuditoriaAnularCheckDocPRP  @@prp_id,
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

  update ParteReparacion set modificado = getdate(), modifico = @@us_id where prp_id = @@prp_id

  if @@anular <> 0 exec sp_HistoriaUpdate 28007, @@prp_id, @@us_id, 7
  else             exec sp_HistoriaUpdate 28007, @@prp_id, @@us_id, 8

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

  set @MsgError = 'Ha ocurrido un error al actualizar el estado del parte de reparación. sp_DocParteReparacionAnular. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  
  Goto fin

MueveStock:
  raiserror ('@@ERROR_SP:Los documentos que mueven stock no pueden des-anularce.', 16, 1)
  Goto fin

fin:

end