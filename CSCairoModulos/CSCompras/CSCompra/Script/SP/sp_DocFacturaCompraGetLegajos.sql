if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetLegajos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetLegajos]

go

/*

sp_DocFacturaCompraGetLegajos 1

*/
create procedure sp_DocFacturaCompraGetLegajos (
	@@fc_id int
)
as

begin

	select 	FacturaCompraLegajo.*, 
					case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo

	from 	FacturaCompraLegajo
				inner join Legajo   							on FacturaCompraLegajo.lgj_id = Legajo.lgj_id

	where 
			fc_id = @@fc_id

	order by fclgj_orden
end