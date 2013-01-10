/*---------------------------------------------------------------------
Nombre: Listado de ventas por provincia resumido
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_CON_0130 1, '20050101','20100201'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0130]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0130]

go
create procedure DC_CSC_CON_0130 (

  @@us_id        int,
  @@Fini          datetime,
  @@Ffin          datetime
)
as
begin

set nocount on

    select  fv.fv_id,
            pr_nombreventa        as Articulo,
            ti_nombre             as Tasa,
            ti_porcentaje         as Porcentaje,
            emp_nombre            as Empresa,
            doc_nombre            as Documento,
            cli_nombre            as Cliente,
            fv_fecha              as Fecha,
            fv_nrodoc              as Comprobante,
            fv_numero             as Numero
    
    from FacturaVenta fv inner join FacturaVentaItem fvi on fv.fv_id  = fvi.fv_id
                         inner join Documento doc        on fv.doc_id = doc.doc_id
                         inner join Cliente cli          on fv.cli_id = cli.cli_id
                         inner join Empresa emp          on fv.emp_id = emp.emp_id
                         inner join Producto pr          on fvi.pr_id = pr.pr_id
                         inner join TasaImpositiva ti    on pr.ti_id_ivariventa = ti.ti_id
    
    where   fvi_ivari = 0
      and    ti_porcentaje <> 0
      and   fv_fecha between @@Fini and @@Ffin

  union

    select  fv.fv_id,
            pr_nombreventa        as Articulo,
            ti_nombre             as Tasa,
            ti_porcentaje         as Porcentaje,
            emp_nombre            as Empresa,
            doc_nombre            as Documento,
            cli_nombre            as Cliente,
            fv_fecha              as Fecha,
            fv_nrodoc              as Comprobante,
            fv_numero             as Numero
    
    from FacturaVenta fv inner join FacturaVentaItem fvi on fv.fv_id  = fvi.fv_id
                         inner join Documento doc        on fv.doc_id = doc.doc_id
                         inner join Cliente cli          on fv.cli_id = cli.cli_id
                         inner join Empresa emp          on fv.emp_id = emp.emp_id
                         inner join Producto pr          on fvi.pr_id = pr.pr_id
                         inner join TasaImpositiva ti    on pr.ti_id_ivariventa = ti.ti_id
    
    where   fvi_ivari <> 0
      and    ti_porcentaje = 0
      and   fv_fecha between @@Fini and @@Ffin

end

go