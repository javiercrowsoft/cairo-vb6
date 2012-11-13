if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorChartProductos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorChartProductos2]

/*

sp_infoProveedorChartProductos 1,1,34

*/

go
create procedure sp_infoProveedorChartProductos2 (
	@@us_id        int,
	@@emp_id       int,
	@@prov_id      int,
	@@info_aux     varchar(255) = ''
)
as

begin

	set nocount on

	declare @fDesde datetime

	set @fDesde = dateadd(d,-180,getdate())

	select 	pr_nombreCompra						as [Artículo],
					sum(case when doct_id = 8 then -fci_neto else fci_neto end)   					     					
																		as Total

	from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id 	= fci.fc_id
											  inner join Producto pr           on fci.pr_id	= pr.pr_id
	where prov_id = @@prov_id 
		and fc_fecha >= @fDesde
		and est_id <> 7

	group by pr_nombreCompra

	order by sum(case when doct_id = 8 then -fci_neto else fci_neto end) desc, pr_nombreCompra

end
go