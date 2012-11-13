if exists (select * from sysobjects where id = object_id(N'[dbo].[Tercero]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Tercero]
GO

CREATE TABLE [dbo].[Tercero] (
	[te_id] [int] NOT NULL ,
	[te_nombre] [varchar] (50) NOT NULL ,
	[te_alias] [varchar] (50) NOT NULL ,
	[te_cliente] [smallint] NOT NULL ,
	[te_proveedor] [smallint] NOT NULL ,
	[te_contacto] [varchar] (50) NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
)
GO

