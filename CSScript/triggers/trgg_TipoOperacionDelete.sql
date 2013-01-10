if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_tipoOperacionDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_tipoOperacionDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_tipoOperacionDelete] ON [dbo].[TipoOperacion] 
FOR DELETE 
AS

declare @to_id int

declare c_topUpdate insensitive cursor for

  select to_id from deleted

open c_topUpdate

fetch next from c_topUpdate into @to_id
while @@fetch_status = 0
begin
  if @to_id = 1 begin

    rollback transaction
    raiserror ('El tipo de operación Comercial no puede borrarse', 16, 11)

  end

  fetch next from c_topUpdate into @to_id
end

close c_topUpdate
deallocate c_topUpdate
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

