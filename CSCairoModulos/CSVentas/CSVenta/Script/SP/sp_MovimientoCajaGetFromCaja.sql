/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetFromCaja]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetFromCaja]


/*

sp_MovimientoCajaGetFromCaja 5,2

*/

go
create procedure sp_MovimientoCajaGetFromCaja (

	@@cj_id			int,
	@@tipo			int,
	@@mcj_id 		int out

)as 

begin

	set nocount on
	
	declare @mcj_id int
	declare @tipo   int

	select @mcj_id = max(mcj_id) from MovimientoCaja where cj_id = @@cj_id

	if @mcj_id is not null begin

		select @tipo = mcj_tipo from MovimientoCaja where mcj_id = @mcj_id

		if @tipo <> @@tipo select @@mcj_id = null
		else         			 select @@mcj_id = @mcj_id

	end else begin

		select @@mcj_id = @mcj_id

	end	

end
go