if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteCheques]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteCheques]

/*

sp_infoClienteCheques '',114,1

*/

go
create procedure sp_infoClienteCheques (
	@@us_id         int,
	@@emp_id        int,
	@@cli_id        int,
	@@info_aux      varchar(255) = ''
)
as

begin

	set nocount on

	exec sp_infoClienteCheques2 @@us_id,
															@@emp_id,
															@@cli_id,
															@@info_aux

end
go
