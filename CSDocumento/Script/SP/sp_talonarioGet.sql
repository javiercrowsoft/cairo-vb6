if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_talonarioGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_talonarioGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 select * from talonario
 exec sp_talonarioGet 2,'x-0001-0002405'
*/
create procedure sp_talonarioGet (
	@@ta_id	      int
)
as

set nocount on

begin

	select Talonario.*,
				 emp_nombre
	from Talonario left join Empresa on Talonario.emp_id = Empresa.emp_id
  where ta_id = @@ta_id
end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



