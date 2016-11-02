if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FEGetNroDoc]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FEGetNroDoc]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


create function FEGetNroDoc  (

@@fv_nrodoc varchar(50)

)

returns int

as
begin

	return substring(@@fv_nrodoc,8,50)

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

