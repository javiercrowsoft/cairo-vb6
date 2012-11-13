if exists (select * from sysobjects where id = object_id(N'[dbo].[Asiento]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Asiento]
GO

CREATE TABLE [dbo].[Asiento] (
	[as_id] [int] NOT NULL ,
	[creado] [datetime] NOT NULL ,
	[modificado] [datetime] NOT NULL ,
	[modifico] [int] NOT NULL ,
	[activo] [smallint] NOT NULL ,
	[as_numero] [int] NOT NULL ,
	[as_numerodoc] [varchar] (30) NOT NULL ,
	[te_id] [int] NULL ,
	[as_fechadoc] [datetime] NOT NULL ,
	[as_total] [money] NOT NULL ,
	[as_neto] [money] NOT NULL ,
	[as_ivaimporte] [money] NOT NULL ,
	[as_descimporte] [money] NOT NULL ,
	[as_descporcentaje] [int] NOT NULL 
) ON [PRIMARY]
GO

