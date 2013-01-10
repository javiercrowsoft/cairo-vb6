if exists (select * from sysobjects where id = object_id(N'[dbo].[Id]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Id]
GO

CREATE TABLE [dbo].[Id] (
  [Id_Tabla] [varchar] (50) NOT NULL ,
  [Id_NextId] [int] NOT NULL ,
  [Id_CampoId] [varchar] (50) NOT NULL 
) ON [PRIMARY]
GO

