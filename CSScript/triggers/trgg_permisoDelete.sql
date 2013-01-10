if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_permisoDelete]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_permisoDelete]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_permisoDelete] ON [dbo].[Permiso] 
FOR DELETE 
AS

declare @per_id int

declare c_permiso insensitive cursor for

  select per_id from deleted

open c_permiso

fetch next from c_permiso into @per_id
while @@fetch_status = 0
begin

  delete Permiso where per_id_padre = @per_id

  fetch next from c_permiso into @per_id
end

close c_permiso
deallocate c_permiso
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

