if exists (select * from sysobjects where id = object_id(N'[dbo].[Producto]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Producto]
GO

CREATE TABLE [dbo].[Producto] (
  [pr_id] [int] NOT NULL ,
  [pr_nombrecompra] [varchar] (100) NOT NULL ,
  [pr_nombreventa] [varchar] (100) NOT NULL ,
  [pr_alias] [varchar] (90) NOT NULL ,
  [creado] [datetime] NOT NULL ,
  [modifico] [int] NOT NULL ,
  [modificado] [datetime] NOT NULL ,
  [activo] [smallint] NOT NULL ,
  [pr_descripventa] [varchar] (2000) NOT NULL ,
  [pr_descripcompra] [varchar] (2000) NOT NULL ,
  [un_id_compra] [int] NULL ,
  [un_id_venta] [int] NULL ,
  [un_id_stock] [int] NULL ,
  [pr_relacioncompraventa] [real] NOT NULL ,
  [pr_ventastock] [real] NOT NULL ,
  [pr_comprastock] [real] NOT NULL ,
  [pr_sevende] [smallint] NOT NULL ,
  [pr_secompra] [smallint] NOT NULL ,
  [pr_llevastock] [smallint] NOT NULL ,
  [ti_id_ivariventa] [int] NULL ,
  [ti_id_ivarnicompra] [int] NULL ,
  [ti_id_ivaricompra] [int] NULL ,
  [ti_id_ivarniventa] [int] NULL ,
  [cue_id_compra] [int] NULL ,
  [cue_id_venta] [int] NULL ,
  [pr_x] [smallint] NOT NULL ,
  [pr_y] [smallint] NOT NULL ,
  [pr_z] [smallint] NOT NULL ,
  [pr_id_padre] [int] NULL 
)
GO

