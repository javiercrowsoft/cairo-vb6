  update ProductoNumeroSerie set ppk_id = (select top 1 ppk_id
                                                  from ParteProdKit p inner join StockItem s on p.st_id1 = s.st_id
                                                  where prns_id = ProductoNumeroSerie.prns_id
                                                  order by ppk_id desc
                                           )
--  where pr_id_kit is not null


--select * from productonumeroserie where pr_id_kit is not null