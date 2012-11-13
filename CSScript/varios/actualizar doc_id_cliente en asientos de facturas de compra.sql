begin tran

	update Asiento set doc_id_cliente = fc.doc_id
	from facturacompra fc
	where
	id_cliente = fc_id and
	doct_id_cliente in (2,8,10) and 
	doc_id_cliente <> fc.doc_id

rollback tran

begin tran

	update Asiento set doc_id_cliente = opg.doc_id
	from ordenpago opg
	where
	id_cliente = opg_id and
	doct_id_cliente = 16 and 
	doc_id_cliente <> opg.doc_id

rollback tran
