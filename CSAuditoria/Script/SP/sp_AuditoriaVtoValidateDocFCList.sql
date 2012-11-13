-- Script de Chequeo de Integridad de:

-- 2 - Control de vencimientos FC y FV

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaVtoValidateDocFCList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaVtoValidateDocFCList]

go

create procedure sp_AuditoriaVtoValidateDocFCList (

	@@fc_id       int

)
as

begin

  set nocount on

	declare @doct_id      int
	declare @fc_nrodoc 		varchar(50) 
	declare @fc_numero 		varchar(50) 

	select 
						@doct_id 		= doct_id,
						@fc_nrodoc  = fc_nrodoc,
						@fc_numero  = convert(varchar,fc_numero)

	from FacturaCompra where fc_id = @@fc_id

	select *,
				 IsNull(
					(select sum(fcopg_importe) from FacturaCompraOrdenPago 
					 where fcd_id = fcd.fcd_id),0)

							as OrdenPagos,

				 IsNull(
				  (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
		       where 
		             (fcd_id_factura     = fcd.fcd_id and @doct_id in (2,10))
		          or (fcd_id_notacredito = fcd.fcd_id and @doct_id = 8)
		      ),0) 

							as [Notas de Credito]

	from FacturaCompraDeuda fcd
	where (fcd_pendiente +  (		IsNull(
																(select sum(fcopg_importe) from FacturaCompraOrdenPago 
																 where fcd_id = fcd.fcd_id),0)
														+	IsNull(
															  (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
	                               where 
	                                     (fcd_id_factura     = fcd.fcd_id and @doct_id in (2,10))
	                                  or (fcd_id_notacredito = fcd.fcd_id and @doct_id = 8)
	                              ),0)
													) 
				) <> fcd_importe

		and fc_id = @@fc_id
	
	select *,
				 IsNull(
					(select sum(fcopg_importe) from FacturaCompraOrdenPago 
					 where fcp_id = fcp.fcp_id),0)

							as OrdenPagos,

				 IsNull(
				  (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
           where 
                 (fcp_id_factura     = fcp.fcp_id and @doct_id in (2,10))
              or (fcp_id_notacredito = fcp.fcp_id and @doct_id = 8)
          ),0) 

							as [Notas de Credito]

  from FacturaCompraPago fcp
	where fcp_importe   <> (		IsNull(
																(select sum(fcopg_importe) from FacturaCompraOrdenPago 
																 where fcp_id = fcp.fcp_id),0)
														+	IsNull(
															  (select sum(fcnc_importe)   from FacturaCompraNotaCredito 
	                               where 
	                                     (fcp_id_factura     = fcp.fcp_id and @doct_id in (2,10))
	                                  or (fcp_id_notacredito = fcp.fcp_id and @doct_id = 8)
	                              ),0)
													) 
		and fc_id = @@fc_id

end
GO