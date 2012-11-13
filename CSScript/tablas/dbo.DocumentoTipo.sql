if exists (select * from sysobjects where id = object_id(N'[dbo].[DocumentoTipo]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DocumentoTipo]
GO

CREATE TABLE [dbo].[DocumentoTipo] (
	[doct_nombre] [varchar] (50) NOT NULL ,
	[doct_alias] [varchar] (50) NOT NULL ,
	[doct_id] [int] NOT NULL 
)
GO

