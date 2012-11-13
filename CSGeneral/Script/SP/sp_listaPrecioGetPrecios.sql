if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_listaPrecioGetPrecios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_listaPrecioGetPrecios]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_listaPrecioGetPrecios 2

create procedure sp_listaPrecioGetPrecios (
	@@lp_id				int,
	@@lp_tipo 		tinyint,
  @@pr_nombre		varchar(255)
)
as

set nocount on

begin

	exec sp_listaPrecioGetPreciosCliente @@lp_id, @@lp_tipo, @@pr_nombre

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



