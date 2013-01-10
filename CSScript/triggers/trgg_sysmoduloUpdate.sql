if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_sysmoduloUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_sysmoduloUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_sysmoduloUpdate] ON [dbo].[SysModulo] 
FOR INSERT, UPDATE
AS

  update sysmodulo set modificado = getdate() where sysm_id in (select sysm_id from inserted)

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

