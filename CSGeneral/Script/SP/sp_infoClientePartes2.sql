if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClientePartes2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClientePartes2]

/*

sp_infoClientePartes '',114,1

*/

go
create procedure sp_infoClientePartes2 (
	@@us_id         int,
	@@emp_id        int,
	@@cli_id        int,
	@@info_aux      varchar(255) = ''
)
as

begin

	set nocount on

	declare @fDesde datetime

	set @fDesde = dateadd(d,-180,getdate())

	select 	top 20

					ptd.ptd_id, 
					ptd_fechaini     	as Fecha,
					ptd_numero  		 	as Parte,
					ptd_titulo 				as [Título2],
					ptd_descrip				as Observaciones

	from ParteDiario ptd  left  join Usuario usa  on ptd.us_id_asignador 		= usa.us_id
												left  join Usuario usr  on ptd.us_id_responsable	= usr.us_id

	where ptd.cli_id = @@cli_id 
		and ptd_fechaini >= @fDesde

	order by ptd_fechaini desc, ptd.ptd_id

end
go
