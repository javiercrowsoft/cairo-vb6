if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductosSaveKit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductosSaveKit]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select pr_id,pr_kititems from producto where pr_eskit <>0
-- sp_ProductosSaveKit 

create procedure sp_ProductosSaveKit as
set nocount on

begin
	declare @pr_id int

	declare c_prkittosave insensitive cursor for select pr_id from producto where pr_eskit <>0
	open c_prkittosave

	fetch next from c_prkittosave into @pr_id
	while @@fetch_status = 0
	begin

		exec sp_ProductoSaveKit @pr_id

		fetch next from c_prkittosave into @pr_id
	end
	close c_prkittosave
	deallocate c_prkittosave
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



--select * from stockitem