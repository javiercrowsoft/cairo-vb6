if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetListasPrecio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetListasPrecio]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoGetListasPrecio 2

create procedure sp_ProductoGetListasPrecio (
	@@pr_id	int
)
as

set nocount on

begin

	select lp.lp_id,
				 lpi_id,
				 lpi_precio,
				 lpi_porcentaje,
				 lp_nombre

	from ListaPrecio lp inner join ListaPrecioItem lpi on lp.lp_id = lpi.lp_id

 	where

     pr_id = @@pr_id

	and lp_tipo = 1

	order by lp_nombre desc

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



