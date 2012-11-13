if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_cajaValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_cajaValidate]

/*

*/

go
create procedure sp_cajaValidate (
	@@cj_id int
)
as

begin

	set nocount on

	if exists(select * from CajaCuenta cjc inner join cuenta cue on cjc.cue_id_trabajo = cue.cue_id
						where -- Si en mis cuentas de fondos existe una cuenta que
                  -- es de trabajo de otra caja y esta dicha cuenta no
                  -- esta marcada como cuenta de sucursal, la cuenta
                  -- no puede ser usada como cuenta de fondos.
									--
									cue.cue_id in	(select cue_id_fondos from CajaCuenta where cj_id = @@cj_id)
							and	cue_escajasucursal = 0
							and cjc.cj_id <> @@cj_id)
	begin
		select 1 as error_code
		select cue_nombre from cuenta where cue_id in (

						select cue.cue_id from CajaCuenta cjc inner join cuenta cue on cjc.cue_id_trabajo = cue.cue_id
						where -- Si en mis cuentas de fondos existe una cuenta que
                  -- es de trabajo de otra caja y esta dicha cuenta no
                  -- esta marcada como cuenta de sucursal, la cuenta
                  -- no puede ser usada como cuenta de fondos.
									--
									cue.cue_id in	(select cue_id_fondos from CajaCuenta where cj_id = @@cj_id)
							and	cue_escajasucursal = 0
		)
		return
	end

	-- La cuenta de fondos no puede ser cuenta de trabajo
	-- de esta misma caja
	--
	if exists(select cue_id_fondos from CajaCuenta 
						where cj_id = @@cj_id 
							and cue_id_fondos in (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id)
						) begin

		select 2 as error_code
		select cue_nombre from cuenta where cue_id in (
						select cue_id_fondos from CajaCuenta 
						where cj_id = @@cj_id 
							and cue_id_fondos in (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id)
		)
		return
	end

	-- Una cuenta de trabajo solo se puede mencionar una vez
	--
	if exists(select cue_id_trabajo from CajaCuenta 
						where cj_id = @@cj_id 
						group by cue_id_trabajo having count(*)>1
						) begin

		select 3 as error_code
		select cue_nombre from cuenta where cue_id in (
						select cue_id_trabajo from CajaCuenta 
						where cj_id = @@cj_id 
						group by cue_id_trabajo having count(*)>1
		)
		return
	end

	-- Las cuentas de trabajo no pueden estar usadas por otras cajas
	--
	if exists(select cue_id_trabajo from CajaCuenta
						where cj_id = @@cj_id
						and cue_id_trabajo in (select cue_id_trabajo from CajaCuenta where cj_id <> @@cj_id)
						) begin

		select 4 as error_code
		select 'Caja: ' + cj_nombre + ' Cuenta: ' + cue_nombre	as cue_nombre
		from cuenta cue inner join CajaCuenta cjc on cue.cue_id = cjc.cue_id_trabajo
										inner join Caja cj on cjc.cj_id = cj.cj_id and cj.cj_id <> @@cj_id
		where cue.cue_id in (
						select cue_id_trabajo from CajaCuenta
						where cj_id = @@cj_id
						and cue_id_trabajo in (select cue_id_trabajo from CajaCuenta where cj_id <> @@cj_id)
		)
		return
	end

	-- Si la cuenta de trabajo es bancos o documentos en cartera,
	-- la cuenta de fondos no puede ser caja
	--
	if exists(select cue_id_trabajo 
						from CajaCuenta cjc inner join Cuenta cuet on cjc.cue_id_trabajo = cuet.cue_id
																inner join Cuenta cuef on cjc.cue_id_fondos  = cuef.cue_id
						where cjc.cj_id = @@cj_id
							and cuet.cuec_id in (1,2) and cuef.cuec_id = 14
						) begin

		select 5 as error_code
		select cue_nombre
		from cuenta cue 
		where cue_id in (
						select cue_id_trabajo 
						from CajaCuenta cjc inner join Cuenta cuet on cjc.cue_id_trabajo = cuet.cue_id
																inner join Cuenta cuef on cjc.cue_id_fondos  = cuef.cue_id
						where cjc.cj_id = @@cj_id
							and cuet.cuec_id in (1,2) and cuef.cuec_id = 14
		)
		return
	end

	select 0 as error_code

end

go