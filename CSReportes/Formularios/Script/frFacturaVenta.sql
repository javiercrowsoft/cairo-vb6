/*

select * from facturaventa
frFacturaVenta 4

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frFacturaVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frFacturaVenta]

go
create procedure frFacturaVenta (

  @@fv_id      int

)as 

begin

-------------------------------------------------------------------------------------------------------------
--
--  REMITOS
--
-------------------------------------------------------------------------------------------------------------

  declare c_remitos insensitive cursor for 
                  select distinct rv_nrodoc 
                  from RemitoVenta rv inner join RemitoVentaItem rvi 
                                              on rv.rv_id = rvi.rv_id
                                      inner join RemitoFacturaVenta rvfv
                                              on rvi.rvi_id = rvfv.rvi_id
                                      inner join FacturaVentaItem fvi
                                              on rvfv.fvi_id = fvi.fvi_id
                                             and fvi.fv_id = @@fv_id

  open c_remitos

  declare @remitos varchar(5000)
  declare @remito  varchar(5000)

  set @remitos = ''

  fetch next from c_remitos into @remito  
  while @@fetch_status=0
  begin

    set @remitos = @remitos + @remito +','

    fetch next from c_remitos into @remito    
  end

  close c_remitos
  deallocate c_remitos

  if len(@remitos)>1 set @remitos=  substring(@remitos,1,len(@remitos)-1)

-------------------------------------------------------------------------------------------------------------
--
--  CALCULOS PARA DESCUENTOS
--
-------------------------------------------------------------------------------------------------------------

  declare @iva_renglones        decimal(18,6)
  declare @internos_renglones   decimal(18,6)
  declare @iva_descuentos       decimal(18,6)
  declare @internos_descuentos  decimal(18,6)
  declare @descuentos           decimal(18,6)

  select   @iva_renglones        = sum(fvi_ivari+fvi_ivarni),
          @internos_renglones   = sum(fvi_internos)
  from FacturaVentaItem where fv_id = @@fv_id

  select @iva_descuentos         = -(@iva_renglones-fv_ivari-fv_ivarni),
         @internos_descuentos    = -(@internos_renglones-fv_internos),
         @descuentos             = -(fv_importedesc1 + fv_importedesc2)
  from FacturaVenta where fv_id = @@fv_id

-------------------------------------------------------------------------------------------------------------
--
--  SELECT DE LA FACTURA
--
-------------------------------------------------------------------------------------------------------------

  select  FacturaVenta.*, 
          
          fvi_orden,
          fvi_cantidad, 
          fvi_importe,
          fvi_importeorigen,
          fvi_ivari,
          fvi_ivarni,
          fvi_internos,

          cue_nombre, 
          doc_nombre, 
          ccos_nombre, 
          cli_nombre,
          cli_razonsocial,
          cli_tel,
          cpg_nombre,
          cli_cuit,
          pro_nombre,
          mon_nombre,
          mon_signo,
          mon_codigodgi2,
          ley_texto,

      case cli_catfiscal
        when 1 then 'Inscripto'
        when 2 then 'Exento'
        when 3 then 'No inscripto'
        when 4 then 'Consumidor Final'
        when 5 then 'Extranjero'
        when 6 then 'Mono Tributo'
        when 7 then 'Extranjero Iva'
        when 8 then 'No responsable'
        when 9 then 'No Responsable exento'
        when 10 then 'No categorizado'
        when 11 then 'Inscripto M'
        else 'Sin categorizar'
      end as cat_fiscal,

      case cli_catfiscal
        when 1 then 'X'
        else ''
      end as inscripto,

      case cli_catfiscal
        when 2 then 'X'
        else ''
      end as exento,

      case cli_catfiscal
        when 3 then 'X'
        else ''
      end as noinscripto,

      case cli_catfiscal
        when 4 then 'X'
        else ''
      end as consumidorfinal,

      case cli_catfiscal
        when 5 then 'X'
        else ''
      end as extranjero,

      case cli_catfiscal
        when 6 then 'X'
        else ''
      end as monotributo,

      case cli_catfiscal
        when 7 then 'X'
        else ''
      end as extranjeroiva,

      case cli_catfiscal
        when 8 then 'X'
        else ''
      end as noresponsable,

      case cli_catfiscal
        when 9 then 'X'
        else ''
      end as norespexento,

      case cli_catfiscal
        when 10 then 'X'
        else ''
      end as nocategorizado,

      case 
        when fvi_importe <> 0 and fvi_importeorigen <> 0 then  fvi_importeorigen / fvi_importe
        else  1
      end as coef,

      cli_calle + ' ' +
      cli_callenumero + ' ' +
      cli_piso + ' ' +
      cli_depto        as calle,

      cli_calle + ' ' +
      cli_callenumero + ' ' +
      cli_piso + ' ' +
      cli_depto        as direccion,

      cli_localidad + ' - ' +
      cli_codpostal   as cli_localidad,

      lgj_codigo,
      pr_codigo,
      pr_nombreventa,

      case cli_catfiscal
        when 1 then       fvi_precio                                     -- 'Inscripto'
        when 2 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Exento'
        when 3 then       fvi_precio                                     -- 'No inscripto'
        when 4 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Consumidor Final' 
        when 5 then       fvi_precio                                     -- 'Extranjero'
        when 6 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Mono Tributo'
        when 7 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Extranjero Iva'
        when 8 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'No responsable'
        when 9 then       fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'No Responsable exento'
        when 10 then      fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'No categorizado'
        when 11 then      fvi_precio                                     -- 'Inscripto M'
        else              fvi_precio + (fvi_precio * fvi_ivariporc/100) -- 'Sin categorizar'
      end as precio,

      case cli_catfiscal
        when 1 then       fvi_neto     -- 'Inscripto'
        when 2 then       fvi_importe  -- 'Exento'
        when 3 then       fvi_neto     -- 'No inscripto'
        when 4 then       fvi_importe  -- 'Consumidor Final'
        when 5 then       fvi_neto     -- 'Extranjero'
        when 6 then       fvi_importe  -- 'Mono Tributo'
        when 7 then       fvi_importe  -- 'Extranjero Iva'
        when 8 then       fvi_importe  -- 'No responsable'
        when 9 then       fvi_importe  -- 'No Responsable exento'
        when 10 then      fvi_importe  -- 'No categorizado'
        when 11 then      fvi_neto     -- 'Inscripto M'
        else              fvi_importe  -- 'Sin categorizar'
      end as importe,

      case cli_catfiscal
        when 1 then       1 -- 'Inscripto'
        when 2 then       0 -- 'Exento'
        when 3 then       1 -- 'No inscripto'
        when 4 then       0 -- 'Consumidor Final'
        when 5 then       0 -- 'Extranjero'
        when 6 then       0 -- 'Mono Tributo'
        when 7 then       1 -- 'Extranjero Iva'
        when 8 then       0 -- 'No responsable'
        when 9 then       0 -- 'No Responsable exento'
        when 10 then      0 -- 'No categorizado'
        when 11 then      1 -- 'Inscripto M'
        else              0 -- 'Sin categorizar'
      end as bShowIva,

      @remitos   as remitos,
      fvi_descrip

  from FacturaVenta inner join FacturaVentaItem on FacturaVenta.fv_id = FacturaVentaItem.fv_id
               inner join Cuenta        on FacturaVentaItem.cue_id    = Cuenta.cue_id
               inner join Documento     on FacturaVenta.doc_id        = Documento.doc_id
               inner join Cliente       on FacturaVenta.cli_id        = Cliente.cli_id
               inner join CondicionPago on FacturaVenta.cpg_id        = CondicionPago.cpg_id
               inner join Producto      on FacturaVentaItem.pr_id     = Producto.pr_id
               inner join Moneda        on FacturaVenta.mon_id        = Moneda.mon_id
               left join  Legajo        on FacturaVenta.lgj_id        = Legajo.lgj_id
               left join  CentroCosto   on FacturaVentaItem.ccos_id   = CentroCosto.ccos_id
               left join  Provincia     on FacturaVenta.pro_id_origen = Provincia.pro_id
               left join leyenda         on ley_codigo = 'fv_001'

  where FacturaVenta.fv_id = @@fv_id

UNION ALL
-------------------------------------------------------------------------------------------------------------
--
--  RENGLONES DE DESCUENTO
--
-------------------------------------------------------------------------------------------------------------

  select 

          FacturaVenta.*, 

          1000000     as fvi_orden,
          1           as fvi_cantidad, 

          @descuentos
         +@iva_descuentos 
         +@internos_descuentos  as fvi_importe,

          case 
              when fv_total <> 0 and fv_totalorigen <> 0 
              then  (@descuentos+@iva_descuentos+@internos_descuentos) 
                  * (fv_totalorigen / fv_total)
              else  0
          end as fvi_importeorigen,

          @iva_descuentos       as fvi_ivari,
          0                     as fvi_ivarni,
          @internos_descuentos   as fvi_interno,

          '' as cue_nombre,
          doc_nombre,
          '' as ccos_nombre,

          cli_nombre,
          cli_razonsocial,
          cli_tel,
          cpg_nombre,
          cli_cuit,
          pro_nombre,
          mon_nombre,
          mon_signo,
          mon_codigodgi2,
          ley_texto,
    
      case cli_catfiscal
        when 1 then 'Responsable Inscripto'
        when 2 then 'Exento'
        when 3 then 'No inscripto'
        when 4 then 'Consumidor Final'
        when 5 then 'Exento Operación de Exportación'
        when 6 then 'Mono Tributo'
        when 7 then 'Extranjero Iva'
        when 8 then 'No responsable'
        when 9 then 'No Responsable exento'
        when 10 then 'No categorizado'
        when 11 then 'Inscripto M'
        else 'Sin categorizar'
      end as cat_fisctal,

      case cli_catfiscal
        when 1 then  'X'
        when 11 then 'X'
        else ''
      end as inscripto,

      case cli_catfiscal
        when 2 then 'X'
        else ''
      end as exento,

      case cli_catfiscal
        when 3 then 'X'
        else ''
      end as noinscripto,

      case cli_catfiscal
        when 4 then 'X'
        else ''
      end as consumidorfinal,

      case cli_catfiscal
        when 5 then 'X'
        else ''
      end as extranjero,

      case cli_catfiscal
        when 6 then 'X'
        else ''
      end as monotributo,

      case cli_catfiscal
        when 7 then 'X'
        else ''
      end as extranjeroiva,

      case cli_catfiscal
        when 8 then 'X'
        else ''
      end as noresponsable,

      case cli_catfiscal
        when 9 then 'X'
        else ''
      end as norespexento,

      case cli_catfiscal
        when 10 then 'X'
        else ''
      end as nocategorizado,

      case 
          when fv_total <> 0 and fv_totalorigen <> 0 
          then  fv_totalorigen / fv_total
          else  1
      end as coef,

      cli_calle + ' ' +
      cli_callenumero + ' ' +
      cli_piso + ' ' +
      cli_depto        as calle,

      cli_calle + ' ' +
      cli_callenumero + ' ' +
      cli_piso + ' ' +
      cli_depto        as direccion,

      cli_localidad + ' - ' +
      cli_codpostal   as cli_localidad,

      lgj_codigo,

      ''    as pr_codigo,

      case
        when fv_importedesc1 <> 0 and fv_importedesc2 <> 0 
        then ' Descuento (' + convert(varchar,convert (decimal(18,2),fv_descuento1))
             + '% + ' 
             + convert(varchar,convert (decimal(18,2),fv_descuento2))+'%)'

        when fv_importedesc1 <> 0                           
        then ' Descuento (' + convert(varchar,convert (decimal(18,2),fv_descuento1))+'%)'

      end  as pr_nombreventa,

      case cli_catfiscal
        when 1 then       @descuentos                                           -- 'Inscripto'
        when 2 then       @descuentos + @iva_descuentos + @internos_descuentos   -- 'Exento'
        when 3 then       @descuentos                                           -- 'No inscripto'
        when 4 then       @descuentos + @iva_descuentos + @internos_descuentos  -- 'Consumidor Final'
        when 5 then       @descuentos                                           -- 'Extranjero'
        when 6 then       @descuentos + @iva_descuentos + @internos_descuentos  -- 'Mono Tributo'
        when 7 then       @descuentos + @iva_descuentos + @internos_descuentos  -- 'Extranjero Iva'
        when 8 then       @descuentos + @iva_descuentos + @internos_descuentos  -- 'No responsable'
        when 9 then       @descuentos + @iva_descuentos + @internos_descuentos  -- 'No Responsable exento'
        when 10 then      @descuentos + @iva_descuentos + @internos_descuentos  -- 'No categorizado'
        when 11 then      @descuentos                                           -- 'Inscripto M'
        else              @descuentos + @iva_descuentos + @internos_descuentos  -- 'Sin categorizar'
      end as precio,

      case cli_catfiscal
        when 1 then       @descuentos                                           -- 'Inscripto'
        when 2 then       @descuentos + @iva_descuentos + @internos_descuentos -- 'Exento'
        when 3 then       @descuentos                                           -- 'No inscripto'
        when 4 then       @descuentos + @iva_descuentos + @internos_descuentos -- 'Consumidor Final'
        when 5 then       @descuentos                                           -- 'Extranjero'
        when 6 then       @descuentos + @iva_descuentos + @internos_descuentos -- 'Mono Tributo'
        when 7 then       @descuentos + @iva_descuentos + @internos_descuentos -- 'Extranjero Iva'
        when 8 then       @descuentos + @iva_descuentos + @internos_descuentos -- 'No responsable'
        when 9 then       @descuentos + @iva_descuentos + @internos_descuentos -- 'No Responsable exento'
        when 10 then      @descuentos + @iva_descuentos + @internos_descuentos -- 'No categorizado'
        when 11 then      @descuentos                                           -- 'Inscripto M'
        else              @descuentos + @iva_descuentos + @internos_descuentos -- 'Sin categorizar'
      end as importe,

      case cli_catfiscal
        when 1 then       1 -- 'Inscripto'
        when 2 then       0 -- 'Exento'
        when 3 then       1 -- 'No inscripto'
        when 4 then       0 -- 'Consumidor Final'
        when 5 then       0 -- 'Extranjero'
        when 6 then       0 -- 'Mono Tributo'
        when 7 then       1 -- 'Extranjero Iva'
        when 8 then       0 -- 'No responsable'
        when 9 then       0 -- 'No Responsable exento'
        when 10 then      0 -- 'No categorizado'
        when 11 then      1 -- 'Inscripto M'
        else              0 -- 'Sin categorizar'
      end as bShowIva,

      @remitos   as remitos,
      '' as fvi_descrip

  from FacturaVenta 
               
               inner join Documento     on FacturaVenta.doc_id        = Documento.doc_id
               inner join Cliente       on FacturaVenta.cli_id        = Cliente.cli_id
               inner join CondicionPago on FacturaVenta.cpg_id        = CondicionPago.cpg_id
               inner join Moneda        on FacturaVenta.mon_id        = Moneda.mon_id
               left join  Legajo        on FacturaVenta.lgj_id        = Legajo.lgj_id
               left join  Provincia     on FacturaVenta.pro_id_origen = Provincia.pro_id                              
               left join leyenda         on ley_codigo = 'fv_001'

  where FacturaVenta.fv_id = @@fv_id and fv_importedesc1 <> 0

  order by fvi_orden
end
go