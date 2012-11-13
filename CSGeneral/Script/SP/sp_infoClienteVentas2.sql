if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteVentas2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteVentas2]

/*

sp_infoClienteVentas 1,1,912

select * from cliente where cli_nombre like '%tai%'

sp_infoClienteVentas '',114,1

*/

go
create procedure sp_infoClienteVentas2 (
	@@us_id        int,
	@@emp_id       int,
	@@cli_id       int,
	@@info_aux     varchar(255) = ''
)
as

begin

	set nocount on

	declare @fDesde datetime

	set @fDesde = dateadd(d,-180,getdate())

	select 	top 20

					fv.fv_id, 
					fv_fecha 				as Fecha,
					fv_nrodoc				as Comprobante,

					(case when fv.doct_id = 7 then -fv_total      else fv_total 		 end) as Total,
					(case when fv.doct_id = 7 then -fvd_pendiente else fvd_pendiente end)	as Pendiente,

					fvd_fecha       as Vto,
					emp_nombre      as Empresa,
					fv_descrip      as Observaciones

	from FacturaVenta fv 	left  join FacturaVentaDeuda fvd 	on fv.fv_id   = fvd.fv_id
											 	inner join Empresa emp           	on fv.emp_id = emp.emp_id

	where cli_id = @@cli_id 
		and fv_fecha >= @fDesde
		and est_id <> 7

	order by fv_fecha desc, fv.fv_id, fvd_fecha, emp_nombre

end
go