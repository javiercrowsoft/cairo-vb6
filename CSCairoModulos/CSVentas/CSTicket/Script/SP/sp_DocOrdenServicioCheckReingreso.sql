if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioCheckReingreso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioCheckReingreso]

go
/*

 sp_DocOrdenServicioCheckReingreso 

*/

create procedure sp_DocOrdenServicioCheckReingreso (
	@@pr_id        int,
	@@prns_codigo  varchar(100),
	@@prns_codigo2 varchar(100),
	@@prns_codigo3 varchar(100)
)
as

begin

	set nocount on

	if exists(select * from ProductoNumeroSerie 
						where (
									prns_codigo  = @@prns_codigo
							or  (prns_codigo2 = @@prns_codigo2 and @@prns_codigo2 <> '')
							or  (prns_codigo3 = @@prns_codigo3 and @@prns_codigo3 <> '')
									)
							and pr_id = @@pr_id
							and doct_id_ingreso = 42
						) begin

		select 	prns.prns_id, 
						prns.pr_id,
						prns.depl_id,
						rub_nombre,
						pr_nombrecompra, 
						prns_codigo, 
						prns_codigo2, 
						prns_codigo3,
						depl_nombre,
						os_fecha,
						os_nrodoc

		from ProductoNumeroSerie prns inner join Producto pr 					on prns.pr_id 		= pr.pr_id
																	left  join Rubro rub   					on pr.rub_id  		= rub.rub_id
																	left  join DepositoLogico depl  on prns.depl_id		= depl.depl_id

																	left  join OrdenServicio os		on 		prns.doct_id_ingreso = 42
                                                                 and	prns.doc_id_ingreso  = os.os_id

		where (
					prns_codigo   = @@prns_codigo
			or  (prns_codigo2 = @@prns_codigo2 and @@prns_codigo2 <> '')
			or  (prns_codigo3 = @@prns_codigo3 and @@prns_codigo3 <> '')
					)
			and prns.pr_id = @@pr_id

	end else begin

		-- Esto es para que devuelva un recordset vacio
		-- no demora nada, no perocuparum !!!
		--
		select prns_id from ProductoNumeroSerie where 1=2

	end

end