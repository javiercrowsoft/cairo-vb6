if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getTextoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getTextoItems]

go
/*

*/

create procedure sp_srv_cvxi_getTextoItems (

	@@cmit_id           int

)

as

begin

	set nocount on

	select * 
	from ComunidadInternetTextoItem
	where cmit_id  = @@cmit_id
	order by cmiti_orden

end