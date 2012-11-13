if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGet]

go

create procedure sp_MovimientoCajaGet (
	@@mcj_id int
)
as

begin

	declare @cj_id int
	declare @last_mcj_id int

	select @cj_id = cj_id from MovimientoCaja where mcj_id = @@mcj_id

	select @last_mcj_id = max(mcj_id) from MovimientoCaja where cj_id = @cj_id

	declare @items_editable tinyint

	if isnull(@last_mcj_id,0) <> @@mcj_id set @items_editable = 0
	else                                  set @items_editable = 1

	select 
					mcj.*,
      		suc_nombre,
					us_nombre,
					cj_nombre,
					@items_editable as items_editable

	from 
	
			MovimientoCaja mcj	 
									 left  join Caja cj    			on mcj.cj_id 					= cj.cj_id
									 left  join sucursal suc    on cj.suc_id      		= suc.suc_id
									 left  join Usuario us   		on mcj.us_id_cajero  	= us.us_id

	
	where 
				mcj.mcj_id = @@mcj_id
	
end

go