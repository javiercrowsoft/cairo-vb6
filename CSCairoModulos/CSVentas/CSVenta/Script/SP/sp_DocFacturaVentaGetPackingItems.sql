if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetPackingItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetPackingItems]

go

/*

exec sp_DocFacturaVentaGetPackingItems '1,2,3,4,5,6'

*/

create procedure sp_DocFacturaVentaGetPackingItems (
	@@strIds 					  varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 
				pklsti_id,
				pklst.pklst_id,
				pklst_numero,
        pklst_nrodoc,
        pr_codigo + '-' + pr_nombreventa as pr_nombreventa,
				pr_llevanroserie,
				pr_llevanrolote,
				pr_lotefifo,
				pr_eskit,
        pklsti.pr_id,

				case 
					when cli_catfiscal = 1  or
							 cli_catfiscal = 2  or
							 cli_catfiscal = 3  or
							 cli_catfiscal = 4  or
							 cli_catfiscal = 6  or
							 cli_catfiscal = 7  or
							 cli_catfiscal = 8  or
							 cli_catfiscal = 9  or
							 cli_catfiscal = 10 or
							 cli_catfiscal = 11 then 
											((pklsti_neto / pklsti_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'

					-- No inscripto
					--
					when cli_catfiscal = 3 
						or cli_catfiscal = 10 then 
											((pklsti_neto / pklsti_cantidad) * (1+tiri.ti_porcentaje/100)) + 
											((pklsti_neto / pklsti_cantidad) * (1+tirni.ti_porcentaje/100))

					-- Exentos
					else        (pklsti_neto / pklsti_cantidad)

				end pklsti_precio,

				pklsti_cantidad,
        pklsti_pendientefac,

				case 
					when cli_catfiscal = 1  or
							 cli_catfiscal = 2  or
							 cli_catfiscal = 3  or
							 cli_catfiscal = 4  or
							 cli_catfiscal = 6  or
							 cli_catfiscal = 7  or
							 cli_catfiscal = 8  or
							 cli_catfiscal = 9  or
							 cli_catfiscal = 10 or
							 cli_catfiscal = 11 then 
											pklsti_pendientefac * ((pklsti_neto / pklsti_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'

					-- No inscripto
					--
					when cli_catfiscal = 3 
						or cli_catfiscal = 10 then 
											pklsti_pendientefac * ((pklsti_neto / pklsti_cantidad) * (1+tiri.ti_porcentaje/100)) + 
											pklsti_pendientefac * ((pklsti_neto / pklsti_cantidad) * (1+tirni.ti_porcentaje/100))

					-- Exentos
					else        pklsti_pendientefac * (pklsti_neto / pklsti_cantidad)

				end pklsti_importe,

        pklsti_descrip,
        pklsti_precio2 = pklsti_precio,
        pklsti_precioLista,
				pklsti_precioUsr,
				pklsti_descuento,
        pklsti.ccos_id,

				case cli_catfiscal
					when 1  then tiri.ti_porcentaje    --'Inscripto'
					when 2  then tiri.ti_porcentaje    -- FALTA VERIFICAR QUE SEA ASI --'Exento'
					when 3  then tiri.ti_porcentaje    --'No inscripto'
					when 4  then tiri.ti_porcentaje    --'Consumidor Final'
					when 6  then tiri.ti_porcentaje    --'Mono Tributo'
					when 7  then tiri.ti_porcentaje    --'Extranjero Iva'
					when 8  then tiri.ti_porcentaje    --'No responsable'
					when 9  then tiri.ti_porcentaje    -- FALTA VERIFICAR QUE SEA ASI --'No Responsable exento'
					when 10 then tiri.ti_porcentaje    --'No categorizado'
					when 11 then tiri.ti_porcentaje    --'InscriptoM'
					else         0           
				end pklsti_ivariporc,

				case cli_catfiscal
					when 3  then tirni.ti_porcentaje     --'No inscripto'
					when 10 then tirni.ti_porcentaje     --'No categorizado'
					else         0           						 
				end pklsti_ivarniporc

  from PackingList pklst  inner join PackingListItem pklsti 	on pklsti.pklst_id = pklst.pklst_id
													inner join TmpStringToTable					on pklst.pklst_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                      		inner join Producto p         		  on pklsti.pr_id = p.pr_id
													inner join Cliente cli          		on pklst.cli_id = cli.cli_id
													inner join TasaImpositiva tiri  		on p.ti_id_ivariventa  = tiri.ti_id
													left  join TasaImpositiva tirni 		on p.ti_id_ivarniventa = tirni.ti_id
	where 
          pklsti_pendientefac > 0
		and   tmpstr2tbl_id =  @timeCode

	order by 

				pklst_nrodoc,
				pklst_fecha

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  Info Kit
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////
	declare @pr_id int

	create table #KitItems			(
																pr_id int not null, 
																nivel int not null
															)

	create table #KitItemsSerie(
																pr_id_kit 			int null,
																cantidad 				decimal(18,6) not null,
																pr_id 					int not null, 
                                prk_id 					int not null,
																nivel       		smallint not null default(0)
															)

	declare c_KitItem insensitive cursor for 
																							select 
																						        pvi.pr_id
																						
																						  from PedidoVenta pv inner join PedidoVentaItem pvi 	on pvi.pv_id = pv.pv_id
																																	inner join TmpStringToTable			on pv.pv_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
																						                      inner join Producto p           on pvi.pr_id = p.pr_id
																							where 
																						          pvi_pendiente > 0
																								and   tmpstr2tbl_id =  @timeCode
                                                and   p.pr_eskit <> 0
																						
																							group by pvi.pr_id
	
	open c_KitItem

	fetch next from c_KitItem into @pr_id
	while @@fetch_status = 0 begin

		exec sp_StockProductoGetKitInfo @pr_id, 0

		update #KitItemsSerie set pr_id_kit = @pr_id where pr_id_kit is null

		fetch next from c_KitItem into @pr_id
	end

	close c_KitItem
	deallocate c_KitItem

	select 
					k.pr_id_kit 		as pr_id,
					k.pr_id 				as pr_id_item, 
					pr_nombrecompra,
					pr_llevanroserie,
					cantidad 
	from 
					#KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id
end
go