
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_OrdenServicio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_OrdenServicio]

go
create procedure sp_lsdoc_OrdenServicio (
@@os_id int

)as 
begin

select 
      os_id,
      ''                    as [TypeTask],
      os_numero             as [Número],
      os_nrodoc              as [Comprobante],
      cli_nombre            as [Cliente],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      os_fecha              as [Fecha],
      os_fechaentrega        as [Fecha de entrega],
      os_neto                as [Neto],
      os_ivari              as [IVA RI],
      os_ivarni              as [IVA RNI],
      os_subtotal            as [Subtotal],
      os_total              as [Total],
      os_pendiente          as [Pendiente],
      case os_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],

      case impreso
        when 0 then 'No'
        else        'Si'
      end                    as [Impreso],

      os_descuento1          as [% Desc. 1],
      os_descuento2          as [% Desc. 2],
      os_importedesc1        as [Desc. 1],
      os_importedesc2        as [Desc. 2],

      lp_nombre              as [Lista de Precios],
      ld_nombre              as [Lista de descuentos],
      cpg_nombre            as [Condicion de Pago],
      ccos_nombre            as [Centro de costo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      OrdenServicio.Creado,
      OrdenServicio.Modificado,
      us_nombre             as [Modifico],
      os_descrip            as [Observaciones]
from 
      OrdenServicio inner join documento    on OrdenServicio.doc_id   = documento.doc_id
                   inner join empresa       on documento.emp_id       = empresa.emp_id
                   inner join condicionpago on OrdenServicio.cpg_id   = condicionpago.cpg_id
                   inner join estado        on OrdenServicio.est_id   = estado.est_id
                   inner join sucursal      on OrdenServicio.suc_id   = sucursal.suc_id
                   inner join Cliente       on OrdenServicio.cli_id   = Cliente.cli_id
                   inner join usuario       on OrdenServicio.modifico = usuario.us_id
                   left join centrocosto    on OrdenServicio.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on OrdenServicio.lp_id    = listaprecio.lp_id
                   left join listadescuento on OrdenServicio.ld_id    = listadescuento.ld_id
where 
          
          @@os_id = os_id

end
