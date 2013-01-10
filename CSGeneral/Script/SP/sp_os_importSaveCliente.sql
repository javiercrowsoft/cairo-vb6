if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_os_importSaveCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_os_importSaveCliente]

/*

begin transaction

exec sp_os_importSaveCliente 14136, -1

rollback transaction

*/

go
create procedure sp_os_importSaveCliente (
  @@rvTMP_id       int,
  @@bSuccess      tinyint out,
  @@MsgError      varchar(255) out
)
as

begin

  set @@bSuccess = 1
  set @@MsgError = ''

end
