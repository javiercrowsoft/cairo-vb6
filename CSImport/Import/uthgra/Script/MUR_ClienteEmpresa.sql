if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ClienteEmpresa]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ClienteEmpresa]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ClienteEmpresa.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ClienteEmpresa 
as
begin

  set nocount on

	declare @cli_id 			int
	declare @emp_id 			int
	declare @empcli_id    int

	set @emp_id = 1

	declare c_cli insensitive cursor for 
	select cli_id from cliente where not exists(select cli_id from EmpresaCliente where cli_id = cliente.cli_id)
	
	open c_cli

	fetch next from c_cli into @cli_id
	while @@fetch_status = 0
	begin

    exec sp_dbgetnewid 'EmpresaCliente','empcli_id',@empcli_id out, 0
    insert into EmpresaCliente (empcli_id, cli_id, emp_id, modifico)
                              values(@empcli_id, @cli_id, @emp_id, 1)

		fetch next from c_cli into @cli_id
	end

	close c_cli
	deallocate c_cli

	update cliente set cli_nombre ='vacio' where cli_nombre = ''

	exec MUR_ClienteCreateTree

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

