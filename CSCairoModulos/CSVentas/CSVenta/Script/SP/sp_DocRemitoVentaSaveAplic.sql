if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaSaveAplic]

/*
begin transaction
  exec  sp_DocRemitoVentaSaveAplic 17
rollback transaction

*/

go
create procedure sp_DocRemitoVentaSaveAplic (
  @@rvTMP_id int  
)
as

begin

  set nocount on

  declare @MsgError varchar(5000)

  declare @rv_id         int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @modifico int

  select @rv_id = rv_id, @modifico = modifico from RemitoVentaTMP where rvTMP_id = @@rvTMP_id

  ---------------------------------
  -- Si no hay remito no hago nada
  --
  if @rv_id is null begin

    select @rv_id
    return
  end

  begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        PEDIDOS - REMITOS                                                      //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocRemitoVtaSaveAplic @rv_id, @@rvTMP_id, 1, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocRemitoVentaSetCredito @rv_id
  if @@error <> 0 goto ControlError

  exec sp_DocRemitoVentaSetEstado @rv_id
  if @@error <> 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        VALIDACIONES                                                           //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

    --/////////////////////////////////////////////////////////////////////////////////////////////////
    -- Validaciones
    --

      -- ESTADO
          exec sp_AuditoriaEstadoCheckDocRV    @rv_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError
      
      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocRV  @rv_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError

    --
    --/////////////////////////////////////////////////////////////////////////////////////////////////


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_HistoriaUpdate 16002, @rv_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete RemitoFacturaVentaTMP where rvTMP_ID = @@rvTMP_ID
  delete PedidoRemitoVentaTMP where rvTMP_ID = @@rvTMP_ID
  delete RemitoDevolucionVentaTMP where rvTMP_ID = @@rvTMP_ID
  delete RemitoVentaTMP where rvTMP_ID = @@rvTMP_ID
  delete OrdenRemitoVentaTMP where rvTMP_ID = @@rvTMP_ID

  commit transaction

  select @rv_id

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al grabar la aplicación del remito de venta. sp_DocRemitoVentaSaveAplic. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end

end 

go