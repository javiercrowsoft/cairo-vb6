if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ConciliacionBancoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ConciliacionBancoGet]

go

/*

sp_ConciliacionBancoGet 518,'20081215 00:00:00','20090115 00:00:00',1,1

*/
create procedure sp_ConciliacionBancoGet (
  @@cue_id        int,
  @@fDesde         datetime,
  @@fHasta        datetime,
  @@fechaCobro    tinyint,
  @@verPendiente  tinyint
)
as

begin

  set nocount on

  if @@verPendiente <> 0 begin

    select  0  as saldoP,
            ---------------------------------
            sum(
              case asi_conciliado
                  when 2 then asi_debe
                  else        0
              end)
          - sum(
              case asi_conciliado
                  when 2 then asi_haber
                  else        0
              end) 
              as saldoC,
            ---------------------------------
            sum(
              case asi_conciliado
                  when 3 then asi_debe
                  else        0
              end)
          - sum(
              case asi_conciliado
                  when 3 then asi_haber
                  else        0
              end) 
              as saldoR
            ---------------------------------
  
    from Asiento ast inner join AsientoItem asi on     asi.cue_id = @@cue_id 
                                                  and ast.as_id  = asi.as_id
  
                     left join Cheque cheq          on asi.cheq_id = cheq.cheq_id

    where (
              (      as_fecha < @@fdesde
                and (     
                         @@fechaCobro = 0 
                      or cheq_fechacobro is null 
                      or isnull(ast.doct_id_cliente,0) = 17)
                    )

          or  (      isnull(cheq_fecha2,'99991231') < @@fdesde
                and @@fechaCobro <> 0 
                and isnull(ast.doct_id_cliente,0) <> 17 -- debe tomar la fecha del deposito cuando el cheque
                                                        -- es depositado en el banco
              )
          )

  end else begin

    select  sum(
              case asi_conciliado
                  when 1 then asi_debe
                  else        0
              end)
          - sum(
              case asi_conciliado
                  when 1 then asi_haber
                  else        0
              end) 
              as saldoP,
            ---------------------------------  
            sum(
              case asi_conciliado
                  when 2 then asi_debe
                  else        0
              end)
          - sum(
              case asi_conciliado
                  when 2 then asi_haber
                  else        0
              end) 
              as saldoC,
            ---------------------------------  
            sum(
              case asi_conciliado
                  when 3 then asi_debe
                  else        0
              end)
          - sum(
              case asi_conciliado
                  when 3 then asi_haber
                  else        0
              end) 
              as saldoR
            ---------------------------------

    from Asiento ast inner join AsientoItem asi on     asi.cue_id = @@cue_id 
                                                  and ast.as_id  = asi.as_id
  
                     left join Cheque cheq          on asi.cheq_id = cheq.cheq_id
    where (
              (      as_fecha < @@fdesde
                and (     
                         @@fechaCobro = 0 
                      or cheq_fechacobro is null 
                      or isnull(ast.doct_id_cliente,0) = 17)
                    )

          or  (      isnull(cheq_fecha2,'99991231') < @@fdesde
                and @@fechaCobro <> 0 
                and isnull(ast.doct_id_cliente,0) <> 17 -- debe tomar la fecha del deposito cuando el cheque
                                                        -- es depositado en el banco
              )
          )
  end

