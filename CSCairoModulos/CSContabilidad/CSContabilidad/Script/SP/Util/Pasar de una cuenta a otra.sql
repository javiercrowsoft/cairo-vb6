declare @@cue_id_find 		int
declare @@cue_id_replace  int

set @@cue_id_find  			=129
set @@cue_id_replace 		=129

begin tran

update DepositoBancoItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update AsientoItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update CuentaGrupo set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update TasaImpositiva set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update PercepcionTipo set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update OrdenPagoItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update ClienteCuentaGrupo set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update Cheque set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update EjercicioContable set cue_id_resultado = @@cue_id_replace where cue_id_resultado = @@cue_id_find if @@error <> 0 goto Error 
update DepositoCuponItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update RetencionTipo set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update FacturaVentaItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update FacturaVentaItem set cue_id_ivari = @@cue_id_replace where cue_id_ivari = @@cue_id_find if @@error <> 0 goto Error 
update FacturaVentaItem set cue_id_ivarni = @@cue_id_replace where cue_id_ivarni = @@cue_id_find if @@error <> 0 goto Error 

update ResolucionCuponItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update Chequera set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update TipoOperacionCuentaGrupo set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update DepositoBanco set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update CashFlow set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update TarjetaCreditoCupon set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update ProveedorCuentaGrupo set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update FacturaCompraItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update FacturaCompraItem set cue_id_ivari = @@cue_id_replace where cue_id_ivari = @@cue_id_find if @@error <> 0 goto Error 
update FacturaCompraItem set cue_id_ivarni = @@cue_id_replace where cue_id_ivarni = @@cue_id_find if @@error <> 0 goto Error 
update MovimientoFondoItem set cue_id_debe = @@cue_id_replace where cue_id_debe = @@cue_id_find if @@error <> 0 goto Error 
update MovimientoFondoItem set cue_id_haber = @@cue_id_replace where cue_id_haber = @@cue_id_find if @@error <> 0 goto Error 
update CobranzaItem set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 
update TarjetaCredito set cue_id_banco = @@cue_id_replace where cue_id_banco = @@cue_id_find if @@error <> 0 goto Error 
update TarjetaCredito set cue_id_comision = @@cue_id_replace where cue_id_comision = @@cue_id_find if @@error <> 0 goto Error 
update TarjetaCredito set cue_id_encartera = @@cue_id_replace where cue_id_encartera = @@cue_id_find if @@error <> 0 goto Error 
update TarjetaCredito set cue_id_presentado = @@cue_id_replace where cue_id_presentado = @@cue_id_find if @@error <> 0 goto Error 
update TarjetaCredito set cue_id_rechazo = @@cue_id_replace where cue_id_rechazo = @@cue_id_find if @@error <> 0 goto Error 
update FacturaCompraOtro set cue_id = @@cue_id_replace where cue_id = @@cue_id_find if @@error <> 0 goto Error 

	commit tran

	select 'Update exitoso'

	goto Fin
Error:

	select 'Hubo errores'
	rollback tran

Fin: