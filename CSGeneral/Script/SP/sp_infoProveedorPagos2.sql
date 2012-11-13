if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorPagos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorPagos2]

/*

sp_infoProveedorPagos '',114,1

*/

go
create procedure sp_infoProveedorPagos2 (
	@@us_id         int,
	@@emp_id        int,
	@@prov_id       int,
	@@info_aux      varchar(255) = ''
)
as

begin

	set nocount on

	declare @fDesde datetime

	set @fDesde = dateadd(d,-180,getdate())

	select 	top 20

					opg.opg_id, 
					opg_fecha 				as Fecha,
					opg_nrodoc				as Comprobante,
					opg_total         as Total,
					opg_pendiente 		as Pendiente,
					emp_nombre      	as Empresa,
					opg_descrip       as Observaciones

	from OrdenPago opg  inner join Empresa emp on opg.emp_id = emp.emp_id

	where prov_id = @@prov_id 
		and opg_fecha >= @fDesde
		and est_id <> 7

	order by opg_fecha desc, opg.opg_id, emp_nombre

end
go