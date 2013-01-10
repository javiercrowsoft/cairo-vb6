if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_LenguajeUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_LenguajeUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_LenguajeUpdate] ON [dbo].[Lenguaje] 
FOR INSERT, UPDATE
AS

declare @leng_id int

declare c_lengUpdate insensitive cursor for

  select leng_id from inserted

open c_lengUpdate

fetch next from c_lengUpdate into @leng_id
while @@fetch_status = 0
begin
   if @leng_id = 1 begin
     update Lenguaje set leng_nombre = 'Castellano' where leng_id = 1
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

