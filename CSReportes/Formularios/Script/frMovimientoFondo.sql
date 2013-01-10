if exists (select * from sysobjects where id = object_id(N'[dbo].[frMovimientoFondo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frMovimientoFondo]

/*

select * from movimientofondo
sp_col movimientofondo

select * from MovimientoFondoitem where mfi_tipo = 1

frMovimientoFondo 921

Public Enum csEMovimientoFondoItemTipo
  csEMfiTCheques = 1
  csEMfiTEfectivo = 2
  csEMfiTChequesT = 6
  csEMfiTChequesI = 7
End Enum
*/
go
create procedure frMovimientoFondo (

  @@mf_id      int

)as 

begin

select
      0                                          as orden_id,
      mf.mf_id,
      mfi_tipo                                  as tipo,
      mf_fecha                                  as Fecha,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as Legajo,
      usFirma.us_nombre                         as Autorizado,
      usModifico.us_nombre                      as Confeccionado,
      mf_numero                                  as [Mov. Fondo Nro.],
      mf_nroDoc                                  as [Mov. Fondo Comp.],
      0                                         as Aplicacion,
      mf_descrip                                as Aclaraciones,
      bco_nombre                                as Banco,
      mon_nombre                                as Moneda,
      cueh.cue_nombre                           as [Cuenta origen],
      cued.cue_nombre                           as [Cuenta destino],
       cheq_numerodoc                             as [Nro. cheque],
      cheq_fechaVto                             as Vencimiento,
      cheq_fechacobro                           as [Fecha Cobro],
      cle_nombre                                as Clearing,
       mfi_descrip                                 as Detalle,
      mfi_importe                                as Importe,   
      mf_total                                  as Total,
      ccosh.ccos_nombre                          as CentroCostoHeader,
      ccosi.ccos_nombre                         as CentroCostoItem

from 

      MovimientoFondo mf 
                  inner join MovimientoFondoItem mfi       on mf.mf_id       = mfi.mf_id
                  inner join Usuario usModifico           on mf.modifico    = usModifico.us_id
                  inner join Documento doc                on mf.doc_id      = doc.doc_id
                  inner join Empresa    emp                on doc.emp_id     = emp.emp_id
                  inner join Moneda    mon                on mf.mon_id      = mon.mon_id

                  inner join  Cuenta cued                 on mfi.cue_id_debe  = cued.cue_id
                  inner join  Cuenta cueh                 on mfi.cue_id_haber = cueh.cue_id

              
                  left join  Cheque cheq                  on mfi.cheq_id   = cheq.cheq_id
                  left join  Clearing cle                 on cheq.cle_id   = cle.cle_id
                  left join  Chequera chq                 on cheq.chq_id   = chq.chq_id
                  left join  Cuenta cuechq                on chq.cue_id     = cuechq.cue_id
                  left join  Banco bco                     on (    cuechq.bco_id = bco.bco_id
                                                              or  cheq.bco_id   = bco.bco_id 
                                                              )

                  left join  Usuario usFirma              on mf.mf_firmado = usFirma.us_id
                  left join  Legajo l                     on mf.lgj_id     = l.lgj_id

                  left join CentroCosto ccosh             on mf.ccos_id     = ccosh.ccos_id
                  left join CentroCosto ccosi             on mfi.ccos_id    = ccosi.ccos_id

where
      mf.mf_id       = @@mf_id

order by orden_id, tipo

end
go

