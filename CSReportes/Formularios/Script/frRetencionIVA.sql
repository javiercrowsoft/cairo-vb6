USE [cairoSDI]
GO
/****** Object:  StoredProcedure [dbo].[frRetencionIVA]    Script Date: 07/03/2018 08:13:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

[frRetencionIVA] 21691
select * from retencion
*/

alter procedure [dbo].[frRetencionIVA] (

	@@opg_id			int

)as

begin

	set nocount on

	-- Para cuando hay diferencias
	--
	declare @descrip 		varchar(5000)
	declare @fc_base 		decimal(18,6)
	declare @fc_numero  int

	-- Cabecera
	--
	declare @emp_id 		int
	declare @opg_total 	decimal(18,6)

	select  @emp_id    = emp_id,
					@opg_total = opg_total

	from OrdenPago where opg_id = @@opg_id

	declare @emp_razonsocial varchar(255)
	declare @emp_cuit        varchar(255)

	select  @emp_razonsocial 	= emp_razonsocial,
					@emp_cuit 				= emp_cuit

	from Empresa where emp_id = @emp_id

	-- Retenciones
	--
	create table #t_frRetencionIVA (opgi_id int, alicuota decimal(18,6))

	declare @alicuota 		decimal(18,6)
	declare @ret_id 			int
	declare @opgi_id 			int
	declare @ret_nrodoc		varchar(255)

	declare c_opgi insensitive cursor for

		select opgi.ret_id,
					 opgi_id,
					 opgi_nroRetencion

		from OrdenPagoItem opgi
		inner join Retencion ret on opgi.ret_id = ret.ret_id
		inner join RetencionTipo rett on ret.rett_id = rett.rett_id
		where opg_id = @@opg_id
			and ret.ret_esiibb = 0
			and rett_tipo = 1

	open c_opgi

	fetch next from c_opgi into @ret_id, @opgi_id, @ret_nrodoc
	while @@fetch_status=0
	begin

		select @alicuota = reti_porcentaje
		from RetencionItem
		where ret_id = @ret_id
			and @opg_total between reti_importedesde and reti_importehasta

		insert into #t_frRetencionIVA (opgi_id,  alicuota)
														values (@opgi_id, @alicuota)

		fetch next from c_opgi into @ret_id, @opgi_id, @ret_nrodoc
	end

	close c_opgi
	deallocate c_opgi

	-- Facturas
	--
	declare @error_msg 			varchar(500)
	declare @fc_id 					int
	declare @last_fc_id     int
	declare @last_opgi_id 	int
	declare @pago     			decimal(18,6)
	declare @total    			decimal(18,6)
	declare @neto     			decimal(18,6)
	declare @item_neto			decimal(18,6)
	declare @item_total 		decimal(18,6)
	declare @percepciones   decimal(18,6)
	declare @opgi_importe   		decimal(18,6)
	declare @last_opgi_importe  decimal(18,6)
	declare @porcentaje     decimal(18,6)
	declare @base           decimal(18,6)
	declare @retencion      decimal(18,6)

	declare @desc1          decimal(18,6)
	declare @desc2          decimal(18,6)

	declare @base_opgi           decimal(18,6)
	declare @retencion_opgi      decimal(18,6)

	declare @last_alicuota  decimal(18,6)
	declare @prov_catfiscal int

	select @prov_catfiscal = prov_catfiscal
	from OrdenPago opg inner join Proveedor prov on opg.prov_id = prov.prov_id
	where opg_id = @@opg_id

	create table #t_FacturaCompraOrdenPago (opg_id int, fc_id int, fcopg_importe decimal(18,6))

	insert into #t_FacturaCompraOrdenPago (opg_id, fc_id, fcopg_importe)
		select opg_id, fc_id, sum(fcopg_importe)
		from FacturaCompraOrdenPago
		where opg_id = @@opg_id
		group by opg_id, fc_id

	create table #t_Facturas (	opgi_id   int,
															fc_id 		int,
															base 			decimal(18,6),
															alicuota  decimal(18,6),
															retencion decimal(18,6)
														)

	declare c_fac insensitive cursor for

	select opgi.opgi_id,
				 fc.fc_id,
				 alicuota,
				 fcopg_importe,
				 fc_total,
				 fc_neto,
				 fc_totalpercepciones,
				 sum(fci_neto),
				 sum(fci_importe),
				 opgi_importe,
				 fc_descuento1,
				 fc_descuento2

	from OrdenPagoItem opgi inner join OrdenPago opg 				on opgi.opg_id 	= opg.opg_id
													inner join #t_frRetencionIVA t on opgi.opgi_id = t.opgi_id
													inner join Retencion ret 				on opgi.ret_id 	= ret.ret_id

													inner join #t_FacturaCompraOrdenPago fcopg on opg.opg_id = fcopg.opg_id

													inner join FacturaCompra fc 			on fcopg.fc_id = fc.fc_id
													inner join FacturaCompraItem fci  on fc.fc_id    = fci.fc_id
													/*inner join Producto pr            on fci.pr_id   = pr.pr_id
																														and (		 isnull(ret.ibc_id,0) = isnull(pr.ibc_id,0)
																																	or ret.ibc_id is null
																																)
																														and isnull(pr.ibc_id,0)<> 1 -- Exento*/
	where opg.opg_id = @@opg_id

	group by
				 opgi.opgi_id,
				 fc.fc_id,
				 alicuota,
				 fcopg_importe,
				 fc_total,
				 fc_neto,
				 fc_totalpercepciones,
				 opgi_importe,
				 fc_descuento1,
				 fc_descuento2

	open c_fac

	set @last_opgi_id 			= 0
	set @last_opgi_importe 	= 0
	set @last_alicuota 			= 0
	set @last_fc_id 				= 0

	fetch next from c_fac into @opgi_id, @fc_id, @alicuota, @pago, @total, @neto,
                             @percepciones, @item_neto, @item_total, @opgi_importe, @desc1, @desc2
	while @@fetch_status=0
	begin

		if @last_opgi_id <> @opgi_id begin

			if @last_opgi_id <> 0 begin

				insert into #t_Facturas (opgi_id, fc_id, base, alicuota, retencion)
												values  (@last_opgi_id, @last_fc_id, @base, @last_alicuota/100, @retencion)

				if    (abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2)) > 0.10)
					 or (abs(round(@last_opgi_importe,2) - round(@base_opgi*@last_alicuota/100,2)) > 0.10) begin


					--//////////////////////////////////////////////////////////////////////////////////////////

						set @descrip = ''

						declare c_facturas insensitive cursor for select fc.fc_numero, t.base from #t_Facturas t inner join FacturaCompra fc on t.fc_id = fc.fc_id

						open c_facturas

						fetch next from c_facturas into @fc_numero, @fc_base
						while @@fetch_status=0
						begin

							set @descrip = @descrip + 'FV:'
																			+ convert(varchar,@fc_numero) + ' - '
																			+ convert(varchar,@fc_base) + ','

							fetch next from c_facturas into @fc_numero, @fc_base
						end
						close c_facturas
						deallocate c_facturas

					--//////////////////////////////////////////////////////////////////////////////////////////

					-- para debug
					-- select @last_opgi_importe, @retencion, @base, @last_alicuota, @base*@last_alicuota/100

					-- Se pudrio todo, yo no se como resolver esto asi que se lo dejo al usuario
					--
					set @error_msg =
											'@@ERROR_SP:1)El sistema fallo al calcular las bases de las '
										 +'retenciones para esta orden de pago.'+char(13)+char(13)
										 +'Esto puede deberse a que la orden de pago esta hecha sobre '
										 +'varios parciales.'+char(13)+char(13)
										 +'Comuniquese con CrowSoft para obtener una solucion a este problema.'
										 +char(13)+char(13)
										 +'dif: ' + convert(varchar,convert(decimal(18,2),abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2))))
										 +char(13)+char(13)
										 +'dif: ' + convert(varchar,convert(decimal(18,2),abs(round(@last_opgi_importe,2) - round(@base_opgi*@last_alicuota/100,2))))
										 +char(13)+char(13)
										 + 'Base de facturas ' + @descrip
										 /*+'(sepa disculpar la ignorancia de nuestros programadores :)'*/

					raiserror (@error_msg, 16, 1) -- :) sefini
					return

				end

			end

			set @last_opgi_id 			= @opgi_id
			set @last_fc_id 				= @fc_id
			set @last_opgi_importe 	= @opgi_importe
			set @last_alicuota 			= @alicuota
			set @base 							= 0
			set @retencion 					= 0

			set @base_opgi 					= 0
			set @retencion_opgi			= 0

		end else begin

			if @last_fc_id <> @fc_id begin

				if @last_fc_id <> 0 begin

					insert into #t_Facturas (opgi_id, fc_id, base, alicuota, retencion)
													values  (@last_opgi_id, @last_fc_id, @base, @last_alicuota/100, @retencion)


					set @last_fc_id 				= @fc_id
					set @base 							= 0
					set @retencion 					= 0
				end
			end
		end

		if @desc1 <> 0 begin

			set @item_total = @item_total - (@item_total * @desc1)/100
		end

		if @desc2 <> 0 begin

			set @item_total = @item_total - (@item_total * @desc2)/100
		end

		set @porcentaje = @item_total / (@total - @percepciones)

