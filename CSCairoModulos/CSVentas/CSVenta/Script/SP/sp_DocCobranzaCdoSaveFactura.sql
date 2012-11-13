if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaCdoSaveFactura]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaCdoSaveFactura]

go

/*

select max(fv_id) from facturaventa
sp_DocCobranzaCdoSaveFactura  29183

*/

create procedure sp_DocCobranzaCdoSaveFactura (
	@@fv_id   int,
	@@cj_id   int,
	@@ctacte  tinyint
)
as

begin

	declare @fvcj_id int

	exec sp_dbgetnewid 'FacturaVentaCajero', 'fvcj_id', @fvcj_id out, 0

	insert into FacturaVentaCajero (
																	fvcj_id,
																	cj_id,
																	fv_id,
																	fvcj_ctacte
																	)
													values  (
																		@fvcj_id,
																		@@cj_id,
																		@@fv_id,
																		@@ctacte
																	)
	insert into FacturaVentaCajeroLog (
																	fvcj_id,
																	cj_id,
																	fv_id,
																	fvcj_ctacte
																	)
													values  (
																		@fvcj_id,
																		@@cj_id,
																		@@fv_id,
																		@@ctacte
																	)

end