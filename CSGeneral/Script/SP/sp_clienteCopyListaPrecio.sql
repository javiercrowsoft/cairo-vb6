if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteCopyListaPrecio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteCopyListaPrecio]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_clienteCopyListaPrecio 35639

*/

go
create procedure sp_clienteCopyListaPrecio (
	@@from_id 		int,
	@@to_id				int,
	@@us_id				int
)
as

begin

	set nocount on

	declare @lpcli_id int
	declare @lp_id    int

	declare c_lpcli insensitive cursor for select lp_id from ListaPrecioCliente where cli_id = @@from_id

	open c_lpcli

	fetch next from c_lpcli into @lp_id
	while @@fetch_status=0
	begin

		exec sp_dbgetnewid 'ListaPrecioCliente', 'lpcli_id', @lpcli_id out, 0

		insert into ListaPrecioCliente(lpcli_id, lp_id, cli_id, modifico) 
														values(@lpcli_id, @lp_id, @@to_id, @@us_id)
 
		fetch next from c_lpcli into @lp_id
	end

	close c_lpcli
	deallocate c_lpcli

end

go