if exists (select * from sysobjects where id = object_id(N'[dbo].[UsuarioRol]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[UsuarioRol]
GO

CREATE TABLE [dbo].[UsuarioRol] (
	[rol_id] [int] NOT NULL ,
	[us_id] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [smallint] NOT NULL 
)
GO

