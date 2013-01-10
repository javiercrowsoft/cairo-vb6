
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PresupuestoEnvio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PresupuestoEnvio]

go
create procedure sp_lsdoc_PresupuestoEnvio (
@@pree_id int
)as 
begin
select 
      pree_id,
      ''                      as [TypeTask],
      pree_numero             as [Número],
      pree_nrodoc              as [Comprobante],
      cli_nombre              as [Cliente],
      doc_nombre              as [Documento],
      est_nombre              as [Estado],
      pree_fecha              as [Fecha],
      pree_fechaentrega        as [Fecha de entrega],
      pree_neto                as [Neto],
      pree_ivari              as [IVA RI],
      pree_ivarni              as [IVA RNI],
      pree_subtotal            as [Subtotal],
      pree_total              as [Total],
      pree_pendiente          as [Pendiente],
      case pree_firmado
        when 0 then 'No'
        else        'Si'
      end                      as [Firmado],
      
      pree_descuento1          as [% Desc. 1],
      pree_descuento2          as [% Desc. 2],
      pree_importedesc1        as [Desc. 1],
      pree_importedesc2        as [Desc. 2],

      cpg_nombre          as [Condicion de Pago],
      ccos_nombre          as [Centro de costo],
      suc_nombre          as [Sucursal],
      emp_nombre          as [Empresa],

      PresupuestoEnvio.Creado,
      PresupuestoEnvio.Modificado,
      us_nombre             as [Modifico],
      pree_descrip          as [Observaciones]
from 
      PresupuestoEnvio  inner join documento          on PresupuestoEnvio.doc_id   = documento.doc_id
                        inner join empresa            on documento.emp_id          = empresa.emp_id
                        inner join condicionpago      on PresupuestoEnvio.cpg_id   = condicionpago.cpg_id
                        inner join estado             on PresupuestoEnvio.est_id   = estado.est_id
                        inner join sucursal           on PresupuestoEnvio.suc_id   = sucursal.suc_id
                        inner join cliente            on PresupuestoEnvio.cli_id   = cliente.cli_id
                        inner join usuario            on PresupuestoEnvio.modifico = usuario.us_id
                        left join vendedor            on PresupuestoEnvio.ven_id   = vendedor.ven_id
                        left join centrocosto         on PresupuestoEnvio.ccos_id  = centrocosto.ccos_id
where 

          
          @@pree_id = pree_id

end
