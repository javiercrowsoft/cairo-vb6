if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraOrdenPagoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraOrdenPagoDelete]

go
/*

 sp_DocFacturaCompraOrdenPagoDelete 93

*/

create procedure sp_DocFacturaCompraOrdenPagoDelete (
	@@fc_id 				int,
	@@emp_id    		int,
	@@us_id					int,
  @@bSuccess    	tinyint = 0 out,
	@@ErrorMsg   	  varchar(5000) = '' out
)
as

begin

	set nocount on

	/*
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                                    //
	//                          GENERACION AUTOMATICA DE ORDEN DE PAGO																										//
	//                                                                                                                    //
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/

		declare @cpg_tipo tinyint
		declare @opg_id   int

		select 	@cpg_tipo = cpg_tipo, 
						@opg_id 	= opg_id
		from FacturaCompra fc inner join CondicionPago cpg on fc.cpg_id = cpg.cpg_id
		where fc_id = @@fc_id
	
		if @cpg_tipo in (2,3) /*Debito automatico o Fondo fijo*/ begin

					delete FacturaCompraOrdenPago where fc_id = @@fc_id
  				if @@error <> 0 goto ControlError

					update FacturaCompra set opg_id = null where fc_id = @@fc_id
  				if @@error <> 0 goto ControlError

					update OrdenPago set fc_id = null where opg_id = @opg_id
  				if @@error <> 0 goto ControlError

					declare @emp_id 	int
					declare @bSuccess tinyint

					select @emp_id = emp_id from OrdenPago where opg_id = @opg_id

					exec sp_DocOrdenPagoDelete    @opg_id,
																				@emp_id,
																				@@us_id,
																			  @bSuccess out,
																				@@ErrorMsg out
					if @bSuccess = 0 goto ControlError

		end else begin

			set @bSuccess = 1

		end
	/*
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                                                                                                                    //
	//                          FIN GENERACION AUTOMATICA DE ORDEN DE PAGO																								//
	//                                                                                                                    //
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/

	return
ControlError:

	set @@ErrorMsg = 'Ha ocurrido un error al borrar la orden de pago asociada a la factura de compra. sp_DocFacturaCompraOrdenPagoDelete. ' + IsNull(@@ErrorMsg,'')
	raiserror (@@ErrorMsg, 16, 1)
	rollback transaction	

end