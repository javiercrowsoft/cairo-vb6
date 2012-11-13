if exists (select * from sysobjects where id = object_id(N'[dbo].[TasaImpositiva]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TasaImpositiva]
GO

CREATE TABLE [dbo].[TasaImpositiva] (
	[ti_id] [int] NOT NULL ,
	[ti_nombre] [varchar] (20) NOT NULL ,
	[ti_alias] [varchar] (15) NOT NULL ,
	[ti_porcentaje] [money] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL 
)
GO

