if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_productoBOMEsEditable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_productoBOMEsEditable]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select * from stockitem where pr_id_kit is not null
-- sp_productoBOMEsEditable 13443

create procedure sp_productoBOMEsEditable (
	@@pr_id	int
)
as

set nocount on

begin

	select 1
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



--select * from stockitem