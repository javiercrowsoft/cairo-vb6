if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ComunidadInternetRespuestaPlantillaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ComunidadInternetRespuestaPlantillaGet]

go
/*

*/

create procedure sp_ComunidadInternetRespuestaPlantillaGet (

	@@cmirp_id int

)

as

begin

	set nocount on

	select 	cmirp.*,
					cmi_nombre,
					cmia_nombre,
					idm_nombre,
					marc_nombre,
					pr_nombreventa,
					rub_nombre
	
	from ComunidadInternetRespuestaPlantilla cmirp

				left join ComunidadInternet cmi on cmirp.cmi_id = cmi.cmi_id
				left join ComunidadInternetAplicacion cmia on cmirp.cmia_id = cmia.cmia_id
				left join Idioma idm on cmirp.idm_id = idm.idm_id
				left join Marca marc on cmirp.marc_id = marc.marc_id
				left join Producto pr on cmirp.pr_id = pr.pr_id
				left join Rubro rub on cmirp.rub_id = rub.rub_id
		
	where cmirp.cmirp_id = @@cmirp_id

end