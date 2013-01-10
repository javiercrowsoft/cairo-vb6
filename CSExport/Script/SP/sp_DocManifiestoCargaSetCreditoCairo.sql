if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaSetCreditoCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaSetCreditoCairo]

/*

 sp_DocManifiestoCargaSetCreditoCairo 12

*/

go
create procedure sp_DocManifiestoCargaSetCreditoCairo (
  @@mfc_id     int,
  @@borrar     tinyint = 0
)
as

begin

  -- Si no hay documento adios
  --
  if @@mfc_id = 0 return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @pendiente              decimal(18,6)
  declare @doct_ManifiestoCarga    int
  declare @cli_id                 int
  declare @doct_id                int
  declare @emp_id                 int

  set @doct_ManifiestoCarga = 20

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @bInternalTransaction smallint 
  set @bInternalTransaction = 0

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Datos del documento
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  select @cli_id = cli_id, @pendiente = round(mfc_pendiente,2), @doct_id = mf.doct_id, @emp_id = doc.emp_id 
  from ManifiestoCarga mf inner join Documento doc on mf.doc_id = doc.doc_id
  where mfc_id = @@mfc_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar referencias a este documento por otro cliente
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Siempre borro cualquier mencion a este documento en el cache de cualquier 
  -- cliente que no sea el indicado por el documento
  if exists(select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_ManifiestoCarga 
               and id      = @@mfc_id
            ) begin

    declare @oldcli int
    declare c_oldcli insensitive cursor for 
            select cli_id 
            from ClienteCacheCredito 
             where cli_id  <> @cli_id 
               and doct_id = @doct_ManifiestoCarga 
               and id      = @@mfc_id
    open c_oldcli

    delete ClienteCacheCredito 
           where cli_id  <> @cli_id 
             and doct_id = @doct_ManifiestoCarga 
             and id      = @@mfc_id

    fetch next from c_oldcli into @oldcli
    while @@fetch_status=0 begin

      exec sp_clienteUpdateManifiestoCredito @oldcli, @emp_id

      fetch next from c_oldcli into @oldcli
    end
    close c_oldcli
    deallocate c_oldcli

  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @@borrar <> 0 begin  

      delete ClienteCacheCredito 
             where cli_id  = @cli_id 
               and doct_id = @doct_ManifiestoCarga 
               and id      = @@mfc_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Insert - Update
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  end else begin

    if @doct_id = 41 /*devolucion*/ set @pendiente = -@pendiente

    if exists(select id from ClienteCacheCredito 
              where cli_id  = @cli_id 
                and doct_id = @doct_ManifiestoCarga 
                and id      = @@mfc_id) begin
  
      if abs(@pendiente) >= 0.01 begin

        update ClienteCacheCredito set clicc_importe = @pendiente  
               where cli_id  = @cli_id 
                 and doct_id = @doct_ManifiestoCarga 
                 and id      = @@mfc_id

      -- Si no hay nada pendiente lo saco del cache
      end else begin   

        delete ClienteCacheCredito 
               where cli_id  = @cli_id 
                 and doct_id = @doct_ManifiestoCarga 
                 and id      = @@mfc_id
      end
  
    end else begin
  
      -- Solo si hay algo pendiente
      if abs(@pendiente) >= 0.01 begin
        insert into ClienteCacheCredito (cli_id,doct_id,id,clicc_importe,emp_id) 
                                  values(@cli_id, @doct_ManifiestoCarga, @@mfc_id, @pendiente, @emp_id)
      end
    end
  end -- Insertar - Actualizar


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda en cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Actualizo la deuda en la tabla Cliente
  exec sp_clienteUpdateManifiestoCredito @cli_id, @emp_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @bInternalTransaction <> 0 
    commit transaction

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Fin
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Errores
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del manifiesto de carga. sp_DocManifiestoCargaSetCreditoCairo.', 16, 1)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @bInternalTransaction <> 0 
    rollback transaction  

end
go