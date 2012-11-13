if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockGetPrns]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockGetPrns]

go

/*

select * from recuentostock

sp_DocRecuentoStockGetPrns 361


*/
create procedure sp_DocRecuentoStockGetPrns (
	@@rs_id int
)
as

begin

	select 
									prns.prns_id,
									prns.stl_id,
									prns_codigo,
									prns_descrip,
									prns_fechavto,
					  			rsi_id,
									stl_codigo,
									pr_codigobarra,
									pr_codigobarranombre,
									emp_codigobarra as marca

	from ProductoNumeroSerie prns inner join StockItem sti 						on prns.prns_id   = sti.prns_id
																inner join RecuentoStockItem rsi 		on sti.sti_grupo  = rsi.rsi_id
																inner join RecuentoStock rs         on rsi.rs_id      = rs.rs_id
															  inner join Producto pr              on prns.pr_id     = pr.pr_id
																inner join Documento doc            on rs.doc_id      = doc.doc_id
																inner join Empresa emp              on doc.emp_id     = emp.emp_id
																left  join StockLote stl            on prns.stl_id    = stl.stl_id
																

	where rsi.rs_id = @@rs_id 
		and sti.st_id = rs.st_id2

	group by
					prns.prns_id,
					prns.stl_id,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
	  			rsi_id,
          stl_codigo,
					pr_codigobarra,
					pr_codigobarranombre,
					emp_codigobarra

union

	select 
									prns.prns_id,
									prns.stl_id,
									prns_codigo,
									prns_descrip,
									prns_fechavto,
					  			rsi_id,
									stl_codigo,
									pr_codigobarra,
									pr_codigobarranombre,
									emp_codigobarra as marca

	from ProductoNumeroSerie prns inner join StockItem sti 						on prns.prns_id   = sti.prns_id
																inner join RecuentoStockItem rsi 		on sti.sti_grupo  = rsi.rsi_id
																inner join RecuentoStock rs         on rsi.rs_id      = rs.rs_id
															  inner join Producto pr              on prns.pr_id     = pr.pr_id
																inner join Documento doc            on rs.doc_id      = doc.doc_id
																inner join Empresa emp              on doc.emp_id     = emp.emp_id
																left  join StockLote stl            on prns.stl_id    = stl.stl_id
																

	where rsi.rs_id = @@rs_id 
		and sti.st_id = rs.st_id1

	group by
					prns.prns_id,
					prns.stl_id,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
	  			rsi_id,
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

	from StockLote stl inner join StockItem sti 					 on stl.stl_id   	 = sti.stl_id
										 inner join RecuentoStock rs         on sti.st_id      = rs.st_id1
									   inner join Producto pr              on stl.pr_id      = pr.pr_id
										 inner join Documento doc            on rs.doc_id      = doc.doc_id
										 inner join Empresa emp              on doc.emp_id     = emp.emp_id
																

	where rs.rs_id  = @@rs_id 
		and sti.st_id = rs.st_id1

	group by
					stl.stl_id,
          stl_codigo,
					pr_codigobarra,
					pr_codigobarranombre,
					emp_codigobarra

	order by
					rsi_id, prns_codigo, stl_codigo

end