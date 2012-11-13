if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraSaveDeuda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraSaveDeuda]

/*

 sp_DocFacturaCompraSaveDeuda 124

*/

go
create procedure sp_DocFacturaCompraSaveDeuda (

			@@fc_id						int,
			@@cpg_id					int,
			@@fc_fecha				datetime,
			@@fc_fechaVto			datetime,
			@@fc_total				decimal(18,6),
			@@est_id          int,
	    @@bSuccess     		tinyint out
)
as

begin


declare			@fc_id					int
declare			@cpg_id					int
declare			@fc_fecha				datetime
declare			@fc_total				decimal(18,6)
declare			@fc_pendiente		decimal(18,6)

			set @fc_id						= @@fc_id						
			set @cpg_id						= @@cpg_id
			set @fc_fecha					= @@fc_fecha				
			set @fc_total					= @@fc_total
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
	delete FacturaCompraDeuda where fc_id = @fc_id

	declare @cpg_escontado tinyint
	declare @cpg_eslibre   tinyint

	select @cpg_escontado = cpg_escontado,
				 @cpg_eslibre   = cpg_eslibre 
	from CondicionPago where cpg_id = @cpg_id

	if @@fc_total <> 0 and @@est_id <> 7 begin

		if @cpg_escontado <> 0 begin

			declare c_pagoItem insensitive cursor for 
				select  0 as cpgi_dias, 100 as cpgi_porcentaje
			
		end else begin
		
			if @cpg_eslibre <> 0 begin

				-- Por seguridad
				--
				if @@fc_fechaVto < @@fc_fecha set @@fc_fechaVto = dateadd(d,1,@@fc_fecha)

				declare c_pagoItem insensitive cursor for 
						select  datediff(d,@@fc_fecha,@@fc_fechaVto) as cpgi_dias, 100 as cpgi_porcentaje

			end else begin

				declare c_pagoItem insensitive cursor for 
						select cpgi_dias, cpgi_porcentaje from CondicionPagoItem where cpg_id = @cpg_id     
			end
		end
		
		declare @cpgi_dias 					smallint
	  declare @cpgi_porcentaje	  decimal(18,6)
		declare @fcd_id							int
		declare @fcd_fecha					datetime
		declare @fcd_fecha2 				datetime
		declare @fcd_pendiente			decimal(18,6)
	  declare @importe            decimal(18,6)
	  declare @n                  tinyint
	  declare @CountCpgi          tinyint
	
		set @n = 0
	  set @importe = 0
	  select @CountCpgi = count (*) from CondicionPagoItem where cpg_id = @cpg_id     

		open c_pagoItem

	  fetch next from c_pagoItem into @cpgi_dias, @cpgi_porcentaje 
		while @@fetch_status = 0 begin
	
			set @fcd_fecha = dateadd(d,@cpgi_dias,@fc_fecha)
			set @n = @n + 1
			if @n < @CountCpgi begin
				set @fcd_pendiente = @fc_total * @cpgi_porcentaje /100
		    set @importe       = @importe + @fcd_pendiente
			end else begin
				set @fcd_pendiente = @fc_total - @importe 
	    end

			set @fcd_pendiente = round(@fcd_pendiente,2)
	
			exec SP_DBGetNewId 'FacturaCompraDeuda','fcd_id',@fcd_id out, 0
			if @@error <> 0 goto ControlError

			exec sp_DocGetFecha2 @fcd_fecha, @fcd_fecha2 out, 0, null
			if @@error <> 0 goto ControlError

			insert into FacturaCompraDeuda (fcd_id, fcd_fecha, fcd_fecha2, fcd_importe, fcd_pendiente, fc_id)
														values  (@fcd_id,@fcd_fecha,@fcd_fecha2,@fcd_pendiente,@fcd_pendiente,@fc_id)
			if @@error <> 0 goto ControlError
	
		  fetch next from c_pagoItem into @cpgi_dias, @cpgi_porcentaje 
	  end

		close c_pagoItem
		deallocate c_pagoItem

		select @fc_pendiente = sum(fcd_pendiente) from FacturaCompraDeuda where fc_id = @fc_id

  end else begin
		select @fc_pendiente = 0
  end

	update FacturaCompra set fc_pendiente = IsNull(@fc_pendiente,0) where fc_id = @fc_id
	if @@error <> 0 goto ControlError

	set @@bSuccess = 1

	return
ControlError:

	set @@bSuccess = 0

end

go