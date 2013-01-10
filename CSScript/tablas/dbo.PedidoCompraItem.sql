if exists (select * from sysobjects where id = object_id(N'[dbo].[PedidoCompraItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PedidoCompraItem]
GO

CREATE TABLE [dbo].[PedidoCompraItem] (
  [pci_id] [int] NOT NULL ,
  [pc_id] [int] NULL ,
  [creado] [datetime] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [modifico] [int] NULL ,
  [pr_id] [int] NULL 
) ON [PRIMARY]
GO

