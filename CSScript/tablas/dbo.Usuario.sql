if exists (select * from sysobjects where id = object_id(N'[dbo].[Usuario]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Usuario]
GO

CREATE TABLE [dbo].[Usuario] (
	[us_id] [int] NOT NULL ,
	[us_nombre] [varchar] (50) NOT NULL ,
	[us_clave] [varchar] (10) NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[activo] [smallint] NOT NULL ,
	[modifico] [int] NOT NULL 
)
GO

