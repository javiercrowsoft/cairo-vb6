/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetItems]


/*

sp_MovimientoCajaGetItems 5

*/

go
create procedure sp_MovimientoCajaGetItems (

	@@mcj_id	int

)as 

begin

	set nocount on

	select 	mcji.*,
					cue_nombre,
					mon_nombre

	from MovimientoCajaItem	mcji inner join Cuenta cue on mcji.cue_id_trabajo = cue.cue_id
								  						 left  join Moneda mon on mcji.mon_id = mon.mon_id
	where mcj_id = @@mcj_id

end
go