if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ListaPrecioShowDuplicados]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ListaPrecioShowDuplicados]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ListaPrecioShowDuplicados 3

create procedure sp_ListaPrecioShowDuplicados (
	@@lp_id	int
)
as

set nocount on

begin

	if exists(select pr_id from ListaPrecioItem where lp_id = @@lp_id group by pr_id having count(*)>1)

		select 1

	else

		select 0

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



