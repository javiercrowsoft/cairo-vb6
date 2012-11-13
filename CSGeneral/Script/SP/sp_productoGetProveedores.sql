SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_productoGetProveedores]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoGetProveedores]
GO

/*

sp_productoGetProveedores 5974

*/

create procedure sp_productoGetProveedores
(
	@@pr_id   int
)
as
begin

	set nocount on

	----------------------------------------------------------------------------------------------

	create table #t_prov (prov_id int, lp_id int, lpi_id int, lpi_precio decimal(18,6), lpi_top tinyint, lpi_fecha datetime)

	insert into #t_prov (prov_id, lp_id, lpi_id, lpi_precio, lpi_top, lpi_fecha) 

	select distinct lpprov.prov_id, lpi.lp_id, lpi_id, lpi_precio, 0, lpi_fecha
	from ListaPrecioItem lpi left join ListaPrecioProveedor lpprov on lpi.lp_id = lpprov.lp_id
	where lpi.pr_id = @@pr_id

	-- Obtengo que precio es el preferido en ListaPrecioConfig
	--
	declare @lp_id_top int
	declare @orden     tinyint

	select @orden = min(lpc_orden) 
	from ListaPrecioConfig 
	where pr_id = @@pr_id 
		and lp_id in (select lp_id from #t_prov)


	select @lp_id_top = lp_id 
	from ListaPrecioConfig
	where pr_id = @@pr_id
		and lpc_orden = @orden


	update #t_prov set lpi_top = 1
	where lp_id = @lp_id_top

	----------------------------------------------------------------------------------------------

  select 

		prprov.prprov_id,
		prprov.prprov_codigo,
		prprov.prprov_codigobarra,
		prprov.prprov_fabricante,
		prprov.prprov_nombre,

		prprov.activo,
		prprov.creado,
		prprov.modificado,
		prprov.modifico,

		prprov.pa_id,
		prprov.pr_id,

		prov.prov_id,

    prov_nombre,
    pa_nombre,


		lp_nombre,
		t.lp_id,
		t.lpi_id,
		t.lpi_precio,
		t.lpi_fecha,
		t.lpi_top

  from 
    ProductoProveedor prprov left join Proveedor prov on prprov.prov_id = prov.prov_id
                             left join  Pais      pa   on prprov.pa_id   = pa.pa_id
														 left join  #t_prov   t    on prprov.prov_id = t.prov_id
														 left join  ListaPrecio lp on t.lp_id = lp.lp_id
 
  where prprov.pr_id = @@pr_id
 
	union all

  select 

		-1 as prprov_id, -- Si es un registro virtual lo identifico con un -1
		prprov.prprov_codigo,
		prprov.prprov_codigobarra,
		prprov.prprov_fabricante,
		prprov.prprov_nombre,

		prprov.activo,
		prprov.creado,
		prprov.modificado,
		prprov.modifico,

		prprov.pa_id,
		prprov.pr_id,

		prov.prov_id,

    prov_nombre,
    pa_nombre,

		lp_nombre,
		t.lp_id,
		t.lpi_id,
		t.lpi_precio,
		t.lpi_fecha,
		t.lpi_top

  from 
		#t_prov   t left join ProductoProveedor prprov 	on 1=2
     						left join Proveedor prov 						on t.prov_id = prov.prov_id
                left join Pais pa   								on 1=2
							  left join ListaPrecio lp 						on t.lp_id = lp.lp_id
 
  where not exists(select * from ProductoProveedor where pr_id = @@pr_id and prov_id = t.prov_id)
 
  order by prov_nombre

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go

