if exists (select * from sysobjects where id = object_id(N'[dbo].[Historia]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Historia]
GO

CREATE TABLE [dbo].[Historia] (
	[tbl_id] [int] NOT NULL ,
	[id] [int] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[modificado] [datetime] NOT NULL 
) ON [PRIMARY]
GO

