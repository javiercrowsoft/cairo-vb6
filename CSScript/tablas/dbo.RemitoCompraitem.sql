if exists (select * from sysobjects where id = object_id(N'[dbo].[RemitoCompraitem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RemitoCompraitem]
GO

CREATE TABLE [dbo].[RemitoCompraitem] (
	[rci_id] [int] NOT NULL ,
	[pr_id] [int] NULL 
) ON [PRIMARY]
GO

