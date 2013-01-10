if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetExento]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetExento]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create function FEGetExento (

@@fv_id int

)

returns decimal(18,6)

as
begin

  declare @exento decimal(18,6)

  select @exento = sum(fvi_neto) from FacturaVentaItem where fv_id = @@fv_id and fvi_ivarniporc = 0 and fvi_ivariporc = 0

  return isnull(@exento,0)

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

