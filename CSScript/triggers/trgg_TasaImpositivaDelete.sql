if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_TasaImpositivaDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_TasaImpositivaDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_TasaImpositivaDelete] ON [dbo].[TasaImpositiva] 
FOR DELETE 
AS

declare @ti_id int

declare c_tiUpdate insensitive cursor for

  select ti_id from deleted

open c_tiUpdate

fetch next from c_tiUpdate into @ti_id
while @@fetch_status = 0
begin
  if @ti_id = -1 or @ti_id = -2 begin

    rollback transaction
    raiserror ('@@ERROR_SP:Las tasas impositivas auxiliares para responsables no inscriptos no pueden borrarse', 16, 11)
  end

  fetch next from c_tiUpdate into @ti_id
end

close c_tiUpdate
deallocate c_tiUpdate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

