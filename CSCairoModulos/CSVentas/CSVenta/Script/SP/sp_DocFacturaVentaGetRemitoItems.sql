if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetRemitoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetRemitoItems]

go

/*
select * from remitoventa where rv_pendiente >0
exec sp_DocFacturaVentaGetRemitoItems '5528,5529,5530,5531,5532,5533'

*/

create procedure sp_DocFacturaVentaGetRemitoItems (
	@@strIds 					  varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 
				rvi_id,
				rv.rv_id,
				rv_numero,
        rv_nrodoc,
        pr_nombreventa,
        rvi.pr_id,

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
											((rvi_neto / rvi_cantidad) * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100)) + --'Inscripto'
											(((rvi_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rvi_cantidad) -- Internos

					-- No inscripto
					--
					when cli_catfiscal = 3 
						or cli_catfiscal = 10 then 
											((rvi_neto / rvi_cantidad) * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100)) + 
											((rvi_neto/rvi_cantidad*isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)/100)) +
											(((rvi_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rvi_cantidad) -- Internos

					-- Exentos
					else        (rvi_neto / rvi_cantidad) +
											(((rvi_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rvi_cantidad) -- Internos

				end rvi_precio,

				rvi_cantidadaremitir,
        rvi_pendientefac,

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
											rvi_pendientefac * ((rvi_neto / rvi_cantidad) * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100)) + --'Inscripto'
											rvi_pendientefac * (((rvi_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rvi_cantidad) -- Internos

					-- No inscripto
					--
					when cli_catfiscal = 3 
						or cli_catfiscal = 10 then 
											rvi_pendientefac * ((rvi_neto / rvi_cantidad) * (1+isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)/100)) + 
											rvi_pendientefac * (rvi_neto/rvi_cantidad*isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)/100) +
											rvi_pendientefac * (((rvi_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rvi_cantidad) -- Internos
					-- Exentos
					else        rvi_pendientefac * (rvi_neto / rvi_cantidad) +
											rvi_pendientefac * (((rvi_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rvi_cantidad) -- Internos

				end rvi_importe,

        rvi_descrip,
        rvi_precio2 = rvi_precio,
        rvi_precioLista,
				rvi_precioUsr,
				rvi_descuento,
        rvi.ccos_id,

				case cli_catfiscal
					when 1  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Inscripto'
					when 2  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    -- FALTA VERIFICAR QUE SEA ASI --'Exento'
					when 3  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'No inscripto'
					when 4  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Consumidor Final'
					when 6  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Mono Tributo'
					when 7  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'Extranjero Iva'
					when 8  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'No responsable'
					when 9  then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    -- FALTA VERIFICAR QUE SEA ASI --'No Responsable exento'
					when 10 then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'No categorizado'
					when 11 then isnull(tiri.ti_porcentaje,tiri2.ti_porcentaje)    --'InscriptoM'
					else         0           
				end rvi_ivariporc,

				case cli_catfiscal
					when 3  then isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)     --'No inscripto'
					when 10 then isnull(tirni.ti_porcentaje,tirni2.ti_porcentaje)     --'No categorizado'
					else         0           						 
				end rvi_ivarniporc,

				tiint.ti_porcentaje as fvi_internosporc,
				pr_porcinternov

  from RemitoVenta rv inner join RemitoVentaItem rvi 	on rvi.rv_id = rv.rv_id
											inner join TmpStringToTable			on rv.rv_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                      inner join Producto p           on rvi.pr_id = p.pr_id
											inner join Cliente cli          on rv.cli_id = cli.cli_id

											left  join TasaImpositiva tiri  on p.ti_id_ivariventa  = tiri.ti_id
											left  join TasaImpositiva tirni on p.ti_id_ivarniventa = tirni.ti_id

											left  join TasaImpositiva tiri2  on p.ti_id_ivaricompra  = tiri2.ti_id
											left  join TasaImpositiva tirni2 on p.ti_id_ivarnicompra = tirni2.ti_id
											left  join TasaImpositiva tiint  on p.ti_id_internosv 	 = tiint.ti_id
	where 
          rvi_pendientefac > 0
		and   tmpstr2tbl_id =  @timeCode

	order by 

				rv_nrodoc,
				rv_fecha
end
go