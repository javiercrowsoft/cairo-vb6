  update OrdenPago set opg_grabarAsiento = 1

  delete OrdenPagoAsiento

  insert into OrdenPagoAsiento (opg_id,opg_fecha) select opg_id,'20040304' from OrdenPago 
  where opg_grabarAsiento <> 0 

  exec sp_DocOrdenPagoAsientosSave 


  delete MovimientoFondoAsiento

  insert into MovimientoFondoAsiento (mf_id,mf_fecha) select mf_id,'20040304' from MovimientoFondo 
  where mf_grabarAsiento <> 0 

  exec sp_DocMovimientoFondoAsientosSave 


  delete DepositoBancoAsiento

  insert into DepositoBancoAsiento (dbco_id,dbco_fecha) select dbco_id,'20040304' from DepositoBanco 
  where dbco_grabarAsiento <> 0 

  exec sp_DocDepositoBancoAsientosSave 

  update cobranza set cobz_grabarAsiento = 1

  delete CobranzaAsiento

  insert into CobranzaAsiento (cobz_id,cobz_fecha) select cobz_id,'20040304' from Cobranza 
  where cobz_grabarAsiento <> 0 

  exec sp_DocCobranzaAsientosSave 
