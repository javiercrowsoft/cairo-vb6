if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetForNroDoc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetForNroDoc]

go
/*

*/

create procedure sp_DocFacturaVentaGetForNroDoc (
	@@fv_nrodoc		varchar(50),
  @@emp_id      int
)
as

begin

	set nocount on

	select fv_nrodoc,cli_nombre,doc_nombre,fv_fecha 
	from facturaVenta fv inner join cliente cli 	on fv.cli_id = cli.cli_id
											 inner join documento doc on fv.doc_id = doc.doc_id

	where fv_nrodoc = @@fv_nrodoc and fv.emp_id = @@emp_id

end