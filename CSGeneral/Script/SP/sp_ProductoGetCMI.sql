if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetCMI]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetCMI]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoGetCMI  3

create procedure sp_ProductoGetCMI  (
	@@pr_id	int
)
as

set nocount on

begin


	select 
					prcmi.*,
					cmi_nombre

	from ProductoComunidadInternet prcmi 
					inner join ComunidadInternet cmi on prcmi.cmi_id = cmi.cmi_id

	where prcmi.pr_id = @@pr_id


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



