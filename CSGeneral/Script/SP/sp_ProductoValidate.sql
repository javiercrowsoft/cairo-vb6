if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoValidate]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- select pr_kititems from producto where pr_id = 255
-- sp_ProductoValidate 255

create procedure sp_ProductoValidate (
	@@pr_id	int
)
as

set nocount on

begin

  set nocount on

	declare @pr_codigobarra varchar(255)
	select @pr_codigobarra = pr_codigobarra from producto where pr_id = @@pr_id

	if len(@pr_codigobarra)>0 begin
	
		if exists(select * from producto where pr_codigobarra = @pr_codigobarra and pr_id <> @@pr_id) begin
	
			select 0,'El producto ['+pr_nombrecompra +'] ya tiene asignado este codigo de barras ' + @pr_codigobarra
			from producto where pr_codigobarra = @pr_codigobarra and pr_id <> @@pr_id 
			return
	
		end

	end

	select 1

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



--select * from stockitem