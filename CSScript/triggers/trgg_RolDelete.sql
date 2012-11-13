if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_rolDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_rolDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_rolDelete] ON [dbo].[rol] 
FOR DELETE 
AS

declare @rol_id int

declare c_userUpdate insensitive cursor for

	select rol_id from deleted

open c_userUpdate

fetch next from c_userUpdate into @rol_id
while @@fetch_status = 0
begin
	if @rol_id = 1 begin

		rollback transaction
		raiserror ('El rol Administrador no puede borrarse', 16, 11)
	end

	fetch next from c_userUpdate into @rol_id
end

close c_userUpdate
deallocate c_userUpdate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

