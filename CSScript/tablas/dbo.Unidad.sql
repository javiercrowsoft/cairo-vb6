if exists (select * from sysobjects where id = object_id(N'[dbo].[Unidad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Unidad]
GO

CREATE TABLE [dbo].[Unidad] (
  [un_id] [int] NOT NULL ,
  [un_nombre] [varchar] (30) NOT NULL ,
  [un_alias] [varchar] (20) NULL ,
  [creado] [datetime] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL 
)
GO

