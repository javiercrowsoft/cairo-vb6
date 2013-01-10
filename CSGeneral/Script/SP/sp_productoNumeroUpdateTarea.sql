if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_productoNumeroUpdateTarea]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoNumeroUpdateTarea]
GO

/*


*/
create procedure sp_productoNumeroUpdateTarea 

as
begin

  set nocount on
  
  declare @prns_id int
  declare @tar_id  int
  
  declare c_serie insensitive cursor for select prns_id from productonumeroserie where doct_id_ingreso = 42 and depl_id not in (-2,-3)
  
  open c_serie
  
  fetch next from c_serie into @prns_id
  while @@fetch_status = 0
  begin
  
    select @tar_id = max(tar_id) from Tarea where prns_id = @prns_id and tar_fechaini < getdate()
  
    update productonumeroserie set tar_id = @tar_id where prns_id = @prns_id
  
    fetch next from c_serie into @prns_id
  
  end
  
  close c_serie
  deallocate c_serie

end

GO
