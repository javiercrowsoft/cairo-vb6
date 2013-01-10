if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_empresaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_empresaDelete]

/*

TODO:

 sp_empresaDelete 4,1,null,null,-1

- FacturaVentaDeuda/Pago, y FacturaCompraDeuda/Pago deben regenerarce 
  cuando se modifica la aplicacion entre facturas cobranzas y ordenes de pago

*/

go
create procedure sp_empresaDelete (
  @@emp_id     int,
  @@us_id     int,
  @@fdesde     datetime = null,
  @@fhasta    datetime = null,
  @@soloDoc   smallint  = 1
)
as

begin

  set nocount on

  declare @controlstock varchar(50)

  select @controlstock = cfg_valor from configuracion where cfg_aspecto = 'Tipo Control Stock'

  update configuracion set cfg_valor = 2 where cfg_aspecto = 'Tipo Control Stock'

  --// si quiere borrar la empresa se hacen cosas drasticas
  --
  if @@solodoc = 0 
  begin
    update Documento set doc_editarimpresos = 1 where emp_id = @@emp_id
    update MovimientoFondo set est_id = 1 
    where doc_id in (select doc_id from Documento where emp_id = @@emp_id)

    update StockItem set prns_id = null
    where st_id in (select st_id from Stock 
                    where doc_id in (select doc_id from Documento  
                                      where emp_id = @@emp_id)
                    )
  end
