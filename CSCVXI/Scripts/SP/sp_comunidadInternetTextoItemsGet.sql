if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_comunidadInternetTextoItemsGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_comunidadInternetTextoItemsGet]

go
/*

*/

create procedure sp_comunidadInternetTextoItemsGet (

	@@cmit_id int
)

as

begin

	set nocount on

	select 	i.*,
					p.cmiti_nombre as padre

	from ComunidadInternetTextoItem i 
						left join ComunidadInternetTextoItem p on i.cmiti_id_padre = p.cmiti_id

	where i.cmit_id = @@cmit_id

	order by i.cmiti_orden
end