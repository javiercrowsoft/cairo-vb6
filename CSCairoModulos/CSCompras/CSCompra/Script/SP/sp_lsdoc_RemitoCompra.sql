
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_RemitoCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_RemitoCompra]

go
create procedure sp_lsdoc_RemitoCompra (
@@rc_id int
)as 
begin
select 
      rc_id,
      ''                    as [TypeTask],
      rc_numero             as [Número],
      rc_nrodoc              as [Comprobante],
      prov_nombre           as [Proveedor],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      rc_fecha              as [Fecha],
      rc_fechaentrega        as [Fecha de entrega],
      rc_neto                as [Neto],
      rc_ivari              as [IVA RI],
      rc_ivarni              as [IVA RNI],
      rc_subtotal            as [Subtotal],
      rc_total              as [Total],
      rc_pendiente          as [Pendiente],
      case rc_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      
      rc_descuento1          as [% Desc. 1],
      rc_descuento2          as [% Desc. 2],
      rc_importedesc1        as [Desc. 1],
      rc_importedesc2        as [Desc. 2],

      lp_nombre              as [Lista de Precios],
      ld_nombre              as [Lista de descuentos],
      cpg_nombre            as [Condicion de Pago],
      ccos_nombre            as [Centro de costo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      RemitoCompra.Creado,
      RemitoCompra.Modificado,
      us_nombre             as [Modifico],
      rc_descrip            as [Observaciones]
from 
      RemitoCompra inner join documento     on RemitoCompra.doc_id   = documento.doc_id
                   inner join empresa       on documento.emp_id      = empresa.emp_id
                   inner join condicionpago on RemitoCompra.cpg_id   = condicionpago.cpg_id
                   inner join estado        on RemitoCompra.est_id   = estado.est_id
                   inner join sucursal      on RemitoCompra.suc_id   = sucursal.suc_id
                   inner join Proveedor     on RemitoCompra.prov_id  = proveedor.prov_id
                   inner join usuario       on RemitoCompra.modifico = usuario.us_id
                   left join centrocosto    on RemitoCompra.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on RemitoCompra.lp_id    = listaprecio.lp_id
                   left join listadescuento on RemitoCompra.ld_id    = listadescuento.ld_id
where 
          
          @@rc_id = rc_id

end
