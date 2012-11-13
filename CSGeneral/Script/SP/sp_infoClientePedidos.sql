if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClientePedidos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClientePedidos]

/*

sp_infoClientePedidos 1,1,39

*/

go
create procedure sp_infoClientePedidos (
	@@us_id         int,
	@@emp_id        int,
	@@cli_id        int,
	@@info_aux      varchar(255) = ''
)
as

begin

	set nocount on

	exec sp_infoClientePedidos2 @@us_id,
															@@emp_id,
															@@cli_id,
															@@info_aux

end
go