if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getTextos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getTextos]

go
/*

*/

create procedure sp_srv_cvxi_getTextos (

	@@cmi_id            int,
	@@cmia_id           int,
	@@idm_id            int

)

as

begin

	set nocount on

	select * 
	from ComunidadInternetTexto
	where (cmi_id  is null or cmi_id  = @@cmi_id)
		and (cmia_id is null or cmia_id = @@cmia_id)
		and (idm_id  is null or idm_id  = @@idm_id)

end