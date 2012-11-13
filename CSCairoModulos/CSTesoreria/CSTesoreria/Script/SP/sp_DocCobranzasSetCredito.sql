if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzasSetCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzasSetCredito]

/*

 sp_DocCobranzasSetCredito 

*/

go
create procedure sp_DocCobranzasSetCredito (
	@@desde						datetime = '19900101',
	@@hasta						datetime = '21000101',
	@@bSoloPendientes	tinyint  = 1,
	@@cli_id      		int			 = 0
)
as

begin

	declare @cobz_id 	int
	declare @est_id   int

	declare c_Cobranzas insensitive cursor for 
		select cobz_id,est_id from Cobranza 
		where cobz_fecha between @@desde and @@hasta
			and (@@bSoloPendientes = 0 or est_id in (1,2,3,4,8))
			and (cli_id = @@cli_id or @@cli_id = 0)

	open c_Cobranzas

	fetch next from c_Cobranzas into @cobz_id, @est_id
	while @@fetch_status = 0 begin

		if @est_id<> 7 set @est_id=0

		exec  sp_DocCobranzaSetCredito @cobz_id, @est_id

		fetch next from c_Cobranzas into @cobz_id, @est_id
  end

	close c_Cobranzas
	deallocate c_Cobranzas
end