/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ComunidadInternetPreguntaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ComunidadInternetPreguntaGet]

go
create procedure sp_ComunidadInternetPreguntaGet (
  @@cmip_id int
)as 

begin


select 

	cmip.*,
	cmip_nick + '  ' + isnull(cli_nombre,'') as cli_nombre,
	cmi_nombre,
	pr_nombreventa,
	us_nombre as respondio

from 

		ComunidadInternetPregunta cmip 
			left join Cliente cli   on cmip_nick = substring(cli_codigocomunidad,5,100)
			left join ProductoComunidadInternet prcmi on prcmi_codigo = cmip_articuloid
			left join Producto pr on prcmi.pr_id = pr.pr_id
			left join ComunidadInternet cmi on cmip.cmi_id = cmi.cmi_id
			left join usuario us on cmip.us_id_respondio = us.us_id

where 

	cmip_id = @@cmip_id

end

go