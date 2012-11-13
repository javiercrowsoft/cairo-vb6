if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaSetEstado]

/*

 sp_DocPedidoVentaSetEstado 21

*/

go
create procedure sp_DocPedidoVentaSetEstado (
	@@pv_id 			int,
  @@Select      tinyint = 0,
  @@est_id      int = 0 out 
)
as

begin

	if @@pv_id = 0 return

  declare @est_id 		 		int
	declare @cli_id 		 		int
  declare @pendiente   		decimal (18,6)
  declare @pendientedoc   decimal (18,6)
  declare @creditoTotal		decimal (18,6)
  declare @creditoCtaCte	decimal (18,6)
  declare @llevaFirma     tinyint
  declare @firmado        tinyint
  declare @deuda          decimal (18,6)
	declare @doc_id         int

  declare @doc_llevafirma 				tinyint
  declare @doc_llevafirmaCredito 	tinyint

	declare @estado_pendienteDespacho int set @estado_pendienteDespacho =2
	declare @estado_pendienteCredito  int set @estado_pendienteCredito  =3
	declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
	declare @estado_anulado           int set @estado_anulado           =7
	declare @estado_pendienteStock    int set @estado_pendienteStock    =8

	select @cli_id = cli_id, @firmado = pv_firmado, @est_id = est_id, @doc_id = doc_id
  from PedidoVenta where pv_id = @@pv_id

	select @doc_llevafirma 					= doc_llevafirma,
				 @doc_llevafirmaCredito 	= doc_llevafirmaCredito

	from Documento where doc_id = @doc_id

	if @est_id <> @estado_anulado begin

		-- Si el documento requiere firma y el comprobante no esta firmado
		-- y no esta finalizado (puede ser que se finalizo y luego se modifico el documento
    -- para que requiera firma en cuyo caso no se exige firma para documentos finalizados)
		if @firmado = 0 and @doc_llevafirma <> 0 and @est_id <> @estado_finalizado begin             
			set @est_id = @estado_pendienteFirma 
		end
    else begin                                

			-- Se obtiene la deuda del comprobante
			select @deuda = round(sum(pvi_pendiente),2) from PedidoVentaItem where pv_id = @@pv_id

			-- Si el comprobante no tiene deuda se finaliza
			if IsNull(@deuda,0)<=0 begin
				set @est_id = @estado_finalizado					

			end else begin

				-- Se obtiene la deuda del cliente
				exec sp_DocPedidoVentaGetDeudaCliente @cli_id, @pendiente out, @pendientedoc out

				-- Se obtiene el credito del cliente
				select @creditoTotal 	= cli_creditototal,
							 @creditoCtaCte = cli_creditoctacte
				from Cliente where cli_id = @cli_id

				-- Averiguo si valida stock
        declare @bStock 		smallint
        declare @cfg_valor 	varchar(5000)

				-- Si debe mas que el credito concedido al cliente
				if @pendiente + @pendientedoc > @creditoTotal or @pendiente > @creditoCtaCte begin	

					if @firmado = 0 and @doc_llevafirmaCredito <> 0 begin

						set @est_id = @estado_pendienteFirma
	
					end else begin

						exec sp_Cfg_GetValor 	'Stock-General','Stock en Pedido de Venta',  @cfg_valor out, 0
						if @cfg_valor is null 				set @bStock = 0
		        else begin
							if IsNumeric(@cfg_valor)=0  set @bStock = 0
		          else                        set @bStock = convert(smallint,@cfg_valor)
		        end
		
						if @bStock <> 0 begin
							exec sp_DocPedidoVentaStockValidate @@pv_id, @bStock out
							-- Sino hay Stock
							if @bStock = 0 begin
								set @est_id = @estado_pendienteStock 
								goto fin
							end
						end

						if @firmado <> 0 and @doc_llevafirmaCredito <> 0 begin

							set @est_id = @estado_pendienteDespacho

						end else begin

							set @est_id = @estado_pendienteCredito	

						end
					end

				-- sino solo pendiente
		    end else begin

					exec sp_Cfg_GetValor 	'Stock-General','Stock en Pedido de Venta',  @cfg_valor out, 0
					if @cfg_valor is null 				set @bStock = 0
	        else begin
						if IsNumeric(@cfg_valor)=0  set @bStock = 0
	          else                        set @bStock = convert(smallint,@cfg_valor)
	        end
	
					if @bStock <> 0 begin
						exec sp_DocPedidoVentaStockValidate @@pv_id, @bStock out
						-- Sino hay Stock
						if @bStock = 0 begin
							set @est_id = @estado_pendienteStock 
							goto fin
						end
					end
	
					set @est_id = @estado_pendienteDespacho	
				end
      end
    end

fin:
	
		update PedidoVenta set est_id = @est_id
		where pv_id = @@pv_id
	
	end

	set @@est_id = @est_id  
	if @@Select <> 0 select @est_id

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el estado del pedido de venta. sp_DocPedidoVentaSetEstado.', 16, 1)

end
GO