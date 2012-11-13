		set @@bError = 1
		set @@MsgError = '@@ERROR_SP:El asiento no balancea:;;  Debe : ' + @strDebe + ';  Haber: ' + @strHaber + ';;'


	if @@MsgError is not null set @@MsgError = @@MsgError + ';'

	set @@MsgError = IsNull(@@MsgError,'') + 'Ha ocurrido un error al grabar la factura de venta. sp_DocFacturaVentaAsientoSave.'
                          
  if @@bRaiseError <> 0 begin
		raiserror (@@MsgError, 16, 1)
	end
