if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_chequeGetData]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_chequeGetData]

go

/*

DepositoBanco                   reemplazar por el nombre del documento Ej. PedidoVenta
@@dbco_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
DepositoBanco                 reemplazar por el nombre de la tabla ej PedidoVenta
dbco_id                     reemplazar por el campo ID ej. pv_id
del deposito bancario                  reemplazar por el texto de error ej. del pedido de venta

sp_chequeGetData 1

*/
create procedure sp_chequeGetData (
	@@cheq_id int
)
as

begin

	select 
						bco_nombre, 
						cue_nombre, 
						cli_nombre,
						cle_nombre,
						cheque.bco_id, 
						cheque.cue_id, 
						cheq_importe, 
						cheq_importeorigen,
            cheq_fechavto,
            cheq_fechacobro
	from 
				cheque 		inner join banco 			on cheque.bco_id = banco.bco_id
                  inner join cuenta 		on cheque.cue_id = cuenta.cue_id
									left  join cliente    on cheque.cli_id = cliente.cli_id
									left  join clearing   on cheque.cle_id = clearing.cle_id

	where cheq_id = @@cheq_id

end