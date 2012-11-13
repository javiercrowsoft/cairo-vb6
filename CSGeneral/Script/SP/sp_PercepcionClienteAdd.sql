if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PercepcionClienteAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PercepcionClienteAdd]

/*

*/

go
create procedure sp_PercepcionClienteAdd (
	@@perc_id 	int,
	@@cli_id 		int,
	@@desde     datetime,
	@@hasta     datetime,
	@@us_id     int
)
as

begin

	declare @cliperc_id int
	exec sp_dbgetnewid 'ClientePercepcion', 'cliperc_id', @cliperc_id out, 0

	insert into ClientePercepcion (cli_id,
																 cliperc_id,
																 perc_id,
																 cliperc_desde,
																 cliperc_hasta,
																 creado,
																 modificado,
																 modifico
																)
											values		(@@cli_id,
																 @cliperc_id,
																 @@perc_id,
																 @@desde,
																 @@hasta,
																 getdate(),
																 getdate(),
																 @@us_id
																)

end

go