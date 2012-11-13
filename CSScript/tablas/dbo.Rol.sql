if exists (select * from sysobjects where id = object_id(N'[dbo].[Rol]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Rol]
GO

CREATE TABLE [dbo].[Rol] (
	[rol_id] [int] NOT NULL ,
	[rol_nombre] [varchar] (50) NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [smallint] NOT NULL 
)
GO

