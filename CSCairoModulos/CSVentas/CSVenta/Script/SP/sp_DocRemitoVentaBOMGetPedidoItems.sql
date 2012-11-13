if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaBOMGetPedidoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaBOMGetPedidoItems]

go

/*

select * from pedidoventaitem where pv_id = 8
exec sp_DocRemitoVentaBOMGetPedidoItems '1,2,3,4,5,6'

*/

create procedure sp_DocRemitoVentaBOMGetPedidoItems (
	@@strIds 					  varchar(5000)
)
as

begin

  set nocount on

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 
				pvi_id,
				pv.pv_id,
				pv_numero,
        pv_nrodoc,
        pr_nombreventa,
				pr_llevanroserie,
				pr_eskit,

				case pr_seproduce
					when 1 then (select max(pbm_id) from ProductoBOMElaborado where pr_id = pvi.pr_id)
					else null
				end 			as pbm_id,

				case pr_seproduce
					when 1 then (select pbm_nombre from ProductoBOM 
											 where pbm_id in(
																				select max(pbm_id) 
																				from ProductoBOMElaborado 
																				where pr_id = pvi.pr_id
																			)
											)
					else null
				end 			as pbm_nombre,

        pvi.pr_id,

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
											((pvi_neto / pvi_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'

					-- No inscripto
					--
					when cli_catfiscal = 3 
						or cli_catfiscal = 10 then 
											((pvi_neto / pvi_cantidad) * (1+tiri.ti_porcentaje/100)) + 
											((pvi_neto / pvi_cantidad) * (1+tirni.ti_porcentaje/100))

					-- Exentos
					else        (pvi_neto / pvi_cantidad)

				end pvi_precio,

				pvi_cantidadaremitir,
        pvi_pendiente,

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
											pvi_pendiente * ((pvi_neto / pvi_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'

					-- No inscripto
					--
					when cli_catfiscal = 3 
						or cli_catfiscal = 10 then 
											pvi_pendiente * ((pvi_neto / pvi_cantidad) * (1+tiri.ti_porcentaje/100)) + 
											pvi_pendiente * ((pvi_neto / pvi_cantidad) * (1+tirni.ti_porcentaje/100))

					-- Exentos
					else        pvi_pendiente * (pvi_neto / pvi_cantidad)

				end pvi_importe,

        pvi_descrip,
        pvi_precio2 = pvi_precio,
        pvi_precioLista,
				pvi_precioUsr,
				pvi_descuento,
        pvi.ccos_id,

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
				end pvi_ivariporc,

				case cli_catfiscal
					when 3  then tirni.ti_porcentaje     --'No inscripto'
					when 10 then tirni.ti_porcentaje     --'No categorizado'
					else         0           						 
				end pvi_ivarniporc

  from PedidoVenta pv inner join PedidoVentaItem pvi 	on pvi.pv_id = pv.pv_id
											inner join TmpStringToTable			on pv.pv_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                      inner join Producto p           on pvi.pr_id = p.pr_id
											inner join Cliente cli          on pv.cli_id = cli.cli_id
											inner join TasaImpositiva tiri  on p.ti_id_ivariventa  = tiri.ti_id
											left  join TasaImpositiva tirni on p.ti_id_ivarniventa = tirni.ti_id
	where 
          pvi_pendiente > 0
		and   tmpstr2tbl_id =  @timeCode

	order by 

				pv_nrodoc,
				pv_fecha

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