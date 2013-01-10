if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Cobranza]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Cobranza]

/*
    sp_lsdoc_Cobranza 14
    select * from Cobranza
*/

go
create procedure sp_lsdoc_Cobranza (
  @@cobz_id int
)as 
begin
select 
      cobz_id,
      ''                    as [TypeTask],
      cobz_numero           as [Número],
      cobz_nrodoc            as [Comprobante],
      cli_nombre            as [Cliente],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      cobz_fecha            as [Fecha],
      cobz_neto              as [Neto],
      cobz_total            as [Total],
      cobz_pendiente        as [Pendiente],
      case cobz_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      
      ccos_nombre            as [Centro de costo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      Cobranza.Creado,
      Cobranza.Modificado,
      us_nombre             as [Modifico],
      cobz_descrip          as [Observaciones]

from 
      Cobranza      inner join documento     on Cobranza.doc_id   = documento.doc_id
                   inner join empresa       on documento.emp_id  = empresa.emp_id
                   inner join estado        on Cobranza.est_id   = estado.est_id
                   inner join sucursal      on Cobranza.suc_id   = sucursal.suc_id
                   inner join cliente       on Cobranza.cli_id   = cliente.cli_id
                   inner join usuario       on Cobranza.modifico = usuario.us_id
                   left join cobrador       on Cobranza.cob_id   = cobrador.cob_id
                   left join centrocosto    on Cobranza.ccos_id  = centrocosto.ccos_id
where 

          
          @@cobz_id = cobz_id

end
