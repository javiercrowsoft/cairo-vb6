if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteFixCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteFixCredito]

/*

 sp_clienteFixCredito 12

*/

go
create procedure sp_clienteFixCredito (
	@@cli_id      int
)
as

begin

	declare @emp_id int

	declare c_empresa insensitive cursor for select emp_id from empresa

	open c_empresa

	fetch next from c_empresa into @emp_id	
	while @@fetch_status=0
	begin

		exec sp_clienteUpdateCredito 						@@cli_id, @emp_id
		exec sp_clienteUpdateManifiestoCredito 	@@cli_id, @emp_id
		exec sp_clienteUpdatePackingCredito 		@@cli_id, @emp_id
		exec sp_clienteUpdatePedidoCredito 			@@cli_id, @emp_id
		exec sp_clienteUpdateOrdenCredito 		  @@cli_id, @emp_id
		exec sp_clienteUpdateRemitoCredito 			@@cli_id, @emp_id

		fetch next from c_empresa into @emp_id
	end

	close c_empresa
	deallocate c_empresa



	update Cliente 
			set cli_deudatotal = 	cli_deudapedido 
													+ cli_deudaorden
													+	cli_deudaremito 
													+	cli_deudapackinglist
													+	cli_deudamanifiesto
													+	cli_deudactacte
													+	cli_deudadoc
	where cli_id = @@cli_id

end
go