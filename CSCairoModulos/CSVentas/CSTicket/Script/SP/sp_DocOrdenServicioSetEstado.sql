if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioSetEstado]

/*

 sp_DocOrdenServicioSetEstado 21

*/

go
create procedure sp_DocOrdenServicioSetEstado (
  @@os_id       int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

  if @@os_id = 0 return

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

  select @cli_id = cli_id, @firmado = os_firmado, @est_id = est_id, @doc_id = doc_id
  from OrdenServicio where os_id = @@os_id

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
      select @deuda = round(sum(osi_pendiente),2) from OrdenServicioItem where os_id = @@os_id

      -- Si el comprobante no tiene deuda se finaliza
      if IsNull(@deuda,0)<=0 begin
        set @est_id = @estado_finalizado          
      end else begin
        -- Se obtiene la deuda del Cliente
        select @pendiente = sum(clicc_importe) from ClienteCacheCredito where cli_id = @cli_id
        -- Se obtiene el credito del Cliente
        select @creditoTotal = cli_creditototal from Cliente where cli_id = @cli_id
        -- Si debe mas que el credito concedido al Cliente
        if @pendiente > @creditoTotal begin  
          set @est_id = @estado_pendienteCredito 

        -- sino solo pendiente
        end else begin
          set @est_id = @estado_pendiente  
        end
      end
    end
  
    update OrdenServicio set est_id = @est_id
    where os_id = @@os_id
  
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado de la orden de servicio. sp_DocOrdenServicioSetEstado.', 16, 1)

end
GO