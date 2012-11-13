if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TrabajoImpresionSaveItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TrabajoImpresionSaveItem]

/*

*/

go
create procedure sp_TrabajoImpresionSaveItem (
	@@timp_id 							int,
	@@timpi_id							int,
	@@timpi_rptname					varchar(1000),
	@@timpi_rptfile					varchar(500),
	@@timpi_action					tinyint,
	@@timpi_copies					tinyint,
	@@timpi_strobject				varchar(255)

)
as

begin

	if @@timpi_id = 0 begin

		exec sp_dbgetnewid 'TrabajoImpresionItem', 'timpi_id', @@timpi_id out, 0

		insert into TrabajoImpresionItem (timp_id, timpi_id, timpi_rptname, timpi_rptfile, timpi_action, timpi_copies, timpi_strobject)
												  		values (@@timp_id, @@timpi_id, @@timpi_rptname, @@timpi_rptfile, @@timpi_action, @@timpi_copies, @@timpi_strobject)

	end else begin

		update TrabajoImpresionItem set timpi_rptname = @@timpi_rptname,
																		timpi_rptfile = @@timpi_rptfile,
																		timpi_action = @@timpi_action,
																		timpi_copies = @@timpi_copies,
																		timpi_strobject = @@timpi_strobject
		where timpi_id = @@timpi_id																

	end

	select @@timpi_id as timpi_id

end

go