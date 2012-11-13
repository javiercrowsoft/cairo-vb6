SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_productoGetClientes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoGetClientes]
GO

/*

sp_productoGetClientes 7

*/

create procedure sp_productoGetClientes
(
	@@pr_id   int
)
as
begin


  select 
    prcli.*, 
    cli_nombre
    
  

  from 
    ProductoCliente prcli inner join Cliente cli on prcli.cli_id = cli.cli_id
                            
  
  where pr_id= @@pr_id
  
  order by cli_nombre

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go

