if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionGetEmpleadoFormula]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionGetEmpleadoFormula]

go

create procedure sp_LiquidacionGetEmpleadoFormula (
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

  from LiquidacionFormula

  where liqf_id = @liqf_id
          
end

go