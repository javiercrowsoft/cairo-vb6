if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_tablaUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_tablaUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_tablaUpdate] ON [dbo].[Tabla] 
FOR INSERT, UPDATE
AS

	update tabla set modificado = getdate() where tbl_id in (select tbl_id from inserted)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

