if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_catwCopiarItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_catwCopiarItems]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 select * from Chequera
 exec sp_catwCopiarItems 2,'x-0001-0002405'
*/
create procedure sp_catwCopiarItems (
  @@idSource    int,
  @@idTarget    int,
  @@modifico    int
)
as

set nocount on

begin

  declare @catwi_id          int
  declare @pr_id             int
  declare @catwi_activo      tinyint

  declare c_items insensitive cursor for select pr_id, catwi_activo from CatalogoWebItem where catw_id = @@idSource

  open c_items
  fetch next from c_items into @pr_id, @catwi_activo
  while @@fetch_status=0
  begin
      
      exec sp_dbgetnewid 'CatalogoWebItem','catwi_id', @catwi_id out, 0

      insert into CatalogoWebItem(catw_id,catwi_id,pr_id,catwi_activo,modificado,modifico)
                          values (@@idTarget,@catwi_id,@pr_id,@catwi_activo,getdate(),@@modifico)

      fetch next from c_items into @pr_id, @catwi_activo    
  end
  close c_items
  deallocate c_items

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



