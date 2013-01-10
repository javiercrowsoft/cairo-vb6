-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoCheckDocPC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoCheckDocPC]

go

create procedure sp_AuditoriaEstadoCheckDocPC (

  @@pc_id       int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

  declare @bError tinyint

  set @bError     = 0
  set @@bSuccess   = 0
  set @@bErrorMsg = '@@ERROR_SP:'

  declare @doct_id      int
  declare @pc_nrodoc     varchar(50) 
  declare @pc_numero     varchar(50) 
  declare @est_id       int

  select 
            @doct_id     = doct_id,
            @pc_nrodoc  = pc_nrodoc,
            @pc_numero  = convert(varchar,pc_numero),
            @est_id     = est_id

  from PedidoCompra where pc_id = @@pc_id

  if exists(select * from PedidoCompraItem pci
            where (pci_pendiente +  (    IsNull(
                                          (select sum(pcoc_cantidad) from PedidoOrdenCompra 
                                           where pci_id = pci.pci_id),0)
                                      +  IsNull(
                                          (select sum(pcdc_cantidad) from PedidoDevolucionCompra 
                                           where 
                                                 (pci_id_pedido      = pci.pci_id and @doct_id = 6)
                                              or (pci_id_devolucion  = pci.pci_id and @doct_id = 23)
                                          ),0)
                                      + IsNull(
                                          (select sum(pccot_cantidad) from PedidoCotizacionCompra 
                                           where pci_id = pci.pci_id),0)
                                    ) 
                  ) <> pci_cantidadaremitir

              and pc_id = @@pc_id
            )
  begin

      set @bError = 1
      set @@bErrorMsg = @@bErrorMsg + 'El pendiente de los items de este pedido no coincide con la suma de sus aplicaciones' + char(10)

  end

  if     @est_id <> 7 
    and @est_id <> 5 
    and @est_id <> 4 begin

    declare @pc_pendiente  decimal(18,6)

    select 
            @pc_pendiente    = sum(pci_pendiente)

    from PedidoCompraItem where pc_id = @@pc_id

    if @pc_pendiente = 0 begin

        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg + 'El pedido no tiene items pendientes y su estado no es finalizado, o anulado, o pendiente de firma' + char(10)
  
    end

  end

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO