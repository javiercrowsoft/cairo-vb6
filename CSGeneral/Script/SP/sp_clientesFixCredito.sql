if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clientesFixCredito]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clientesFixCredito]

/*

 sp_clientesFixCredito

*/

go
create procedure sp_clientesFixCredito 

as

begin

  declare @cli_id int

  declare c_cliente insensitive cursor for select cli_id from Cliente

  open c_cliente

  fetch next from c_cliente into @cli_id  
  while @@fetch_status=0
  begin

    exec sp_ClienteFixCredito @cli_id

    fetch next from c_cliente into @cli_id
  end

  close c_cliente
  deallocate c_cliente

end
go