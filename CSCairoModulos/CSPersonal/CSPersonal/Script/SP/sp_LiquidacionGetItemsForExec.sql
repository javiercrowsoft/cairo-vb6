if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionGetItemsForExec]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionGetItemsForExec]

go

create procedure sp_LiquidacionGetItemsForExec (
	@@liq_id 		int
)
as

begin

	set nocount on

	select 	liqi.*,
					em_apellido + ', ' + em_nombre as em_nombre

	from LiquidacionItem liqi left join Empleado em on liqi.em_id = em.em_id

	where liqi.liq_id = @@liq_id
					

end

go