if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitosCompraUpdateCotizCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitosCompraUpdateCotizCredito]

/*

 sp_DocRemitosCompraUpdateCotizCredito 1

*/

go
create procedure sp_DocRemitosCompraUpdateCotizCredito (
	@@todos tinyint
)
as

begin

	set nocount on	
	
	declare @mon_id 		int
	declare @fecha  		datetime
	declare @cotizacion decimal(18,6)
	
	set @fecha = getdate()
	
	declare c_rc_cot insensitive cursor for
	
	select distinct doc.mon_id from remitocompra rc inner join documento doc on rc.doc_id  = doc.doc_id
	                               						 			inner join moneda mon    on doc.mon_id = mon.mon_id
	where (rc_cotizacion = 0 or @@todos <> 0)
		and mon_legal = 0 
	
	open c_rc_cot
	
	fetch next from c_rc_cot into @mon_id
	while @@fetch_status = 0
	begin
	
		exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotizacion out
	
		update remitocompra set rc_cotizacion = @cotizacion 
		from Documento doc 
		where remitocompra.doc_id = doc.doc_id 
			and doc.mon_id 				 = @mon_id
	
		fetch next from c_rc_cot into @mon_id
	end
	
	close c_rc_cot
	deallocate c_rc_cot


	if @@todos <> 0 begin

		update proveedor set 
											prov_deudaorden 				=0,
											prov_deudaremito				=0,
											prov_deudactacte				=0,
											prov_deudadoc						=0,
											prov_deudatotal					=0
		
		delete empresaproveedordeuda
		
		exec sp_docordencomprassetcredito
		exec sp_docremitocomprassetcredito
		exec sp_docfacturacomprassetcredito
		exec sp_docordenpagossetcredito

	end

end