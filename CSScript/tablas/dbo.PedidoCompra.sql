if exists (select * from sysobjects where id = object_id(N'[dbo].[PedidoCompra]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PedidoCompra]
GO

CREATE TABLE [dbo].[PedidoCompra] (
  [pc_id] [int] NOT NULL ,
  [te_id] [int] NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

