if exists (select * from sysobjects where id = object_id(N'[dbo].[Rama]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Rama]
GO

CREATE TABLE [dbo].[Rama] (
  [ram_id] [int] NOT NULL ,
  [ram_nombre] [varchar] (50) NOT NULL ,
  [arb_id] [int] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL ,
  [ram_id_padre] [int] NOT NULL 
) ON [PRIMARY]
GO

