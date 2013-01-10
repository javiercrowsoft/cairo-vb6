if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_usuarioGuestDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_usuarioGuestDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_usuarioGuestDelete] ON [dbo].[Usuario] 
FOR DELETE 
AS

declare @us_id int

declare c_userUpdateG insensitive cursor for

  select us_id from deleted

open c_userUpdateG

fetch next from c_userUpdateG into @us_id
while @@fetch_status = 0
begin
  if @us_id = 21 begin

    rollback transaction
    raiserror ('El usuario Invitado no puede borrarse', 16, 11)

  end

  fetch next from c_userUpdateG into @us_id
end

close c_userUpdateG
deallocate c_userUpdateG
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

