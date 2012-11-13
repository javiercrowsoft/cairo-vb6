if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_FE_GetConsultaComprobantes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_FE_GetConsultaComprobantes]

/*

 sp_FE_GetConsultaComprobantes 

	select * from facturaelectronica

*/

go
create procedure [dbo].[sp_FE_GetConsultaComprobantes] 

as

begin

	set nocount on

	select * from FacturaElectronicaConsulta where fvfec_respuesta = ''

end

go