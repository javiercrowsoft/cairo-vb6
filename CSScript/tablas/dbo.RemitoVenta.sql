if exists (select * from sysobjects where id = object_id(N'[dbo].[RemitoVenta]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RemitoVenta]
GO

CREATE TABLE [dbo].[RemitoVenta] (
	[rv_id] [int] NOT NULL ,
	[te_id] [int] NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NULL 
) ON [PRIMARY]
GO

