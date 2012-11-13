/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de ordenes de pago
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_9989]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_9989]

/*

select * from cuenta where cue_nombre like '%cuenta%'

[DC_CSC_TSR_9989] 1,1

*/

go
create procedure DC_CSC_TSR_9989 (

  @@us_id    		int,

	@@bCorregir   smallint
)as 
begin

  set nocount on

	select top 4000
			c.cobz_id				as comp_id,
			cobz.doct_id		as doct_id,
			cli_nombre 			as Cliente,
			prov_nombre			as Proveedor,
			cheq_numerodoc	as Cheque,
			cheq_importe    as Monto,
			cue_nombre    	as Cuenta,
			cobz_nrodoc   	as Cobranza,
			cobz_fecha      as [Fecha Cobz.],
			opg_nrodoc    	as [Orden de Pago],
			opg_fecha       as [Fecha OP],
			mf_nrodoc     	as [Movimiento de Fondos],
			cheq_numero   	as Numero,
			cheq_fechacobro	as Cobro,
			cle_nombre      as Clearing,
			bco_nombre      as Banco,
			cheq_descrip    as Observaciones
	
	from Cheque c left join Cliente cli on c.cli_id = cli.cli_id
								left join Proveedor prov on c.prov_id = prov.prov_id
								left join Cobranza cobz on c.cobz_id = cobz.cobz_id
								left join OrdenPago opg on c.opg_id = opg.opg_id
								left join MovimientoFondo mf on c.mf_id = mf.mf_id
								left join Cuenta cue on c.cue_id = cue.cue_id
								left join Clearing cle on c.cle_id = cle.cle_id
								left join Banco bco on c.bco_id = bco.bco_id 

	where cheq_id in (	
			select cheq_id
			from cheque 
			where 
			
					not exists(select * from depositobancoitem dbcoi left join depositobanco dbco on dbcoi.dbco_id = dbco.dbco_id
										 where cheq_id = cheque.cheq_id and dbco.cue_id = cheque.cue_id
										)
			and	not exists(select * from cobranzaitem where cheq_id = cheque.cheq_id and cue_id = cheque.cue_id)
			and not exists(select * from ordenpagoitem where cheq_id = cheque.cheq_id and cue_id = cheque.cue_id)
			and not exists(select * from movimientofondoitem where cheq_id = cheque.cheq_id and cue_id_debe = cheque.cue_id)
			and not exists(select * from movimientofondoitem where cheq_id = cheque.cheq_id and cue_id_haber = cheque.cue_id)
			--and not exists(select * from asientoitem where cue_id = cheque.cue_id and cheq_id = cheque.cheq_id)
			and cheque.cue_id is not null
	)


	if @@bCorregir <> 0 begin

		declare @cheq_id int
		declare @cue_id  int
		declare @asi_id  int

		declare c_cheques_mal insensitive cursor for 

			select cheq_id
			from cheque 
			where 
			
					not exists(select * from depositobancoitem dbcoi left join depositobanco dbco on dbcoi.dbco_id = dbco.dbco_id
										 where cheq_id = cheque.cheq_id and dbco.cue_id = cheque.cue_id
										)
					and	not exists(select * from cobranzaitem where cheq_id = cheque.cheq_id and cue_id = cheque.cue_id)
					and not exists(select * from ordenpagoitem where cheq_id = cheque.cheq_id and cue_id = cheque.cue_id)
					and not exists(select * from movimientofondoitem where cheq_id = cheque.cheq_id and cue_id_debe = cheque.cue_id)
					and not exists(select * from movimientofondoitem where cheq_id = cheque.cheq_id and cue_id_haber = cheque.cue_id)
					--and not exists(select * from asientoitem where cue_id = cheque.cue_id and cheq_id = cheque.cheq_id)
					and cheque.cue_id is not null
					
		open c_cheques_mal

		fetch next from c_cheques_mal into @cheq_id
		while @@fetch_status = 0
		begin

			set @asi_id = null
			set @cue_id = null

			select @asi_id = max(asi_id) from AsientoItem where cheq_id = @cheq_id

			select @cue_id = cue_id from asientoitem where asi_id = @asi_id

			if @cue_id is not null
				update Cheque set cue_id = @cue_id where cheq_id = @cheq_id

			fetch next from c_cheques_mal into @cheq_id
		end

		close c_cheques_mal
		deallocate c_cheques_mal

	end
end
go
 