--select @base,@porcentaje

		set @base = @base +
                @porcentaje * (
																case @prov_catfiscal
																	when 1		then @pago * (@neto/@total)

																	when 11 	then @pago * (@neto/@total)

																	when 6 		then @pago
																								-(@pago	*	(@percepciones/@total))

																	else 					 0
																end
														)

		set @retencion = @retencion +
                     @porcentaje * (
																case @prov_catfiscal
																	when 1		then (@pago * (@neto/@total))*@alicuota/100

																	when 11 	then (@pago * (@neto/@total))*@alicuota/100

																	when 6 		then (	@pago
																										-(@pago	*	(@percepciones/@total))
																									)*@alicuota/100

																	else 					 0
																end
														)

		set @base_opgi 					= @base_opgi + @base

--select @base_opgi,@base,@neto,@total,@pago

		set @retencion_opgi			= @retencion_opgi + @retencion

		fetch next from c_fac into @opgi_id, @fc_id, @alicuota, @pago, @total, @neto,
                               @percepciones, @item_neto, @item_total, @opgi_importe, @desc1, @desc2
	end

	close c_fac
	deallocate c_fac

	insert into #t_Facturas (opgi_id, fc_id, base, alicuota, retencion)
									values  (@last_opgi_id, @last_fc_id, @base, @last_alicuota/100, @retencion)

	--// la ultima retencion
	--
	if    (abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2)) > 0.10)
		 or (abs(round(@last_opgi_importe,2) - round(@base_opgi*@alicuota/100,2)) > 0.10) begin

		--//////////////////////////////////////////////////////////////////////////////////////////

			set @descrip = ''

			declare c_facturas insensitive cursor for select fc.fc_numero, t.base from #t_Facturas t inner join FacturaCompra fc on t.fc_id = fc.fc_id

			open c_facturas

			fetch next from c_facturas into @fc_numero, @fc_base
			while @@fetch_status=0
			begin

				set @descrip = @descrip + 'FV:'
																+ convert(varchar,@fc_numero) + ' - '
																+ convert(varchar,@fc_base) + ','

				fetch next from c_facturas into @fc_numero, @fc_base
			end
			close c_facturas
			deallocate c_facturas

		--//////////////////////////////////////////////////////////////////////////////////////////

		-- Se pudrio todo, yo no se como resolver esto asi que se lo dejo al usuario
		--
		set @error_msg =
								'@@ERROR_SP:2)El sistema fallo al calcular las bases de las '
							 +'retenciones para esta orden de pago.'+char(13)+char(13)
							 +'Esto puede deberse a que la orden de pago esta hecha sobre '
							 +'varios parciales.'+char(13)+char(13)
							 +'Comuniquese con CrowSoft para obtener una solucion a este problema.'
							 +char(13)+char(13)
							 +'dif: ' + convert(varchar,convert(decimal(18,2),abs(round(@last_opgi_importe,2) - round(@retencion_opgi,2))))
							 +char(13)+char(13)
							 +'dif: ' + convert(varchar,convert(decimal(18,2),abs(round(@last_opgi_importe,2) - round(@base_opgi*@alicuota/100,2))))
							 +char(13)+char(13)
							 +'base: ' + convert(varchar,convert(decimal(18,2),@base_opgi))
							 +char(13)+char(13)
							 + 'Base de facturas ' + @descrip
							 /*+'(sepa disculpar la ignorancia de nuestros programadores :)'*/

