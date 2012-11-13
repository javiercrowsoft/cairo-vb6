if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzasSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzasSetPendiente]

/*

 sp_DocCobranzasSetPendiente 

*/

go
create procedure sp_DocCobranzasSetPendiente (
	@@desde       datetime = '19900101',
	@@hasta       datetime = '21000101'
)
as

begin

	declare @cobz_id int

	declare c_Cobranzas insensitive cursor for 
		select cobz_id from Cobranza where cobz_fecha between @@desde and @@hasta

	open c_Cobranzas

	fetch next from c_Cobranzas into @cobz_id
	while @@fetch_status = 0 begin

		exec sp_DocCobranzaSetPendiente @cobz_id

		fetch next from c_Cobranzas into @cobz_id
  end

	close c_Cobranzas
	deallocate c_Cobranzas
end