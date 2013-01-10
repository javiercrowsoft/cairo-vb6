if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancosSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancosSetEstado]

/*

 sp_DocDepositoBancosSetEstado 

*/

go
create procedure sp_DocDepositoBancosSetEstado (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @dbco_id int

  declare c_DepBcos insensitive cursor for 
    select dbco_id from DepositoBanco where dbco_fecha between @@desde and @@hasta

  open c_DepBcos

  fetch next from c_DepBcos into @dbco_id
  while @@fetch_status = 0 begin

    exec sp_DocDepositoBancoSetEstado @dbco_id

    fetch next from c_DepBcos into @dbco_id
  end

  close c_DepBcos
  deallocate c_DepBcos
end