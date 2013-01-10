if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionGetEmpleadoGetFormulaItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionGetEmpleadoGetFormulaItem]

go

create procedure sp_LiquidacionGetEmpleadoGetFormulaItem (
  @@liq_id     int,
  @@em_id     int
)
as

begin

  set nocount on

  declare @liqp_id int

  select @liqp_id = liqp_id from Liquidacion where liq_id = @@liq_id

  declare @liqf_id int
  
  select @liqf_id = liqf_id from LiquidacionPlantillaItem where em_id = @@em_id and liqp_id = @liqp_id

  select   *

  from LiquidacionFormulaItem

  where liqf_id = @liqf_id
          
end

go