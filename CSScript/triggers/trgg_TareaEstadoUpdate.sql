if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_TareaEstadoUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_TareaEstadoUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_TareaEstadoUpdate] ON [dbo].[TareaEstado] 
FOR INSERT, UPDATE
AS

declare @tarest_id int

declare c_tarestUpdate insensitive cursor for

  select tarest_id from inserted

open c_tarestUpdate

fetch next from c_tarestUpdate into @tarest_id
while @@fetch_status = 0
begin
   if @tarest_id = 1 begin
     update TareaEstado set tarest_nombre = 'Pendiente' where tarest_id = 1
   end

  fetch next from c_tarestUpdate into @tarest_id
end

close c_tarestUpdate
deallocate c_tarestUpdate


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

