if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNOMBRE_DOCSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNOMBRE_DOCSetCredito]

/*

NOMBRE_DOC                   reemplazar por el nombre del documento Ej. NOMBRE_TABLA
PARAM_ID                     reemplazar por el id del documento ej @@CAMPO_ID (incluir arrobas)
NOMBRE_TABLA                 reemplazar por el nombre de la tabla ej NOMBRE_TABLA
CAMPO_ID                     reemplazar por el campo ID ej. CAMPO_ID
TEXTO_ERROR                  reemplazar por el texto de error ej. del pedido de venta
DOCT_DOCUMENTO               reemplazar por el tipo de documento ej. @doct_pedidoVta
CAMPO_PENDIENTE              reemplazar por el nombre del campo pv_pendiente
DEUDA_DOC                     reemplazar por el nombre del documento ej. DeudaPedido
ID_DOCUMENTO_TIPO             reemplazar por el ID del documento tipo
                                    select * from documentotipo

TABLA_CLIENTE_PROVEEDOR        reemplazar por Cliente o Proveedor segun el circuito
CAMPO_CLIENTE_PROVEEDOR        reemplazar por cli_ o prov_ segun el circuito
CAMPO_CACHE_CLIENTE_PROVEEDOR  reemplazar por clicc_ o provcc_ segun el circuito

 select * from NOMBRE_TABLA
 select * from NOMBRE_TABLAitem

 sp_col NOMBRE_TABLAitem

 select * from NOMBRE_TABLAtmp
 select * from NOMBRE_TABLAitemtmp
 sp_DocNOMBRE_DOCSetCredito 12
*/

go
create procedure sp_DocNOMBRE_DOCSetCredito (
  PARAM_ID      int,
  @@borrar     tinyint = 0
)
as

begin

  if PARAM_ID = 0 return

  declare @pendiente        decimal(18,6)
  declare DOCT_DOCUMENTO    int
  declare @CAMPO_CLIENTE_PROVEEDORid           int

  set DOCT_DOCUMENTO = ID_DOCUMENTO_TIPO

  declare @bInternalTransaction smallint 
  set bInternalTransaction = 0

  if @@trancount = 0 begin
    set @bInternalTransaction = 1
    begin transaction
  end

  if @@borrar <> 0 begin  

      select @CAMPO_CLIENTE_PROVEEDORid = CAMPO_CLIENTE_PROVEEDORid from NOMBRE_TABLA where CAMPO_ID = PARAM_ID
      delete TABLA_CLIENTE_PROVEEDORCacheCredito 
             where CAMPO_CLIENTE_PROVEEDORid  = @CAMPO_CLIENTE_PROVEEDORid 
               and doct_id = DOCT_DOCUMENTO 
               and id      = PARAM_ID

  end else begin

    select @pendiente = CAMPO_PENDIENTE, @CAMPO_CLIENTE_PROVEEDORid = CAMPO_CLIENTE_PROVEEDORid from NOMBRE_TABLA where CAMPO_ID = PARAM_ID
  
    if exists(select id from TABLA_CLIENTE_PROVEEDORCacheCredito 
              where CAMPO_CLIENTE_PROVEEDORid  = @CAMPO_CLIENTE_PROVEEDORid 
                and doct_id = DOCT_DOCUMENTO 
                and id      = PARAM_ID) begin
  
      if @pendiente > 0 begin

        update TABLA_CLIENTE_PROVEEDORCacheCredito set CAMPO_CACHE_CLIENTE_PROVEEDORimporte = @pendiente  
               where CAMPO_CLIENTE_PROVEEDORid  = @CAMPO_CLIENTE_PROVEEDORid 
                 and doct_id = DOCT_DOCUMENTO 
                 and id      = PARAM_ID

      -- Si no hay nada pendiente lo saco del cache
      end else begin   

        delete TABLA_CLIENTE_PROVEEDORCacheCredito 
               where CAMPO_CLIENTE_PROVEEDORid  = @CAMPO_CLIENTE_PROVEEDORid 
                 and doct_id = DOCT_DOCUMENTO 
                 and id      = PARAM_ID
      end
  
    end else begin
  
      -- Solo si hay algo pendiente
      if @pendiente > 0 begin
        insert into TABLA_CLIENTE_PROVEEDORCacheCredito (CAMPO_CLIENTE_PROVEEDORid,doct_id,id,CAMPO_CACHE_CLIENTE_PROVEEDORimporte) 
                                  values(@CAMPO_CLIENTE_PROVEEDORid, DOCT_DOCUMENTO, PARAM_ID, @pendiente)
      end
    end
  end -- Insertar - Actualizar


  -- Actualizo la deuda en la tabla TABLA_CLIENTE_PROVEEDOR
  declare @DEUDA_DOCAnterior decimal(18,6)
  declare @DEUDA_DOC         decimal(18,6)

  select @DEUDA_DOC = sum(CAMPO_CACHE_CLIENTE_PROVEEDORimporte) from TABLA_CLIENTE_PROVEEDORCacheCredito where doct_id = DOCT_DOCUMENTO and CAMPO_CLIENTE_PROVEEDORid = @CAMPO_CLIENTE_PROVEEDORid
  select @DEUDA_DOCAnterior = CAMPO_CLIENTE_PROVEEDORDEUDA_DOC from TABLA_CLIENTE_PROVEEDOR where CAMPO_CLIENTE_PROVEEDORid = @CAMPO_CLIENTE_PROVEEDORid
  update TABLA_CLIENTE_PROVEEDOR set 
                    CAMPO_CLIENTE_PROVEEDORDEUDA_DOC   = @DEUDA_DOC, 
                    CAMPO_CLIENTE_PROVEEDORdeudaTotal     = CAMPO_CLIENTE_PROVEEDORdeudaTotal - @DEUDA_DOCAnterior + @DEUDA_DOC
        where CAMPO_CLIENTE_PROVEEDORid = @CAMPO_CLIENTE_PROVEEDORid

  if @bInternalTransaction <> 0 
    commit transaction

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado TEXTO_ERROR. sp_DocNOMBRE_DOCSetCredito.', 16, 1)

  if @bInternalTransaction <> 0 
    rollback transaction  

end