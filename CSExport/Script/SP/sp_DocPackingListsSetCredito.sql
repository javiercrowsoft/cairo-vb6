if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListsSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListsSetCredito]

/*

 sp_DocPackingListsSetCredito 

*/

go
create procedure sp_DocPackingListsSetCredito (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101',
	@@cli_id      int			 = 0
)
as

begin

	declare @pklst_id int
	declare @est_id   int

	declare c_packings insensitive cursor for 
		select pklst_id,est_id from packingList 
		where pklst_fecha between @@desde and @@hasta
			and (cli_id = @@cli_id or @@cli_id = 0)

	open c_packings

	fetch next from c_packings into @pklst_id, @est_id
	while @@fetch_status = 0 begin

		if @est_id<> 7 set @est_id=0

		exec sp_DocpackingListSetCredito @pklst_id, @est_id

		fetch next from c_packings into @pklst_id, @est_id
  end

	close c_packings
	deallocate c_packings
end