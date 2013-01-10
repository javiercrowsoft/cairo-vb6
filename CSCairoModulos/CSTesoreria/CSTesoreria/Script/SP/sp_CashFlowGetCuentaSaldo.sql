if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_CashFlowGetCuentaSaldo ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_CashFlowGetCuentaSaldo ]

go

/*

sp_CashFlowGetCuentaSaldo 8,'20090225'

*/
create procedure sp_CashFlowGetCuentaSaldo (
  @@cf_id   int,
  @@fecha    datetime,

  @@bNoSelect tinyint = 0,
  @@saldo_ini decimal(18,6)=0 out,

  @@bNoCreateTable tinyint = 0
)
as

begin

  set nocount on

  declare @mon_id     int
  declare @cotiz      decimal(18,6)
  declare @mon_legal   int
  declare @fecha      datetime

  set @fecha = getdate()

  select @mon_legal = mon_id from Moneda where mon_legal <> 0

  create table #t_moneda (mon_id int, cotiz decimal(18,6))

  declare c_mon insensitive cursor for
  select mon_id
  from Moneda

  open c_mon

  fetch next from c_mon into @mon_id
  while @@fetch_status=0
  begin

    set @cotiz = 1

    exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotiz out

    insert into #t_moneda (mon_id, cotiz) values (@mon_id, @cotiz)

    fetch next from c_mon into @mon_id
  end

  close c_mon
  deallocate c_mon

  if @@bNoCreateTable = 0 begin

    create table #t_table ( cue_id     int, 
                            debe       decimal(18,6), 
                            haber     decimal(18,6), 
                            saldo     decimal(18,6),
                            debeex     decimal(18,6), 
                            haberex   decimal(18,6), 
                            saldoex   decimal(18,6)
                          )

  end

  insert into #t_table (cue_id, debe, haber, saldo, debeex, haberex, saldoex)

  select   cue.cue_id,
          sum(case when cue.mon_id <> @mon_legal and asi_debe <> 0 
                        then asi_origen * cotiz 
                   else asi_debe 
              end
              )                    as debe,

          sum(case when cue.mon_id <> @mon_legal and asi_haber <> 0 
                        then asi_origen * cotiz 
                   else asi_haber 
              end
              )                    as haber,

          sum(case when cue.mon_id <> @mon_legal and asi_debe <> 0 
                        then asi_origen * cotiz 
                   else asi_debe 
              end
              -
              case when cue.mon_id <> @mon_legal and asi_haber <> 0 
                        then asi_origen * cotiz 
                   else asi_haber 
              end
              )                    as saldo,

          sum(case when asi_debe  <> 0 then asi_origen else 0 end)            as debeex,
          sum(case when asi_haber <> 0 then asi_origen else 0 end)            as haberex,
          sum(case when asi_debe  <> 0 then asi_origen else -asi_origen end)  as saldoex


  from CashFlowParam cfp  inner  join Cuenta cue       on cfp.cue_id = cue.cue_id
                          inner  join AsientoItem asi on cue.cue_id = asi.cue_id 
                                                        and (asi_conciliado = 2 or cuec_id <> 2 or cheq_id is null)
                          inner  join Asiento ast     on asi.as_id  = ast.as_id
                           left   join Cheque cheq     on asi.cheq_id = cheq.cheq_id
                          left   join #t_moneda t     on cue.mon_id = t.mon_id

  where cf_id = @@cf_id
    and  (
              (      as_fecha <= @@fecha
                and cheq_fechacobro is null 
              )

          or  (      dateadd(d,1,as_fecha) <= @@fecha
                and isnull(ast.doct_id_cliente,0) = 17
              )

          or  (      isnull(cheq_fecha2,'99991231') <= @@fecha
                and isnull(ast.doct_id_cliente,0) <> 17 -- debe tomar la fecha del deposito cuando el cheque
                                                        -- es depositado en el banco
              )
          )

  group by cue_nombre, cue.cue_id

  --//////////////////////////////////////////////////////////////////////////////
  --
  -- Saldos
  --

  if @@bNoSelect = 0 begin

    select   0 as cfp_id,
            case when cue_codigorpt <> '' then 0 else cue.cue_id end cue_id,
            case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre end cue_nombre,
            sum(debe)      as debe,
            sum(haber)    as haber,
            sum(saldo)    as saldo,
            sum(debeex)    as debeex,
            sum(haberex)  as haberex,
            sum(saldoex)  as saldoex
  
    from CashFlowParam cfp inner join Cuenta cue on cfp.cue_id = cue.cue_id
                           left  join #t_table t on cfp.cue_id = t.cue_id
    where cf_id = @@cf_id
  
    group by 
  
            case when cue_codigorpt <> '' then 0 else cue.cue_id end,
            case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre end
  
  
    union all
  
    select  99999999,
            0 as cue_id,
            'Saldo Disponibilidades' as cue_nombre,
            sum(debe),
            sum(haber),
            sum(debe)-sum(haber),
            sum(debeex),
            sum(haberex),
            sum(debeex)-sum(haberex)
  
    from #t_table
  
    order by cue_nombre

  end else begin

    select  @@saldo_ini = sum(debe)-sum(haber)
    from #t_table

  end

end        