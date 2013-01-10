if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraSetCredito]

/*

 sp_DocFacturaCompraSetCredito 27

*/

go
create procedure sp_DocFacturaCompraSetCredito (
  @@fc_id      int,
  @@borrar     tinyint = 0
)
as

begin

  -- Si no hay documento adios
  --
  if @@fc_id = 0 return

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Variables
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  declare @pendiente         decimal(18,6)
  declare @doct_facturaCpra   int
  declare @prov_id           int
  declare @doct_id           int
  declare @emp_id            int

  set @doct_facturaCpra = 2

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
  select @prov_id = prov_id, @doct_id = fc.doct_id, @emp_id = doc.emp_id 
  from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id
  where fc_id = @@fc_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar referencias a este documento por otro proveedor
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  -- Siempre borro cualquier mencion a este documento en el cache de cualquier 
  -- proveedor que no sea el indicado por el documento
  if exists(select prov_id 
            from ProveedorCacheCredito 
             where prov_id  <> @prov_id 
               and doct_id = @doct_facturaCpra 
               and id      = @@fc_id
            ) begin

    declare @oldprov int
    declare c_oldprov insensitive cursor for 
            select prov_id 
            from ProveedorCacheCredito 
             where prov_id  <> @prov_id 
               and doct_id = @doct_facturaCpra 
               and id      = @@fc_id
    open c_oldprov

    delete ProveedorCacheCredito 
           where prov_id  <> @prov_id 
             and doct_id = @doct_facturaCpra 
             and id      = @@fc_id

    fetch next from c_oldprov into @oldprov
    while @@fetch_status=0 begin

      exec sp_ProveedorUpdateCredito @oldprov, @emp_id

      fetch next from c_oldprov into @oldprov
    end
    close c_oldprov
    deallocate c_oldprov

  end

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Borrar
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @@borrar <> 0 begin  

      delete ProveedorCacheCredito 
             where prov_id = @prov_id 
               and doct_id = @doct_facturaCpra 
               and id      = @@fc_id

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Insert - Update
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  end else begin

    select @pendiente = sum(fcd_pendiente) from FacturaCompraDeuda where fc_id = @@fc_id

    set @pendiente = Round(IsNull(@pendiente,0),2)
    update FacturaCompra set fc_pendiente = @pendiente where fc_id = @@fc_id

    if @doct_id = 8 /*nota de credito*/ set @pendiente = -@pendiente
  
    if exists(select id from ProveedorCacheCredito 
              where prov_id  = @prov_id 
                and doct_id = @doct_facturaCpra 
                and id      = @@fc_id) begin
  
      if abs(@pendiente) >= 0.01 begin

        update ProveedorCacheCredito set provcc_importe = @pendiente  
               where prov_id  = @prov_id 
                 and doct_id  = @doct_facturaCpra 
                 and id       = @@fc_id

      -- Si no hay nada pendiente lo saco del cache
      end else begin   

        delete ProveedorCacheCredito 
               where prov_id  = @prov_id 
                 and doct_id  = @doct_facturaCpra 
                 and id       = @@fc_id
      end
  
    end else begin
  
      -- Solo si hay algo pendiente
      if abs(@pendiente) >= 0.01 begin
        insert into ProveedorCacheCredito (prov_id,doct_id,id,provcc_importe,emp_id) 
                                  values(@prov_id, @doct_facturaCpra, @@fc_id, @pendiente, @emp_id)
      end
    end
  end -- Insertar - Actualizar

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Deuda en cache
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  -- Actualizo la deuda en la tabla proveedor
  --
  exec sp_proveedorUpdateCredito @prov_id, @emp_id

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

  raiserror ('Ha ocurrido un error al actualizar el estado de la factura de Compra. sp_DocFacturaCompraSetCredito.', 16, 1)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Transaccion
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  if @bInternalTransaction <> 0 
    rollback transaction  

end