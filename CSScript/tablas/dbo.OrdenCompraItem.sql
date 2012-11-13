if exists (select * from sysobjects where id = object_id(N'[dbo].[OrdenCompraItem]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OrdenCompraItem]
GO

CREATE TABLE [dbo].[OrdenCompraItem] (
	[oci_id] [int] NOT NULL ,
	[oc_id] [int] NOT NULL ,
	[pr_id] [int] NOT NULL 
) ON [PRIMARY]
GO

