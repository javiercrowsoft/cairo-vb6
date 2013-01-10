
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_FacturaCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_FacturaCompra]

/*
    sp_lsdoc_FacturaCompra 14
    select * from facturaCompra
*/

go
create procedure sp_lsdoc_FacturaCompra (
  @@fc_id int
)as 
begin
select 
      fc_id,
      ''                    as [TypeTask],
      fc_numero             as [Número],
      fc_nrodoc              as [Comprobante],
      prov_nombre           as [Proveedor],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      case fc_tipocomprobante
        when 1 then 'Original'
        when 2 then 'Fax'
        when 3 then 'Fotocopia'
        when 4 then 'Duplicado'
      end                    as [Tipo Comprobante],
      fc_fecha              as [Fecha],
      fc_fechaentrega        as [Fecha de entrega],
      fc_fechaiva            as [Fecha IVA],
      fc_neto                as [Neto],
      fc_ivari              as [IVA RI],
      fc_ivarni              as [IVA RNI],
      fc_totalotros         as [Otros],
      fc_subtotal            as [Subtotal],
      fc_total              as [Total],
      fc_pendiente          as [Pendiente],
      case fc_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      
      fc_descuento1          as [% Desc. 1],
      fc_descuento2          as [% Desc. 2],
      fc_importedesc1        as [Desc. 1],
      fc_importedesc2        as [Desc. 2],

      lp_nombre            as [Lista de Precios],
      ld_nombre            as [Lista de descuentos],
      cpg_nombre          as [Condicion de Pago],
      ccos_nombre          as [Centro de costo],
      suc_nombre          as [Sucursal],
      emp_nombre          as [Empresa],

      FacturaCompra.Creado,
      FacturaCompra.Modificado,
      us_nombre             as [Modifico],
      fc_descrip            as [Observaciones]
from 
      FacturaCompra inner join documento     on FacturaCompra.doc_id   = documento.doc_id
                    inner join empresa       on documento.emp_id       = empresa.emp_id
                    inner join condicionpago on FacturaCompra.cpg_id   = condicionpago.cpg_id
                    inner join estado        on FacturaCompra.est_id   = estado.est_id
                    inner join sucursal      on FacturaCompra.suc_id   = sucursal.suc_id
                    inner join Proveedor     on FacturaCompra.prov_id  = Proveedor.prov_id
                    inner join usuario       on FacturaCompra.modifico = usuario.us_id
                    left join centrocosto    on FacturaCompra.ccos_id  = centrocosto.ccos_id
                    left join listaprecio    on FacturaCompra.lp_id    = listaprecio.lp_id
                    left join listadescuento on FacturaCompra.ld_id    = listadescuento.ld_id
where 

          
          @@fc_id = fc_id

end
