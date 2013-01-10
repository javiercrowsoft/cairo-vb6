/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_MovimientoCajaGetTotalesXCjId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_MovimientoCajaGetTotalesXCjId]


/*

sp_MovimientoCajaGetTotalesXCjId 1

*/

go
create procedure sp_MovimientoCajaGetTotalesXCjId (

  @@cj_id   int

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

  create table #t_saldos (cue_id int, saldo decimal(18,6))

  insert into #t_saldos (cue_id, saldo)

  select   cjc.cue_id_trabajo,
          sum(asi_debe-asi_haber) as saldo

  from #t_asientos t     inner join AsientoItem asi   on t.as_id = asi.as_id
                        inner join CajaCuenta cjc   on asi.cue_id = cjc.cue_id_trabajo                      
  where cjc.cj_id = @@cj_id
  group by cjc.cue_id_trabajo
    
  select   cjc.cue_id_trabajo,
          cue.cue_nombre,
          saldo
  from CajaCuenta cjc inner join Cuenta cue on cjc.cue_id_trabajo = cue.cue_id
                      left join #t_saldos t on cjc.cue_id_trabajo = t.cue_id
  where cjc.cj_id = @@cj_id
    and (cue.activo <> 0 or isnull(t.saldo,0) <> 0)
  order by (
            case 
              when cuec_id = 14 then 1 
              when cuec_id = 1 then 2 
              else 3 
            end
            ),
            cue_nombre

end
go