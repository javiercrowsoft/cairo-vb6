-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocRC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocRC]

go

create procedure sp_AuditoriaTotalesValidateDocRC (

	@@rc_id     int,
	@@aud_id 		int

)
as

begin

  set nocount on

	declare @audi_id 					int
	declare @doct_id      		int
	declare @rc_nrodoc 				varchar(50) 
	declare @rc_numero 				varchar(50) 
	declare @est_id       		int
	declare @rc_pendiente			decimal(18,6)
	declare @rc_total    			decimal(18,6)
	declare @rc_neto          decimal(18,6)
	declare @rc_ivari         decimal(18,6)
	declare @rc_importedesc1  decimal(18,6)
	declare @rc_importedesc2  decimal(18,6)
	declare @rc_desc1  				decimal(18,6)
	declare @rc_desc2  				decimal(18,6)

	select 
						@doct_id 		 	= doct_id,
						@rc_nrodoc  	= rc_nrodoc,
						@rc_numero  	= convert(varchar,rc_numero),
						@est_id      	= est_id,
						@rc_pendiente	= rc_pendiente,
						@rc_total			= rc_total,
						@rc_neto			= rc_neto,
						@rc_ivari			= rc_ivari,

						@rc_desc1					= rc_descuento1,
						@rc_desc2					= rc_descuento2,

						@rc_importedesc1	= rc_importedesc1,
						@rc_importedesc2	= rc_importedesc2

	from RemitoCompra where rc_id = @@rc_id

	if exists(select rc_id 
						from RemitoCompraItem
         		where round(rci_neto,2) <> round(rci_precio * rci_cantidad,2)
							and rc_id = @@rc_id
						) begin


			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este remito posee items cuyo neto no coincide con el precio por la cantidad '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rc_id
																)

	end

	if exists(select rc_id 
						from RemitoCompraItem
         		where round(rci_neto * (rci_ivariporc / 100),2) <> round(rci_ivari,2)
							and rc_id = @@rc_id
						) begin


			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'Este remito posee items cuyo iva no coincide con el neto por el porcentaje de la tasa '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rc_id
																)

	end

	declare @rci_neto decimal(18,6)

	select @rci_neto = sum(rci_neto)
	from RemitoCompraItem
	where rc_id = @@rc_id
	group by rc_id

	set @rci_neto = IsNull(@rci_neto,0) - (@rci_neto * @rc_desc1/100) 
	set @rci_neto = IsNull(@rci_neto,0) - (@rci_neto * @rc_desc2/100)

	if round(@rci_neto,2) <> round(@rc_neto,2) begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El neto de este remito no coincide con la suma de los netos de sus items '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rc_id
																)

	end

	declare @importe 				decimal(18,6)

	select @importe = sum(rci_importe) from RemitoCompraItem where rc_id = @@rc_id group by rc_id

	set @importe = isnull(@importe,0)

	declare @rc_descivari decimal(18,6)
	declare @rci_ivari 		decimal(18,6)

	select @rci_ivari = sum(rci_ivari)
						from RemitoCompraItem
						where rc_id = @@rc_id
						group by rc_id

	set @rci_ivari = isnull(@rci_ivari,0)
	set @rc_descivari = (@rci_ivari * @rc_desc1/100) 
	set @rc_descivari = @rc_descivari + ((@rci_ivari - @rc_descivari) * @rc_desc2/100)
	set @rc_total 		= @rc_total + @rc_importedesc1 + @rc_importedesc2 + @rc_descivari

	if round(@importe,2) <> round(@rc_total,2) begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El total de este remito no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rc_id
																)

	end

	select @rci_ivari = sum(rci_ivari)
						from RemitoCompraItem
						where rc_id = @@rc_id
						group by rc_id

	set @rci_ivari = isnull(@rci_ivari,0)
	set @rci_ivari = @rci_ivari - (@rci_ivari * @rc_desc1/100) 
	set @rci_ivari = @rci_ivari - (@rci_ivari * @rc_desc2/100)

	if round(@rci_ivari,2) <> round(@rc_ivari,2) begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El IVA de este remito no coincide con la suma de los IVA de sus items '
                                 + '(comp.:' + @rc_nrodoc + ' nro.: '+ @rc_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@rc_id
																)

	end

ControlError:

end
GO