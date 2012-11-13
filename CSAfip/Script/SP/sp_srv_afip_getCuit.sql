if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_afip_getCuit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_afip_getCuit]

/*

sp_srv_afip_getCuit 1

*/

go
create procedure sp_srv_afip_getCuit(

	@@safipc_id			int

) as

begin

	set nocount on

	select

			safipc_pendiente		as pendiente,
			safipc_success 			as success,
      safipc_error   			as error

	from SRV_AfipCuit

	where safipc_id = @@safipc_id

end

go

/*
*/