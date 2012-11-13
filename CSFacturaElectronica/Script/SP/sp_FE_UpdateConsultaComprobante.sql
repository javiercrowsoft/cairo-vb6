if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_UpdateConsultaComprobante]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_UpdateConsultaComprobante]

/*

 sp_FE_UpdateConsultaComprobante 

	select * from facturaelectronica

*/

go
create procedure [dbo].[sp_FE_UpdateConsultaComprobante] (
	@@fvfec_id int,
	@@fvfec_respuesta varchar(8000)
)
as

begin

	set nocount on

	update FacturaElectronicaConsulta 
			set fvfec_respuesta = @@fvfec_respuesta 
	where fvfec_id = @@fvfec_id

end

go