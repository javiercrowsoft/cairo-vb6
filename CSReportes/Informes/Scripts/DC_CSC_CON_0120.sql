/*---------------------------------------------------------------------
Nombre: Listado de compras por provincia resumido
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_CON_0120 1, '20050101','20100201'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0120]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0120]

go
create procedure DC_CSC_CON_0120 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime
)
as
begin

set nocount on

      select  fc.fc_id,
              pr_nombrecompra       as Articulo,
              ti_nombre             as Tasa,
              ti_porcentaje         as Porcentaje,
              emp_nombre            as Empresa,
              doc_nombre            as Documento,
              prov_nombre           as Proveedor,
              fc_fecha              as Fecha,
              fc_nrodoc              as Comprobante,
              fc_numero             as Numero,
              fci_importe           as Importe,
              fci_ivari             as Iva
      
      from Facturacompra fc inner join FacturacompraItem fci     on fc.fc_id    = fci.fc_id
                             inner join Documento doc            on fc.doc_id   = doc.doc_id
                             inner join Proveedor prov            on fc.prov_id = prov.prov_id
                             inner join Empresa emp              on doc.emp_id = emp.emp_id
                             inner join Producto pr              on fci.pr_id   = pr.pr_id
                             inner join TasaImpositiva ti        on pr.ti_id_ivaricompra = ti.ti_id
      
      where   fci_ivari = 0
        and    ti_porcentaje <> 0
        and   fc_fecha between @@Fini and @@Ffin

    union
      
      select  fc.fc_id,
              pr_nombrecompra       as Articulo,
              ti_nombre             as Tasa,
              ti_porcentaje         as Porcentaje,
              emp_nombre            as Empresa,
              doc_nombre            as Documento,
              prov_nombre           as Proveedor,
              fc_fecha              as Fecha,
              fc_nrodoc              as Comprobante,
              fc_numero             as Numero,
              fci_importe           as Importe,
              fci_ivari             as Iva
      
      from Facturacompra fc inner join FacturacompraItem fci     on fc.fc_id    = fci.fc_id
                             inner join Documento doc            on fc.doc_id   = doc.doc_id
                             inner join Proveedor prov            on fc.prov_id = prov.prov_id
                             inner join Empresa emp              on doc.emp_id = emp.emp_id
                             inner join Producto pr              on fci.pr_id   = pr.pr_id
                             inner join TasaImpositiva ti        on pr.ti_id_ivaricompra = ti.ti_id
      
      where   fci_ivari <> 0
        and    ti_porcentaje = 0
        and   fc_fecha between @@Fini and @@Ffin
end
go