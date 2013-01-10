if exists (select * from sysobjects where id = object_id(N'[dbo].[PedidoVentaItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PedidoVentaItem]
GO

CREATE TABLE [dbo].[PedidoVentaItem] (
  [pvi_id] [int] NOT NULL ,
  [pv_id] [int] NULL ,
  [pr_id] [int] NULL 
) ON [PRIMARY]
GO

