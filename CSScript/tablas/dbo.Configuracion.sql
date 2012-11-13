if exists (select * from sysobjects where id = object_id(N'[dbo].[Configuracion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Configuracion]
GO

CREATE TABLE [dbo].[Configuracion] (
	[cfg_grupo] [varchar] (60) NOT NULL ,
	[cfg_aspecto] [varchar] (60) NOT NULL ,
	[cfg_valor] [varchar] (5000) NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
) ON [PRIMARY]
GO

