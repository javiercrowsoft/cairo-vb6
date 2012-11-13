if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_StockLoteGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_StockLoteGet]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_StockLoteGet 35639

*/

go
create procedure sp_StockLoteGet (
	@@stl_id 		int
)
as

begin

	set nocount on

  select stl.*,
         pr_nombrecompra,
         pa_nombre,
         stlp.stl_codigo as stl_codigo2

  from StockLote stl inner join Producto pr     on stl.pr_id         = pr.pr_id
                     left  join Pais pa         on stl.pa_id         = pa.pa_id
                     left  join StockLote stlp  on stl.stl_id_padre  = stlp.stl_id

	where stl.stl_id = @@stl_id

end

go