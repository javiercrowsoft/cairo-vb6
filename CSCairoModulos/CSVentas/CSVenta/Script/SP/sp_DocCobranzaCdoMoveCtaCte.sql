if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaCdoMoveCtaCte]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaCdoMoveCtaCte]

go

/*

select max(fv_id) from facturaventa
sp_DocCobranzaCdoMoveCtaCte  29183

*/

create procedure sp_DocCobranzaCdoMoveCtaCte (
	@@fv_id   int
)
as

begin

	set nocount off

	update FacturaVentaCajero set fvcj_ctacte = 1 where fv_id = @@fv_id

	select 1

end