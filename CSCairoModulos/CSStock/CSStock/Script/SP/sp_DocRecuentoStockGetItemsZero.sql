if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockGetItemsZero]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockGetItemsZero]

go

/*

select * from depositologico

sp_DocRecuentoStockGetItemsZero 1

*/
create procedure sp_DocRecuentoStockGetItemsZero (
	@@depl_id int
)
as

begin

		select 	0 					as rs_id,
						0 					as rsi_id,
						0 					as rsi_orden,
						0 					as rsi_cantidadstock,
						0 					as rsi_cantidad,
						0 					as rsi_ajuste,
						'' 					as rsi_descrip,
						pr_id,
						@@depl_id 	as depl_id,
						0  					as stl_id,
 
						pr_nombrecompra, 
						pr_llevanroserie,
						pr_llevanrolote,
						pr_eskit,
	          un_nombre,
	          depl_nombre,
						'' stl_codigo
	
		from 	producto pr	inner join Unidad un								on pr.un_id_stock = un.un_id
	        						inner join DepositoLogico depl      on @@depl_id      = depl.depl_id
	
		where pr_llevanroserie =0 
			and pr_llevanrolote  =0
			and exists (select pr_id 
									from stockitem 
									where depl_id = @@depl_id 
										and pr_id 	= pr.pr_id 
										and pr_id_kit is null
									group by pr_id, depl_id
									having (sum (sti_ingreso)- sum (sti_salida)) <> 0
									)

	order by pr_nombrecompra

end

GO