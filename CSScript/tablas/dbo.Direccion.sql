if exists (select * from sysobjects where id = object_id(N'[dbo].[Direccion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Direccion]
GO

CREATE TABLE [dbo].[Direccion] (
  [dir_id] [int] NOT NULL ,
  [dir_calle] [varchar] (30) NOT NULL ,
  [dir_numero] [varchar] (20) NOT NULL ,
  [dir_cpa] [varchar] (15) NOT NULL ,
  [dir_tel] [varchar] (20) NOT NULL ,
  [te_id] [int] NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL ,
  [activo] [smallint] NOT NULL ,
  [pro_id] [int] NOT NULL 
) ON [PRIMARY]
GO

