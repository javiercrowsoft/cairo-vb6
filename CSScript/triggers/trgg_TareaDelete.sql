if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_TareaDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_TareaDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_TareaDelete] ON [dbo].[Tarea] 
FOR DELETE 
AS

declare @tar_id int

declare c_tareaUpdate insensitive cursor for

	select tar_id from deleted

open c_tareaUpdate

fetch next from c_tareaUpdate into @tar_id
while @@fetch_status = 0
begin

	if exists(select * from ParteDiario where tar_id = @tar_id) begin

		delete ParteDiario where tar_id = @tar_id

	end

	fetch next from c_tareaUpdate into @tar_id
end

close c_tareaUpdate
deallocate c_tareaUpdate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

