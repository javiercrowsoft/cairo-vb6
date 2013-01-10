if exists (select * from sysobjects where id = object_id(N'[dbo].[frOrdendePago2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frOrdendePago2]

/*

select * from ordenpago


select * from ordenpagoitem where opg_id = 1

frOrdendePago2 13

*/
go
create procedure frOrdendePago2 (

  @@opg_id      int

)as 

begin

select
      0                                          as orden_id,

      o.opg_id,
      0 as fc_id,

      1                                         as tipo,
      prov_nombre                                as Proveedor,
      opg_fecha                                 as Fecha,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as Legajo,
      usFirma.us_nombre                         as Autorizado,
      usModifico.us_nombre                      as Confeccionado,

      ccos.ccos_nombre                          as [Centro Costo],
      ccosi.ccos_nombre                         as [Centro Costo Item],

      null                                      as [Fecha comprobante],
       ''                                        as [Tipo comp.],
       ''                                         as [Nro. comp.],
      o.opg_numero                              as [OPG Nro.],
      o.opg_nroDoc                              as [OPG Comp.],
      0                                         as Aplicacion,
      opg_descrip                               as Aclaraciones,
      bco_nombre                                as Banco,
      c.cue_nombre                              as Cuenta,
       cheq_numerodoc                             as [Nro. cheque],
      cheq_fechaVto                             as Vencimiento,
      cheq_fechaCobro                           as Cobro,
       opgi_descrip                               as Detalle,
      opgi_importe                              as Importe,   
      opg_total                                  as Total,
      'Recibí de ' + emp_razonsocial + ' la cantidad de:'    as [Recibi de]   

from 

      OrdenPago o inner join OrdenPagoItem oi             on o.opg_id      = oi.opg_id
                  inner join Proveedor p                  on o.prov_id     = p.prov_id
                  inner join Usuario usModifico           on o.modifico    = usModifico.us_id
                  inner join Empresa emp                  on o.emp_id      = emp.emp_id

                  left join  Cheque ch                    on oi.cheq_id    = ch.cheq_id
                  left join  Chequera chq                 on ch.chq_id     = chq.chq_id
                  left join  Cuenta c                     on IsNull(oi.cue_id,chq.cue_id) = c.cue_id

                  left join  Usuario usFirma              on o.opg_firmado = usFirma.us_id
                  left join  Cuenta chqc                  on chq.cue_id    = chqc.cue_id
                  left join  Banco b                      on (chqc.bco_id  = b.bco_id or ch.bco_id = b.bco_id)
                  left join  Legajo l                     on o.lgj_id      = l.lgj_id

                  left join CentroCosto ccos              on o.ccos_id     = ccos.ccos_id
                  left join CentroCosto ccosi             on oi.ccos_id    = ccosi.ccos_id

where
      o.opg_id       = @@opg_id
  and oi.opgi_tipo   <> 5 -- cuenta corriente 

union all

select
      1                                          as orden_id,

      o.opg_id,
      fc.fc_id,

      0                                         as tipo,
      prov_nombre                                as Proveedor,
      opg_fecha                                 as Fecha,
      ''                                        as Legajo,
      usFirma.us_nombre                         as Autorizado,
      usModifico.us_nombre                      as Confeccionado,

      ccos.ccos_nombre                          as [Centro Costo],
      ''                                         as [Centro Costo Item],

      fc_fecha                                  as [Fecha comprobante],
       doc_nombre                                as [Tipo comp.],
       fc_nrodoc                                 as [Nro. comp.],
      o.opg_numero                              as [OPG Nro.],
      o.opg_nroDoc                              as [OPG Comp.],
      fcopg_importe                             as Aplicacion,
      opg_descrip                               as Aclaraciones,
      ''                                        as Banco,
      ''                                        as Cuenta,
       ''                                        as [Nro. cheque],
      ''                                        as Cobro,
      ''                                         as Vencimiento,
       ''                                         as Detalle,
      0                                          as Importe,   
      opg_total                                  as Total,
      'Recibí de ' + emp_razonsocial + ' la cantidad de:'    as [Recibi de]  

from 

      OrdenPago o inner join Proveedor p                  on o.prov_id     = p.prov_id
                  inner join Usuario usModifico           on o.modifico    = usModifico.us_id
                  inner join Empresa emp                  on o.emp_id      = emp.emp_id

                  left join  Usuario usFirma              on o.opg_firmado = usFirma.us_id

                  left join  FacturaCompraOrdenPago fcop   on fcop.opg_id   = o.opg_id
                  left join  FacturaCompraDeuda fcd       on fcop.fcd_id   = fcd.fcd_id
                  left join  FacturaCompraPago fcp        on fcop.fcp_id   = fcp.fcp_id
                  left join  FacturaCompra fc             on (fcd.fc_id    = fc.fc_id or fcp.fc_id = fc.fc_id)
                  left join  Documento d                  on fc.doc_id     = d.doc_id

                  left join CentroCosto ccos              on o.ccos_id     = ccos.ccos_id

where
      o.opg_id = @@opg_id

order by orden_id, tipo

end
go

