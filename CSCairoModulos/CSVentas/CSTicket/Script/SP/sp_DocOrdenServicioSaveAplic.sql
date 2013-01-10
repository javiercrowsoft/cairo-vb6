if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioSaveAplic]

/*
begin transaction
  exec  sp_DocOrdenServicioSaveAplic 17
rollback transaction

*/

go
create procedure sp_DocOrdenServicioSaveAplic (
  @@osTMP_id int  
)
as

begin

  set nocount on

  declare @MsgError varchar(5000)

  declare @os_id         int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  declare @modifico int

  select @os_id = os_id, @modifico = modifico from OrdenServicioTMP where osTMP_id = @@osTMP_id

  ---------------------------------
  -- Si no hay remito no hago nada
  --
  if @os_id is null begin

    select @os_id
    return
  end

  begin transaction

  declare @bSuccess      tinyint

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ORDENES DE SERVICIO - REMITOS                                          //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocOrdenSrvSaveAplic @os_id, @@osTMP_id, 1, @bSuccess out

  -- Si fallo al guardar
  if IsNull(@bSuccess,0) = 0 goto ControlError

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        ESTADO                                                                 //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  exec sp_DocOrdenServicioSetCredito @os_id
  if @@error <> 0 goto ControlError

  exec sp_DocOrdenServicioSetEstado @os_id
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
          exec sp_AuditoriaEstadoCheckDocOS    @os_id,
                                              @bSuccess  out,
                                              @MsgError out
        
          -- Si el documento no es valido
          if IsNull(@bSuccess,0) = 0 goto ControlError
      
      -- CREDITO
          exec sp_AuditoriaCreditoCheckDocOS  @os_id,
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

  exec sp_HistoriaUpdate 28008, @os_id, @modifico, 6

/*
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //
//                                        TEMPORALES                                                             //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  delete OrdenRemitoVentaTMP where osTMP_ID = @@osTMP_ID
  delete OrdenServicioTMP where osTMP_ID = @@osTMP_ID

  commit transaction

  select @os_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al grabar la aplicación del orden de servicio. sp_DocOrdenServicioSaveAplic.', 16, 1)
  rollback transaction  

end 

go