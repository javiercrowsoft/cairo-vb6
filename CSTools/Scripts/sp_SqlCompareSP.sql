if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SqlCompareSP]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SqlCompareSP]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

  sp_SqlCompareSP 'caironortur'

*/
create procedure sp_SqlCompareSP (
  @@base      varchar(255)        
)
as
begin
  set nocount on

  declare @sqlstmt varchar(8000)

  set @sqlstmt = 'select p.name,p.crdate,p2.name,p2.crdate ' +
                  'from sysobjects p left join '+@@base+'..sysobjects p2 ' +
                  'on p.name = p2.name and p.xtype = ''P'' and p2.xtype = ''P'' ' +
                  'where p.crdate > isnull(p2.crdate,''19000101'')' +
                  'and p.xtype = ''P'' ' +
                  'order by p.crdate,p.name'

  exec(@sqlstmt)

end


GO
