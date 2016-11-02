if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetTributos]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetTributos]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create function FEGetTributos (

@@fv_id int

)

returns decimal(18,6)

as
begin

	declare @tributos decimal(18,6)

	select @tributos = sum(fvperc_importe) from FacturaVentaPercepcion where fv_id = @@fv_id

	return isnull(@tributos,0)

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

