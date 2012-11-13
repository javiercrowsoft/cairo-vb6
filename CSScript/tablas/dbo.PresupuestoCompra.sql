if exists (select * from sysobjects where id = object_id(N'[dbo].[PresupuestoCompra]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PresupuestoCompra]
GO

CREATE TABLE [dbo].[PresupuestoCompra] (
	[prc_id] [int] NOT NULL ,
	[te_id] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[prc_total] [int] NOT NULL 
) ON [PRIMARY]
GO

