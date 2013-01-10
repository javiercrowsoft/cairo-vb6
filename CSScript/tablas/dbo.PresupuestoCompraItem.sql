if exists (select * from sysobjects where id = object_id(N'[dbo].[PresupuestoCompraItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PresupuestoCompraItem]
GO

CREATE TABLE [dbo].[PresupuestoCompraItem] (
  [prci_id] [int] NOT NULL ,
  [pr_id] [int] NULL ,
  [prc_id] [int] NULL 
) ON [PRIMARY]
GO

