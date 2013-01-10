if exists (select * from sysobjects where id = object_id(N'[dbo].[RamaConfig]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RamaConfig]
GO

CREATE TABLE [dbo].[RamaConfig] (
  [ramc_aspecto] [varchar] (150) NOT NULL ,
  [ramc_valor] [varchar] (1500) NOT NULL ,
  [ram_id] [int] NOT NULL 
) ON [PRIMARY]
GO

