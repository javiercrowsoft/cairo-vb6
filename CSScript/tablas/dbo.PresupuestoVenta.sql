if exists (select * from sysobjects where id = object_id(N'[dbo].[PresupuestoVenta]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PresupuestoVenta]
GO

CREATE TABLE [dbo].[PresupuestoVenta] (
	[prv_id] [int] NOT NULL ,
	[te_id] [int] NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [char] (10) NULL ,
	[prv_total] [int] NULL 
) ON [PRIMARY]
GO

