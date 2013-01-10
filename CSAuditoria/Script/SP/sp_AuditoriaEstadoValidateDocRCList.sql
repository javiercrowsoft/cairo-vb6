-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocRCList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocRCList]

go

create procedure sp_AuditoriaEstadoValidateDocRCList (

  @@rc_id       int

)
as

begin

  set nocount on

  declare @doct_id      int
  declare @rc_nrodoc     varchar(50) 
  declare @rc_numero     varchar(50) 

  select 
            @doct_id     = doct_id,
            @rc_nrodoc  = rc_nrodoc,
            @rc_numero  = convert(varchar,rc_numero)

  from RemitoCompra where rc_id = @@rc_id

  select rc_id, rci_id, rci_cantidadaremitir, rci_pendientefac,
         IsNull(
            (select sum(rcfc_cantidad) from RemitoFacturaCompra 
             where rci_id = rci.rci_id),0)

            as Facturado,

         IsNull(
            (select sum(rcdc_cantidad)   from RemitoDevolucionCompra 
             where 
                   (rci_id_remito      = rci.rci_id and @doct_id = 4)
                or (rci_id_devolucion  = rci.rci_id and @doct_id = 25)
            ),0) 

            as Devoluciones

  from RemitoCompraItem rci
  where (rci_pendientefac + (  IsNull(
                                (select sum(rcfc_cantidad) from RemitoFacturaCompra 
                                 where rci_id = rci.rci_id),0)
                            +  IsNull(
                                (select sum(rcdc_cantidad)   from RemitoDevolucionCompra 
                                 where 
                                       (rci_id_remito      = rci.rci_id and @doct_id = 4)
                                    or (rci_id_devolucion  = rci.rci_id and @doct_id = 25)
                                ),0)
                          ) 
        ) <> rci_cantidadaremitir
  
    and rc_id = @@rc_id  

  select rc_id, rci_id, rci_cantidad, rci_pendiente,
         IsNull(
              (select sum(ocrc_cantidad) from OrdenRemitoCompra 
               where rci_id = rci.rci_id),0)
            as Aplicado

  from RemitoCompraItem rci
  where (rci_pendiente + (    IsNull(
                                (select sum(ocrc_cantidad) from OrdenRemitoCompra 
                                 where rci_id = rci.rci_id),0)
                          ) 
        ) <> rci_cantidad
  
    and rc_id = @@rc_id

end
GO