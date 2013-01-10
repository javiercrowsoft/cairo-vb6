if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitGetPrns]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitGetPrns]

go

/*

sp_DocParteProdKitGetPrns 7770

*/
create procedure sp_DocParteProdKitGetPrns (
  @@ppk_id int
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
                                inner join ParteProdKit ppk          on sti.st_id      = ppk.st_id1
                                inner join Producto pr              on prns.pr_id     = pr.pr_id
                                inner join Documento doc            on ppk.doc_id     = doc.doc_id
                                inner join Empresa emp              on doc.emp_id     = emp.emp_id
                                left  join StockLote stl            on prns.stl_id    = stl.stl_id
                                

  where ppk.ppk_id = @@ppk_id 

  group by
          prns.prns_id,
          prns.stl_id,
          prns_codigo,
          prns_descrip,
          prns_fechavto,
          stl_codigo,
          sti_grupo,
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
                     inner join ParteProdKit ppk         on sti.st_id      = ppk.st_id1
                     inner join Producto pr              on stl.pr_id      = pr.pr_id
                     inner join Documento doc            on ppk.doc_id     = doc.doc_id
                     inner join Empresa emp              on doc.emp_id     = emp.emp_id
                                

  where ppk.ppk_id = @@ppk_id 
    and sti.st_id  = ppk.st_id1

  group by
          stl.stl_id,
          stl_codigo,
          pr_codigobarra,
          pr_codigobarranombre,
          emp_codigobarra

   order by
           sti_grupo, prns_codigo

end