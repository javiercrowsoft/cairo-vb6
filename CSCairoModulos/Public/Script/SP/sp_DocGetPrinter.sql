if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocGetPrinter]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocGetPrinter]

go

/*

  sp_DocGetPrinter 22,48,'DAIMAKU' 

*/

create procedure sp_DocGetPrinter (
	@@doc_id	int,
	@@comp_id int,
	@@pc			varchar(255)
)
as

set nocount on

begin

	declare @doct_id 	int
	declare @ta_id		int

	select @doct_id = doct_id from documento where doc_id = @@doc_id

	if @doct_id in (1,	--Factura de Venta
									7,	--Nota de Credito Venta
									9)	--Nota de Debito Venta
		select @ta_id = case cli_catfiscal
							when 1  then ta_id_inscripto   --'Inscripto'
							when 2  then ta_id_final       --'Exento'
							when 3  then ta_id_inscripto   --'No inscripto'
							when 4  then ta_id_final       --'Consumidor Final'
							when 5  then ta_id_externo     --'Extranjero'
							when 6  then ta_id_final       --'Mono Tributo'
							when 7  then ta_id_externo     --'Extranjero Iva'
							when 8  then ta_id_final       --'No responsable'
							when 9  then ta_id_final       --'No Responsable exento'
							when 10 then ta_id_final       --'No categorizado'
							when 11 then ta_id_inscripto   --'InscriptoM'
			        else         -1                --'Sin categorizar'
					 end

		from facturaventa fv inner join cliente cli 
						on 	fv.cli_id = cli.cli_id
						and	fv.fv_id  = @@comp_id
												 inner join documento doc 
						on	fv.doc_id = doc.doc_id
	else
	if @doct_id in (2,	--Factura de Compra
									8,	--Nota de Credito Compra
									10)	--Nota de Debito Compra
		select @ta_id = case prov_catfiscal
							when 1  then ta_id_inscripto   --'Inscripto'
							when 2  then ta_id_final       --'Exento'
							when 3  then ta_id_final       --'No inscripto'
							when 4  then ta_id_final       --'Consumidor Final'
							when 5  then ta_id_externo     --'Extranjero'
							when 6  then ta_id_final       --'Mono Tributo'
							when 7  then ta_id_externo     --'Extranjero Iva'
							when 8  then ta_id_final       --'No responsable'
							when 9  then ta_id_final       --'No Responsable exento'
							when 10 then ta_id_final       --'No categorizado'
							when 11 then ta_id_inscriptom  --'Inscripto M'
			        else         -1                --'Sin categorizar'
					 end

		from facturacompra fc inner join proveedor prov
						on 	fc.prov_id = prov.prov_id
						and	fc.fc_id   = @@comp_id
												 inner join documento doc 
						on	fc.doc_id = doc.doc_id

	else
	if @doct_id in (3,	--Remito de Venta
									24)	--Devolucion Remito Venta
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (4,	--Remito de Compra
									25)	--Devolucion Remito Compra
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (5,	--Pedido de Venta
									22)	--Devolucion Pedido Venta
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (6,	--Pedido de Compra
									23)	--Devolucion Pedido Compra
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (11,	--Presupuesto de Venta
									39)	--Cancelacion de Presupuesto de Venta
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (12,	--Presupuesto de Compra
									40)	--Cancelacion de Presupuesto de Compra
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 13	--Cobranza
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 14	--Transferencia de Stock
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 15	--Asiento Contable
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 16	--Orden de Pago
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 17	--Deposito Banco
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 18	--Presupuesto de Envio
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 19	--Permiso Embarque
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (20,	--Manifiesto Carga
									41)	--Cancelacion Manifiesto Carga
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (21,	--Packing List
									31)	--Packing List Devolución
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 26	--Movimiento de Fondos
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 28	--Recuento Stock
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 29	--Despacho de Importacion Temporal
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 30	--Parte Producción Kit
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 32	--Presentacion de Cupones
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 33	--Resolución de Cupones
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 34	--Parte Desarme Kit
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (35,	--Orden de Compra
									36)	--Cancelacion de Orden de Compra
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id in (37,	--Cotizacion de Compra
									38)	--Devolucion de Cotización de Compra
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 42	--Orden de Servicio
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 43	--Parte de Reparacion
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 44	--Transferencia Stock a Proveedor
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	else
	if @doct_id = 45	--Transferencia Stock a Cliente
		select @ta_id = ta_id from documento where doc_id = @@doc_id

	if @ta_id is not null

		select * from DocumentoImpresora 
		where (ta_id = @ta_id or (doc_id = @@doc_id and ta_id is null))
			and (doci_pc = @@pc or doci_pc = '')

		order by ta_id desc, doc_id desc

	else

		select * from DocumentoImpresora 
		where doc_id = @@doc_id
			and (doci_pc = @@pc or doci_pc = '')

end

go
