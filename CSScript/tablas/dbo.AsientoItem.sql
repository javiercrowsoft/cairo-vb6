if exists (select * from sysobjects where id = object_id(N'[dbo].[AsientoItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[AsientoItem]
GO

CREATE TABLE [dbo].[AsientoItem] (
  [asi_id] [int] NOT NULL ,
  [as_id] [int] NOT NULL ,
  [asi_orden] [smallint] NOT NULL ,
  [asi_total] [int] NOT NULL ,
  [asi_ivariimporte] [money] NOT NULL ,
  [asi_ivariporcentaje] [int] NOT NULL ,
  [asi_ivarniimporte] [money] NOT NULL ,
  [asi_ivarniporcentaje] [int] NOT NULL ,
  [asi_neto] [int] NOT NULL ,
  [pr_id] [int] NOT NULL ,
  [asi_cantidad] [real] NOT NULL ,
  [asi_descporcentaje] [int] NOT NULL ,
  [asi_descimporte] [money] NOT NULL ,
  [un_id] [int] NOT NULL 
)
GO

