if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoSavePrecio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoSavePrecio]

/*

sp_ProductoSavePrecio 

*/

go
create procedure sp_ProductoSavePrecio (
	@@pr_id			int,
	@@lpi_id 		int,
	@@precio    decimal(18,6),
	@@fecha     datetime
)
as

begin

	set nocount on

	-- 1 tengo que actualizar el lpi_id
	declare @precio decimal(18,6)
	declare @lp_id  int
	declare @pr_id  int

	select @precio = lpi_precio,
				 @lp_id  = lp_id,
				 @pr_id  = pr_id

	from ListaPrecioItem 
	where lpi_id = @@lpi_id

	-- Valido que estemos en el mismo pr_id
	--
	if @@pr_id <> @pr_id return


	if @precio <> @@precio begin

		-- 1 tengo que actualizar el lpi_id
		update ListaPrecioItem set lpi_precio = @@precio, lpi_fecha = @@fecha
		where lpi_id = @@lpi_id

		-- 2 tengo que actualizar el cache de precios	
		exec sp_listaPrecioUpdateCache @lp_id, 0, @@pr_id

		-- 3 actualizo el historial de la lista
		exec sp_ListaPrecioUpdateHistorial @@lpi_id

	end

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

