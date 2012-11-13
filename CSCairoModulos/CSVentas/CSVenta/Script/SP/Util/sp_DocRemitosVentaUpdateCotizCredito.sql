if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitosVentaUpdateCotizCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitosVentaUpdateCotizCredito]

/*

 sp_DocRemitosVentaUpdateCotizCredito 1

*/

go
create procedure sp_DocRemitosVentaUpdateCotizCredito (
	@@todos tinyint
)
as

begin

	set nocount on	
	
	declare @mon_id 		int
	declare @fecha  		datetime
	declare @cotizacion decimal(18,6)
	
	set @fecha = getdate()
	
	declare c_rv_cot insensitive cursor for
	
	select distinct doc.mon_id from remitoventa rv 	inner join documento doc on rv.doc_id  = doc.doc_id
	                               						 			inner join moneda mon    on doc.mon_id = mon.mon_id
	where (rv_cotizacion = 0 or @@todos <> 0)
		and mon_legal = 0 
	
	open c_rv_cot
	
	fetch next from c_rv_cot into @mon_id
	while @@fetch_status = 0
	begin
	
		exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotizacion out
	
		update RemitoVenta set rv_cotizacion = @cotizacion 
		from Documento doc 
		where RemitoVenta.doc_id = doc.doc_id 
			and doc.mon_id 				 = @mon_id
	
		fetch next from c_rv_cot into @mon_id
	end
	
	close c_rv_cot
	deallocate c_rv_cot


	if @@todos <> 0 begin

		update cliente set 
											cli_deudapedido				=0,
											cli_deudaremito				=0,
											cli_deudapackinglist	=0,
											cli_deudamanifiesto		=0,
											cli_deudactacte				=0,
											cli_deudadoc					=0,
											cli_deudatotal				=0
		
		delete empresaclientedeuda
		
		exec sp_docpedidoventassetcredito
		exec sp_docremitoventassetcredito
		exec sp_docfacturaventassetcredito
		exec sp_doccobranzassetcredito

	end

end