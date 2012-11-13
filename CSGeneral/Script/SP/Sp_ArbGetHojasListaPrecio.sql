if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbGetHojasListaPrecio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetHojasListaPrecio]

/*
select * from tabla
select * from listaprecioitem
select * from rama where arb_id in (select arb_id from arbol where tbl_id = 30)
select * from hoja where ram_id = 3827
sp_ArbGetHojasListaPrecio 2,3827

*/

go
create procedure sp_ArbGetHojasListaPrecio (
	@@lp_id         int,
	@@ram_id 				int,
	@@soloColumnas 	smallint = 0,
	@@aBuscar 			varchar(255) ='',
	@@top 					int = 1500
)
as
begin
set nocount on

declare @esRaiz			int
declare @arb_id			int

	select @esRaiz = ram_id_padre, @arb_id = arb_id from rama where ram_id = @@ram_id
	if @esRaiz = 0 
	 begin
		create table #HojaId (hoja_id int, id int)

		-- Ids de la raiz
		insert into #HojaId select hoja_id,id from Hoja where ram_id = @@ram_id

		-- Ids sin asignar
		insert into #HojaId select pr_id *-1, pr_id from producto 
				where not exists (select * from Hoja where Hoja.id = Producto.pr_id and arb_id = @arb_id)

		select top 300 --@@top 
	
						hoja_id, 
						ID							= Producto.pr_id, 
						Nombre					= pr_nombrecompra,
            Codigo          = pr_codigo,
						Precio			    = (select lpi_precio from ListaPrecioItem where pr_id = Producto.pr_id and lp_id = @@lp_id),
	          Porcentaje 	    = (select lpi_porcentaje from ListaPrecioItem where pr_id = Producto.pr_id and lp_id = @@lp_id)
		from 
					-- el filtro esta en #HojaId
					Producto  inner join #HojaId         on #HojaId.id = Producto.pr_id
	 end
	else

		select top 300 --@@top 
	
						hoja_id, 
						ID							= Producto.pr_id, 
						Nombre					= pr_nombrecompra,
            Codigo          = pr_codigo,
						Precio			    = (select lpi_precio from ListaPrecioItem where pr_id = Producto.pr_id and lp_id = @@lp_id),
	          Porcentaje	    = (select lpi_porcentaje from ListaPrecioItem where pr_id = Producto.pr_id and lp_id = @@lp_id)
		from 
					Producto  inner join Hoja on Hoja.id = Producto.pr_id
		where 
					Hoja.ram_id = @@ram_id
 end

go