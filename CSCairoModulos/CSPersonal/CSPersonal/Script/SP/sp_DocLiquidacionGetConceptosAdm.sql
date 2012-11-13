if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionGetConceptosAdm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionGetConceptosAdm]

go

create procedure sp_DocLiquidacionGetConceptosAdm (
	@@liq_id 		int
)
as

begin

	set nocount on

	select 	liqca.*,
					em_nombre,
					liqfi_codigo,
					ccos_nombre

	from LiquidacionConceptoAdm liqca 	left join Empleado em on liqca.em_id = em.em_id
																 			left join LiquidacionFormulaItem liqfi on liqca.liqfi_id = liqfi.liqfi_id
																 			left join CentroCosto ccos on liqca.ccos_id = ccos.ccos_id

	where liqca.liq_id = @@liq_id
					

end

go