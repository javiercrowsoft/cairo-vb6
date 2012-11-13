if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_comunidadInternetTextoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_comunidadInternetTextoDelete]

go
/*

*/

create procedure sp_comunidadInternetTextoDelete (

	@@cmit_id int
)

as

begin

	set nocount on

	begin transaction

	delete ComunidadInternetTextoItem where cmit_id = @@cmit_id
	if @@error <> 0 goto ControlError

	delete ComunidadInternetTexto where cmit_id = @@cmit_id
	if @@error <> 0 goto ControlError

	commit transaction

	return
ControlError:

	raiserror ('Ha ocurrido un error al borrar el texto. sp_comunidadInternetTextoDelete.', 16, 1)
	rollback transaction	

end