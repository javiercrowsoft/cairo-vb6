if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_afip_insertCuit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_afip_insertCuit]

/*

sp_srv_afip_insertCuit 

*/

go
create procedure sp_srv_afip_insertCuit(

					@@safipc_cuit				varchar(50),
					@@safipc_folder			varchar(255)

) as

begin

	set nocount on

	declare @safipc_id int

	exec sp_dbgetnewid 'SRV_AfipCuit', 'safipc_id', @safipc_id out, 0

	insert SRV_AfipCuit (

					safipc_id,
					safipc_cuit,
					safipc_folder,
					safipc_pendiente,
					safipc_success,
					safipc_error

	) 
	values(
					@safipc_id,
					@@safipc_cuit,
					@@safipc_folder,
					1,
					0,
					''
				)


	select @safipc_id as id
end

go

/*
*/