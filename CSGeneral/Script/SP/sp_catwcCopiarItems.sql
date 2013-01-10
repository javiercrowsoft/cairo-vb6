if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_catwcCopiarItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_catwcCopiarItems]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 select * from Chequera
 exec sp_catwcCopiarItems 2,'x-0001-0002405'
*/
create procedure sp_catwcCopiarItems (
  @@idSource    int,
  @@idTarget    int,
  @@modifico    int
)
as

set nocount on

begin

  declare @catwci_id          int
  declare @pr_id               int
  declare @catwci_activo      tinyint

  declare c_items insensitive cursor for select pr_id, catwci_activo from CatalogoWebCategoriaItem where catwc_id = @@idSource

  open c_items
  fetch next from c_items into @pr_id, @catwci_activo
  while @@fetch_status=0
  begin
      
      exec sp_dbgetnewid 'CatalogoWebCategoriaItem','catwci_id', @catwci_id out, 0

      insert into CatalogoWebCategoriaItem(catwc_id,catwci_id,pr_id,catwci_activo,modificado,modifico)
                          values (@@idTarget,@catwci_id,@pr_id,@catwci_activo,getdate(),@@modifico)

      fetch next from c_items into @pr_id, @catwci_activo    
  end
  close c_items
  deallocate c_items

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



