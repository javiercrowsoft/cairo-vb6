if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaGetPresupuestoItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaGetPresupuestoItems]

go

/*

select * from pedidoventaitem where prv_id = 8
exec sp_DocPedidoVentaGetPresupuestoItems '1,2,3,4,5,6'

*/

create procedure sp_DocPedidoVentaGetPresupuestoItems (
  @@strIds             varchar(5000)
)
as

begin

  set nocount on

  declare @timeCode datetime
  set @timeCode = getdate()
  exec sp_strStringToTable @timeCode, @@strIds, ','

  select 
        prvi_id,
        prv.prv_id,
        prv_numero,
        prv_nrodoc,
        pr_nombreventa,
        pr_llevanroserie,
        pr_llevanrolote,
        pr_eskit,
        prvi.pr_id,

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
                      ((prvi_neto / prvi_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'

          -- No inscripto
          --
          when cli_catfiscal = 3 
            or cli_catfiscal = 10 then 
                      ((prvi_neto / prvi_cantidad) * (1+tiri.ti_porcentaje/100)) + 
                      ((prvi_neto / prvi_cantidad) * (1+tirni.ti_porcentaje/100))

          -- Exentos
          else        (prvi_neto / prvi_cantidad)

        end prvi_precio,

        prvi_cantidadaremitir,
        prvi_pendiente,

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
                      prvi_pendiente * ((prvi_neto / prvi_cantidad) * (1+tiri.ti_porcentaje/100))    --'Inscripto'

          -- No inscripto
          --
          when cli_catfiscal = 3 
            or cli_catfiscal = 10 then 
                      prvi_pendiente * ((prvi_neto / prvi_cantidad) * (1+tiri.ti_porcentaje/100)) + 
                      prvi_pendiente * ((prvi_neto / prvi_cantidad) * (1+tirni.ti_porcentaje/100))

          -- Exentos
          else        prvi_pendiente * (prvi_neto / prvi_cantidad)

        end prvi_importe,

        prvi_descrip,
        prvi_precio2 = prvi_precio,
        prvi_precioLista,
        prvi_precioUsr,
        prvi_descuento,
        prvi.ccos_id,

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
        end prvi_ivariporc,

        case cli_catfiscal
          when 3  then tirni.ti_porcentaje     --'No inscripto'
          when 10 then tirni.ti_porcentaje     --'No categorizado'
          else         0                        
        end prvi_ivarniporc

  from PresupuestoVenta prv 
                      inner join PresupuestoVentaItem prvi   on prvi.prv_id = prv.prv_id
                      inner join TmpStringToTable            on prv.prv_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
                      inner join Producto p                 on prvi.pr_id = p.pr_id
                      inner join Cliente cli                on prv.cli_id = cli.cli_id
                      inner join TasaImpositiva tiri        on p.ti_id_ivariventa  = tiri.ti_id
                      left  join TasaImpositiva tirni       on p.ti_id_ivarniventa = tirni.ti_id
  where 
          prvi_pendiente > 0
    and   tmpstr2tbl_id =  @timeCode

  order by 

        prv_nrodoc,
        prv_fecha

end
go