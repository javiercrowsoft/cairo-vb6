if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_productoKitEsEditable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoKitEsEditable]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select * from stockitem where pr_id_kit is not null
-- sp_productoKitEsEditable 13443

create procedure sp_productoKitEsEditable (
	@@pr_id	int
)
as

set nocount on

begin

	if exists(select pr_id_kit from StockItem where pr_id_kit = @@pr_id)
					select 0
	else		select 1
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



--select * from stockitem