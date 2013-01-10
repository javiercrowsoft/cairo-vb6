if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_agendaUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_agendaUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_agendaUpdate] ON [dbo].[Agenda] 
FOR INSERT, UPDATE
AS

declare @agn_id int

declare c_userUpdate insensitive cursor for

  select agn_id from inserted

open c_userUpdate

fetch next from c_userUpdate into @agn_id
while @@fetch_status = 0
begin
  if @agn_id = 1 begin
    update Agenda set agn_nombre = 'Publica', agn_codigo = 'Publica' where agn_id = 1
  end

  fetch next from c_userUpdate into @agn_id
end

close c_userUpdate
deallocate c_userUpdate


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

