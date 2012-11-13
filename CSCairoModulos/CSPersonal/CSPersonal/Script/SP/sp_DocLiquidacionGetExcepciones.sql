if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionGetExcepciones]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionGetExcepciones]

go

create procedure sp_DocLiquidacionGetExcepciones (
	@@liq_id 		int
)
as

begin

	set nocount on

	select 	liqe.*,
					em_nombre,
					liqfi_codigo,
					ccos_nombre

	from LiquidacionExcepcion liqe left join Empleado em on liqe.em_id = em.em_id
																 left join LiquidacionFormulaItem liqfi on liqe.liqfi_id = liqfi.liqfi_id
																 left join CentroCosto ccos on liqe.ccos_id = ccos.ccos_id

	where liqe.liq_id = @@liq_id
					

end

go