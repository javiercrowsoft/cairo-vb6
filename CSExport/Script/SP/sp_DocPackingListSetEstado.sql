if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListSetEstado]

/*

 sp_DocPackingListSetEstado 21

*/

go
create procedure sp_DocPackingListSetEstado (
  @@pklst_id       int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

  if @@pklst_id = 0 return

  declare @est_id          int
  declare @cli_id          int
  declare @pendiente       decimal (18,6)
  declare @creditoTotal    decimal (18,6)
  declare @llevaFirma     tinyint
  declare @firmado        tinyint
  declare @deuda          decimal (18,6)
  declare @doc_id         int
  declare @doc_llevafirma tinyint

  declare @estado_pendiente         int set @estado_pendiente         =1
  declare @estado_pendienteCredito  int set @estado_pendienteCredito  =3
  declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
  declare @estado_anulado           int set @estado_anulado           =7

  select @cli_id = cli_id, @firmado = pklst_firmado, @est_id = est_id, @doc_id = doc_id
  from PackingList where pklst_id = @@pklst_id

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
      select @deuda = round(sum(pklsti_pendientefac * pklsti_cantidad),2) from PackingListItem where pklst_id = @@pklst_id

      -- Si el comprobante no tiene deuda se finaliza
      if IsNull(@deuda,0)<=0 begin
        set @est_id = @estado_finalizado          
      end else begin
        -- Se obtiene la deuda del cliente
        select @pendiente = sum(clicc_importe) from ClienteCacheCredito where cli_id = @cli_id
        -- Se obtiene el credito del cliente
        select @creditoTotal = cli_creditototal from Cliente where cli_id = @cli_id
        -- Si debe mas que el credito concedido al cliente
        if @pendiente > @creditoTotal begin  
          set @est_id = @estado_pendienteCredito 

        -- sino solo pendiente
        end else begin
          set @est_id = @estado_pendiente  
        end
      end
    end
  
    update PackingList set est_id = @est_id
    where pklst_id = @@pklst_id
  
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del packing list. sp_DocPackingListSetEstado.', 16, 1)

end
GO