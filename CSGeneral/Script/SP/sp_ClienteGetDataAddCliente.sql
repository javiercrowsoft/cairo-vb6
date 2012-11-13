if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ClienteGetDataAddCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ClienteGetDataAddCliente]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

*/

create procedure sp_ClienteGetDataAddCliente (
	@@cli_id	int
)
as

set nocount on

begin

	exec sp_ClienteGetDataAddCairo @@cli_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



