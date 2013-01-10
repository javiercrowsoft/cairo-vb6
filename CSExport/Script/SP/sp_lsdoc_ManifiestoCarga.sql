
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ManifiestoCarga]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ManifiestoCarga]

/*
    sp_lsdoc_ManifiestoCarga 14
    select * from PermisoEmbarque
*/

go
create procedure sp_lsdoc_ManifiestoCarga (
  @@mfc_id int
)as 

begin

select 
      mfc_id,
      ''                      as [TypeTask],
      mfc_numero              as [Número],
      mfc_nrodoc              as [Comprobante],
      cli_nombre              as [Cliente],
      doc_nombre              as [Documento],
      est_nombre              as [Estado],
      mfc_fecha                as [Fecha],
      mfc_cantidad            as [Cantidad],
      mfc_pendiente            as [Pendiente],
      case mfc_firmado
        when 0 then 'No'
        else        'Si'
      end                      as [Firmado],
      
      trans_nombre         as [Transporte],
      barc_nombre          as [Barco],
      ccos_nombre           as [Centro de costo],
      suc_nombre           as [Sucursal],
      emp_nombre           as [Empresa],
      chof_nombre          as [Chofer],
      Origen.pue_nombre    as [Puerto Origen],
      Destino.pue_nombre   as [Puerto Destino],
      dOrigen.depl_nombre  as [Deposito Origen],
      dDestino.depl_nombre as [Deposito Destino],
      cmarc_nombre         as [Contra Marca],

      mfc.Creado,
      mfc.Modificado,
      us_nombre             as [Modifico],
      mfc_descrip            as [Observaciones]
from 
      ManifiestoCarga mfc inner join Documento      on mfc.doc_id         = Documento.doc_id
                          inner join empresa        on documento.emp_id   = empresa.emp_id
                          left  join Transporte     on mfc.trans_id       = Transporte.trans_id
                          inner join Estado         on mfc.est_id         = Estado.est_id
                          inner join Sucursal       on mfc.suc_id         = Sucursal.suc_id
                          inner join Cliente        on mfc.cli_id         = Cliente.cli_id
                          inner join Usuario        on mfc.modifico       = Usuario.us_id
                          left  join Barco          on mfc.barc_id        = Barco.barc_id
                          left  join Chofer         on mfc.chof_id        = Chofer.chof_id
                          left  join Puerto Origen  on mfc.pue_id_origen  = Origen.pue_id
                          left  join Puerto Destino on mfc.pue_id_destino = Destino.pue_id
                          left  join ContraMarca    on mfc.cmarc_id       = ContraMarca.cmarc_id
                          left  join Centrocosto    on mfc.ccos_id        = Centrocosto.ccos_id

                          left  join DepositoLogico dOrigen  on mfc.depl_id_origen  = dOrigen.depl_id
                          left  join DepositoLogico dDestino on mfc.depl_id_destino = dDestino.depl_id
where 
          
          @@mfc_id = mfc_id

end