--
--	select pr.pr_id,fc.fc_id, pr_nombrecompra, sum(fci_neto)
--
--	from OrdenPagoItem opgi inner join OrdenPago opg 				on opgi.opg_id 	= opg.opg_id
--													inner join #t_frRetencionIVA t on opgi.opgi_id = t.opgi_id
--													inner join Retencion ret 				on opgi.ret_id 	= ret.ret_id
--
--													inner join #t_FacturaCompraOrdenPago fcopg on opg.opg_id = fcopg.opg_id
--
--													inner join FacturaCompra fc 			on fcopg.fc_id = fc.fc_id
--													inner join FacturaCompraItem fci  on fc.fc_id    = fci.fc_id
--													inner join Producto pr            on fci.pr_id   = pr.pr_id
--																														and not (
--																																				 (		 isnull(ret.ibc_id,0) = isnull(pr.ibc_id,0)
--																																						or ret.ibc_id is null
--																																					)
--																																			and isnull(pr.ibc_id,0)<> 1 -- Exento
--																																		)
--	where opg.opg_id = @@opg_id
--
--	group by
--				 pr.pr_id,fc.fc_id, pr_nombrecompra
--

		raiserror (@error_msg, 16, 1) -- :) sefini
		return

	end

	--///////////////////////////////////////////////////////////////////////////
	--
	--
	--///////////////////////////////////////////////////////////////////////////


	select 	1                as orden_id,
					@emp_razonsocial as [Razon Social],
					@emp_cuit				 as CUIT,
					@ret_nrodoc			 as ret_nrodoc,
					opg_fecha,
					opgi_nroRetencion,
					prov_razonsocial,
					prov_cuit,
					prov_calle + ' ' + prov_callenumero + ' ' + prov_localidad + '('+ prov_codpostal +')' as direccion,
					pro_nombre,

					/* Facturas */

					fc_nrodoc,
					fc_fecha,

					tfc.base					as Base,

					case fc.doct_id
						when 2		then 'FC'
						when 8		then 'NC'
						when 10		then 'ND'
					end		as [Tipo Comp.],

					tfc.retencion 		as Retencion,
					tfc.alicuota			as alicuota,
					opg_descrip

	from OrdenPagoItem opgi inner join OrdenPago opg 				on opgi.opg_id 	= opg.opg_id
													inner join Proveedor prov 			on opg.prov_id 	= prov.prov_id
													inner  join #t_Facturas tfc      on opgi.opgi_id = tfc.opgi_id
													left  join FacturaCompra fc 		on tfc.fc_id 		= fc.fc_id
													left  join Provincia pro    on prov.pro_id = pro.pro_id


	where opg.opg_id = @@opg_id

end
