if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCAnular]

go
/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. PedidoVenta
PARAM_ID                     reemplazar por el id del documento ej @@pv_id  (incluir arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej PedidoVenta
CAMPO_ID                     reemplazar por el campo ID ej. pv_id
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta

////////////////////////////////////////////////////////////////////////////////////
 select * from estado

1	Pendiente								pend	
2	Pendiente de Despachar	desp	
3	Pendiente de Crédito		cred	
4	Pendiente de Firma			firma	
5	Finalizado							fin	 	
6	Rechazado								rechazado	 	

 sp_DocNOMBRE_DOCAnular xx
*/

create procedure sp_DocNOMBRE_DOCAnular (
	PARAM_ID 			int,
  @@anular      tinyint,
  @@Select      tinyint = 0
)
as

begin

	if PARAM_ID = 0 return

  declare @bInternalTransaction smallint 
  set bInternalTransaction = 0

	declare @est_id           int
	declare @estado_pendiente int set @estado_pendiente = 1
	declare @estado_anulado   int set @estado_anulado   = 7

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
		begin transaction
  end

	if @@anular <> 0 begin

		update NOMBRE_TABLA set est_id = @estado_anulado
		where CAMPO_ID = PARAM_ID
		set @est_id = @estado_anulado

	end else begin

		update NOMBRE_TABLA set est_id = @estado_pendiente
		where CAMPO_ID = PARAM_ID

    exec sp_DocNOMBRE_TABLASetEstado PARAM_ID,0,@est_id out

  end
  
	if @bInternalTransaction <> 0 
		commit transaction

	if @@Select <> 0 begin
		select est_id, est_nombre from Estado where est_id = @est_id
	end

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el estado TEXTO_ERROR. sp_DocNOMBRE_DOCAnular.', 16, 1)

	if @bInternalTransaction <> 0 
		rollback transaction	

end