if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponesSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponesSetEstado]

/*

 sp_DocDepositoCuponesSetEstado 

*/

go
create procedure sp_DocDepositoCuponesSetEstado (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @dcup_id int

  declare c_DepBcos insensitive cursor for 
    select dcup_id from DepositoCupon where dcup_fecha between @@desde and @@hasta

  open c_DepBcos

  fetch next from c_DepBcos into @dcup_id
  while @@fetch_status = 0 begin

    exec sp_DocDepositoCuponSetEstado @dcup_id

    fetch next from c_DepBcos into @dcup_id
  end

  close c_DepBcos
  deallocate c_DepBcos
end