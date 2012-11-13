if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RetencionProveedorAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RetencionProveedorAdd]

/*

*/

go
create procedure sp_RetencionProveedorAdd (
	@@ret_id 		int,
	@@prov_id 	int,
	@@desde     datetime,
	@@hasta     datetime,
	@@us_id     int
)
as

begin

	declare @provret_id int
	exec sp_dbgetnewid 'ProveedorRetencion', 'provret_id', @provret_id out, 0

	insert into ProveedorRetencion (prov_id,
																	provret_id,
																	ret_id,
																	provret_desde,
																	provret_hasta,
																	creado,
																	modificado,
																	modifico
																)
											values		(@@prov_id,
																 @provret_id,
																 @@ret_id,
																 @@desde,
																 @@hasta,
																 getdate(),
																 getdate(),
																 @@us_id
																)

end

go