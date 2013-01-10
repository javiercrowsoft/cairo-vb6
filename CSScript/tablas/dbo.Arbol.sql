if exists (select * from sysobjects where id = object_id(N'[dbo].[Arbol]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Arbol]
GO

CREATE TABLE [dbo].[Arbol] (
  [arb_id] [int] NOT NULL ,
  [arb_nombre] [varchar] (50) NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [tbl_Id] [int] NOT NULL ,
  [modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

