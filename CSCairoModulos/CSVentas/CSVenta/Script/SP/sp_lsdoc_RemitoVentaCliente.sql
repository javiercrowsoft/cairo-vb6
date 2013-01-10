
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_RemitoVentaCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_RemitoVentaCliente]

go
create procedure sp_lsdoc_RemitoVentaCliente (
@@rv_id int
)as 
begin
select 
      rv_id,
      ''                    as [TypeTask],
      rv_numero             as [Número],
      rv_nrodoc              as [Comprobante],
      cli_nombre            as [Cliente],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      rv_fecha              as [Fecha],
      rv_fechaentrega        as [Fecha de entrega],
      rv_neto                as [Neto],
      rv_ivari              as [IVA RI],
      rv_ivarni              as [IVA RNI],
      rv_subtotal            as [Subtotal],
      rv_total              as [Total],
      rv_pendiente          as [Pendiente],
      case rv_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      
      rv_descuento1          as [% Desc. 1],
      rv_descuento2          as [% Desc. 2],
      rv_importedesc1        as [Desc. 1],
      rv_importedesc2        as [Desc. 2],

      lp_nombre              as [Lista de Precios],
      ld_nombre              as [Lista de descuentos],
      cpg_nombre            as [Condicion de Pago],
      ccos_nombre            as [Centro de costo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      RemitoVenta.Creado,
      RemitoVenta.Modificado,
      us_nombre             as [Modifico],
      rv_descrip            as [Observaciones]
from 
      Remitoventa inner join documento     on Remitoventa.doc_id   = documento.doc_id
                  inner join empresa       on documento.emp_id      = empresa.emp_id
                  inner join condicionpago on Remitoventa.cpg_id   = condicionpago.cpg_id
                  inner join estado        on Remitoventa.est_id   = estado.est_id
                  inner join sucursal      on Remitoventa.suc_id   = sucursal.suc_id
                  inner join cliente       on Remitoventa.cli_id   = cliente.cli_id
                  inner join usuario       on Remitoventa.modifico = usuario.us_id
                  left join vendedor       on Remitoventa.ven_id   = vendedor.ven_id
                  left join centrocosto    on Remitoventa.ccos_id  = centrocosto.ccos_id
                  left join listaprecio    on Remitoventa.lp_id    = listaprecio.lp_id
                  left join listadescuento on Remitoventa.ld_id    = listadescuento.ld_id
where 

          
          @@rv_id = rv_id

end
