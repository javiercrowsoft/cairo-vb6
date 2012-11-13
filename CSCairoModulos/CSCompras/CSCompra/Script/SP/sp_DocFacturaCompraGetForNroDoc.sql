if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetForNroDoc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetForNroDoc]

go
/*

*/

create procedure sp_DocFacturaCompraGetForNroDoc (
	@@fc_nrodoc		varchar(50),
  @@prov_id     int
)
as

begin

	set nocount on

	select fc_nrodoc,prov_nombre,doc_nombre,fc_fecha 
	from facturaCompra fc inner join proveedor prov on fc.prov_id = prov.prov_id
											  inner join documento doc 	on fc.doc_id  = doc.doc_id

	where fc_nrodoc = @@fc_nrodoc and fc.prov_id = @@prov_id

end