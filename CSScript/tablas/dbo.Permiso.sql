if exists (select * from sysobjects where id = object_id(N'[dbo].[Permiso]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Permiso]
GO

CREATE TABLE [dbo].[Permiso] (
	[per_id] [int] NOT NULL ,
	[pre_id] [int] NOT NULL ,
	[us_id] [int] NULL ,
	[rol_id] [int] NULL ,
	[modificado] [datetime] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
)
GO

