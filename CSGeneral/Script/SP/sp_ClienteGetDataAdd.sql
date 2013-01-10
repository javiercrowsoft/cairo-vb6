if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ClienteGetDataAdd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ClienteGetDataAdd]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/*

*/

create procedure sp_ClienteGetDataAdd (
  @@cli_id  int
)
as

set nocount on

begin

  exec sp_ClienteGetDataAddCliente @@cli_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



