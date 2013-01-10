if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRequiereFirma]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRequiereFirma]

go

/*
select * from facturaventa
  sp_DocRequiereFirma 

*/

create procedure sp_DocRequiereFirma (
  @@Id            int,
  @@doc_id         int
)
as

set nocount on

begin

  declare @doct_id int


  if not exists(select doc_id from Documento where doc_id = @@doc_id and doc_llevaFirma <> 0 or doc_llevaFirmaCredito <> 0)
  begin

    select 0
    return
  end

  select @doct_id = doct_id from Documento where doc_id = @@doc_id

  if @doct_id in (1  , /* Factura de Venta*/
                  7  , /* Nota de Credito Venta*/
                  9  ) /* Nota de Debito Venta*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from FacturaVenta where fv_id = @@id

  end else 

  if @doct_id in (2  , /* Factura de Compra*/
                  8  , /* Nota de Credito Compra*/
                  10) /* Nota de Debito Compra*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from FacturaCompra where fc_id = @@id

  end else

  if @doct_id in (3  , /* Remito de Venta*/
                  24) /* Devolucion Remito Venta*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from RemitoVenta where rv_id = @@id

  end else

  if @doct_id in (4  , /* Remito de Compra*/
                  25) /* Devolucion Remito Compra*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from RemitoCompra where rc_id = @@id

  end else
  if @doct_id in (5  , /* Pedido de Venta*/
                  22) /* Devolucion Pedido Venta*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from PedidoVenta where pv_id = @@id

  end else

  if @doct_id in (6  , /* Pedido de Compra*/
                  23) /* Devolucion Pedido Compra*/
                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from PedidoCompra where pc_id = @@id

  end else

  if @doct_id in (11, /* Presupuesto de Venta*/
                  39) /* Cancelacion de Presupuesto de Venta*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from PresupuestoVenta where prv_id = @@id

  end else
  if @doct_id in (12,  /* Presupuesto de Compra*/
                  40) /* Cancelacion de Presupuesto de Compra*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from PresupuestoCompra where prc_id = @@id

  end else

  if @doct_id    =13   /* Cobranza*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from Cobranza where cobz_id = @@id

  end else

  if @doct_id    =14   /* Transferencia de Stock*/
  begin

    select   0

  end else

  if @doct_id    =15   /* Asiento Contable*/
  begin

    select   0

  end else

  if @doct_id    =16   /* Orden de Pago*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from OrdenPago where opg_id = @@id

  end else

  if @doct_id    =17   /* Deposito Banco*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from DepositoBanco where dbco_id = @@id

  end else

  if @doct_id    =18   /* Presupuesto de Envio*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from PresupuestoEnvio where pree_id = @@id

  end else

  if @doct_id    =19   /* Permiso Embarque*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from PermisoEmbarque where pemb_id = @@id

  end else

  if @doct_id in (20, /* Manifiesto Carga*/
                  41) /* Cancelacion Manifiesto Carga*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from ManifiestoCarga where mfc_id = @@id

  end else

  if @doct_id in (21,  /* Packing List*/
                  31) /* Packing List Devolución*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from PackingList where pklst_id = @@id

  end else

  if @doct_id = 26   /* Movimiento de Fondos*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from MovimientoFondo where mf_id = @@id

  end else

  if @doct_id = 28   /* Recuento Stock*/
  begin

    select   0

  end else

  if @doct_id = 29   /* Despacho de Importacion Temporal*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from ImportacionTemp where impt_id = @@id

  end else

  if @doct_id in (30, /* Parte Producción Kit*/
                  34) /* Parte Desarme Kit*/                                    
  begin

    select   0

  end else

  if @doct_id = 32   /* Presentacion de Cupones*/
                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from DepositoCupon where dcup_id = @@id

  end else

  if @doct_id = 33   /* Resolución de Cupones*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from ResolucionCupon where rcup_id = @@id

  end else

  if @doct_id in (35, /* Orden de Compra*/
                  36) /* Cancelacion de Orden de Compra*/                  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from OrdenCompra where oc_id = @@id

  end else

  if @doct_id in (37, /* Cotizacion de Compra*/
                  38) /* Devolucion de Cotización de Compra*/
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from CotizacionCompra where cot_id = @@id

  end else

  if @doct_id = 42 /* Ordenes de Servicio */

  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from OrdenServicio where os_id = @@id

  end else

  if @doct_id = 42 /* Ordenes de Servicio */
  
  begin

    select   case est_id 
              when 4 then 1
              else        0
            end
    from OrdenServicio where os_id = @@id

  end else

  if @doct_id = 42 /* Ordenes de Servicio */

  begin

    select   0

  end else

  if @doct_id = 43 /* Partes de Reparacion */

  begin

    select   0

  end else

  if @doct_id = 44 /* Transferencia a proveedor */

  begin

    select   0

  end else

  if @doct_id = 45 /* Transferencia a cliente */

  begin

    select   0

  end else

    select   0

end

go
