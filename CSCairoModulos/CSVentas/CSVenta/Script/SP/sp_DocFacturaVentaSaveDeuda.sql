if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSaveDeuda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSaveDeuda]

/*

 sp_DocFacturaVentaSaveDeuda 124

*/

go
create procedure sp_DocFacturaVentaSaveDeuda (

			@@fv_id						int,
			@@cpg_id					int,
			@@fv_fecha				datetime,
			@@fv_fechaVto			datetime,
			@@fv_total				decimal(18,6),
			@@est_id          int,
	    @@bSuccess     		tinyint out
)
as

begin


declare			@fv_id					int
declare			@cpg_id					int
declare			@fv_fecha				datetime
declare			@fv_total				decimal(18,6)
declare			@fv_pendiente		decimal(18,6)

			set @fv_id						= @@fv_id						
			set @cpg_id						= @@cpg_id
			set @fv_fecha					= @@fv_fecha				
			set @fv_total					= @@fv_total
			set @@bSuccess 				= 0
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     PAGO EN CTA CTE Y CONTADO                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	-- La factura no puede estar aplicada a ninguna cobranza
  -- por lo tanto lo primero que hago es borrar toda la info de deuda
  -- y volver a generarla
	delete FacturaVentaDeuda where fv_id = @fv_id

	declare @cpg_escontado tinyint
	declare @cpg_eslibre   tinyint

	select @cpg_escontado = cpg_escontado,
				 @cpg_eslibre   = cpg_eslibre
	from CondicionPago where cpg_id = @cpg_id

	if @@fv_total <> 0 and @@est_id <> 7 begin

		if @cpg_escontado <> 0 begin
			
			declare c_pagoItem insensitive cursor for
				select  0 as cpgi_dias, 100 as cpgi_porcentaje
			
		end else begin
		
			if @cpg_eslibre <> 0 begin

				-- Por seguridad
				--
				if @@fv_fechaVto < @@fv_fecha set @@fv_fechaVto = dateadd(d,1,@@fv_fecha)

				declare c_pagoItem insensitive cursor for 
						select  datediff(d,@@fv_fecha,@@fv_fechaVto) as cpgi_dias, 100 as cpgi_porcentaje

			end else begin

				declare c_pagoItem insensitive cursor for 
						select cpgi_dias, cpgi_porcentaje from CondicionPagoItem where cpg_id = @cpg_id     
			end
		end
		
		declare @cpgi_dias 					smallint
	  declare @cpgi_porcentaje	  decimal(18,6)
		declare @fvd_id							int
		declare @fvd_fecha					datetime
		declare @fvd_fecha2 				datetime
		declare @fvd_pendiente			decimal(18,6)
	  declare @importe            decimal(18,6)
	  declare @n                  tinyint
	  declare @CountCpgi          tinyint
	
		set @n = 0
	  set @importe = 0
	  select @CountCpgi = count (*) from CondicionPagoItem where cpg_id = @cpg_id     

		open c_pagoItem

	  fetch next from c_pagoItem into @cpgi_dias, @cpgi_porcentaje 
		while @@fetch_status = 0 begin
	
			set @fvd_fecha = dateadd(d,@cpgi_dias,@fv_fecha)
			set @n = @n + 1
			if @n < @CountCpgi begin
				set @fvd_pendiente = @fv_total * @cpgi_porcentaje /100
		    set @importe       = @importe + @fvd_pendiente
			end else begin
				set @fvd_pendiente = @fv_total - @importe 
	    end
	
			set @fvd_pendiente = round(@fvd_pendiente,2)

			exec SP_DBGetNewId 'FacturaVentaDeuda','fvd_id',@fvd_id out,0
			if @@error <> 0 goto ControlError

			exec sp_DocGetFecha2 @fvd_fecha, @fvd_fecha2 out, 0, null
			if @@error <> 0 goto ControlError

			insert into FacturaVentaDeuda (fvd_id, fvd_fecha, fvd_fecha2, fvd_importe, fvd_pendiente, fv_id)
														values  (@fvd_id,@fvd_fecha,@fvd_fecha2,@fvd_pendiente,@fvd_pendiente,@fv_id)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_pagoItem into @cpgi_dias, @cpgi_porcentaje 
	  end

		close c_pagoItem
		deallocate c_pagoItem

		select @fv_pendiente = sum(fvd_pendiente) from FacturaVentaDeuda where fv_id = @fv_id

  end else begin
		select @fv_pendiente = 0
  end

	update FacturaVenta set fv_pendiente = isnull(@fv_pendiente,0) where fv_id = @fv_id
	if @@error <> 0 goto ControlError

	set @@bSuccess = 1

	return
ControlError:

	set @@bSuccess = 0

end

go