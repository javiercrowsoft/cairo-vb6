if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteCobranzas2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteCobranzas2]

/*

sp_infoClienteCobranzas '',114,1

*/

go
create procedure sp_infoClienteCobranzas2 (
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

					cobz.cobz_id, 
					cobz_fecha 				as Fecha,
					cobz_nrodoc				as Comprobante,
					cobz_total        as Total,
					cobz_pendiente 		as Pendiente,
					emp_nombre      	as Empresa,
					cobz_descrip      as Observaciones

	from Cobranza cobz  inner join Empresa emp on cobz.emp_id = emp.emp_id

	where cli_id = @@cli_id 
		and cobz_fecha >= @fDesde
		and est_id <> 7

	order by cobz_fecha desc, cobz.cobz_id, emp_nombre

end
go