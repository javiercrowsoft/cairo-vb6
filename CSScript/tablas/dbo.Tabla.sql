if exists (select * from sysobjects where id = object_id(N'[dbo].[Tabla]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Tabla]
GO

CREATE TABLE [dbo].[Tabla] (
	[tbl_id] [int] NOT NULL ,
	[tbl_nombre] [varchar] (50) NOT NULL ,
	[tbl_nombrefisico] [varchar] (50) NOT NULL ,
	[tbl_campoId] [varchar] (50) NOT NULL ,
	[tbl_campoAlias] [varchar] (50) NOT NULL ,
	[tbl_sqlHelp] [varchar] (255) NOT NULL ,
	[tbl_tieneArbol] [smallint] NOT NULL ,
	[tbl_campoNombre] [varchar] (50) NOT NULL ,
	[tbl_camposInView] [varchar] (255) NOT NULL 
) ON [PRIMARY]
GO

