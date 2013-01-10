/*---------------------------------------------------------------------
Nombre: Aplicaciones de Documentos entre Distintas Empresas
---------------------------------------------------------------------*/

/*
Para testear:


DC_CSC_SYS_0050 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0050]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0050]

go
create procedure DC_CSC_SYS_0050 (

  @@us_id    int
)
as

set nocount on

begin

  select  
    1               as Tipo,
    empc.emp_nombre as [Empresa Cobranza],
    cli_nombre       as [Cliente],
    docc.doc_nombre as [Doc. Cobranza],
    cobz_numero      as Cobranza, 
    cobz_nrodoc      as [Cob. Comprobante],
    cobz_fecha      as [Fecha Cobranza],
    empf.emp_nombre as [Empresa Factura],
    docf.doc_nombre as [Doc. Factura],
    fv_numero        as Factura,
    fv_nrodoc        as [Fac. Comprobante],
    fv_fecha        as [Fecha Factura]
  
  from cobranza cobz inner join facturaventacobranza fvcobz on cobz.cobz_id = fvcobz.cobz_id
                     inner join facturaventa fv             on fvcobz.fv_id = fv.fv_id
                     inner join cliente cli                 on cobz.cli_id  = cli.cli_id
                     inner join documento docc              on cobz.doc_id  = docc.doc_id
                     inner join documento docf              on fv.doc_id    = docf.doc_id
                     inner join empresa empc                on cobz.emp_id  = empc.emp_id
                     inner join empresa empf                on fv.emp_id    = empf.emp_id
  where
    fv.emp_id <> cobz.emp_id
  
  union
  
  select  
    2                 as Tipo,
    empnc.emp_nombre   as [Empresa Nota de Credito],
    cli_nombre         as [Cliente],
    docnc.doc_nombre   as [Doc. Nota de Credito],
    nc.fv_numero      as [Nota de Credito], 
    nc.fv_nrodoc      as [Credito Comprobante],
    nc.fv_fecha        as [Fecha Nota de Credito],
  
    empf.emp_nombre   as [Empresa Factura],
    docf.doc_nombre   as [Doc. Factura],
    fv.fv_numero      as Factura,
    fv.fv_nrodoc      as [Fac. Comprobante],
    fv.fv_fecha        as [Fecha Factura]
  
  from facturaventa nc inner join facturaventanotacredito fvnc on nc.fv_id             = fvnc.fv_id_notacredito
                        inner join facturaventa fv              on fvnc.fv_id_factura  = fv.fv_id
                        inner join cliente cli                  on nc.cli_id            = cli.cli_id
                        inner join documento docnc              on nc.doc_id            = docnc.doc_id
                        inner join documento docf               on fv.doc_id            = docf.doc_id
                        inner join empresa empnc                on nc.emp_id            = empnc.emp_id
                       inner join empresa empf                 on fv.emp_id            = empf.emp_id
  where
    fv.emp_id <> nc.emp_id
  
  union
  
  select  
    3               as Tipo,
    empo.emp_nombre as [Empresa Orden de Pago],
    prov_nombre     as [Proveedor],
    doco.doc_nombre as [Doc. Orden de Pago],
    opg_numero      as [Orden de Pago], 
    opg_nrodoc      as [Pago Comprobante],
    opg_fecha        as [Fecha Orden de Pago],
    empf.emp_nombre as [Empresa Factura],
    docf.doc_nombre as [Doc. Factura],
    fc_numero        as Factura,
    fc_nrodoc        as [Fac. Comprobante],
    fc_fecha        as [Fecha Factura]
  
  from ordenpago opg inner join facturacompraordenpago fcopg on opg.opg_id   = fcopg.opg_id
                     inner join facturacompra fc             on fcopg.fc_id = fc.fc_id
                     inner join proveedor prov               on opg.prov_id = prov.prov_id
                     inner join documento doco               on opg.doc_id  = doco.doc_id
                     inner join documento docf               on fc.doc_id   = docf.doc_id
                     inner join empresa empo                 on opg.emp_id  = empo.emp_id
                     inner join empresa empf                 on docf.emp_id = empf.emp_id
  where
    docf.emp_id <> opg.emp_id
  
  union
  
  select  
    4                 as Tipo,
    empnc.emp_nombre   as [Empresa Nota de Credito],
    prov_nombre       as [Proveedor],
    docnc.doc_nombre   as [Doc. Nota de Credito],
    nc.fc_numero      as [Nota de Credito], 
    nc.fc_nrodoc      as [Credito Comprobante],
    nc.fc_fecha        as [Fecha Nota de Credito],
  
    empf.emp_nombre   as [Empresa Factura],
    docf.doc_nombre   as [Doc. Factura],
    fc.fc_numero      as Factura,
    fc.fc_nrodoc      as [Fac. Comprobante],
    fc.fc_fecha        as [Fecha Factura]
  
  from facturacompra nc inner join facturacompranotacredito fcnc on nc.fc_id             = fcnc.fc_id_notacredito
                         inner join facturacompra fc              on fcnc.fc_id_factura  = fc.fc_id
                         inner join proveedor prov                on nc.prov_id          = prov.prov_id
                         inner join documento docnc               on nc.doc_id            = docnc.doc_id
                         inner join documento docf                on fc.doc_id            = docf.doc_id
                         inner join empresa empnc                 on docnc.emp_id        = empnc.emp_id
                        inner join empresa empf                  on docf.emp_id          = empf.emp_id
  where
    docf.emp_id <> docnc.emp_id
  
  union
  
  select  
  
    distinct
  
    5               as Tipo,
    empr.emp_nombre as [Empresa Remito],
    prov_nombre     as [Proveedor],
    docr.doc_nombre as [Doc. Remito],
    rc_numero        as Remito, 
    rc_nrodoc        as [Remito Comprobante],
    rc_fecha        as [Fecha Remito],
    empf.emp_nombre as [Empresa Factura],
    docf.doc_nombre as [Doc. Factura],
    fc_numero        as Factura,
    fc_nrodoc        as [Fac. Comprobante],
    fc_fecha        as [Fecha Factura]
  
  from remitocompra rc inner join remitocompraitem rci           on rc.rc_id    = rci.rc_id
                       inner join remitofacturacompra fcrc        on rci.rci_id  = fcrc.rci_id
                       inner join facturacompraitem fci          on fcrc.fci_id = fci.fci_id
                       inner join facturacompra fc                on fci.fc_id   = fc.fc_id
                       inner join proveedor prov                  on rc.prov_id   = prov.prov_id
                       inner join documento docr                  on rc.doc_id    = docr.doc_id
                       inner join documento docf                  on fc.doc_id   = docf.doc_id
                       inner join empresa empr                    on docr.emp_id = empr.emp_id
                       inner join empresa empf                    on docf.emp_id = empf.emp_id
  where
    docf.emp_id <> docr.emp_id
  
  union
  
  select  
  
    distinct
  
    6               as Tipo,
    empr.emp_nombre as [Empresa Remito],
    cli_nombre      as [Cliente],
    docr.doc_nombre as [Doc. Remito],
    rv_numero        as Remito, 
    rv_nrodoc        as [Remito Comprobante],
    rv_fecha        as [Fecha Remito],
    empf.emp_nombre as [Empresa Factura],
    docf.doc_nombre as [Doc. Factura],
    fv_numero        as Factura,
    fv_nrodoc        as [Fac. Comprobante],
    fv_fecha        as [Fecha Factura]
  
  from remitoventa rv  inner join remitoventaitem rvi           on rv.rv_id    = rvi.rv_id
                       inner join remitofacturaventa fvrv       on rvi.rvi_id   = fvrv.rvi_id
                       inner join facturaventaitem fvi          on fvrv.fvi_id = fvi.fvi_id
                       inner join facturaventa fv               on fvi.fv_id    = fv.fv_id
                       inner join cliente cli                   on rv.cli_id    = cli.cli_id
                       inner join documento docr                 on rv.doc_id   = docr.doc_id
                       inner join documento docf                 on fv.doc_id   = docf.doc_id
                       inner join empresa empr                   on docr.emp_id = empr.emp_id
                       inner join empresa empf                   on docf.emp_id = empf.emp_id
  where
    docf.emp_id <> docr.emp_id
  
  union
  
  select  
  
    distinct
  
    7               as Tipo,
    empr.emp_nombre as [Empresa Remito],
    cli_nombre      as [Cliente],
    docr.doc_nombre as [Doc. Remito],
    rv_numero        as Remito, 
    rv_nrodoc        as [Remito Comprobante],
    rv_fecha        as [Fecha Remito],
    empp.emp_nombre as [Empresa Pedido],
    docp.doc_nombre as [Doc. Pedido],
    pv_numero        as Pedido,
    pv_nrodoc        as [Pedido Comprobante],
    pv_fecha        as [Fecha Pedido]
  
  from remitoventa rv  inner join remitoventaitem rvi         on rv.rv_id    = rvi.rv_id
                       inner join pedidoremitoventa pvrv       on rvi.rvi_id   = pvrv.rvi_id
                       inner join pedidoventaitem pvi         on pvrv.pvi_id = pvi.pvi_id
                       inner join pedidoventa pv               on pvi.pv_id    = pv.pv_id
                       inner join cliente cli                 on rv.cli_id    = cli.cli_id
                       inner join documento docr              on rv.doc_id   = docr.doc_id
                       inner join documento docp              on pv.doc_id   = docp.doc_id
                       inner join empresa empr                on docr.emp_id = empr.emp_id
                       inner join empresa empp                on docp.emp_id = empp.emp_id
  where
    docp.emp_id <> docr.emp_id
  
  union
  
  select  
  
    distinct
  
    8               as Tipo,
    empr.emp_nombre as [Empresa Remito],
    prov_nombre     as [Proveedor],
    docr.doc_nombre as [Doc. Remito],
    rc_numero        as Remito, 
    rc_nrodoc        as [Remito Comprobante],
    rc_fecha        as [Fecha Remito],
    empo.emp_nombre as [Empresa Orden Compra],
    doco.doc_nombre as [Doc. Orden],
    oc_numero        as [Orden de Compra],
    oc_nrodoc        as [Fac. Comprobante],
    oc_fecha        as [Fecha Orden]
  
  from remitocompra rc inner join remitocompraitem rci           on rc.rc_id    = rci.rc_id
                       inner join ordenremitocompra ocrc          on rci.rci_id  = ocrc.rci_id
                       inner join ordencompraitem oci            on ocrc.oci_id = oci.oci_id
                       inner join ordencompra oc                  on oci.oc_id   = oc.oc_id
                       inner join proveedor prov                  on rc.prov_id   = prov.prov_id
                       inner join documento docr                  on rc.doc_id    = docr.doc_id
                       inner join documento doco                  on oc.doc_id   = doco.doc_id
                       inner join empresa empr                    on docr.emp_id = empr.emp_id
                       inner join empresa empo                    on doco.emp_id = empo.emp_id
  where
    doco.emp_id <> docr.emp_id
  
  order by 1,2,4,8,9

end