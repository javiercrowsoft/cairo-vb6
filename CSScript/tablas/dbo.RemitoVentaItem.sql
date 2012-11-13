if exists (select * from sysobjects where id = object_id(N'[dbo].[RemitoVentaItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RemitoVentaItem]
GO

CREATE TABLE [dbo].[RemitoVentaItem] (
	[rvi_id] [int] NOT NULL ,
	[pr_id] [int] NULL 
) ON [PRIMARY]
GO

