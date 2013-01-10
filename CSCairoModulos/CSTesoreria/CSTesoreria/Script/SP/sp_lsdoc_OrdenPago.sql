if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_OrdenPago]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_OrdenPago]

/*
    sp_lsdoc_OrdenPago 14
    select * from OrdenPago
*/

go
create procedure sp_lsdoc_OrdenPago (
  @@opg_id int
)as 
begin
select 
      opg_id,
      ''                  as [TypeTask],
      opg_numero          as [Número],
      opg_nrodoc          as [Comprobante],
      prov_nombre         as [Proveedor],
      doc_nombre          as [Documento],
      est_nombre          as [Estado],
      opg_fecha            as [Fecha],
      opg_neto            as [Neto],
      opg_total            as [Total],
      opg_pendiente        as [Pendiente],
      case opg_firmado
        when 0 then 'No'
        else        'Si'
      end                  as [Firmado],
      
      ccos_nombre          as [Centro de costo],
      suc_nombre          as [Sucursal],
      emp_nombre          as [Empresa],

      OrdenPago.Creado,
      OrdenPago.Modificado,
      us_nombre           as [Modifico],
      opg_descrip          as [Observaciones]

from 
      OrdenPago    inner join documento     on OrdenPago.doc_id    = documento.doc_id
                   inner join empresa       on documento.emp_id    = empresa.emp_id
                   inner join estado        on OrdenPago.est_id    = estado.est_id
                   inner join sucursal      on OrdenPago.suc_id    = sucursal.suc_id
                   inner join Proveedor     on OrdenPago.prov_id   = Proveedor.prov_id
                   inner join usuario       on OrdenPago.modifico  = usuario.us_id
                   left join centrocosto    on OrdenPago.ccos_id   = centrocosto.ccos_id
where 

          
          @@opg_id = opg_id

end
