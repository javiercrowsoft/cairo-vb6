if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_chequeUpdateDeudaDoc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_chequeUpdateDeudaDoc]

/*

 sp_chequeUpdateDeudaDoc 12

*/

go
create procedure sp_chequeUpdateDeudaDoc 

as

begin

	-- Ordenes de Pago - Proveedores
	--

	declare @opg_id int

	declare c_opg_cheq insensitive cursor for

	select distinct opg_id
	from Cheque chq
	where (
							cheq_cacheproc = '19000101' 
					or 	(			cheq_cacheproc 	< cheq_fechacobro 
								and cheq_anulado 		= 0 
								and cheq_rechazado 	= 0
							)
				) 
		and cheq_fechacobro < getdate()
		and opg_id is not null

	open c_opg_cheq

	fetch next from c_opg_cheq into @opg_id
	while @@fetch_status=0
	begin

		exec sp_DocOrdenPagoChequeSetCredito @opg_id

		fetch next from c_opg_cheq into @opg_id
	end

	close c_opg_cheq
	deallocate c_opg_cheq

	-- Cobranzas - Clientes
	--

	declare @cobz_id int

	declare c_cobz_cheq insensitive cursor for

	select distinct cobz_id
	from Cheque chq
	where (
							cheq_cacheproc = '19000101' 
					or 	(			cheq_cacheproc 	< cheq_fechacobro 
								and cheq_anulado 		= 0 
								and cheq_rechazado 	= 0
							)
				) 
		and cheq_fechacobro < getdate()
		and cobz_id is not null

	open c_cobz_cheq

	fetch next from c_cobz_cheq into @cobz_id
	while @@fetch_status=0
	begin

		exec sp_DocCobranzaChequeSetCredito @cobz_id

		fetch next from c_cobz_cheq into @cobz_id
	end

	close c_cobz_cheq
	deallocate c_cobz_cheq

	-- Finalmente actualizo los cheques
	--

	update Cheque set cheq_cacheproc = getdate()
	where	(
							cheq_cacheproc = '19000101' 
					or 	(			cheq_cacheproc 	< cheq_fechacobro 
								and cheq_anulado 		= 0 
								and cheq_rechazado 	= 0
							)
				) 
		and cheq_fechacobro < getdate()

end
go