if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_afip_getCuits]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_afip_getCuits]

/*

sp_srv_afip_getCuits 

*/

go
create procedure sp_srv_afip_getCuits as

begin

	set nocount on

	select 
					safipc_id     as id,
					safipc_cuit   as cuit,
					safipc_folder as folder

	from SRV_AfipCuit

	where safipc_pendiente <> 0

end

go

/*
*/