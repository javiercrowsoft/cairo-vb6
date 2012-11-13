if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockUpdateNumeroSerieTask]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockUpdateNumeroSerieTask]

/*

  select * from ProductoNumeroSerieAsinc

  sp_DocStockUpdateNumeroSerieTask 64059,0

*/

go
create procedure sp_DocStockUpdateNumeroSerieTask (
	@@All tinyint = 0
)
as

begin

  set nocount on

	declare @prns_id        int
	declare @prnsa_id       int
	declare @st_id          int
	declare @restar       	tinyint

	if @@All = 0 begin

		declare c_prnsa insensitive cursor for 

			select top 5 prnsa_id, prns_id, st_id, prnsa_restar from ProductoNumeroSerieAsinc
	
	end else begin

		declare c_prnsa insensitive cursor for 

			select prnsa_id, prns_id, st_id, prnsa_restar from ProductoNumeroSerieAsinc

	end

	open c_prnsa

	fetch next from c_prnsa into @prnsa_id, @prns_id, @st_id, @restar
	while @@fetch_status=0
	begin

		exec sp_DocStockUpdateNumeroSerieAsinc @prns_id, @st_id, @restar

		delete ProductoNumeroSerieAsinc where prnsa_id = @prnsa_id

		fetch next from c_prnsa into @prnsa_id, @prns_id, @st_id, @restar

	end

	close c_prnsa
	deallocate c_prnsa

end

GO
