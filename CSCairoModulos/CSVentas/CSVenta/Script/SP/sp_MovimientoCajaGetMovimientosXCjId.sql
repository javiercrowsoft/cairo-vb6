/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetMovimientosXCjId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetMovimientosXCjId]


/*

sp_MovimientoCajaGetMovimientosXCjId 1

*/

go
create procedure sp_MovimientoCajaGetMovimientosXCjId (

	@@cj_id	 int

)as 

begin

	set nocount on

	-----------------------------------------------------------------------

	declare @mcj_id int
	declare @fecha_apertura datetime
	declare @hora_apertura  datetime

	select @mcj_id = max(mcj_id) from MovimientoCaja where cj_id = @@cj_id

	select @hora_apertura = dateadd(second,datepart(second,mcj_hora),
															dateadd(minute,datepart(minute,mcj_hora),
																	dateadd(hour,datepart(hour,mcj_hora),
																		mcj_fecha))),
				 @fecha_apertura = mcj_fecha
	from MovimientoCaja where mcj_id = @mcj_id

	set @fecha_apertura = isnull(@fecha_apertura, '19000101')
	set @hora_apertura = isnull(@hora_apertura, '19000101')

	create table #t_asientos(as_id int)
  create index ix_asiento on #t_asientos (as_id asc)

	insert into #t_asientos (as_id)

	select distinct ast.as_id 
	from Asiento ast inner join AsientoItem asi on ast.as_id = asi.as_id
	where cue_id in (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id)
		and as_fecha >= @fecha_apertura 
		and creado >= @hora_apertura
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

	-----------------------------------------------------------------------

	select 	mcjm.*,

					ast.as_id	as as_id_movimiento,
					
						(	select sum(asi_debe) 
							from AsientoItem asi
							where as_id = ast.as_id 
								and not exists (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id and cue_id_trabajo = asi.cue_id)
						)
					as ingreso,
						(	select sum(asi_haber) 
							from AsientoItem asi
							where as_id = ast.as_id
								and not exists (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id and cue_id_trabajo = asi.cue_id)
						)
					as egreso,

						(	select sum(asi_debe) 
							from AsientoItem asi
							where as_id = ast.as_id 
								and not exists (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id and cue_id_trabajo = asi.cue_id)
						)
					+
						(	select sum(asi_haber) 
							from AsientoItem asi
							where as_id = ast.as_id
								and not exists (select cue_id_trabajo from CajaCuenta where cj_id = @@cj_id and cue_id_trabajo = asi.cue_id)
						)
					as importe,

					case 
						when fv_nrodoc is not null then fv_nrodoc + ' - cobz: ' + cobz_nrodoc + ' #' + cli_nombre 
						else as_doc_cliente 
					end as as_doc_cliente,
					as_nrodoc,
					as_fecha,
					case when doct_id_cliente = 13 then id_cliente else 0 end as cobz_id,
					ast.creado as sort_column

	from (Asiento ast inner join #t_asientos t on ast.as_id = t.as_id)
										left  join Cobranza cobz on ast.as_id = cobz.as_id
										left  join FacturaVentaCobranza fvcobz on cobz.cobz_id = fvcobz.cobz_id
										left  join FacturaVenta fv on fv.fv_id = fvcobz.fv_id
										left  join Cliente cli on fv.cli_id = cli.cli_id
									 	left  join MovimientoCajaMovimiento	mcjm on 1=2

	order by sort_column desc

end
go