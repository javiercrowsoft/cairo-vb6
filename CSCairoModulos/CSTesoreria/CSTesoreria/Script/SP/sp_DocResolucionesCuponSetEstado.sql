if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponesSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponesSetEstado]

/*

 sp_DocResolucionCuponesSetEstado 

*/

go
create procedure sp_DocResolucionCuponesSetEstado (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @rcup_id int

  declare c_DepBcos insensitive cursor for 
    select rcup_id from ResolucionCupon where rcup_fecha between @@desde and @@hasta

  open c_DepBcos

  fetch next from c_DepBcos into @rcup_id
  while @@fetch_status = 0 begin

    exec sp_DocResolucionCuponSetEstado @rcup_id

    fetch next from c_DepBcos into @rcup_id
  end

  close c_DepBcos
  deallocate c_DepBcos
end