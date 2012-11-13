if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_rolUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_rolUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_rolUpdate] ON [dbo].[rol] 
FOR INSERT, UPDATE
AS

declare @rol_id int

declare c_rolUpdate insensitive cursor for

	select rol_id from inserted

open c_rolUpdate

fetch next from c_rolUpdate into @rol_id
while @@fetch_status = 0
begin
	if @rol_id = 1 begin
		update rol set rol_nombre = 'Administrador' where rol_id = 1
	end

	fetch next from c_rolUpdate into @rol_id
end

close c_rolUpdate
deallocate c_rolUpdate


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

