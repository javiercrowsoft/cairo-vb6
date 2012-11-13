if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ImportacionIDHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ImportacionIDHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_ImportacionIDHelp 1,'300%',0,0,596

 sp_ImportacionIDHelp 3,'',0,0,1 

  select * from usuario where us_nombre like '%ahidal%'

*/
create procedure sp_ImportacionIDHelp (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@impid_id        int           = 0,
	@@filter2         varchar(255)  = ''
)
as
begin

	set nocount on

	if @@check <> 0 begin

		select	impid_id,
						impid_descrip   	as [Descripción],
						impid_fecha				as [Fecha]

		from ImportacionID

		where (convert(varchar(12),impid_fecha,105) = convert(varchar(12),@@filter,105) 
						or impid_descrip = @@filter)
			and (impid_id = @@impid_id or @@impid_id=0)

	end else begin

			select top 50
						 impid_id,
             impid_descrip   as [Descripción],
	           impid_fecha     as [Fecha]

			from ImportacionID 

			where (impid_descrip like '%'+@@filter+'%' or convert(varchar(12),impid_fecha,105) like '%'+@@filter+'%' 
              or @@filter = '')
	end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

