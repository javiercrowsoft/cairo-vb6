if exists (select * from sysobjects where id = object_id(N'[dbo].[PresupuestoVentaItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PresupuestoVentaItem]
GO

CREATE TABLE [dbo].[PresupuestoVentaItem] (
  [pvi_id] [int] NOT NULL ,
  [pv_id] [int] NULL ,
  [pr_id] [int] NULL 
) ON [PRIMARY]
GO

