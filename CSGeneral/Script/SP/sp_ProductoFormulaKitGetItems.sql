if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_productoFormulaKitGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoFormulaKitGetItems]

go

/*

sp_productoFormulaKitGetItems 7

*/
create procedure sp_productoFormulaKitGetItems(
	@@prfk_id		int
) 
as
begin

	-- Items

	select  pk.*, 
					pr_nombrecompra

	from ProductoKit pk inner join Producto pr on pk.pr_id_item = pr.pr_id

	where pk.prfk_id = @@prfk_id

	order by pr_nombrecompra

	-- Alternativas

	select	prka.*,
					pr_nombrecompra

	from ProductoKit pk inner join ProductoKitItemA prka on pk.prk_id = prka.prk_id
											inner join Producto pr           on prka.pr_id = pr.pr_id

	where pk.prfk_id = @@prfk_id

	order by pk.prk_id, pr_nombrecompra

end
go