-----------------------------------------------------------------------------------------------------------------------------------------
--select 'declare @@'+doct_codigo+ ' int set @@'+ doct_codigo +'='+convert(varchar,doct_id)+' --'+doct_nombre from documentotipo order by 1
-----------------------------------------------------------------------------------------------------------------------------------------
declare @@AC       int set @@AC=15       --Asiento Contable
declare @@COBZ     int set @@COBZ=13      --Cobranza
declare @@DBCO     int set @@DBCO=17     --Deposito Banco
declare @@DIT     int set @@DIT=29       --Despacho de Importacion Temporal
declare @@DVoc     int set @@DVoc=23     --Devolucion Pedido Compra
declare @@DVPV     int set @@DVPV=22     --Devolucion Pedido Venta
declare @@DVRC     int set @@DVRC=25     --Devolucion Remito Compra
declare @@DVRV     int set @@DVRV=24     --Devolucion Remito Venta
declare @@FC       int set @@FC=2         --Factura de Compra
declare @@FV       int set @@FV=1         --Factura de Venta
declare @@MF       int set @@MF=26       --Movimiento de Fondos
declare @@MFC     int set @@MFC=20       --Manifiesto Carga
declare @@NCC     int set @@NCC=8       --Nota de Credito Compra
declare @@NCV     int set @@NCV=7       --Nota de Credito Venta
declare @@NDC     int set @@NDC=10       --Nota de Debito Compra
declare @@NDV     int set @@NDV=9       --Nota de Debito Venta
declare @@OPG      int set @@OPG=16       --Orden de Pago
declare @@PC       int set @@PC=6        --Pedido de Compra 
declare @@OC       int set @@OC=35        --Pedido de Compra 
declare @@PCUP     int set @@PCUP=32     --Presentación de Cupones
declare @@PERE     int set @@PERE=19     --Permiso Embarque
declare @@PKLST   int set @@PKLST=21     --Packing List
declare @@PPK     int set @@PPK=30       --Parte Producción Kit
declare @@PREC     int set @@PREC=12     --Presupuesto de Compra
declare @@PREE     int set @@PREE=18     --Presupuesto de Envio
declare @@PREV     int set @@PREV=11     --Presupuesto de Venta
declare @@PV       int set @@PV=5         --Pedido de Venta
declare @@RC       int set @@RC=4         --Remito de Compra
declare @@RCUP     int set @@RCUP=33     --Resolución de Cupones
declare @@RS       int set @@RS=28       --Recuento Stock
declare @@RV       int set @@RV=3         --Remito de Venta
declare @@TSTK     int set @@TSTK=14     --Trasferencia de Stock


  -- Borrar los documentos
  --
    create table #docEstado(comp_id int, doct_id int)
    declare @id         int
    declare @doct_id    int

    -- Aplicaciones
    --

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Pedido Remito Venta
        --

        -- Pedidos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rvi.rv_id,@@RV 
        from PedidoRemitoVenta pvrv inner join PedidoVentaItem pvi on pvrv.pvi_id = pvi.pvi_id
                                    inner join RemitoVentaItem rvi on pvrv.rvi_id = rvi.rvi_id
                                    inner join PedidoVenta pv      on pvi.pv_id   = pv.pv_id
                                    inner join Documento d         on pv.doc_id   = d.doc_id 
        where   (    (pv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoRemitoVenta 
        where pvi_id in ( select pvi_id 
                          from PedidoVenta pv inner join PedidoVentaItem pvi  on pv.pv_id  = pvi.pv_id
                                              inner join Documento d           on pv.doc_id = d.doc_id 
                          where   (    (pv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Remitos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pv_id,@@PV 
        from PedidoRemitoVenta pvrv inner join RemitoVentaItem rvi on pvrv.rvi_id = rvi.rvi_id
                                    inner join PedidoVentaItem pvi on pvrv.pvi_id = pvi.pvi_id
                                    inner join RemitoVenta rv      on rvi.rv_id   = rv.rv_id
                                    inner join Documento d         on rv.doc_id   = d.doc_id 
        where   (    (rv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoRemitoVenta 
        where rvi_id in ( select rvi_id 
                          from RemitoVenta rv inner join RemitoVentaItem rvi  on rv.rv_id  = rvi.rv_id
                                              inner join Documento d           on rv.doc_id = d.doc_id 
                          where   (    (rv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Pedido Orden Compra
        --

        -- Pedidos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct oci.oc_id, @@oc
        from PedidoOrdenCompra pcoc inner join PedidoCompraItem pci  on pcoc.pci_id = pci.pci_id
                                    inner join OrdenCompraItem oci   on pcoc.oci_id = oci.oci_id
                                    inner join PedidoCompra pc       on pci.pc_id   = pc.pc_id
                                    inner join Documento d           on pc.doc_id   = d.doc_id 
        where   (    (pc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoOrdenCompra 
        where pci_id in ( select pci_id 
                          from PedidoCompra pc inner join PedidoCompraItem pci  on pc.pc_id = pci.pc_id
                                               inner join Documento d           on pc.doc_id = d.doc_id 
                          where   (    (pc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Ordenes
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pc_id,@@pc
        from PedidoOrdenCompra pcoc inner join OrdenCompraItem oci  on pcoc.oci_id = oci.oci_id
                                    inner join PedidoCompraItem pci on pcoc.pci_id = pci.pci_id
                                    inner join OrdenCompra oc       on oci.oc_id   = oc.oc_id
                                    inner join Documento d          on oc.doc_id   = d.doc_id 
        where   (    (oc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoOrdenCompra 
        where oci_id in ( select oci_id 
                          from OrdenCompra oc inner join OrdenCompraItem oci  on oc.oc_id  = oci.oc_id
                                              inner join Documento d           on oc.doc_id = d.doc_id 
                          where   (    (oc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Orden Remito Compra
        --

        -- Ordenes
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rci.rc_id, @@RC
        from OrdenRemitoCompra ocrc inner join OrdenCompraItem oci  on ocrc.oci_id = oci.oci_id
                                    inner join RemitoCompraItem rci on ocrc.rci_id = rci.rci_id
                                    inner join OrdenCompra oc       on oci.oc_id   = oc.oc_id
                                    inner join Documento d          on oc.doc_id   = d.doc_id 
        where   (    (oc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete OrdenRemitoCompra 
        where oci_id in ( select oci_id 
                          from OrdenCompra oc inner join OrdenCompraItem oci  on oc.oc_id = oci.oc_id
                                               inner join Documento d           on oc.doc_id = d.doc_id 
                          where   (    (oc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Remitos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct oc_id,@@OC
        from OrdenRemitoCompra ocrc inner join RemitoCompraItem rci on ocrc.rci_id = rci.rci_id
                                     inner join OrdenCompraItem oci on ocrc.oci_id = oci.oci_id
                                     inner join RemitoCompra rc      on rci.rc_id   = rc.rc_id
                                     inner join Documento d          on rc.doc_id   = d.doc_id 
        where   (    (rc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete OrdenRemitoCompra 
        where rci_id in ( select rci_id 
                          from RemitoCompra rc inner join RemitoCompraItem rci  on rc.rc_id  = rci.rc_id
                                               inner join Documento d           on rc.doc_id = d.doc_id 
                          where   (    (rc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Pedido Factura Venta
        --

        -- Pedidos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fv_id,@@FV 
        from PedidoFacturaVenta pvfv inner join PedidoVentaItem pvi  on pvfv.pvi_id = pvi.pvi_id
                                     inner join FacturaVentaItem fvi on pvfv.fvi_id = fvi.fvi_id
                                     inner join PedidoVenta pv       on pvi.pv_id   = pv.pv_id
                                     inner join Documento d          on pv.doc_id   = d.doc_id 
        where   (    (pv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoFacturaVenta 
        where pvi_id in ( select pvi_id 
                          from PedidoVenta pv inner join PedidoVentaItem pvi  on pv.pv_id  = pvi.pv_id
                                              inner join Documento d           on pv.doc_id = d.doc_id 
                          where   (    (pv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pv_id,@@PV 
        from PedidoFacturaVenta pvfv inner join FacturaVentaItem fvi on pvfv.fvi_id = fvi.fvi_id
                                     inner join PedidoVentaItem pvi  on pvfv.pvi_id = pvi.pvi_id
                                     inner join FacturaVenta fv      on fvi.fv_id   = fv.fv_id
                                     inner join Documento d          on fv.doc_id   = d.doc_id 
        where   (    (fv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoFacturaVenta 
        where fvi_id in ( select fvi_id 
                          from FacturaVenta fv inner join FacturaVentaItem fvi  on fv.fv_id  = fvi.fv_id
                                               inner join Documento d           on fv.doc_id = d.doc_id 
                          where   (    (fv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Orden Factura Compra
        --

        -- Ordenes
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fc_id,@@FC 
        from OrdenFacturaCompra ocfc inner join OrdenCompraItem oci   on ocfc.oci_id = oci.oci_id
                                     inner join FacturaCompraItem fci on ocfc.fci_id = fci.fci_id
                                     inner join OrdenCompra oc        on oci.oc_id   = oc.oc_id
                                     inner join Documento d           on oc.doc_id   = d.doc_id 
        where   (    (oc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete OrdenFacturaCompra 
        where oci_id in ( select oci_id 
                          from OrdenCompra oc inner join OrdenCompraItem oci  on oc.oc_id  = oci.oc_id
                                               inner join Documento d           on oc.doc_id = d.doc_id 
                          where   (    (oc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct oc_id,@@OC 
        from OrdenFacturaCompra ocfc  inner join FacturaCompraItem fci on ocfc.fci_id = fci.fci_id
                                       inner join OrdenCompraItem oci  on ocfc.oci_id = oci.oci_id
                                       inner join FacturaCompra fc      on fci.fc_id   = fc.fc_id
                                       inner join Documento d            on fc.doc_id   = d.doc_id 
        where   (    (fc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete OrdenFacturaCompra 
        where fci_id in ( select fci_id 
                          from FacturaCompra fc  inner join FacturaCompraItem fci  on fc.fc_id  = fci.fc_id
                                                 inner join Documento d            on fc.doc_id = d.doc_id 
                          where   (    (fc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Devolucion Venta
        --

        -- Pedidos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pvid.pv_id,@@PV 
        from PedidoDevolucionVenta pvpd inner join PedidoVentaItem pvi      on pvpd.pvi_id_pedido     = pvi.pvi_id
                                        inner join PedidoVentaItem pvid     on pvpd.pvi_id_devolucion = pvid.pvi_id
                                        inner join PedidoVenta pv           on pvi.pv_id               = pv.pv_id
                                        inner join Documento d              on pv.doc_id               = d.doc_id 
        where   (    (pv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoDevolucionVenta 
        where pvi_id_pedido in (select pvi_id 
                                from PedidoVenta pv inner join PedidoVentaItem pvi  on pv.pv_id  = pvi.pv_id
                                                    inner join Documento d           on pv.doc_id = d.doc_id 
                                where   (    (pv_fecha between @@fdesde and @@fhasta)
                                        or  (@@fdesde is null and @@fhasta is null)
                                        )
                                    and d.emp_id = @@emp_id
                              )

        -- Devoluciones
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pvi.pv_id,@@PV 
        from PedidoDevolucionVenta pvpd inner join PedidoVentaItem pvid     on pvpd.pvi_id_devolucion = pvid.pvi_id
                                        inner join PedidoVentaItem pvi      on pvpd.pvi_id_pedido     = pvi.pvi_id
                                        inner join PedidoVenta pv           on pvid.pv_id             = pv.pv_id
                                        inner join Documento d              on pv.doc_id               = d.doc_id 
        where   (    (pv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoDevolucionVenta 
        where pvi_id_devolucion in (select pvi_id 
                                    from PedidoVenta pv inner join PedidoVentaItem pvi  on pv.pv_id  = pvi.pv_id
                                                        inner join Documento d           on pv.doc_id = d.doc_id 
                                    where   (    (pv_fecha between @@fdesde and @@fhasta)
                                            or  (@@fdesde is null and @@fhasta is null)
                                            )
                                        and d.emp_id = @@emp_id
                                    )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Devolucion Pedidos de Compra
        --

        -- Pedidos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pcid.pc_id,@@OC 
        from PedidoDevolucionCompra pcpd inner join PedidoCompraItem pci    on pcpd.pci_id_Pedido     = pci.pci_id
                                         inner join PedidoCompraItem pcid   on pcpd.pci_id_devolucion = pcid.pci_id
                                         inner join PedidoCompra pc         on pci.pc_id               = pc.pc_id
                                         inner join Documento d              on pc.doc_id               = d.doc_id 
        where   (    (pc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoDevolucionCompra 
        where pci_id_Pedido in (select pci_id 
                                from PedidoCompra pc inner join PedidoCompraItem pci  on pc.pc_id  = pci.pc_id
                                                     inner join Documento d           on pc.doc_id = d.doc_id 
                                where   (    (pc_fecha between @@fdesde and @@fhasta)
                                        or  (@@fdesde is null and @@fhasta is null)
                                        )
                                    and d.emp_id = @@emp_id
                              )

        -- Devoluciones
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pci.pc_id,@@OC 
        from PedidoDevolucionCompra pcpd  inner join PedidoCompraItem pcid     on pcpd.pci_id_devolucion = pcid.pci_id
                                          inner join PedidoCompraItem pci      on pcpd.pci_id_Pedido      = pci.pci_id
                                          inner join PedidoCompra pc            on pcid.pc_id              = pc.pc_id
                                          inner join Documento d               on pc.doc_id              = d.doc_id 
        where   (    (pc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoDevolucionCompra 
        where pci_id_devolucion in (select pci_id 
                                    from PedidoCompra pc inner join PedidoCompraItem pci  on pc.pc_id  = pci.pc_id
                                                         inner join Documento d           on pc.doc_id = d.doc_id 
                                    where   (    (pc_fecha between @@fdesde and @@fhasta)
                                            or  (@@fdesde is null and @@fhasta is null)
                                            )
                                        and d.emp_id = @@emp_id
                                    )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Devolucion Ordenes de Compra
        --

        -- Ordenes
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct ocid.oc_id,@@OC 
        from OrdenDevolucionCompra ocpd inner join OrdenCompraItem oci      on ocpd.oci_id_orden       = oci.oci_id
                                        inner join OrdenCompraItem ocid     on ocpd.oci_id_devolucion = ocid.oci_id
                                        inner join OrdenCompra oc           on oci.oc_id               = oc.oc_id
                                        inner join Documento d              on oc.doc_id               = d.doc_id 
        where   (    (oc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete OrdenDevolucionCompra 
        where oci_id_orden in (select oci_id 
                                from OrdenCompra oc inner join OrdenCompraItem oci  on oc.oc_id  = oci.oc_id
                                                    inner join Documento d           on oc.doc_id = d.doc_id 
                                where   (    (oc_fecha between @@fdesde and @@fhasta)
                                        or  (@@fdesde is null and @@fhasta is null)
                                        )
                                    and d.emp_id = @@emp_id
                              )

        -- Devoluciones
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct oci.oc_id,@@OC 
        from OrdenDevolucionCompra ocpd  inner join OrdenCompraItem ocid     on ocpd.oci_id_devolucion = ocid.oci_id
                                         inner join OrdenCompraItem oci      on ocpd.oci_id_orden      = oci.oci_id
                                         inner join OrdenCompra oc            on ocid.oc_id              = oc.oc_id
                                         inner join Documento d               on oc.doc_id              = d.doc_id 
        where   (    (oc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete OrdenDevolucionCompra 
        where oci_id_devolucion in (select oci_id 
                                    from OrdenCompra oc inner join OrdenCompraItem oci  on oc.oc_id  = oci.oc_id
                                                        inner join Documento d           on oc.doc_id = d.doc_id 
                                    where   (    (oc_fecha between @@fdesde and @@fhasta)
                                            or  (@@fdesde is null and @@fhasta is null)
                                            )
                                        and d.emp_id = @@emp_id
                                    )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Pedido PackingList
        --

        -- Pedidos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pklst_id,@@PKLST 
        from PedidoPackingList pvpklst  inner join PedidoVentaItem pvi     on pvpklst.pvi_id = pvi.pvi_id
                                        inner join PackingListItem pklsti on pvpklst.pklsti_id = pklsti.pklsti_id
                                        inner join PedidoVenta pv          on pvi.pv_id   = pv.pv_id
                                        inner join Documento d             on pv.doc_id   = d.doc_id 
        where   (    (pv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoPackingList 
        where pvi_id in ( select pvi_id 
                          from PedidoVenta pv inner join PedidoVentaItem pvi  on pv.pv_id  = pvi.pv_id
                                              inner join Documento d           on pv.doc_id = d.doc_id 
                          where   (    (pv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- PackingList
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pv_id,@@PV 
        from PedidoPackingList pvpklst  inner join PackingListItem pklsti on pvpklst.pklsti_id = pklsti.pklsti_id
                                        inner join PedidoVentaItem pvi     on pvpklst.pvi_id    = pvi.pvi_id
                                        inner join PackingList pklst      on pklsti.pklst_id   = pklst.pklst_id
                                        inner join Documento d             on pklst.doc_id      = d.doc_id 
        where   (    (pklst_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PedidoPackingList 
        where pklsti_id in ( select pklsti_id 
                          from PackingList pklst inner join PackingListItem pklsti  on pklst.pklst_id = pklsti.pklst_id
                                                 inner join Documento d             on pklst.doc_id   = d.doc_id 
                          where   (    (pklst_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Remito Factura Venta
        --

        -- Remitos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fv_id,@@FV 
        from RemitoFacturaVenta rvfv inner join RemitoVentaItem rvi  on rvfv.rvi_id = rvi.rvi_id
                                     inner join FacturaVentaItem fvi on rvfv.fvi_id = fvi.fvi_id
                                     inner join RemitoVenta rv       on rvi.rv_id   = rv.rv_id
                                     inner join Documento d          on rv.doc_id   = d.doc_id 
        where   (    (rv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoFacturaVenta 
        where rvi_id in ( select rvi_id 
                          from RemitoVenta rv inner join RemitoVentaItem rvi  on rv.rv_id  = rvi.rv_id
                                              inner join Documento d           on rv.doc_id = d.doc_id 
                          where   (    (rv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rvi.rv_id,@@RV 
        from RemitoFacturaVenta rvfv inner join FacturaVentaItem fvi on rvfv.fvi_id = fvi.fvi_id
                                     inner join RemitoVentaItem rvi  on rvfv.rvi_id = rvi.rvi_id
                                     inner join FacturaVenta fv      on fvi.fv_id   = fv.fv_id
                                     inner join Documento d          on fv.doc_id   = d.doc_id 
        where   (    (fv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoFacturaVenta 
        where fvi_id in ( select fvi_id 
                          from FacturaVenta fv inner join FacturaVentaItem fvi  on fv.fv_id  = fvi.fv_id
                                               inner join Documento d           on fv.doc_id = d.doc_id 
                          where   (    (fv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Remito Factura Compra
        --

        -- Remitos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fc_id,@@FC 
        from RemitoFacturaCompra rcfc inner join RemitoCompraItem rci  on rcfc.rci_id = rci.rci_id
                                       inner join FacturaCompraItem fci on rcfc.fci_id = fci.fci_id
                                       inner join RemitoCompra rc       on rci.rc_id   = rc.rc_id
                                       inner join Documento d           on rc.doc_id   = d.doc_id 
        where   (    (rc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoFacturaCompra 
        where rci_id in ( select rci_id 
                          from RemitoCompra rc inner join RemitoCompraItem rci  on rc.rc_id  = rci.rc_id
                                               inner join Documento d           on rc.doc_id = d.doc_id 
                          where   (    (rc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rci.rc_id,@@RC 
        from RemitoFacturaCompra rcfc  inner join FacturaCompraItem fci on rcfc.fci_id = fci.fci_id
                                       inner join RemitoCompraItem rci  on rcfc.rci_id = rci.rci_id
                                       inner join FacturaCompra fc      on fci.fc_id   = fc.fc_id
                                       inner join Documento d            on fc.doc_id   = d.doc_id 
        where   (    (fc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoFacturaCompra 
        where fci_id in ( select fci_id 
                          from FacturaCompra fc  inner join FacturaCompraItem fci  on fc.fc_id  = fci.fc_id
                                                 inner join Documento d            on fc.doc_id = d.doc_id 
                          where   (    (fc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Devolucion Venta
        --

        -- Remitos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rvid.rv_id,@@RV 
        from RemitoDevolucionVenta rvpd inner join RemitoVentaItem rvi      on rvpd.rvi_id_Remito     = rvi.rvi_id
                                        inner join RemitoVentaItem rvid     on rvpd.rvi_id_devolucion = rvid.rvi_id
                                        inner join RemitoVenta rv           on rvi.rv_id               = rv.rv_id
                                        inner join Documento d              on rv.doc_id               = d.doc_id 
        where   (    (rv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoDevolucionVenta 
        where rvi_id_Remito in (select rvi_id 
                                from RemitoVenta rv inner join RemitoVentaItem rvi  on rv.rv_id  = rvi.rv_id
                                                    inner join Documento d           on rv.doc_id = d.doc_id 
                                where   (    (rv_fecha between @@fdesde and @@fhasta)
                                        or  (@@fdesde is null and @@fhasta is null)
                                        )
                                    and d.emp_id = @@emp_id
                              )

        -- Devoluciones
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rvi.rv_id,@@RV 
        from RemitoDevolucionVenta rvpd inner join RemitoVentaItem rvid     on rvpd.rvi_id_devolucion = rvid.rvi_id
                                        inner join RemitoVentaItem rvi      on rvpd.rvi_id_Remito     = rvi.rvi_id
                                        inner join RemitoVenta rv           on rvid.rv_id             = rv.rv_id
                                        inner join Documento d              on rv.doc_id               = d.doc_id 
        where   (    (rv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoDevolucionVenta 
        where rvi_id_devolucion in (select rvi_id 
                                    from RemitoVenta rv inner join RemitoVentaItem rvi  on rv.rv_id  = rvi.rv_id
                                                        inner join Documento d           on rv.doc_id = d.doc_id 
                                    where   (    (rv_fecha between @@fdesde and @@fhasta)
                                            or  (@@fdesde is null and @@fhasta is null)
                                            )
                                        and d.emp_id = @@emp_id
                                    )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Devolucion Compra
        --

        -- Remitos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rcid.rc_id,@@RC 
        from RemitoDevolucionCompra rcpd inner join RemitoCompraItem rci      on rcpd.rci_id_Remito     = rci.rci_id
                                         inner join RemitoCompraItem rcid     on rcpd.rci_id_devolucion = rcid.rci_id
                                         inner join RemitoCompra rc           on rci.rc_id               = rc.rc_id
                                         inner join Documento d                on rc.doc_id               = d.doc_id 
        where   (    (rc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoDevolucionCompra 
        where rci_id_Remito in (select rci_id 
                                from RemitoCompra rc inner join RemitoCompraItem rci  on rc.rc_id  = rci.rc_id
                                                     inner join Documento d           on rc.doc_id = d.doc_id 
                                where   (    (rc_fecha between @@fdesde and @@fhasta)
                                        or  (@@fdesde is null and @@fhasta is null)
                                        )
                                    and d.emp_id = @@emp_id
                              )

        -- Devoluciones
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct rci.rc_id,@@RC 
        from RemitoDevolucionCompra rcpd  inner join RemitoCompraItem rcid     on rcpd.rci_id_devolucion = rcid.rci_id
                                          inner join RemitoCompraItem rci      on rcpd.rci_id_Remito     = rci.rci_id
                                          inner join RemitoCompra rc            on rcid.rc_id             = rc.rc_id
                                          inner join Documento d               on rc.doc_id               = d.doc_id 
        where   (    (rc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete RemitoDevolucionCompra 
        where rci_id_devolucion in (select rci_id 
                                    from RemitoCompra rc inner join RemitoCompraItem rci  on rc.rc_id  = rci.rc_id
                                                         inner join Documento d           on rc.doc_id = d.doc_id 
                                    where   (    (rc_fecha between @@fdesde and @@fhasta)
                                            or  (@@fdesde is null and @@fhasta is null)
                                            )
                                        and d.emp_id = @@emp_id
                                    )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Factura Cobranza
        --

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct cobz_id,@@COBZ
        from FacturaVentaCobranza fvcobz  inner join FacturaVenta fv     on fvcobz.fv_id  = fv.fv_id
                                          inner join Documento d         on fv.doc_id     = d.doc_id 
        where   (    (fv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaVentaCobranza 
        where fv_id in ( select fv_id 
                          from FacturaVenta fv inner join Documento d  on fv.doc_id = d.doc_id 
                          where   (    (fv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- Cobranzas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fv_id,@@FV 
        from FacturaVentaCobranza fvcobz  inner join Cobranza cobz  on fvcobz.cobz_id = cobz.cobz_id
                                          inner join Documento d    on cobz.doc_id    = d.doc_id 
        where   (    (cobz_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaVentaCobranza 
        where cobz_id in ( select cobz_id 
                            from Cobranza cobz  inner join Documento d on cobz.doc_id = d.doc_id 
                            where   (    (cobz_fecha between @@fdesde and @@fhasta)
                                    or  (@@fdesde is null and @@fhasta is null)
                                    )
                                and d.emp_id = @@emp_id
                          )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Factura OrdenPago
        --

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fcopg.opg_id,@@OPG
        from FacturaCompraOrdenPago fcopg  inner join FacturaCompra fc     on fcopg.fc_id  = fc.fc_id
                                          inner join Documento d         on fc.doc_id     = d.doc_id 
        where   (    (fc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaCompraOrdenPago 
        where fc_id in ( select fc_id 
                          from FacturaCompra fc inner join Documento d  on fc.doc_id = d.doc_id 
                          where   (    (fc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- OrdenPagos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fcopg.fc_id,@@FC 
        from FacturaCompraOrdenPago fcopg  inner join OrdenPago opg  on fcopg.opg_id = opg.opg_id
                                          inner join Documento d     on opg.doc_id    = d.doc_id 
        where   (    (opg_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaCompraOrdenPago 
        where opg_id in ( select opg_id 
                            from OrdenPago opg  inner join Documento d on opg.doc_id = d.doc_id 
                            where   (    (opg_fecha between @@fdesde and @@fhasta)
                                    or  (@@fdesde is null and @@fhasta is null)
                                    )
                                and d.emp_id = @@emp_id
                          )


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Factura Venta Nota de Credito
        --

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fv_id,@@FV
        from FacturaVentaNotaCredito fvnc inner join FacturaVenta fv     on fvnc.fv_id_factura  = fv.fv_id
                                          inner join Documento d         on fv.doc_id           = d.doc_id 
        where   (    (fv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaVentaNotaCredito 
        where fv_id_factura in ( select fv_id 
                                  from FacturaVenta fv inner join Documento d  on fv.doc_id = d.doc_id 
                                  where   (    (fv_fecha between @@fdesde and @@fhasta)
                                          or  (@@fdesde is null and @@fhasta is null)
                                          )
                                      and d.emp_id = @@emp_id
                                )

        -- Notas de Credito
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fv_id,@@FV 
        from FacturaVentaNotaCredito fvnc inner join FacturaVenta fv    on fvnc.fv_id_notacredito = fv.fv_id
                                          inner join Documento d        on fv.doc_id              = d.doc_id 
        where   (    (fv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaVentaNotaCredito 
        where fv_id_notacredito in ( select fv_id 
                                      from FacturaVenta fv  inner join Documento d on fv.doc_id = d.doc_id 
                                      where   (    (fv_fecha between @@fdesde and @@fhasta)
                                              or  (@@fdesde is null and @@fhasta is null)
                                              )
                                          and d.emp_id = @@emp_id
                                    )
        -- Pagos
        --
        delete FacturaVentaPago
        where fv_id in ( select fv_id 
                          from FacturaVenta fv  inner join Documento d on fv.doc_id = d.doc_id 
                          where   (    (fv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Factura Compra Nota de Credito
        --

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fc_id,@@FC
        from FacturaCompraNotaCredito fcnc inner join FacturaCompra fc    on fcnc.fc_id_factura  = fc.fc_id
                                           inner join Documento d         on fc.doc_id           = d.doc_id 
        where   (    (fc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaCompraNotaCredito 
        where fc_id_factura in ( select fc_id 
                                  from FacturaCompra fc inner join Documento d  on fc.doc_id = d.doc_id 
                                  where   (    (fc_fecha between @@fdesde and @@fhasta)
                                          or  (@@fdesde is null and @@fhasta is null)
                                          )
                                      and d.emp_id = @@emp_id
                                )

        -- Notas de Credito
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fc_id,@@FC 
        from FacturaCompraNotaCredito fcnc inner join FacturaCompra fc   on fcnc.fc_id_notacredito = fc.fc_id
                                           inner join Documento d        on fc.doc_id              = d.doc_id 
        where   (    (fc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete FacturaCompraNotaCredito 
        where fc_id_notacredito in ( select fc_id 
                                      from FacturaCompra fc  inner join Documento d on fc.doc_id = d.doc_id 
                                      where   (    (fc_fecha between @@fdesde and @@fhasta)
                                              or  (@@fdesde is null and @@fhasta is null)
                                              )
                                          and d.emp_id = @@emp_id
                                    )

        -- Pagos
        --
        delete FacturaCompraPago
        where fc_id in ( select fc_id 
                          from FacturaCompra fc  inner join Documento d on fc.doc_id = d.doc_id 
                          where   (    (fc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- PackingList Factura Venta
        --

        -- PackingLists
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct fv_id,@@FV 
        from PackingListFacturaVenta pklstfv   inner join PackingListItem pklsti on pklstfv.pklsti_id = pklsti.pklsti_id
                                              inner join FacturaVentaItem fvi   on pklstfv.fvi_id    = fvi.fvi_id
                                              inner join PackingList pklst       on pklsti.pklst_id   = pklst.pklst_id
                                              inner join Documento d             on pklst.doc_id      = d.doc_id 
        where   (    (pklst_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PackingListFacturaVenta 
        where pklsti_id in (select pklsti_id 
                            from PackingList pklst inner join PackingListItem pklsti on pklst.pklst_id = pklsti.pklst_id
                                                   inner join Documento d            on pklst.doc_id = d.doc_id 
                              where   (    (pklst_fecha between @@fdesde and @@fhasta)
                                      or  (@@fdesde is null and @@fhasta is null)
                                      )
                                  and d.emp_id = @@emp_id
                            )

        -- Facturas
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pklst_id,@@PKLST 
        from PackingListFacturaVenta pklstfv  inner join FacturaVentaItem fvi   on pklstfv.fvi_id    = fvi.fvi_id
                                              inner join PackingListItem pklsti on pklstfv.pklsti_id = pklsti.pklsti_id
                                              inner join FacturaVenta fv        on fvi.fv_id          = fv.fv_id
                                              inner join Documento d             on fv.doc_id          = d.doc_id 
        where   (    (fv_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PackingListFacturaVenta 
        where fvi_id in ( select fvi_id 
                          from FacturaVenta fv inner join FacturaVentaItem fvi  on fv.fv_id  = fvi.fv_id
                                              inner join Documento d           on fv.doc_id = d.doc_id 
                          where   (    (fv_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Manifiesto PackingList
        --

        -- Manifiestos
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pklst_id,@@PKLST 
        from ManifiestoPackingList mfcpklst inner join ManifiestoCargaItem mfci on mfcpklst.mfci_id   = mfci.mfci_id
                                            inner join PackingListItem pklsti   on mfcpklst.pklsti_id = pklsti.pklsti_id
                                            inner join ManifiestoCarga mfc      on mfci.mfc_id         = mfc.mfc_id
                                            inner join Documento d              on mfc.doc_id         = d.doc_id 
        where   (    (mfc_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete ManifiestoPackingList 
        where mfci_id in ( select mfci_id 
                          from ManifiestoCarga mfc inner join ManifiestoCargaItem mfci  on mfc.mfc_id = mfci.mfc_id
                                                   inner join Documento d               on mfc.doc_id = d.doc_id 
                          where   (    (mfc_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )

        -- PackingLists
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct mfc_id,@@MFC 
        from ManifiestoPackingList mfcpklst inner join PackingListItem pklsti   on mfcpklst.pklsti_id = pklsti.pklsti_id
                                            inner join ManifiestoCargaItem mfci on mfcpklst.mfci_id   = mfci.mfci_id
                                            inner join PackingList pklst        on pklsti.pklst_id     = pklst.pklst_id
                                            inner join Documento d               on pklst.doc_id       = d.doc_id 
        where   (    (pklst_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete ManifiestoPackingList 
        where pklsti_id in ( select pklsti_id 
                          from PackingList pklst  inner join PackingListItem pklsti on pklst.pklst_id = pklsti.pklst_id
                                                  inner join Documento d             on pklst.doc_id   = d.doc_id 
                          where   (    (pklst_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                        )


--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        -- Packing List Devolucion
        --

        -- PackingLists
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pklstid.pklst_id,@@PKLST 
        from PackingListDevolucion pklstdv 
                      inner join PackingListItem pklsti  on pklstdv.pklsti_id_pklst       = pklsti.pklsti_id
                      inner join PackingListItem pklstid on pklstdv.pklsti_id_devolucion  = pklstid.pklsti_id
                      inner join PackingList pklst       on pklsti.pklst_id               = pklst.pklst_id
                      inner join Documento d             on pklst.doc_id                   = d.doc_id 
        where   (    (pklst_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PackingListDevolucion 
        where pklsti_id_pklst in (select pklsti_id 
                                    from PackingList pklst 
                                              inner join PackingListItem pklsti  on pklst.pklst_id = pklsti.pklst_id
                                              inner join Documento d              on pklst.doc_id   = d.doc_id 
                                    where   (    (pklst_fecha between @@fdesde and @@fhasta)
                                            or  (@@fdesde is null and @@fhasta is null)
                                            )
                                        and d.emp_id = @@emp_id
                                  )

        -- Devoluciones
        --
        insert into #docEstado (comp_id, doct_id)
        select distinct pklsti.pklst_id,@@PKLST 
        from PackingListDevolucion pklstdv 
                      inner join PackingListItem pklstid    on pklstdv.pklsti_id_devolucion = pklstid.pklsti_id
                      inner join PackingListItem pklsti     on pklstdv.pklsti_id_pklst       = pklsti.pklsti_id
                      inner join PackingList pklst           on pklstid.pklst_id             = pklst.pklst_id
                      inner join Documento d                on pklst.doc_id                 = d.doc_id 
        where   (    (pklst_fecha between @@fdesde and @@fhasta)
                or  (@@fdesde is null and @@fhasta is null)
                )
            and d.emp_id = @@emp_id

        delete PackingListDevolucion 
        where pklsti_id_devolucion in (select pklsti_id 
                                        from PackingList pklst 
                                                inner join PackingListItem pklsti   on pklst.pklst_id = pklsti.pklst_id
                                                inner join Documento d               on pklst.doc_id   = d.doc_id 
                                        where   (    (pklst_fecha between @@fdesde and @@fhasta)
                                                or  (@@fdesde is null and @@fhasta is null)
                                                )
                                            and d.emp_id = @@emp_id
                                        )

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    ----------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------
    --
    --    Comienzo a Borrar los documentos de esta empresa
    --
    ----------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------
        
        -- DepositoBanco
        declare c_doc insensitive cursor for select dbco_id from DepositoBanco t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (dbco_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocDepositoBancoDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- DepositoCupon
        declare c_doc insensitive cursor for select dcup_id from DepositoCupon t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (dcup_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocDepositoCuponDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        

        -- MovimientoFondo

        if @@soloDoc = 0 begin

          update Cheque set mf_id = null 
          where mf_id in (
                           select mf_id from MovimientoFondo t inner join Documento d on t.doc_id = d.doc_id 
                           where (    (mf_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                          )

          update MovimientoFondoItem set cheq_id = null 
          where mf_id in (
                           select mf_id from MovimientoFondo t inner join Documento d on t.doc_id = d.doc_id 
                           where (    (mf_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                          )
        end

        declare c_doc insensitive cursor for select mf_id from MovimientoFondo t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (mf_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocMovimientoFondoDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- OrdenPago
        declare c_doc insensitive cursor for select opg_id from OrdenPago t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (opg_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocOrdenPagoDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc


        -- Cobranza

        if @@soloDoc = 0 begin

          update Cheque set cobz_id = null 
          where cobz_id in (
                           select cobz_id from Cobranza t inner join Documento d on t.doc_id = d.doc_id 
                           where (    (cobz_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                          )

          update CobranzaItem set cheq_id = null 
          where cobz_id in (
                           select cobz_id from Cobranza t inner join Documento d on t.doc_id = d.doc_id 
                           where (    (cobz_fecha between @@fdesde and @@fhasta)
                                  or  (@@fdesde is null and @@fhasta is null)
                                  )
                              and d.emp_id = @@emp_id
                          )
        end

        declare c_doc insensitive cursor for select cobz_id from Cobranza t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (cobz_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocCobranzaDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc

        
        -- FacturaVenta
        declare c_doc insensitive cursor for select fv_id from FacturaVenta t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (fv_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocFacturaVentaDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- ImportacionTemp 
        declare c_doc insensitive cursor for select impt_id from ImportacionTemp t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (impt_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocImportacionTempDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- ManifiestoCarga
        declare c_doc insensitive cursor for select mfc_id from ManifiestoCarga t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (mfc_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocManifiestoCargaDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- PackingList
        declare c_doc insensitive cursor for select pklst_id from PackingList t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (pklst_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocPackingListDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- ParteProdKit
        declare c_doc insensitive cursor for select ppk_id from ParteProdKit t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (ppk_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocParteProdKitDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        

        -- PedidoCompra
        declare c_doc insensitive cursor for select pc_id from PedidoCompra t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (pc_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocPedidoCompraDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        

        -- OrdenCompra
        declare c_doc insensitive cursor for select oc_id from OrdenCompra t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (oc_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocOrdenCompraDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- PedidoVenta
        declare c_doc insensitive cursor for select pv_id from PedidoVenta t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (pv_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocPedidoVentaDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- PermisoEmbarque
        declare c_doc insensitive cursor for select pemb_id from PermisoEmbarque t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (pemb_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocPermisoEmbarqueDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        --PresupuestoVenta
        declare c_doc insensitive cursor for select prv_id from PresupuestoVenta t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (prv_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocPresupuestoVentaDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- RecuentoStock
        declare c_doc insensitive cursor for select rs_id from RecuentoStock t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (rs_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocRecuentoStockDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        
        -- RemitoVenta
        declare c_doc insensitive cursor for select rv_id from RemitoVenta t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (rv_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocRemitoVentaDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
        
        -- ResolucionCupon
        declare c_doc insensitive cursor for select rcup_id from ResolucionCupon t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (rcup_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocResolucionCuponDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc

        -- Solucion para aquellos numeros de serie ingresados por remitos de esta empresa y vendidos con documentos
        -- de otras empresas

        update StockItem set prns_id = null from Stock st inner join Documento doc on st.doc_id = doc.doc_id
        where exists (select sti.prns_id from StockItem sti inner join Stock st on sti.st_id = st.st_id 
                                                            inner join Documento doc on st.doc_id = doc.doc_id
                      where doc.emp_id <> @@emp_id
                        and sti.prns_id = StockItem.prns_id
                      )
          and StockItem.st_id = st.st_id
          and doc.emp_id = @@emp_id
        

        -- FacturaCompra
        declare c_doc insensitive cursor for select fc_id from FacturaCompra t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (fc_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocFacturaCompraDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc


        -- RemitoCompra
        declare c_doc insensitive cursor for select rc_id from RemitoCompra t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (rc_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocRemitoCompraDelete @id, @@emp_id, @@us_id
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc

        
        -- Asiento
        declare c_doc insensitive cursor for select as_id from Asiento t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (as_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocAsientoDelete @id,0,0,1
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc


        -- Stock
        declare c_doc insensitive cursor for select st_id from Stock t inner join Documento d on t.doc_id = d.doc_id 
                                             where (    (st_fecha between @@fdesde and @@fhasta)
                                                    or  (@@fdesde is null and @@fhasta is null)
                                                    )
                                                and d.emp_id = @@emp_id
        open c_doc
        fetch next from c_doc into @id
        while @@fetch_status=0
        begin
        
          exec sp_DocStockDelete @id,0,0,1,1
        
          fetch next from c_doc into @id
        end
        
        close c_doc
        deallocate c_doc
    ----------------------------------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------------------------------


    -- Estados
    --

      declare c_estado insensitive cursor for select distinct comp_id, doct_id from #docEstado
      open c_estado
      fetch next from c_estado into @id, @doct_id
      while @@fetch_status = 0
      begin

             if @doct_id = @@FV     execute sp_DocFacturaVentaSetCredito       @id
        else if @doct_id = @@FC     execute sp_DocFacturaCompraSetCredito     @id
        else if @doct_id = @@RV     execute sp_DocRemitoVentaSetCredito       @id
        else if @doct_id = @@RC     execute sp_DocRemitoCompraSetCredito       @id
        else if @doct_id = @@PV     execute sp_DocPedidoVentaSetCredito       @id
        else if @doct_id = @@COBZ   execute sp_DocCobranzaSetCredito           @id
        else if @doct_id = @@OPG     execute sp_DocOrdenPagoSetCredito         @id
        else if @doct_id = @@PKLST  execute sp_DocPackingListSetCredito       @id
        else if @doct_id = @@MFC     execute sp_DocManifiestoCargaSetCredito   @id

        fetch next from c_estado into @id, @doct_id
      end
      close c_estado
      deallocate c_estado

  if @@soloDoc = 0 begin

    begin transaction

    delete EmpresaCliente where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete EmpresaProveedor where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete EmpresaUsuario where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete ReporteFormulario where doc_id in (select doc_id from Documento where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    delete DocumentoFirma where doc_id in (select doc_id from Documento where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    delete caja where doc_id in (select doc_id from Documento where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    delete Documento where emp_id = @@emp_id and doct_id <> @@AC
    if @@error <> 0 goto ControlError

    delete Documento where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete PercepcionItem where perc_id in (select perc_id from Percepcion where ta_id in (select ta_id from Talonario where emp_id = @@emp_id))
    if @@error <> 0 goto ControlError

    delete Percepcion where ta_id in (select ta_id from Talonario where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    delete RetencionItem where ret_id in (select ret_id from Retencion where ta_id in (select ta_id from Talonario where emp_id = @@emp_id))
    if @@error <> 0 goto ControlError

    delete ProveedorRetencion where ret_id in (select ret_id from Retencion where ta_id in (select ta_id from Talonario where emp_id = @@emp_id))
    if @@error <> 0 goto ControlError

    update OrdenPagoItem set ret_id = null where ret_id in (select ret_id from Retencion where ta_id in (select ta_id from Talonario where emp_id = @@emp_id))
    if @@error <> 0 goto ControlError

    update CobranzaItem set ret_id = null where ret_id in (select ret_id from Retencion where ta_id in (select ta_id from Talonario where emp_id = @@emp_id))
    if @@error <> 0 goto ControlError

    delete Retencion where ta_id in (select ta_id from Talonario where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    delete Talonario where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete EmpresaClienteDeuda where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete EmpresaProveedorDeuda where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete Configuracion where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    update OrdenPagoItem set cheq_id = null where cheq_id in (select cheq_id from Cheque where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    update CobranzaItem set cheq_id = null where cheq_id in (select cheq_id from Cheque where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    update DepositoBancoItem set cheq_id = null where cheq_id in (select cheq_id from Cheque where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    update AsientoItem set cheq_id = null where cheq_id in (select cheq_id from Cheque where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError

    delete Cheque where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    update Cuenta set emp_id = null where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete Cuenta where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    exec sp_docstockcachecreate2 0,0
    if @@error <> 0 goto ControlError

    delete DepositoLogico where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete ProyectoPrecio where us_id in (select us_id from Usuario
                                          where prs_id in (select prs_id from Persona 
                                                    where dpto_id in (select dpto_id from Departamento 
                                                                      where emp_id = @@emp_id)))
    if @@error <> 0 goto ControlError      

    delete UsuarioDepartamento where dpto_id in (select dpto_id from Departamento where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError      

    delete UsuarioDepartamento where dpto_id in (select dpto_id from Departamento 
                                                 where dpto_id_padre in (select dpto_id from Departamento 
                                                                         where emp_id = @@emp_id))
    if @@error <> 0 goto ControlError      

    update Usuario set prs_id = null 
    where prs_id in (select prs_id from Persona 
                     where dpto_id in (select dpto_id from Departamento 
                                       where emp_id = @@emp_id))
      and prs_id in (select prs_id from Persona 
                     where dpto_id in (select dpto_id from Departamento 
                                       where emp_id <> @@emp_id))

    update Usuario set prs_id = null 
    where prs_id in (select prs_id from Persona 
                     where dpto_id in (select dpto_id from Departamento 
                                       where emp_id = @@emp_id))
      and us_id in (select us_id from UsuarioDepartamento where dpto_id in (select dpto_id from Departamento 
                                                 where dpto_id_padre in (select dpto_id from Departamento 
                                                                         where emp_id <> @@emp_id)))

    update Usuario set prs_id = null 
    where prs_id in (select prs_id from Persona 
                     where dpto_id in (select dpto_id from Departamento 
                                       where emp_id = @@emp_id))
      and us_id in (select us_id from UsuarioDepartamento where dpto_id in (select dpto_id from Departamento
                                                                         where emp_id <> @@emp_id))

    update ProductoNumeroSerie set modifico = 1 
    where modifico in (select us_id from Usuario where prs_id in (select prs_id from Persona 
                                    where dpto_id in (select dpto_id from Departamento 
                                                      where emp_id = @@emp_id)))

    delete ReporteParametro 
    where rpt_id in (select rpt_id from Reporte 
                      where us_id in (select us_id from Usuario where prs_id in (select prs_id from Persona 
                                    where dpto_id in (select dpto_id from Departamento 
                                                      where emp_id = @@emp_id))))

    delete Reporte where us_id in (select us_id from Usuario where prs_id in (select prs_id from Persona 
                                    where dpto_id in (select dpto_id from Departamento 
                                                      where emp_id = @@emp_id)))

    update Rama set modifico = 1 
    where modifico in (select us_id from Usuario where prs_id in (select prs_id from Persona 
                                    where dpto_id in (select dpto_id from Departamento 
                                                      where emp_id = @@emp_id)))

    update Arbol set modifico = 1 
    where modifico in (select us_id from Usuario where prs_id in (select prs_id from Persona 
                                    where dpto_id in (select dpto_id from Departamento 
                                                      where emp_id = @@emp_id)))

    delete Usuario where prs_id in (select prs_id from Persona 
                                    where dpto_id in (select dpto_id from Departamento 
                                                      where emp_id = @@emp_id))
    if @@error <> 0 goto ControlError      

    delete Persona where dpto_id in (select dpto_id from Departamento where emp_id = @@emp_id)
    if @@error <> 0 goto ControlError      


    update ProductoNumeroSerie set tar_id = null 
    where tar_id in (select tar_id from Tarea where ali_id in (select ali_id from AlarmaItem 
                                  where dpto_id in (select dpto_id from Departamento 
                                                    where emp_id = @@emp_id)))

    delete Tarea where ali_id in (select ali_id from AlarmaItem 
                                  where dpto_id in (select dpto_id from Departamento 
                                                    where emp_id = @@emp_id))
    delete AlarmaItem where dpto_id in (select dpto_id from Departamento where emp_id = @@emp_id)

    declare @dpto_id int

    declare c_dpto insensitive cursor for select dpto_id from Departamento where emp_id = @@emp_id

    open c_dpto
    fetch next from c_dpto into @dpto_id
    while @@fetch_status = 0
    begin

      exec sp_DepartamentoDelete @dpto_id
      if @@error <> 0 goto ControlError      

      fetch next from c_dpto into @dpto_id
    end
    close c_dpto
    deallocate c_dpto

    delete Departamento where emp_id = @@emp_id

    delete ProductoDepositoEntrega where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete ClienteCacheCredito where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    delete Empresa where emp_id = @@emp_id
    if @@error <> 0 goto ControlError

    commit transaction

  end

  update configuracion set cfg_valor = @controlstock where cfg_aspecto = 'Tipo Control Stock'

  return
ControlError:

  update configuracion set cfg_valor = @controlstock where cfg_aspecto = 'Tipo Control Stock'

  raiserror ('Ha ocurrido un error al borrar el cliente. sp_empresaDelete.', 16, 1)
  rollback transaction  

end
go

