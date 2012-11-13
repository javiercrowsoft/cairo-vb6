if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ClienteVendedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ClienteVendedor]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ClienteVendedor.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ClienteVendedor 
as
begin

  set nocount on

	declare @usemp_id    int
	declare @cli_id      int
	declare @us_id       int
	declare @ven_id      int
	
	set nocount on
	
	declare c insensitive cursor for 
	  select ven_id,us_id from vendedor 
	  where us_id is not null
	
	open c
	
	fetch next from c into @ven_id, @us_id
	while @@fetch_status = 0 begin
	
	  declare cli insensitive cursor for 
	  select cli_id from cliente where ven_id = @ven_id
	  and not exists(select * from UsuarioEmpresa where cli_id = cliente.cli_id and us_id = @us_id)
	
	  open cli
	
	  fetch next from cli into @cli_id
	  while @@fetch_status=0 begin
	
	    if not exists(select * from UsuarioEmpresa where us_id = @us_id and cli_id = @cli_id) begin
	  
	      exec sp_dbgetnewid 'UsuarioEmpresa','usemp_id',@usemp_id out, 0
	
	      insert into UsuarioEmpresa (usemp_id,us_id,cli_id,prov_id,modifico)
	                         values(@usemp_id,@us_id,@cli_id,null,1)
	    end
	
	    fetch next from cli into @cli_id
	  end
	  close cli
		deallocate cli
	
	  fetch next from c into @ven_id, @us_id
	end
	
	close c
	deallocate c 

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO