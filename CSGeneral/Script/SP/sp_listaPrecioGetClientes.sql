if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_listaPrecioGetClientes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_listaPrecioGetClientes]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_listaPrecioGetClientes 2

create procedure sp_listaPrecioGetClientes (
  @@lp_id        int,
  @@cli_nombre    varchar(255)
)
as

set nocount on

begin

  if @@cli_nombre <> '' set @@cli_nombre = '%' + @@cli_nombre + '%'


  select top 50   lpc.*, 
                  cli_nombre as cli_nombre

  from ListaPrecioCliente lpc inner join Cliente cli on lpc.cli_id = cli.cli_id
  where lpc.lp_id = @@lp_id 
    and (      cli_nombre like @@cli_nombre or @@cli_nombre = ''
          or  cli_codigo like @@cli_nombre or @@cli_nombre = ''
        )

  order by cli_nombre

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



