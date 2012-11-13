if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_HelpGetFilter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HelpGetFilter]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

*/
create procedure sp_HelpGetFilter (
	@@bFilterType     tinyint,
	@@filter 					varchar(255) out
)
as
begin

	set nocount on

--/////////////////////////////////////////////////////////////////////////////////////

/*

Public Const c_HelpFilterBeginLike = 1
Public Const c_HelpFilterHaveTo = 2
Public Const c_HelpFilterWildcard = 3
Public Const c_HelpFilterEndLike = 4
Public Const c_HelpFilterIsLike = 5
*/
	set @@filter =

			case @@bFilterType

				when 1 then @@filter + '%'
				when 3 then replace(@@filter,'*','%')
				when 4 then '%' + @@filter
				when 5 then @@filter

				-- Default
				-- case 2 then '%' + @@filter + '%'    
				else				'%' + @@filter + '%'

			end

--/////////////////////////////////////////////////////////////////////////////////////

end
GO