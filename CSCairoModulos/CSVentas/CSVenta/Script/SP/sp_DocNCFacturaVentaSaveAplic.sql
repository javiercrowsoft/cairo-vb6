if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocNCFacturaVentaSaveAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocNCFacturaVentaSaveAplic]

/*

begin tran
select fv_pendiente from facturaventa where fv_id = 446
select fv_pendiente from facturaventa where fv_id = 459
select * from facturaventadeuda where fv_id = 446
select * from facturaventadeuda where fv_id = 459
exec sp_DocNCFacturaVentaSaveAplic 1,446,459
select fv_pendiente from facturaventa where fv_id = 446
select fv_pendiente from facturaventa where fv_id = 459
rollback tran

*/

go
create procedure sp_DocNCFacturaVentaSaveAplic (
	@@us_id					int,
	@@fv_id_fv 			int,	
	@@fv_id_nc			int
)
as

begin

	set nocount on

	declare @fvTMP_id 					int
	declare @fvd_id_nc					int
	declare @fvd_id_fv					int
	declare @fvd_pendiente_nc		decimal(18,6)
	declare @fvd_pendiente_fv		decimal(18,6)
	declare @fvnc_importe     	decimal(18,6)
	declare @doc_id             int
	declare @fvncTMP_id         int

	select @doc_id = doc_id from FacturaVenta where fv_id = @@fv_id_nc

	exec sp_dbgetnewid 'FacturaVentaTMP','fvTMP_id', @fvTMP_id out, 0

	insert into FacturaVentaTMP
															(
																fvTMP_id,
																fv_id,
																fv_numero,
																fv_nrodoc,
																cli_id,
																suc_id,
																doc_id,
																cpg_id,
																fv_grabarasiento,
                                est_id,
																modifico
															)
											values  (
																@fvTMP_id,
																@@fv_id_nc,
																0, 		--fv_numero,
																'', 	--fv_nrodoc,
																0, 		--cli_id,
																0, 		--suc_id,
																@doc_id,
																-2, 	--cpg_id,
																0, 		--fv_grabarasiento,
                                1, 		--est_id
																@@us_id
															)

	declare c_deudanc insensitive cursor for 
			select fvd_id, fvd_pendiente 
			from FacturaVentaDeuda 
			where fv_id = @@fv_id_nc 
				and fvd_pendiente > 0

	open c_deudanc

	fetch next from c_deudanc into @fvd_id_nc, @fvd_pendiente_nc
	while @@fetch_status=0
	begin

		set @fvd_id_fv = null

		select @fvd_id_fv = min(fvd_id)
		from FacturaVentaDeuda 
		where fvd_pendiente > 0 
			and fvd_id not in (select fvd_id from FacturaVentaNotaCreditoTMP where fvTMP_id = @fvTMP_id)
			and fv_id = @@fv_id_fv

		while @fvd_id_fv is not null and @fvd_pendiente_nc > 0
		begin

			select @fvd_pendiente_fv = fvd_pendiente from FacturaVentaDeuda where fvd_id = @fvd_id_fv

			if @fvd_pendiente_nc < @fvd_pendiente_fv	set @fvnc_importe = @fvd_pendiente_nc
			else																			set @fvnc_importe = @fvd_pendiente_fv

			set @fvd_pendiente_nc = @fvd_pendiente_nc - @fvnc_importe

			exec sp_dbgetnewid 'FacturaVentaNotaCreditoTMP','fvncTMP_id', @fvncTMP_id out, 0

			insert into FacturaVentaNotaCreditoTMP (
																							 fvTMP_id
																							,fvncTMP_id

																							,fv_id_factura
																							,fv_id_notacredito
																							,fvd_id_factura
																							,fvd_id_notacredito
																							,fvnc_id
																							,fvnc_importe
																							,fvp_id_factura
																							,fvp_id_notacredito											
																							)
																			values (
																							 @fvTMP_id
																							,@fvncTMP_id

																							,@@fv_id_fv --fv_id_factura
																							,@@fv_id_nc --fv_id_notacredito
																							,@fvd_id_fv --fvd_id_factura
																							,@fvd_id_nc --fvd_id_notacredito
																							,0 --fvnc_id
																							,@fvnc_importe
																							,null --fvp_id_factura
																							,null --fvp_id_notacredito
																							)		
		end

		fetch next from c_deudanc into @fvd_id_nc, @fvd_pendiente_nc
	end

	close c_deudanc
	deallocate c_deudanc

	-- debug
	--select * from FacturaVentaNotaCreditoTMP where fvTMP_id = @fvTMP_id
	-- debug

	exec sp_DocFacturaVentaSaveAplic @fvTMP_id

end 

go