if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_9996]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_9996]
GO


/*

DC_CSC_STK_9996 1

*/

create procedure DC_CSC_STK_9996 (

	@@us_id int,

	@@borrar	smallint

)
as
begin

	set nocount on

	if @@borrar = 0 begin

		select 	ps.prns_id, 
						pr_nombrecompra 	as Articulo,
					 	prns_codigo 			as Serie,
						ps.creado				  as Creado

		from productonumeroserie ps inner join producto pr on ps.pr_id = pr.pr_id 
																	--and pr_eskit <> 0 and pr_id_kit is null
																	and not exists (select * from stockitem where prns_id = ps.prns_id)
		
	end else begin

		delete productonumeroserie where prns_id in (
		
		select ps.prns_id
		from productonumeroserie ps inner join producto pr on ps.pr_id = pr.pr_id 
																	--and pr_eskit <> 0 and pr_id_kit is null
																	and not exists (select * from stockitem where prns_id = ps.prns_id)
		)
		
		delete stockcache where prns_id in (
		
		select ps.prns_id
		from productonumeroserie ps inner join producto pr on ps.pr_id = pr.pr_id 
																	--and pr_eskit <> 0 and pr_id_kit is null
																	and not exists (select * from stockitem where prns_id = ps.prns_id)
		)

		select 1, 'El comando se ejecuto con exito' as Info

	end
		
end

go