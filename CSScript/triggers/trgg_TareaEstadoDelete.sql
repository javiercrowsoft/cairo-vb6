if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_TareaEstadoDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_TareaEstadoDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_TareaEstadoDelete] ON [dbo].[TareaEstado] 
FOR DELETE 
AS

declare @tarest_id int

declare c_tarestUpdate insensitive cursor for

	select tarest_id from deleted

open c_tarestUpdate

fetch next from c_tarestUpdate into @tarest_id
while @@fetch_status = 0
begin
	if @tarest_id = 1 begin

		rollback transaction
		raiserror ('El Estado de Tarea Pendiente no puede borrarse', 16, 11)

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

