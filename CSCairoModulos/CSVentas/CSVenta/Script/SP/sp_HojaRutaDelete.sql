if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HojaRutaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HojaRutaDelete]

go

create procedure sp_HojaRutaDelete (
	@@hr_id int
)
as

begin

	set nocount on

	begin transaction

	delete HojaRutaItem where hr_id = @@hr_id
	if @@error <> 0 goto ControlError

	delete HojaRuta where hr_id = @@hr_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar la hoja de ruta. sp_HojaRutaDelete.', 16, 1)
	rollback transaction	


end

go