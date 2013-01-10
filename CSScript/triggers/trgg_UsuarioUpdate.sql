if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_usuarioUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_usuarioUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_usuarioUpdate] ON [dbo].[Usuario] 
FOR INSERT, UPDATE
AS

declare @us_id int

declare c_userUpdate insensitive cursor for

  select us_id from inserted

open c_userUpdate

fetch next from c_userUpdate into @us_id
while @@fetch_status = 0
begin
   if @us_id = 1 begin
     update usuario set us_nombre = 'Administrador' where us_id = 1
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

