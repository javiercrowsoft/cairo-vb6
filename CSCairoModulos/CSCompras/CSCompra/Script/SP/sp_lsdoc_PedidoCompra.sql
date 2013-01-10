
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PedidoCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PedidoCompra]

go
create procedure sp_lsdoc_PedidoCompra (
@@pc_id int
)as 
begin
select 
      pc_id,
      ''                    as [TypeTask],
      pc_numero             as [Número],
      pc_nrodoc              as [Comprobante],
      us2.us_nombre         as [Usuario],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      pc_fecha              as [Fecha],
      pc_fechaentrega        as [Fecha de entrega],
      pc_neto                as [Neto],
      pc_ivari              as [IVA RI],
      pc_ivarni              as [IVA RNI],
      pc_subtotal            as [Subtotal],
      pc_total              as [Total],
      pc_pendiente          as [Pendiente],
      case pc_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],

      lp_nombre              as [Lista de Precios],
      ccos_nombre            as [Centro de costo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      PedidoCompra.Creado,
      PedidoCompra.Modificado,
      us1.us_nombre         as [Modifico],
      pc_descrip            as [Observaciones]
from 
      PedidoCompra inner join documento     on PedidoCompra.doc_id   = documento.doc_id
                   inner join empresa       on documento.emp_id      = empresa.emp_id
                   inner join estado        on PedidoCompra.est_id   = estado.est_id
                   inner join sucursal      on PedidoCompra.suc_id   = sucursal.suc_id
                   inner join usuario us2   on PedidoCompra.us_id    = us2.us_id
                   inner join usuario us1   on PedidoCompra.modifico = us1.us_id
                   left join centrocosto    on PedidoCompra.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on PedidoCompra.lp_id    = listaprecio.lp_id
where 

          
          @@pc_id = pc_id

end
