if exists (select * from sysobjects where id = object_id(N'[dbo].[frBancoConciliacionDif]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frBancoConciliacionDif]

go

/*

frBancoConciliacionDif 20

*/
create procedure frBancoConciliacionDif  (

  @@bcoc_id int

)
as

begin

  set nocount on

  --/////////////////////////////////////////////////////////////////////////////////////////////////

  declare  @@cue_id        int,
          @@fDesde         datetime,
          @@fHasta        datetime,
          @@fechaCobro    tinyint,
          @@verPendiente  tinyint

  select  @@cue_id         = cue_id,
          @@fDesde         = bcoc_fechadesde,
          @@fHasta         = bcoc_fechahasta,
          @@fechaCobro     = bcoc_fechacheque,
          @@verPendiente  = bcoc_verpendientes

  from BancoConciliacion 

  where bcoc_id = @@bcoc_id

  --/////////////////////////////////////////////////////////////////////////////////////////////////////

  create table #t_Banco ( asi_id int)

  insert into #t_Banco 

    select   
            asi.asi_id
    
    from bancoconciliacionitem b inner join bancoconciliacion bcoc on b.bcoc_id = bcoc.bcoc_id
    
            left join FacturaVenta   fv       on b.comp_id = fv.fv_id     and b.doct_id = fv.doct_id
            left join FacturaCompra fc       on b.comp_id = fc.fc_id     and b.doct_id = fc.doct_id
            left join DepositoBanco dbco     on b.comp_id = dbco.dbco_id and b.doct_id = dbco.doct_id
            left join MovimientoFondo mf     on b.comp_id = mf.mf_id     and b.doct_id = mf.doct_id
            left join Cobranza cobz         on b.comp_id = cobz.cobz_id and b.doct_id = cobz.doct_id
            left join OrdenPago opg         on b.comp_id = opg.opg_id   and b.doct_id = opg.doct_id
            left join DepositoCupon dcup     on b.comp_id = dcup.dcup_id and b.doct_id = dcup.doct_id
            left join ResolucionCupon rcup   on b.comp_id = rcup.rcup_id and b.doct_id = rcup.doct_id
            left join Asiento ast           on b.comp_id = ast.as_id     and b.doct_id = ast.doct_id
    
            left join Asiento ast2           on     fv.as_id     = ast2.as_id
                                              or   fc.as_id     = ast2.as_id
                                              or   dbco.as_id   = ast2.as_id
                                              or   mf.as_id     = ast2.as_id
                                              or   cobz.as_id   = ast2.as_id
                                              or   opg.as_id   = ast2.as_id
                                              or   dcup.as_id   = ast2.as_id
                                              or   rcup.as_id   = ast2.as_id
                                              or   ast.as_id   = ast2.as_id
    
            left join AsientoItem asi       on   ast2.as_id = asi.as_id 
                                            and asi.cue_id = bcoc.cue_id
                                            and asi.asi_conciliado <> b.bcoci_estado
                                            and (asi.asi_debe - asi.asi_haber) = (bcoci_debe - bcoci_haber)
    
    where b.bcoc_id = @@bcoc_id
      and not exists(
                        select * from asientoitem where asi_id = b.asi_id and asi_debe = bcoci_debe and asi_haber = bcoci_haber
                    )

  --/////////////////////////////////////////////////////////////////////////////////////////////////

  delete #t_Banco where asi_id is null

  --/////////////////////////////////////////////////////////////////////////////////////////////////

    select   
            1 as aux_id,
            ast2.as_id    as AsId, 
            b.asi_id      as AsiId,

            '0 - Conciliacion guardada' as Tipo,

            bcoci_descrip,
            ast2.as_doc_cliente,
            bcoci_debe, 
            bcoci_haber, 

            case when bcoci_estado = 2 then 'Conciliado'
                 else                       'Pendiente'
            end bcoci_estado,

            '' as dummy_column,
            ast2.as_id    as AsId_Item,
            ast2.as_nrodoc, 
            asi.asi_debe, 
            asi.asi_haber,
            case when  asi.asi_conciliado is null then 'Borrados'
                 else                                 'Modificados'
            end as asi_conciliado,
            cheq_numerodoc
    
    from bancoconciliacionitem b inner join bancoconciliacion bcoc on b.bcoc_id = bcoc.bcoc_id
    
            left join FacturaVenta   fv       on b.comp_id = fv.fv_id     and b.doct_id = fv.doct_id
            left join FacturaCompra fc       on b.comp_id = fc.fc_id     and b.doct_id = fc.doct_id
            left join DepositoBanco dbco     on b.comp_id = dbco.dbco_id and b.doct_id = dbco.doct_id
            left join MovimientoFondo mf     on b.comp_id = mf.mf_id     and b.doct_id = mf.doct_id
            left join Cobranza cobz         on b.comp_id = cobz.cobz_id and b.doct_id = cobz.doct_id
            left join OrdenPago opg         on b.comp_id = opg.opg_id   and b.doct_id = opg.doct_id
            left join DepositoCupon dcup     on b.comp_id = dcup.dcup_id and b.doct_id = dcup.doct_id
            left join ResolucionCupon rcup   on b.comp_id = rcup.rcup_id and b.doct_id = rcup.doct_id
            left join Asiento ast           on b.comp_id = ast.as_id     and b.doct_id = ast.doct_id
    
            left join Asiento ast2           on     fv.as_id     = ast2.as_id
                                              or   fc.as_id     = ast2.as_id
                                              or   dbco.as_id   = ast2.as_id
                                              or   mf.as_id     = ast2.as_id
                                              or   cobz.as_id   = ast2.as_id
                                              or   opg.as_id   = ast2.as_id
                                              or   dcup.as_id   = ast2.as_id
                                              or   rcup.as_id   = ast2.as_id
                                              or   ast.as_id   = ast2.as_id
    
            left join AsientoItem asi       on   ast2.as_id = asi.as_id 
                                            and asi.cue_id = bcoc.cue_id
                                            and asi.asi_conciliado <> b.bcoci_estado
                                            and (asi.asi_debe - asi.asi_haber) = (bcoci_debe - bcoci_haber)

            left join Cheque cheq       on asi.cheq_id = cheq.cheq_id
    
    where b.bcoc_id = @@bcoc_id
      and not exists(
                        select * from asientoitem where asi_id = b.asi_id and asi_debe = bcoci_debe and asi_haber = bcoci_haber
                    )

  union all

--/////////////////////////////////////////////////////////////////////////////////////////////////////

    select  
            1 as aux_id,
            null   as_id, 
            asi2.asi_id,

            '1 Estado de la cuenta Hoy' as tipo,

            null   bcoci_descrip,
            null   as_doc_cliente,
            null   bcoci_debe, 
            null   bcoci_haber, 
            case when asi2.asi_conciliado = 2 then 'Conciliado'
                 else                              'Pendiente'
            end bcoci_estado,

            '' as dummy_column,
            asi2.as_id,
            ast3.as_nrodoc, 
            asi2.asi_debe, 
            asi2.asi_haber,

            case when  asi_conciliado = 2 then 'Conciliado'
                 else                             'Pendiente'
            end as asi_conciliado,
            cheq_numerodoc
  
    from Asiento ast3 inner join AsientoItem asi2 on     asi2.cue_id = @@cue_id 
                                                    and ast3.as_id  = asi2.as_id
  
                     left join Cheque cheq       on asi2.cheq_id = cheq.cheq_id
    where 
        (
          -- Conciliados pendientes y rechazados del periodo
          --
              (as_fecha between @@fdesde and @@fhasta and (@@fechaCobro = 0 or cheq_fechacobro is null))
          or  (isnull(cheq_fecha2,'19000101') between @@fdesde and @@fhasta and @@fechaCobro <> 0)

          -- Todos los pendientes hasta fecha hasta si @@verPendiente <> 0

          or  (      asi_conciliado <> 2 
                and (
                          (as_fecha <= @@fhasta and (@@fechaCobro = 0 or cheq_fechacobro is null))
                      or  (isnull(cheq_fecha2,'19000101') <= @@fhasta and @@fechaCobro <> 0)
                    )
              )
        )

    and asi2.asi_id not in
    (
      select asi_id from #t_Banco
    )

    and asi2.asi_id not in(
      select asi_id 
      from bancoconciliacionitem 
      where   bcoc_id = @@bcoc_id 
        and asi_debe  = bcoci_debe 
        and asi_haber = bcoci_haber
    )

  order by tipo, ast2.as_id


--select asi_id from #t_Banco where asi_id = 2238



end
GO