if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionItemCodigoTMPSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionItemCodigoTMPSave]

go

create procedure sp_LiquidacionItemCodigoTMPSave (
	@@liqcTMP_id 			int,
	@@liqi_id 				int,
	@@liqfi_id 		 		int,
	@@liqic_importe 	decimal(18,6),
	@@liqic_unidades 	decimal(18,6)
)
as

begin

	set nocount on

	insert into LiquidacionItemCodigoTMP (liqcTMP_id,
																				liqi_id,
																				liqfi_id,
																				liqic_importe,
																				liqic_unidades
																				)			
																values (@@liqcTMP_id,
																				@@liqi_id,
																				@@liqfi_id,
																				@@liqic_importe,
																				@@liqic_unidades
																				)
end

go