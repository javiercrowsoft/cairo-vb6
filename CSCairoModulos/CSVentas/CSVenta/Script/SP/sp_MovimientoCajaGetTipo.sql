/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetTipo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetTipo]


/*

sp_MovimientoCajaGetTipo 5

*/

go
create procedure sp_MovimientoCajaGetTipo (

	@@cj_id	int

)as 

begin

	set nocount on
	
	declare @mcj_id int
	declare @tipo   int

	select @mcj_id = max(mcj_id) from MovimientoCaja where cj_id = @@cj_id

	if @mcj_id is not null begin

		select @tipo = mcj_tipo from MovimientoCaja where mcj_id = @mcj_id

		if @tipo = 1 select 2
		else         select 1

	end else begin

		select 1

	end	

end
go