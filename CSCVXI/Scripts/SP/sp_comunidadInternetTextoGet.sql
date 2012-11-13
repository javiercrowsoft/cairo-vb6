if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_comunidadInternetTextoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_comunidadInternetTextoGet]

go
/*

*/

create procedure sp_comunidadInternetTextoGet (

	@@cmit_id int
)

as

begin

	set nocount on

	select 	c.*,
					cmia_nombre,
					cmi_nombre,
					idm_nombre,
					cmiea_nombre

	from ComunidadInternetTexto c left join ComunidadInternet cmi on c.cmi_id = cmi.cmi_id
																left join ComunidadInternetAplicacion cmia on c.cmia_id = cmia.cmia_id
																left join Idioma idm on c.idm_id = idm.idm_id
																left join ComunidadInternetEmailAccount cmiea on c.cmiea_id = cmiea.cmiea_id
	where cmit_id = @@cmit_id

end