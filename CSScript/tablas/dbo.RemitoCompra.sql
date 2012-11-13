if exists (select * from sysobjects where id = object_id(N'[dbo].[RemitoCompra]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RemitoCompra]
GO

CREATE TABLE [dbo].[RemitoCompra] (
	[rc_id] [int] NOT NULL ,
	[te_id] [int] NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NULL 
) ON [PRIMARY]
GO

