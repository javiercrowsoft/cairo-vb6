if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_productoFormulaKitGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoFormulaKitGet]

go

/*

select max(fv_id) from facturaventa

exec sp_productoFormulaKitGet 95,3

*/
create procedure sp_productoFormulaKitGet(
  @@prfk_id    int
) 
as
begin

  declare @bEdit tinyint

  set @bEdit = 1

  if exists(select prfk_id from ProductoSerieKit where prfk_id = @@prfk_id)

    set @bEdit = 0

  else if exists(select prfk_id from ParteProdKitItem where prfk_id = @@prfk_id)

    set @bEdit = 0

  select   f.*, 
           p.pr_nombrecompra, 
          ps.pr_nombrecompra  as ProductoSerie,
          pl.pr_nombrecompra  as ProductoLote,
           @bEdit as bEdit 

  from ProductoFormulaKit f inner join Producto p   on f.pr_id = p.pr_id
                            left  join Producto ps  on f.pr_id_serie = ps.pr_id
                            left  join Producto pl  on f.pr_id_lote  = pl.pr_id
  where prfk_id = @@prfk_id

end
go