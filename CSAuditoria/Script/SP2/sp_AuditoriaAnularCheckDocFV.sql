if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaAnularCheckDocFV]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaAnularCheckDocFV]

go

create procedure sp_AuditoriaAnularCheckDocFV (
	@@fv_id 			int,
  @@bSuccess    tinyint out,
	@@bErrorMsg   varchar(5000) out
)
as

begin

  set nocount on

	declare @bError tinyint

	set @bError     = 0
	set @@bSuccess 	= 0
	set @@bErrorMsg = '@@ERROR_SP:'

	declare @est_id int

	select @est_id = est_id from FacturaVenta where fv_id = @@fv_id

	if @est_id = 7 begin

		if exists(select * from FacturaVentaDeuda where fv_id = @@fv_id) begin

				set @bError = 1
				set @@bErrorMsg = @@bErrorMsg + 'Esta factura esta anulada pero tiene deuda' + char(10)
	
		end else begin

			if exists(select * from FacturaVentaItem where fv_id = @@fv_id and fvi_pendiente <> 0) begin
	
					set @bError = 1
					set @@bErrorMsg = @@bErrorMsg + 'Esta factura esta anulada pero tiene pendiente en sus items' + char(10)
		
			end

		end

	end

	-- No hubo errores asi que todo bien
	--
	if @bError = 0 set @@bSuccess = 1

end