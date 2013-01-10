if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioUpdateProductosSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioUpdateProductosSerie]

go
/*

 sp_DocOrdenServicioUpdateProductosSerie

*/

create procedure sp_DocOrdenServicioUpdateProductosSerie 

as

begin

  set nocount on

  declare @os_id   int

  declare c_oss insensitive cursor for

    select os_id from ordenservicio order by os_id asc

  open c_oss

  fetch next from c_oss into @os_id
  while @@fetch_status=0
  begin

    exec sp_DocOrdenServicioUpdateProductoSerie @os_id

    fetch next from c_oss into @os_id
  end
  
  close c_oss
  deallocate c_oss

end
GO