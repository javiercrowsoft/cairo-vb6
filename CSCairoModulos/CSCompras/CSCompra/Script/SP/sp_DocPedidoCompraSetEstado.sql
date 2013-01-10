if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraSetEstado]

/*

select  sum(pci_pendiente) from PedidoCompraItem where pc_id=6

select * from PedidoCompraItem where pc_id=9

  select * from pedidocompra

 sp_DocPedidoCompraSetEstado 9

*/

go
create procedure sp_DocPedidoCompraSetEstado (
  @@pc_id       int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

  if @@pc_id = 0 return

  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  declare @est_id          int
  declare @us_id            int
  declare @pendiente       decimal (18,6)
  declare @creditoTotal    decimal (18,6)
  declare @llevaFirma     tinyint
  declare @firmado        tinyint
  declare @deuda          decimal (18,6)
  declare @doc_id         int
  declare @doc_llevafirma tinyint

  declare @estado_pendiente         int set @estado_pendiente          =1
  declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
  declare @estado_anulado           int set @estado_anulado           =7

  select @us_id = us_id, @firmado = pc_firmado, @est_id = est_id, @doc_id = doc_id
  from PedidoCompra where pc_id = @@pc_id

  select @doc_llevafirma = doc_llevafirma from Documento where doc_id = @doc_id

  if @est_id <> @estado_anulado begin

    -- Si el documento requiere firma y el comprobante no esta firmado
    -- y no esta finalizado (puede ser que se finalizo y luego se modifico el documento
    -- para que requiera firma en cuyo caso no se exige firma para documentos finalizados)
    if @firmado = 0 and @doc_llevafirma <> 0 and @est_id <> @estado_finalizado begin             
      set @est_id = @estado_pendienteFirma 
    end
    else begin                                
      -- Se obtiene la deuda del comprobante
      select @deuda = round(sum(pci_pendiente),2) from PedidoCompraItem where pc_id = @@pc_id

      -- Si el comprobante no tiene deuda se finaliza
      if IsNull(@deuda,0)<=0 begin
        set @est_id = @estado_finalizado          
      end else begin
        set @est_id = @estado_pendiente
      end
    end
  
    if @@trancount = 0 begin
      set @bInternalTransaction = 1
      begin transaction
    end

    update PedidoCompra set est_id = @est_id
    where pc_id = @@pc_id
  
    if @bInternalTransaction <> 0 
      commit transaction
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del pedido de compra. sp_DocPedidoCompraSetEstado.', 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  

end
GO