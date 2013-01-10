if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetOrdenItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetOrdenItems]

go

/*

select * from OrdenCompraitem where oc_id = 8
exec sp_DocFacturaCompraGetOrdenItems '1,2,3,4,5,6'

*/

create procedure sp_DocFacturaCompraGetOrdenItems (
  @@strIds             varchar(5000)
)
as

begin

  declare @timeCode datetime
  set @timeCode = getdate()
  exec sp_strStringToTable @timeCode, @@strIds, ','

  select 
        oci_id,
        oc.oc_id,
        oc_numero,
        oc_nrodoc,
        pr_nombreCompra,
        pr_llevanroserie,
        pr_llevanrolote,
        oci.pr_id,

        case 
          when prov_catfiscal = 1  or
               prov_catfiscal = 2  or
               prov_catfiscal = 4  or
               prov_catfiscal = 7  or
               prov_catfiscal = 8  or
               prov_catfiscal = 9  or
               prov_catfiscal = 10 or
               prov_catfiscal = 11 then 
                      ((oci_neto / oci_cantidad) * (1+tiri.ti_porcentaje/100)) + --'Inscripto'
                      (((oci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/oci_cantidad) -- Internos

          -- No inscripto
          --
          when prov_catfiscal = 3 
            or prov_catfiscal = 10 then 
                      ((oci_neto / oci_cantidad) * (1+tiri.ti_porcentaje/100)) + 
                      (oci_neto/oci_cantidad*tirni.ti_porcentaje/100) + -- RNI
                      (((oci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/oci_cantidad) -- Internos

          -- Exentos
          else        (oci_neto / oci_cantidad) +
                      (((oci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/oci_cantidad) -- Internos

        end oci_precio,

        oci_cantidadaremitir,
        oci_pendientefac,

        case 
          when prov_catfiscal = 1  or
               prov_catfiscal = 2  or
               prov_catfiscal = 4  or
               prov_catfiscal = 7  or
               prov_catfiscal = 8  or
               prov_catfiscal = 9  or
               prov_catfiscal = 10 or
               prov_catfiscal = 11 then 
                      oci_pendientefac * ((oci_neto / oci_cantidad) * (1+tiri.ti_porcentaje/100)) + --'Inscripto'
                      oci_pendientefac * (((oci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/oci_cantidad) -- Internos

          -- No inscripto
          --
          when prov_catfiscal = 3 then 
                      oci_pendientefac * ((oci_neto / oci_cantidad) * (1+tiri.ti_porcentaje/100)) + 
                      oci_pendientefac * (oci_neto/oci_cantidad*tirni.ti_porcentaje/100) + -- RNI
                      oci_pendientefac * (((oci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/oci_cantidad) -- Internos

          -- Exentos
          else        oci_pendientefac * (oci_neto / oci_cantidad) +
                      oci_pendientefac * (((oci_neto*pr_porcinternoc/100)*isnull(tiint.ti_porcentaje,0)/100)/oci_cantidad) -- Internos

        end oci_importe,

        oci_descrip,
        oci_precio2 = oci_precio,
        oci_precioLista,
        oci_precioUsr,
        oci_descuento,
        oci.ccos_id,

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
        end oci_ivariporc,

        case prov_catfiscal
          when 3 then tirni.ti_porcentaje     --'No categorizado'
          else         0                        
        end oci_ivarniporc,

        tiint.ti_porcentaje as fci_internosporc,
        pr_porcinternoc

  from OrdenCompra oc inner join OrdenCompraItem oci   on oci.oc_id  = oc.oc_id
                       inner join TmpStringToTable      on oc.oc_id   = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                       inner join Producto p            on oci.pr_id  = p.pr_id
                       inner join Proveedor prov        on oc.prov_id = prov.prov_id
                       inner join TasaImpositiva tiri   on p.ti_id_ivaricompra  = tiri.ti_id
                       left  join TasaImpositiva tirni  on p.ti_id_ivarnicompra = tirni.ti_id
                       left  join TasaImpositiva tiint  on p.ti_id_internosc = tiint.ti_id
  where 
          oci_pendientefac > 0
    and   tmpstr2tbl_id =  @timeCode

  order by 

        oc_nrodoc,
        oc_fecha
end
go