if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_tipoOperacionUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_tipoOperacionUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_tipoOperacionUpdate] ON [dbo].[TipoOperacion] 
FOR INSERT, UPDATE
AS

declare @to_id int

declare c_topUpdate insensitive cursor for

  select to_id from inserted

open c_topUpdate

fetch next from c_topUpdate into @to_id
while @@fetch_status = 0
begin
  if @to_id = 1 begin
    update TipoOperacion set to_nombre = 'Comercial', to_generadeuda = 1, activo = 1 where to_id = 1
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

