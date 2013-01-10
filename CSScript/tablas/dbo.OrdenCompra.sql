if exists (select * from sysobjects where id = object_id(N'[dbo].[OrdenCompra]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OrdenCompra]
GO

CREATE TABLE [dbo].[OrdenCompra] (
  [oc_id] [int] NOT NULL ,
  [te_id] [int] NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL ,
  [total] [int] NOT NULL 
) ON [PRIMARY]
GO

