if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetLeyendas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetLeyendas]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoGetLeyendas  3

create procedure sp_ProductoGetLeyendas  (
	@@pr_id	int
)
as

set nocount on

begin


	select 
					prl.*

	from ProductoLeyenda prl

	where prl.pr_id = @@pr_id


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



