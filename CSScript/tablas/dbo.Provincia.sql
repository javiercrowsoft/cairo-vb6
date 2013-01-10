if exists (select * from sysobjects where id = object_id(N'[dbo].[Provincia]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Provincia]
GO

CREATE TABLE [dbo].[Provincia] (
  [pro_id] [int] NOT NULL ,
  [pro_nombre] [varchar] (30) NOT NULL ,
  [pro_alias] [varchar] (15) NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL ,
  [creado] [datetime] NOT NULL 
)
GO

