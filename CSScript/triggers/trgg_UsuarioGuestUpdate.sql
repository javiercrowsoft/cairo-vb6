if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_usuarioGuestUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_usuarioGuestUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_usuarioGuestUpdate] ON [dbo].[Usuario] 
FOR INSERT, UPDATE
AS

declare @us_id int

declare c_userUpdateG insensitive cursor for

	select us_id from inserted

open c_userUpdateG

fetch next from c_userUpdateG into @us_id
while @@fetch_status = 0
begin
 	if @us_id = 21 begin
 		update usuario set us_nombre = 'Invitado', us_clave='Ô×ÖÑÐÓ' where us_id = 21
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

