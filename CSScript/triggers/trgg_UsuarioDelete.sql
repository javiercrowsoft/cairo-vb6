if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_usuarioDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_usuarioDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_usuarioDelete] ON [dbo].[Usuario] 
FOR DELETE 
AS

declare @us_id int

declare c_userUpdate insensitive cursor for

	select us_id from deleted

open c_userUpdate

fetch next from c_userUpdate into @us_id
while @@fetch_status = 0
begin
	if @us_id = 1 begin

		rollback transaction
		raiserror ('El usuario Administrador no puede borrarse', 16, 11)

	end

	fetch next from c_userUpdate into @us_id
end

close c_userUpdate
deallocate c_userUpdate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

