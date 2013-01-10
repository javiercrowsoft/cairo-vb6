if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_DepositoCupon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_DepositoCupon]

/*
    sp_lsdoc_DepositoCupon 1
    select * from DepositoCupon
*/

go
create procedure sp_lsdoc_DepositoCupon (
  @@dcup_id int
)as 
begin

select distinct
      DepositoCupon.dcup_id,
      ''                      as [TypeTask],
      dcup_numero             as [Número],
      dcup_nrodoc              as [Comprobante],
      tjc_nombre              as [Tarjeta],
      bco_nombre              as [Banco],
      cue_nombre              as [Cuenta],
      doc_nombre              as [Documento],
      est_nombre              as [Estado],
      dcup_fecha              as [Fecha],
      dcup_total              as [Total],
      case dcup_firmado
        when 0 then 'No'
        else        'Si'
      end                      as [Firmado],
      
      suc_nombre              as [Sucursal],
      emp_nombre              as [Empresa],

      DepositoCupon.Creado,
      DepositoCupon.Modificado,
      usuario.us_nombre       as [Modifico],
      dcup_descrip            as [Observaciones]
from 
      DepositoCupon      inner join documento             on DepositoCupon.doc_id       = documento.doc_id
                        inner join empresa              on documento.emp_id           = empresa.emp_id
                         inner join estado                on DepositoCupon.est_id       = estado.est_id
                         inner join sucursal              on DepositoCupon.suc_id       = sucursal.suc_id
                        inner join DepositoCuponItem    on DepositoCupon.dcup_id      = DepositoCuponItem.dcup_id
                         inner join Cuenta               on DepositoCuponItem.cue_id   = Cuenta.cue_id
                         inner join Banco                 on Cuenta.bco_id               = Banco.bco_id
                        inner join TarjetaCreditoCupon  on DepositoCuponItem.tjcc_id  = TarjetaCreditoCupon.tjcc_id
                        inner join TarjetaCredito       on TarjetaCreditoCupon.tjc_id = TarjetaCredito.tjc_id
                         left  join usuario               on DepositoCupon.modifico     = usuario.us_id
where 
          @@dcup_id = DepositoCupon.dcup_id

end
