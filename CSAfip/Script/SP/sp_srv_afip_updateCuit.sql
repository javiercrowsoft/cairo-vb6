if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_afip_updateCuit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_afip_updateCuit]

/*

sp_srv_afip_updateCuit 

*/

go
create procedure sp_srv_afip_updateCuit(

  @@safipc_id int,
  @@success   tinyint,
  @@errormsg  varchar(255)

) as

begin

  set nocount on

  update SRV_AfipCuit set 
          safipc_pendiente = 0,
          safipc_success   = @@success,
          safipc_error     = @@errormsg

  where safipc_id = @@safipc_id

end

go

/*
*/