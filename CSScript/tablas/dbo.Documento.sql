if exists (select * from sysobjects where id = object_id(N'[dbo].[Documento]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Documento]
GO

CREATE TABLE [dbo].[Documento] (
  [doc_id] [int] NOT NULL ,
  [doc_nombre] [varchar] (50) NOT NULL ,
  [doc_alias] [varchar] (50) NOT NULL 
) ON [PRIMARY]
GO

