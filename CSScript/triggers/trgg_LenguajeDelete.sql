if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_LenguajeDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_LenguajeDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_LenguajeDelete] ON [dbo].[Lenguaje] 
FOR DELETE 
AS

declare @leng_id int

declare c_lengUpdate insensitive cursor for

	select leng_id from deleted

open c_lengUpdate

fetch next from c_lengUpdate into @leng_id
while @@fetch_status = 0
begin
	if @leng_id = 1 begin

		rollback transaction
		raiserror ('El Lenguaje Castellano no puede borrarse', 16, 11)

	end

	fetch next from c_lengUpdate into @leng_id
end

close c_lengUpdate
deallocate c_lengUpdate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

