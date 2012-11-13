if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSetEstadoCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSetEstadoCliente]

/*

 sp_DocFacturaVentaSetEstadoCliente 21

*/

go
create procedure sp_DocFacturaVentaSetEstadoCliente (
	@@fv_id 			int,
  @@est_id      int = 0 out 
)
as

begin

	-- Nada que hacer
	declare @dummy tinyint

end
GO