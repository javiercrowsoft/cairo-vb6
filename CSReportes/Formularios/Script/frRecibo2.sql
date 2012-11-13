if exists (select * from sysobjects where id = object_id(N'[dbo].[frRecibo2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frRecibo2]

/*

select * from Cobranza

frRecibo2 1

*/
go
create procedure frRecibo2 (

	@@cobz_id			int

)as 

begin

select
			0																					as orden_id,
      o.cobz_id,
			1                                         as tipo,
			cli_nombre        												as Cliente,
			cobz_fecha                                as Fecha,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as Legajo,
      usFirma.us_nombre                         as Autorizado,
      usModifico.us_nombre                      as Confeccionado,
			ccos_nombre                               as [Centro Costo],
			null                                      as [Fecha comprobante],
 			''      									                as [Tipo comp.],
 			''       									                as [Nro. comp.],
			o.cobz_numero															as [COBZ Nro.],
			o.cobz_nroDoc															as [COBZ Comp.],
      0                                         as Aplicacion,
      cobz_descrip                              as Aclaraciones,
      bco_nombre                                as Banco,
      c.cue_nombre                              as Cuenta,
 			cheq_numerodoc   									        as [Nro. cheque],
			cheq_fechaVto                             as Vencimiento,
			cheq_fechaCobro                           as Cobro,
 			cobzi_descrip      						   					as Detalle,
			cobzi_importe                					    as Importe,	 
			cobz_total                    					    as Total,
      'Recibí de ' + cli_razonsocial + ' la cantidad de:'    as [Recibi de]	 

from 

      Cobranza o  inner join CobranzaItem oi 							on o.cobz_id     = oi.cobz_id
									inner join Cliente p      							on o.cli_id      = p.cli_id
									inner join Usuario usModifico           on o.modifico    = usModifico.us_id
									inner join Empresa emp									on o.emp_id      = emp.emp_id

                  left join  Cheque ch        						on oi.cheq_id    = ch.cheq_id
                  left join  Chequera chq                 on ch.chq_id     = chq.chq_id
                  left join  Cuenta c         						on IsNull(oi.cue_id,chq.cue_id) = c.cue_id

                  left join  Usuario usFirma              on o.cobz_firmado = usFirma.us_id
                  left join  Cuenta chqc                  on chq.cue_id    = chqc.cue_id
                  left join  Banco b          						on (chqc.bco_id  = b.bco_id or ch.bco_id = b.bco_id)
                  left join  Legajo l                     on o.lgj_id      = l.lgj_id

									left join CentroCosto ccos              on o.ccos_id     = ccos.ccos_id
where
			o.cobz_id       = @@cobz_id
  and oi.cobzi_tipo   <> 5 -- cuenta corriente 

union

select
			1																					as orden_id,
      o.cobz_id,
			0                                         as tipo,
			cli_nombre        												as Cliente,
			cobz_fecha                                as Fecha,
      ''                                        as Legajo,
      usFirma.us_nombre                         as Autorizado,
      usModifico.us_nombre                      as Confeccionado,
			ccos_nombre                               as [Centro Costo],
			fv_fecha                                  as [Fecha comprobante],
 			doc_nombre      									        as [Tipo comp.],
 			fv_nrodoc       									        as [Nro. comp.],
			o.cobz_numero															as [COBZ Nro.],
			o.cobz_nroDoc															as [COBZ Comp.],
      fvcobz_importe                             as Aplicacion,
      cobz_descrip                               as Aclaraciones,
      ''                                				as Banco,
      ''                              					as Cuenta,
 			''      									        				as [Nro. cheque],
			''                                        as Cobro,
			''                             						as Vencimiento,
 			''      						   										as Detalle,
			0                					    						as Importe,	 
			cobz_total                    					    as Total,
      'Recibí de ' + cli_razonsocial + ' la cantidad de:'    as [Recibi de]	

from 

      Cobranza o  inner join Cliente p      							on o.cli_id      = p.cli_id
									inner join Usuario usModifico           on o.modifico    = usModifico.us_id
									inner join Empresa emp									on o.emp_id      = emp.emp_id

                  left join  Usuario usFirma              on o.cobz_firmado = usFirma.us_id

									left join  FacturaVentaCobranza fcop 	 on fcop.cobz_id   = o.cobz_id
                  left join  FacturaVentaDeuda fcd       on fcop.fvd_id    = fcd.fvd_id
                  left join  FacturaVentaPago fcp        on fcop.fvp_id    = fcp.fvp_id
									left join  FacturaVenta fc             on (fcd.fv_id     = fc.fv_id or fcp.fv_id = fc.fv_id)
                  left join  Documento d                 on fc.doc_id      = d.doc_id

									left join CentroCosto ccos             on o.ccos_id      = ccos.ccos_id
where
			o.cobz_id = @@cobz_id


order by orden_id, tipo

end
go

