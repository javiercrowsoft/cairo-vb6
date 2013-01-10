if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargasSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargasSetCredito]

/*

 sp_DocManifiestoCargasSetCredito 

*/

go
create procedure sp_DocManifiestoCargasSetCredito (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101',
  @@cli_id      int       = 0
)
as

begin

  declare @mfc_id   int
  declare @est_id   int

  declare c_Manifiestos insensitive cursor for 
    select mfc_id,est_id from ManifiestoCarga 
    where mfc_fecha between @@desde and @@hasta
      and (cli_id = @@cli_id or @@cli_id = 0)

  open c_Manifiestos

  fetch next from c_Manifiestos into @mfc_id, @est_id
  while @@fetch_status = 0 begin

    if @est_id<> 7 set @est_id=0

    exec sp_DocManifiestoCargaSetCredito @mfc_id, @est_id

    fetch next from c_Manifiestos into @mfc_id, @est_id
  end

  close c_Manifiestos
  deallocate c_Manifiestos
end