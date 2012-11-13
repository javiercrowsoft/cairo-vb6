if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionExistsLiquidacionXCodigo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionExistsLiquidacionXCodigo]

go

create procedure sp_LiquidacionExistsLiquidacionXCodigo (
	@@liq_id      	int,
	@@liqf_id       int,
	@@em_id 				int,
  @@liqfi_codigo 	varchar(255),
  @@dias        	int,
	@@meses       	int
)
as

begin

	set nocount on

	declare @fecha_desde 		datetime
	declare @liq_fechadesde datetime

	if @@liq_id = 0 

		set @liq_fechadesde = convert(varchar(10),getdate(),112)

	else 
	
		select @liq_fechadesde = liq_fechadesde from Liquidacion where liq_id = @@liq_id
	

	if @@dias > 0  set @fecha_desde = dateadd(d,-@@dias,@liq_fechadesde)
	if @@meses > 0 set @fecha_desde = dateadd(m,-@@meses,@liq_fechadesde)

	-- Busco este codigo de liquidacion ( Liquidacion Formula item )
	-- en las liquidaciones anteriores a la recibida en @@liq_id
	-- no mas viejas que -@@dias o -@@meses
	--
	if exists(select * 
						from LiquidacionItemCodigo liqic inner join LiquidacionItem liqi on liqic.liqi_id = liqi.liqi_id
						where exists(select * from LiquidacionFormulaItem 
												 where liqfi_id = liqic.liqfi_id 
													 and (liqf_id = @@liqf_id or @@liqf_id = 0)
													 and liqfi_codigo = @@liqfi_codigo
												)
							and liqi.em_id = @@em_id 
							and liqi.liq_id <> @@liq_id
					)

		select 1 -- Ya hay una liquidacion

	else

		select 0 -- No hay una liquidacion

end