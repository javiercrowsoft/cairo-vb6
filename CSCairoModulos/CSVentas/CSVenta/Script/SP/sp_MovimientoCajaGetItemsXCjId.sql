/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetItemsXCjId ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetItemsXCjId ]


/*

sp_MovimientoCajaGetItemsXCjId  4

*/

go
create procedure sp_MovimientoCajaGetItemsXCjId  (

	@@cj_id	int

)as 

begin

	set nocount on

	declare @mcj_id int
	declare @tipo   tinyint

	select @mcj_id = max(mcj_id) from MovimientoCaja where cj_id = @@cj_id

	select @tipo = mcj_tipo from MovimientoCaja where mcj_id = @mcj_id

	set @tipo = isnull(@tipo,2)

	if @tipo = 2 begin -- La caja esta cerrada y hay que abrirla

		select 	mcji.*,
						cjc.*,
						cue_nombre,
						cue.mon_id as mon_id_cuenta,
						mon_nombre,
						0 as saldo
	
		from Cuenta cue inner join CajaCuenta cjc on cue.cue_id = cjc.cue_id_trabajo
										left  join MovimientoCajaItem mcji on 1=2
									  left  join Moneda mon on cue.mon_id = mon.mon_id
	
		where cjc.cj_id = @@cj_id

	end else begin -- La caja esta abierta y hay que cerrarla
		
		-----------------------------------------------------------------------
	
		declare @fecha_apertura datetime
		
		select @fecha_apertura = mcj_fecha from MovimientoCaja where mcj_id = @mcj_id
	
		set @fecha_apertura = isnull(@fecha_apertura, '19000101')
	
		create table #t_asientos(as_id int)
	
		insert into #t_asientos (as_id)
	
		select distinct ast.as_id 
		from Asiento ast inner join AsientoItem asi on ast.as_id = asi.as_id
		where cue_id in (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id)
			and as_fecha >= @fecha_apertura 
			and ast.as_id not in (select mcjm.as_id 
														from MovimientoCaja mcj 
															inner join MovimientoCajaMovimiento mcjm 
																on mcj.mcj_id = mcjm.mcj_id 
														where mcj.cj_id = @@cj_id
												)
			and ast.as_id not in (select as_id 
														from MovimientoCaja mcj 
														where mcj.cj_id = @@cj_id
															and as_id is not null
														)

		-- El movimiento de apertura de la caja
		--
		insert into #t_asientos (as_id)
		select as_id from MovimientoCaja where mcj_id = @mcj_id
	
		-----------------------------------------------------------------------

		create table #t_cuentas (cue_id int, saldo decimal(18,6))

		insert into #t_cuentas (cue_id, saldo)

		select cue_id,
					 sum(asi_debe-asi_haber)

		from AsientoItem asi inner join #t_asientos t on t.as_id = asi.as_id
		group by cue_id

		-----------------------------------------------------------------------

		select 	mcji.*,
						cjc.*,
						cue_nombre,
						cue.mon_id as mon_id_cuenta,
						mon_nombre,
						saldo
	
		from Cuenta cue inner join CajaCuenta cjc on cue.cue_id = cjc.cue_id_trabajo
										left  join MovimientoCajaItem mcji on 1=2
									  left  join Moneda mon on cue.mon_id = mon.mon_id
										left  join #t_cuentas t on cue.cue_id = t.cue_id
	
		where cjc.cj_id = @@cj_id

	end

end
go