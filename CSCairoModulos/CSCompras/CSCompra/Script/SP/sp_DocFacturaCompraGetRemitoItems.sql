if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetRemitoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetRemitoItems]

go

/*

select * from RemitoCompraitem where rc_id = 8
exec sp_DocFacturaCompraGetRemitoItems '1,2,3,4,5,6'

*/

create procedure sp_DocFacturaCompraGetRemitoItems (
	@@strIds 					  varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 
				rci_id,
				rc.rc_id,
				rc_numero,
        rc_nrodoc,
        pr_nombreCompra,
				pr_llevanroserie,
        rci.pr_id,

				case 
					when prov_catfiscal = 1  or
							 prov_catfiscal = 2  or
							 prov_catfiscal = 4  or
							 prov_catfiscal = 7  or
							 prov_catfiscal = 8  or
							 prov_catfiscal = 9  or
							 prov_catfiscal = 10 or
							 prov_catfiscal = 11 then 
											((rci_neto / rci_cantidad) * (1+tiri.ti_porcentaje/100)) + --'Inscripto'
											(((rci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rci_cantidad) -- Internos

					-- No inscripto
					--
					when prov_catfiscal = 3 
						or prov_catfiscal = 10 then 
											((rci_neto / rci_cantidad) * (1+tiri.ti_porcentaje/100)) + 
											((rci_neto*tirni.ti_porcentaje/100)/rci_cantidad) + -- RNI
											(((rci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rci_cantidad) -- Internos
					-- Exentos
					else        (rci_neto / rci_cantidad) +
											(((rci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rci_cantidad) -- Internos

				end rci_precio,

				rci_cantidadaremitir,
        rci_pendientefac,

				case 
					when prov_catfiscal = 1  or
							 prov_catfiscal = 2  or
							 prov_catfiscal = 4  or
							 prov_catfiscal = 7  or
							 prov_catfiscal = 8  or
							 prov_catfiscal = 9  or
							 prov_catfiscal = 10 or
							 prov_catfiscal = 11 then 
											rci_pendientefac * ((rci_neto / rci_cantidad) * (1+tiri.ti_porcentaje/100)) + --'Inscripto'
											rci_pendientefac * (((rci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rci_cantidad) -- Internos
					-- No inscripto
					--
					when prov_catfiscal = 3 then 
											rci_pendientefac * ((rci_neto / rci_cantidad) * (1+tiri.ti_porcentaje/100)) + 
											rci_pendientefac * ((rci_neto*tirni.ti_porcentaje/100)/rci_cantidad) + -- RNI
											rci_pendientefac * (((rci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rci_cantidad) -- Internos
					-- Exentos
					else        rci_pendientefac * (rci_neto / rci_cantidad) +
											rci_pendientefac * (((rci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/rci_cantidad) -- Internos
				end rci_importe,

        rci_descrip,
        rci_precio2 = rci_precio,
        rci_precioLista,
				rci_precioUsr,
				rci_descuento,
        rci.ccos_id,

				case prov_catfiscal
					when 1  then tiri.ti_porcentaje    --'Inscripto'
					when 2  then tiri.ti_porcentaje    -- FALTA VERIFICAR QUE SEA ASI --'Exento'
					when 4  then tiri.ti_porcentaje    --'Consumidor Final'
					when 7  then tiri.ti_porcentaje    --'Extranjero Iva'
					when 8  then tiri.ti_porcentaje    --'No responsable'
					when 9  then tiri.ti_porcentaje    -- FALTA VERIFICAR QUE SEA ASI --'No Responsable exento'
					when 10 then tiri.ti_porcentaje    --'No categorizado'
					when 11 then tiri.ti_porcentaje    --'InscriptoM'
					else         0           
				end rci_ivariporc,

				case prov_catfiscal
					when 3 then tirni.ti_porcentaje     --'No categorizado'
					else         0           						 
				end rci_ivarniporc,

				tiint.ti_porcentaje as fci_internosporc,
				pr_porcinternoc

  from RemitoCompra rc inner join RemitoCompraItem rci 	on rci.rc_id  = rc.rc_id
											 inner join TmpStringToTable			on rc.rc_id   = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                       inner join Producto p            on rci.pr_id  = p.pr_id
											 inner join Proveedor prov        on rc.prov_id = prov.prov_id
											 inner join TasaImpositiva tiri   on p.ti_id_ivaricompra  = tiri.ti_id
											 left  join TasaImpositiva tirni  on p.ti_id_ivarnicompra = tirni.ti_id
											 left  join TasaImpositiva tiint  on p.ti_id_internosc = tiint.ti_id
	where 
          rci_pendientefac > 0
		and   tmpstr2tbl_id =  @timeCode

	order by 

				rc_nrodoc,
				rc_fecha
end
go