if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetUltimasCompras]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetUltimasCompras]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoGetUltimasCompras 2

create procedure sp_ProductoGetUltimasCompras (
	@@pr_id	int
)
as

set nocount on

begin

	declare @mon_id int

	select @mon_id = mon_id from Moneda where mon_legal <> 0

	declare @lp_id_costo 		int
	declare @lp_id_compra		int

	select @lp_id_costo  = lp_id from ListaPrecio where lp_tipo = 3 and lp_default <> 0 and mon_id = @mon_id
	select @lp_id_compra = lp_id from ListaPrecio where lp_tipo = 2 and lp_default <> 0 and mon_id = @mon_id

--//////////////////////////////////////////////////////////////////////////////////
--
-- Lista de Costos por Defecto
--
	select top 10

		null fc_id,
		null fci_id,
		null doct_id,
		lp_nombre 			as fc_nrodoc,
		lpi.modificado  as fc_fecha,
		''              as prov_nombre,
		lpi_precio      as fci_precioLista,
		''   						as fci_descuento,
		lpi_precio      as fci_precio,
		0								as fci_cantidad

	from ListaPrecio lp inner join ListaPrecioItem lpi on lp.lp_id = lpi.lp_id
 	where

     pr_id = @@pr_id

		and lp.lp_id in (@lp_id_costo, @lp_id_compra)

	union all

--//////////////////////////////////////////////////////////////////////////////////
--
-- Facturas
--
	select top 10

		fc.fc_id,
		fci.fci_id,
		fc.doct_id,
		fc_nrodoc,
		fc_fecha,
		prov_nombre,
		fci_precioLista,
		fci_descuento,
		fci_precio,
		fci_cantidad

	from FacturaCompra fc inner join Proveedor prov on fc.prov_id = prov.prov_id
												inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
											  inner join Documento doc on fc.doc_id = doc.doc_id
 	where pr_id = @@pr_id
		and fc.doct_id = 2
		and doc.mon_id = @mon_id

--//////////////////////////////////////////////////////////////////////////////////
--
-- Remitos
--
	union all

	select top 10

		rc.rc_id,
		rci.rci_id,
		rc.doct_id,
		rc_nrodoc,
		rc_fecha,
		prov_nombre,
		rci_precioLista,
		rci_descuento,
		rci_precio,
		rci_cantidad

	from RemitoCompra rc inner join Proveedor prov on rc.prov_id = prov.prov_id
											 inner join RemitoCompraItem rci on rc.rc_id = rci.rc_id
											 inner join Documento doc on rc.doc_id = doc.doc_id
 	where pr_id = @@pr_id
		and rc.doct_id = 4
		and doc.mon_id = @mon_id

	order by fc_fecha desc

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



