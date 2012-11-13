/*---------------------------------------------------------------------
Nombre: Facturas con fechas fuera de rango
---------------------------------------------------------------------*/

/*
Para testear:


DC_CSC_SYS_0080 1,'20041230','20060304'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0080]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0080]

go
create procedure DC_CSC_SYS_0080 (

  @@us_id    int,

	@@fecha_menor datetime,
	@@fecha_mayor datetime
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
					fc.fc_total			as Total
	
	from facturacompra fc 
												inner join documento doc          on fc.doc_id  = doc.doc_id
												inner join empresa emp            on doc.emp_id = emp.emp_id
												inner join proveedor prov         on fc.prov_id = prov.prov_id
	
	where fc_fecha <= @@fecha_menor or fc_fecha >= @@fecha_mayor

	union
	
	select 	
					2,
					'Ventas',
					emp_nombre,
					doc_nombre,
					cli_nombre,
					fv.fv_fecha,
					fv.fv_nrodoc,
					fv.fv_total
	
	from facturaventa fv 
											 inner join documento doc          on fv.doc_id  = doc.doc_id
											 inner join empresa emp            on doc.emp_id = emp.emp_id
											 inner join cliente cli         	 on fv.cli_id = cli.cli_id
	
	where fv_fecha <= @@fecha_menor or fv_fecha >= @@fecha_mayor
	
end
GO