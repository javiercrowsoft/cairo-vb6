/*---------------------------------------------------------------------
Nombre: busca una factura por su numero de comprobante
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9997]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9997]

/*
select * from facturaventa where fv_nrodoc = 'x-0001-00001903'
DC_CSC_VEN_9997 1,'a-0001-00025361'
*/

go
create procedure DC_CSC_VEN_9997 (

  @@us_id     int,
  @@fv_nrodoc varchar(255)

)as 
begin
set nocount on

  set nocount on

	if @@fv_nrodoc <> '' begin

		set @@fv_nrodoc = '%' + @@fv_nrodoc + '%'

	  select fv_id,
					 doc_nombre as Documento,
	         fv_numero  as Numero,
	         fv_nrodoc  as Comprobante,
	         fv_fecha   as Fecha,
					 cli_nombre as Cliente,
					 emp_nombre as Empresa,
					 fv_descrip as Observaciones
	
	  from facturaVenta fv inner join cliente  cli  on fv.cli_id = cli.cli_id
												 inner join empresa  emp  on fv.emp_id = emp.emp_id
												 inner join documento doc on fv.doc_id = doc.doc_id
	  where fv_nrodoc like @@fv_nrodoc

	end
	else

		select 0,'Debe indicar un número de factura' as Mensaje
end
go