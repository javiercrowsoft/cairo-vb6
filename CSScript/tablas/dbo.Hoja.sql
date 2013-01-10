if exists (select * from sysobjects where id = object_id(N'[dbo].[Hoja]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Hoja]
GO

CREATE TABLE [dbo].[Hoja] (
  [hoja_id] [int] NOT NULL ,
  [id] [int] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL ,
  [ram_id] [int] NOT NULL ,
  [arb_id] [int] NOT NULL 
) ON [PRIMARY]
GO

