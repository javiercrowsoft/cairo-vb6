if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_horaSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_horaSetPendiente]

/*


 select * from Agenda

 sp_horaSetPendiente 59

*/

go
create procedure sp_horaSetPendiente (
	@@hora_id 		int,
  @@bSuccess    tinyint = 0 out
)
as

begin

	set nocount on

	declare @hora_pendiente decimal(18,6)
	declare @aplicado 			decimal(18,6)

	select @hora_pendiente = hora_horas + convert(decimal(18,6),hora_minutos)/60
	from hora where hora_id = @@hora_id
	
	select @aplicado = sum(horafv_cantidad) from HoraFacturaVenta where hora_id = @@hora_id

	update hora set hora_pendiente = @hora_pendiente - IsNull(@aplicado,0) where hora_id = @@hora_id
	set @@bSuccess = 1

end
go