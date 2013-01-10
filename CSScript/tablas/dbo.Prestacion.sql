if exists (select * from sysobjects where id = object_id(N'[dbo].[Prestacion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Prestacion]
GO

CREATE TABLE [dbo].[Prestacion] (
  [pre_id] [int] NOT NULL ,
  [pre_nombre] [varchar] (50) NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [pre_grupo] [varchar] (50) NOT NULL ,
  [activo] [smallint] NOT NULL 
) ON [PRIMARY]
GO

