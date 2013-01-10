if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetPrns]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetPrns]

go

/*

sp_DocFacturaCompraGetPrns 123

*/
create procedure sp_DocFacturaCompraGetPrns (
  @@fc_id int
)
as

begin

  select 
                  prns.prns_id,
                  prns.stl_id,
                  prns_codigo,
                  prns_descrip,
                  prns_fechavto,
                  sti_grupo,
                  stl_codigo,
                  pr_codigobarra,
                  pr_codigobarranombre,
                  emp_codigobarra as marca

  from ProductoNumeroSerie prns inner join StockItem sti             on prns.prns_id   = sti.prns_id
                                inner join FacturaCompraItem fci     on sti.sti_grupo  = fci.fci_id
                                inner join FacturaCompra fc         on fci.fc_id      = fc.fc_id
                                inner join Producto pr              on prns.pr_id     = pr.pr_id
                                inner join Documento doc            on fc.doc_id      = doc.doc_id
                                inner join Empresa emp              on doc.emp_id     = emp.emp_id
                                left  join StockLote stl            on prns.stl_id    = stl.stl_id
                                

  where fci.fc_id = @@fc_id 
    and sti.st_id = fc.st_id

  group by
          prns.prns_id,
          prns.stl_id,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          sti_grupo,
          stl_codigo,
          pr_codigobarra,
          pr_codigobarranombre,
          emp_codigobarra


union

  select 
                  0,
                  stl.stl_id,
                  '',
                  '',
                  null,
                  0,
                  stl_codigo,
                  pr_codigobarra,
                  pr_codigobarranombre,
                  emp_codigobarra as marca

  from StockLote stl inner join StockItem sti            on stl.stl_id      = sti.stl_id
                     inner join FacturaCompra fc          on sti.st_id      = fc.st_id
                     inner join Producto pr              on stl.pr_id      = pr.pr_id
                     inner join Documento doc            on fc.doc_id      = doc.doc_id
                     inner join Empresa emp              on doc.emp_id     = emp.emp_id
                                

  where fc.fc_id = @@fc_id 
    and sti.st_id  = fc.st_id

  group by
          stl.stl_id,
          stl_codigo,
          pr_codigobarra,
          pr_codigobarranombre,
          emp_codigobarra

   order by
           sti_grupo, prns_codigo

end