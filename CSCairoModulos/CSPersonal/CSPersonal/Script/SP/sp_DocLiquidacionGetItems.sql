if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionGetItems]

go

create procedure sp_DocLiquidacionGetItems (
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