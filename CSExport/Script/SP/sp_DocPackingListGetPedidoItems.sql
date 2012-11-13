if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListGetPedidoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListGetPedidoItems]

go

/*

select * from pedidoventaitem where pv_id = 8
exec sp_DocPackingListGetPedidoItems '1,2,3,4,5,6'

*/

create procedure sp_DocPackingListGetPedidoItems (
	@@strIds 					  varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 
				pvi_id,
				pv.pv_id,
				pv_numero,
        pv_nrodoc,
        pr_nombreventa,
				pr_pesoneto,
        pr_pesototal,
        un_nombre,
        pvi.pr_id,
				pvi_precio = (pvi_importe / pvi_cantidad),
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
                      left  join Unidad               on p.un_id_peso = unidad.un_id
	where 
          pvi_pendiente > 0
		and   tmpstr2tbl_id =  @timeCode

	order by 

				pv_nrodoc,
				pv_fecha
end
go