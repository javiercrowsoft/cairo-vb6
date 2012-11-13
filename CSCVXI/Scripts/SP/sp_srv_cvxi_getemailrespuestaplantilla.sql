if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getEmailRespuestaPlantilla]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getEmailRespuestaPlantilla]

go
/*
select * from idioma
*/

create procedure sp_srv_cvxi_getEmailRespuestaPlantilla (

	@@cmi_id					int,
	@@cmia_id					int,
	@@idm_id					int,
	@@marc_id					int,
	@@pr_id						int,
	@@rub_id					int

)

as

begin

	set nocount on

	select * 
	from ComunidadInternetRespuestaPlantilla
	where (cmi_id 	= @@cmi_id 			or @@cmi_id 		= 0)
		and (cmia_id 	= @@cmia_id 		or @@cmia_id 		= 0)
		and (idm_id 	= @@idm_id 			or @@idm_id 		= 0)
		and (marc_id 	= @@marc_id 		or @@marc_id 		= 0)
		and (pr_id 		= @@pr_id 			or @@pr_id 			= 0)
		and (rub_id 	= @@rub_id 			or @@rub_id 		= 0)

end