-----------------------------------------------------------------------------------------------

  select   
          asi.as_id,
          asi.asi_id,

                        -- debe tomar la fecha del deposito cuando el cheque
                        -- es depositado en el banco
          case   when @@fechaCobro <> 0 and isnull(ast.doct_id_cliente,0) <> 17 
                then IsNull(cheq_fecha2,as_fecha)
                else as_fecha
          end as Fecha,

          asi.asi_orden,
          case 
              when len(ast.as_doc_cliente)>0 then 
                    doct.doct_nombre + ' ' + ast.as_doc_cliente + '. ' + asi.asi_descrip
              else  asi.asi_descrip
          end asi_descrip,
          asi.asi_debe,
          asi.asi_haber,
          asi.asi_origen,
          asi.asi_tipo,
          asi.asi_conciliado,
          asi.mon_id,
          asi.cue_id,
          asi.ccos_id,
          asi.cheq_id,

          cheq_importe,
          cheq_importeorigen,
          cheq_numero,
          cheq_numerodoc,
          cheq_fechacobro,
          cheq_fechaVto,
          cheq_descrip,

          mon_nombre,

          cheq.cobz_id,
          cobz_nrodoc,
          cheq.opg_id,
          opg_nrodoc,
          cheq.cle_id,
          cle_nombre,
          cheq.chq_id,
          chq_codigo,          
          cheq.bco_id,
          bco_nombre,
          cheq.cli_id,
          cli_nombre,
          cheq.prov_id,
          prov_nombre,
          cheq.mf_id,
          mf_nrodoc,
          cheq.emp_id,
          emp_nombre,
          ccos_nombre,
          cue_nombre,

          ast.doct_id_cliente,
          ast.id_cliente

  from Asiento ast inner join AsientoItem asi on     asi.cue_id = @@cue_id 
                                                and ast.as_id  = asi.as_id

                   left join Cheque cheq          on asi.cheq_id  = cheq.cheq_id
                   left join Cliente cli          on cheq.cli_id  = cli.cli_id
                   left join Proveedor prov       on cheq.prov_id = prov.prov_id
                   left join Cobranza cobz        on cheq.cobz_id = cobz.cobz_id
                   left join OrdenPago opg        on cheq.opg_id  = opg.opg_id
                   left join MovimientoFondo mf    on cheq.mf_id   = mf.mf_id
                   left join Moneda mon           on cheq.mon_id  = mon.mon_id
                   left join Clearing cle         on cheq.cle_id  = cle.cle_id
                   left join Chequera chq         on cheq.chq_id  = chq.chq_id
                   left join Empresa emp          on cheq.emp_id  = emp.emp_id
                   left join Banco bco            on cheq.bco_id  = bco.bco_id
                   left join CentroCosto ccos     on asi.ccos_id  = ccos.ccos_id
                   left join Cuenta cue           on chq.cue_id   = cue.cue_id
                   left join DocumentoTipo doct   on ast.doct_id_cliente = doct.doct_id

  where (
          -- Conciliados pendientes y rechazados del periodo
          --
              (      as_fecha between @@fdesde and @@fhasta 
                and (     
                         @@fechaCobro = 0 
                      or cheq_fechacobro is null 
                      or isnull(ast.doct_id_cliente,0) = 17)
                    )

          or  (      isnull(cheq_fecha2,as_fecha) between @@fdesde and @@fhasta 
                and @@fechaCobro <> 0 
                and isnull(ast.doct_id_cliente,0) <> 17 -- debe tomar la fecha del deposito cuando el cheque
                                                        -- es depositado en el banco
              )

          -- Todos los pendientes hasta fecha hasta si @@verPendiente <> 0

          or  (      asi_conciliado = 1 
                and @@verPendiente <> 0 
                and (
                          (as_fecha <= @@fhasta 
                            and (  @@fechaCobro = 0 
                                  or cheq_fechacobro is null
                                  or isnull(ast.doct_id_cliente,0) = 17 -- debe tomar la fecha del deposito cuando 
                                                                        -- el cheque es depositado en el banco
                                )
                          )

                      or  (isnull(cheq_fecha2,as_fecha) <= @@fhasta 
                            and @@fechaCobro <> 0
                            and isnull(ast.doct_id_cliente,0) <> 17 -- debe tomar la fecha del deposito cuando el cheque
                                                                    -- es depositado en el banco
                          )
                    )
              )
        )

  order by Fecha, asi_debe desc

end        