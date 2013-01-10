if exists (select * from sysobjects where id = object_id(N'[dbo].[PedidoVenta]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PedidoVenta]
GO

CREATE TABLE [dbo].[PedidoVenta] (
  [pv_id] [int] NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [modifico] [int] NULL ,
  [te_id] [int] NULL 
) ON [PRIMARY]
GO

