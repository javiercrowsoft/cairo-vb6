SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetAplicCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetAplicCairo]
GO


/*

delete facturaCompraOrdenPago
delete facturaComprapago

select * from OrdenPago

exec sp_DocOrdenPagoGetAplic 15

sp_columns FacturaCompraOrdenPago

*/
create procedure sp_DocOrdenPagoGetAplicCairo (
	@@emp_id      int,
	@@opg_id 			int
)
as
begin

	declare @prov_id int

	select @prov_id = prov_id from OrdenPago where opg_id = @@opg_id

	select fcopg_id,
				 fcopg_importe,
				 fcopg_importeOrigen,
				 fcopg_cotizacion,
				 fcd.fcd_id,
				 fcp.fcp_id,
				 fc.fc_id,
         fc_nrodoc,
         doc_nombre,
         fcd_fecha,
         fcd_pendiente,
         fcp_fecha,
         0 as orden

	from FacturaCompraOrdenPago fcc  inner join FacturaCompra fc 		 	 on fcc.fc_id = fc.fc_id
                                 	 inner join Documento d     			 on fc.doc_id = d.doc_id
                                 	 left  join FacturaCompraDeuda fcd on fcc.fcd_id = fcd.fcd_id
                                 	 left  join FacturaCompraPago  fcp on fcc.fcp_id = fcp.fcp_id
	where fcc.opg_id = @@opg_id

	union 

	select 0 as fccob_id,
				 0 as fccob_importe,
				 0 as fcopg_importeOrigen,
				 fc_cotizacion as fcopg_cotizacion,
				 fcd_id,
				 0 as fcp_id,
				 fc.fc_id,
         fc_nrodoc,
         doc_nombre,
         fcd_fecha,
         fcd_pendiente,
         null as fcp_fecha,
         1    as orden

	from FacturaCompra fc inner join Documento d     			  on fc.doc_id = d.doc_id
                        inner join FacturaCompraDeuda fcd on fc.fc_id = fcd.fc_id

	where not exists (select fc_id from FacturaCompraOrdenPago where opg_id = @@opg_id and fc_id = fc.fc_id)
		and fc.prov_id = @prov_id

		and fc.est_id <> 7

		-- Empresa
		and d.emp_id = @@emp_id

		and fc.doct_id <> 8
		and Round(fc_pendiente,2) > 0

  order by orden,fc_nrodoc,fcd_fecha 

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



