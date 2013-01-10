
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PresupuestoVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PresupuestoVenta]

go
create procedure sp_lsdoc_PresupuestoVenta (
@@prv_id int
)as 
begin
select 
      prv_id,
      ''                    as [TypeTask],
      prv_numero            as [Número],
      prv_nrodoc            as [Comprobante],
      cli_nombre            as [Cliente],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      prv_fecha              as [Fecha],
      prv_fechaentrega      as [Fecha de entrega],
      prv_neto              as [Neto],
      prv_ivari              as [IVA RI],
      prv_ivarni            as [IVA RNI],
      prv_subtotal          as [Subtotal],
      prv_total              as [Total],
      prv_pendiente          as [Pendiente],
      case prv_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      
      prv_descuento1          as [% Desc. 1],
      prv_descuento2          as [% Desc. 2],
      prv_importedesc1        as [Desc. 1],
      prv_importedesc2        as [Desc. 2],

      lp_nombre              as [Lista de Precios],
      ld_nombre              as [Lista de descuentos],
      cpg_nombre            as [Condicion de Pago],
      ccos_nombre            as [Centro de costo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      PresupuestoVenta.Creado,
      PresupuestoVenta.Modificado,
      us_nombre             as [Modifico],
      prv_descrip            as [Observaciones]
from 
      Presupuestoventa 
                  inner join documento     on Presupuestoventa.doc_id   = documento.doc_id
                  inner join empresa       on documento.emp_id            = empresa.emp_id
                  inner join condicionpago on Presupuestoventa.cpg_id   = condicionpago.cpg_id
                  inner join estado        on Presupuestoventa.est_id   = estado.est_id
                  inner join sucursal      on Presupuestoventa.suc_id   = sucursal.suc_id
                  inner join cliente       on Presupuestoventa.cli_id   = cliente.cli_id
                  inner join usuario       on Presupuestoventa.modifico = usuario.us_id
                  left join vendedor       on Presupuestoventa.ven_id   = vendedor.ven_id
                  left join centrocosto    on Presupuestoventa.ccos_id  = centrocosto.ccos_id
                  left join listaprecio    on Presupuestoventa.lp_id    = listaprecio.lp_id
                  left join listadescuento on Presupuestoventa.ld_id    = listadescuento.ld_id
where 

          
          @@prv_id = prv_id

end
