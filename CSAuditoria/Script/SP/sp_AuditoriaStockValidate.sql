-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockValidate]

go

create procedure sp_AuditoriaStockValidate (

	@@aud_id 			int,
	@@aud_fecha 	datetime

)
as

begin

  set nocount on

	-- Remito de venta
	--
	declare @rv_id int

	declare c_audi_stock insensitive cursor for 

	  select rv_id 
		from RemitoVenta rv inner join Documento doc on rv.doc_id = doc.doc_id 
																								and doc_muevestock <> 0
		where rv.modificado >= @@aud_fecha

	open c_audi_stock

	fetch next from c_audi_stock into @rv_id
	while @@fetch_status = 0
	begin

		exec sp_AuditoriaStockValidateDocRV @rv_id, @@aud_id

		fetch next from c_audi_stock into @rv_id
	end

	close c_audi_stock

	deallocate c_audi_stock

	-- Remito de Compra
	--
	declare @rc_id int

	declare c_audi_stock insensitive cursor for 

	  select rc_id 
		from RemitoCompra rc inner join Documento doc on rc.doc_id = doc.doc_id 
																								 and doc_muevestock <> 0
		where rc.modificado >= @@aud_fecha

	open c_audi_stock

	fetch next from c_audi_stock into @rc_id
	while @@fetch_status = 0
	begin

		exec sp_AuditoriaStockValidateDocRC @rc_id, @@aud_id

		fetch next from c_audi_stock into @rc_id
	end

	close c_audi_stock

	deallocate c_audi_stock

	-- Factura de Venta
	--
	declare @fv_id int

	declare c_audi_stock insensitive cursor for 

	  select fv_id 
		from FacturaVenta fv inner join Documento doc on fv.doc_id = doc.doc_id 
																								 and doc_muevestock <> 0
		where fv.modificado >= @@aud_fecha

	open c_audi_stock

	fetch next from c_audi_stock into @fv_id
	while @@fetch_status = 0
	begin

		exec sp_AuditoriaStockValidateDocFV @fv_id, @@aud_id

		fetch next from c_audi_stock into @fv_id
	end

	close c_audi_stock

	deallocate c_audi_stock

	-- Factura de Compra
	--
	declare @fc_id int

	declare c_audi_stock insensitive cursor for 

	  select fc_id 
		from FacturaCompra fc inner join Documento doc on fc.doc_id = doc.doc_id 
																								  and doc_muevestock <> 0
		where fc.modificado >= @@aud_fecha

	open c_audi_stock

	fetch next from c_audi_stock into @fc_id
	while @@fetch_status = 0
	begin

		exec sp_AuditoriaStockValidateDocFC @fc_id, @@aud_id

		fetch next from c_audi_stock into @fc_id
	end

	close c_audi_stock

	deallocate c_audi_stock

	-- Recuento Stock
	--
	declare @rs_id int

	declare c_audi_stock insensitive cursor for 

	  select rs_id 
		from RecuentoStock rs inner join Documento doc on rs.doc_id = doc.doc_id 
																								  and doc_muevestock <> 0
		where rs.modificado >= @@aud_fecha

	open c_audi_stock

	fetch next from c_audi_stock into @rs_id
	while @@fetch_status = 0
	begin

		exec sp_AuditoriaStockValidateDocRS @rs_id, @@aud_id

		fetch next from c_audi_stock into @rs_id
	end

	close c_audi_stock

	deallocate c_audi_stock

	-- Parte de Produccion de Kit
	--
	declare @ppk_id int

	declare c_audi_stock insensitive cursor for 

	  select ppk_id 
		from ParteProdKit ppk inner join Documento doc on ppk.doc_id = doc.doc_id 
		where ppk.modificado >= @@aud_fecha

	open c_audi_stock

	fetch next from c_audi_stock into @ppk_id
	while @@fetch_status = 0
	begin

		exec sp_AuditoriaStockValidateDocPPK @ppk_id, @@aud_id

		fetch next from c_audi_stock into @ppk_id
	end

	close c_audi_stock

	deallocate c_audi_stock

-- Articulos que se compran y llevan stock y tienen la relacion en cero
--

	declare @audi_id 		int
	declare @pr_nombre 	varchar(255)

	declare c_producto insensitive cursor for
		select pr_nombrecompra 
		from producto 
		where pr_stockcompra = 0 
			and pr_llevastock <> 0 
			and pr_secompra <> 0

	open c_producto

	fetch next from c_producto into @pr_nombre
	while @@fetch_status = 0
	begin
				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El artículo ' + @pr_nombre
	                                 + ' se compra y se mantien en stock pero la' +
                                   + ' relación entre las unidades de compra y stock esta en cero',
																	 3,
																	 1,
																	 null,
																	 null
																	)

		fetch next from c_producto into @pr_nombre
	end

	close c_producto
	deallocate c_producto

-- Articulos que se venden y llevan stock y tienen la relacion en cero
--

	declare c_producto insensitive cursor for
		select pr_nombreventa
		from producto 
		where pr_ventastock = 0 
			and pr_llevastock <> 0 
			and pr_sevende <> 0

	open c_producto

	fetch next from c_producto into @pr_nombre
	while @@fetch_status = 0
	begin
				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El artículo ' + @pr_nombre
	                                 + ' se vende y se mantien en stock pero la' +
                                   + ' relación entre las unidades de venta y stock esta en cero',
																	 3,
																	 1,
																	 null,
																	 null
																	)

		fetch next from c_producto into @pr_nombre
	end

	close c_producto
	deallocate c_producto

-- Articulos que se venden y se compran y tienen la relacion en cero
--

	declare c_producto insensitive cursor for
		select pr_nombreventa
		from producto 
		where pr_ventacompra = 0 
			and pr_secompra <> 0 
			and pr_sevende <> 0

	open c_producto

	fetch next from c_producto into @pr_nombre
	while @@fetch_status = 0
	begin
				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El artículo ' + @pr_nombre
	                                 + ' se compra y se vende pero la' +
                                   + ' relación entre las unidades de compra y venta esta en cero',
																	 3,
																	 1,
																	 null,
																	 null
																	)

		fetch next from c_producto into @pr_nombre
	end

	close c_producto
	deallocate c_producto

-- Articulos que no llevan stock y son kit
--
	declare c_producto insensitive cursor for
		select pr_nombrecompra
		from producto 
		where pr_llevastock = 0 
			and pr_eskit <> 0


	open c_producto

	fetch next from c_producto into @pr_nombre
	while @@fetch_status = 0
	begin
				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'El artículo ' + @pr_nombre
	                                 + ' indica que es un kit pero no lleva stock',
																	 3,
																	 1,
																	 null,
																	 null
																	)

		fetch next from c_producto into @pr_nombre
	end

	close c_producto
	deallocate c_producto

ControlError:

end
GO