if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_CursoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CursoSave]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_CursoSave 1,10,2

*/
create procedure sp_CursoSave (
	@@cur_id  int
)
as
begin

	set nocount on

		select 	1 	as success, 
						0 	as warning, 
						''	as message

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

