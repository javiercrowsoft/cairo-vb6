if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocumentosSavePrestacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocumentosSavePrestacion]

go
create procedure sp_DocumentosSavePrestacion 
as

begin
  declare c_depto insensitive cursor for select doc_id from Documento
  declare @doc_id int
  
  open c_depto
  
  fetch next from c_depto into @doc_id
  while @@fetch_status=0
  begin
  
    exec sp_DocumentoSavePrestacion @doc_id
    fetch next from c_depto into @doc_id
  end
  
  close c_depto
  deallocate c_depto
end