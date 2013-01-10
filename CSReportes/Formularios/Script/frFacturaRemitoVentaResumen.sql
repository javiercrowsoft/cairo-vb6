/*---------------------------------------------------------------------
Nombre: Detalle de comprobantes de facuracion
---------------------------------------------------------------------*/
/*  

Para testear:
select * from documentotipo
frFacturaRemitoVentaResumen 1, '20050311','20050311','0', '0','0','0','0','0','0','0'
,'0','0', 1,'0','0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frFacturaRemitoVentaResumen]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frFacturaRemitoVentaResumen]

go
create procedure frFacturaRemitoVentaResumen (

  @@fv_id  int

)as 
begin

set nocount on

select 
    rv.rv_id        as id,
    1               as tipo_id,
    cli_nombre      as Cliente,
    cli_codigo      as Codigo,
    doct_nombre      as Tipo,
    doc_nombre      as Documento,
    rv_nrodoc        as Comprobante,
    rv_fecha        as Fecha,
    cpg_nombre      as [Condicion de Pago],
    pr_nombreVenta  as Articulo,
    pr_codigo        as [Codigo Articulo],
    rvi_cantidad    as Cantidad,
    depl_nombre     as Deposito,
    rv_descuento1    as Descuento,
    case  
      when doct.doct_id = 24 then -rvi_precio 
    else rvi_precio
    end             as Precio,
    case  
      when doct.doct_id = 24 then -rvi_neto 
    else rvi_neto
    end             as Neto

from
  remitoVenta rv inner join cliente          cli  on rv.cli_id  = cli.cli_id
                 inner join condicionPago    cpg  on rv.cpg_id  = cpg.cpg_id
                 inner join remitoVentaItem  rvi  on rv.rv_id   = rvi.rv_id
                 inner join producto         pr   on rvi.pr_id  = pr.pr_id
                 inner join documentoTipo    doct on rv.doct_id = doct.doct_id
                 inner join documento        doc  on rv.doc_id  = doc.doc_id


                  inner join moneda    mon         on doc.mon_id  = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

                  left join centroCosto ccos       on rvi.ccos_id = ccos.ccos_id
                   left join provincia   pro        on cli.pro_id  = pro.pro_id
                  left join stock       st         on rv.st_id    = st.st_id
                  left join depositoLogico depl     on st.depl_id_origen = depl.depl_id
where 

  exists(select rvfv.rvi_id from RemitoFacturaVenta rvfv 
                              inner join FacturaVentaItem fvi on rvfv.fvi_id = fvi.fvi_id
         where fvi.fv_id = @@fv_id and rvi_id = rvi.rvi_id)

order by tipo_id, cliente, fecha, comprobante


end


go


