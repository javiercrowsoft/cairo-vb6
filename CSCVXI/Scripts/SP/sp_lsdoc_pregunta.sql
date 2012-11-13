/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_pregunta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_pregunta]

go
create procedure sp_lsdoc_pregunta (
  @@cmip_id    int

)as 

begin

set nocount on

select 

	cmip_id,
	'' 													as TypeTask,
  cmip_nick + '   ' + isnull(cli_nombre,'') 									
															as Cliente,
	cmip_fecha 									as [Fecha Pregunta],
	cmip_fecha_respuesta 				as [Fecha Respuesta],
	us.us_nombre 								as Respondio,

	cmip_articuloid 						as Codigo,
	case when cmip_articulo = '' then pr_nombreventa else cmip_articulo end as Articulo,
	cmi_nombre									as Cliente,
	cmip_pregunta + char(10) 
						  + char(10) + '-----------------------------------' 
						  + char(10) + '   respuesta ' 
						  + char(10) + '-----------------------------------' 
							+ char(10) + cmip_respuesta + char(10) 
						  + char(10) + '-----------------------------------' 
						  + char(10) + '   Observaciones ' 
						  + char(10) + '-----------------------------------'
							+ char(10) + cmip_descrip
															as Descripcion

from 

		ComunidadInternetPregunta cmip 
			left join Cliente cli   on cmip_nick = substring(cli_codigocomunidad,5,100)
			left join ProductoComunidadInternet prcmi on prcmi_codigo = cmip_articuloid
			left join Producto pr on prcmi.pr_id = pr.pr_id
			left join ComunidadInternet cmi on cmip.cmi_id = cmi.cmi_id
			left join usuario us on cmip.us_id_respondio = us.us_id

where cmip.cmip_id = @@cmip_id

end

go