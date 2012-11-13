/*---------------------------------------------------------------------
Nombre: Facturas cuyo pago y deduda no suman igual al total
---------------------------------------------------------------------*/

/*
Para testear:


DC_CSC_SYS_0060 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0060]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0060]

go
create procedure DC_CSC_SYS_0060 (

  @@us_id    int
)
as

set nocount on

begin

	select 	
					1               as orden_id,
					'Compras' 			as Tipo,
					emp_nombre			as Empresa,
					doc_nombre			as Documento,
					prov_nombre			as [Proveedor/Cliente],
					fc.fc_fecha			as Fecha,
					fc.fc_nrodoc		as Comprobante,
					fc.fc_total			as Total,
					(sum(fcd_importe)+sum(fcp_importe))		as Deuda
	
	from facturacompra fc inner join facturacompradeuda fcd on fc.fc_id   = fcd.fc_id
											  inner join facturacomprapago fcp  on fc.fc_id   = fcp.fc_id
												inner join documento doc          on fc.doc_id  = doc.doc_id
												inner join empresa emp            on doc.emp_id = emp.emp_id
												inner join proveedor prov         on fc.prov_id = prov.prov_id
	
	group by 	
						emp_nombre,
						doc_nombre,
						prov_nombre,
						fc.fc_id,
						fc.fc_fecha,
						fc.fc_nrodoc, 
						fc.fc_total
	
	having fc_total <> (sum(fcd_importe)+sum(fcp_importe))

	union
	
	select 	
					2,
					'Ventas',
					emp_nombre,
					doc_nombre,
					cli_nombre,
					fv.fv_fecha,
					fv.fv_nrodoc,
					fv.fv_total,
					(sum(fvd_importe)+sum(fvp_importe))
	
	from facturaventa fv inner join facturaventadeuda fvd  on fv.fv_id = fvd.fv_id
											 inner join facturaventapago fvp   on fv.fv_id = fvp.fv_id
											 inner join documento doc          on fv.doc_id  = doc.doc_id
											 inner join empresa emp            on doc.emp_id = emp.emp_id
											 inner join cliente cli         	 on fv.cli_id = cli.cli_id
	
	group by 	
					emp_nombre,
					doc_nombre,
					cli_nombre,
					fv.fv_id,
					fv.fv_fecha,
					fv.fv_nrodoc, 
					fv.fv_total
	
	having fv_total <> (sum(fvd_importe)+sum(fvp_importe))
	
end
GO