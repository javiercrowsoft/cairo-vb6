-- Saldo FC OP y Contabilidad

declare @haber decimal(18,6)
declare @debe  decimal(18,6)
declare @deuda decimal(18,6)
declare @pagos decimal(18,6)
declare @saldo decimal(18,6)

select @deuda = sum(case fc.doct_id when 8 then -fc_total else fc_total end) 
from facturacompra fc inner join documento doc on fc.doc_id = doc.doc_id and doc.cico_id = 1
where fc_fecha between '20050101' and '20051231' and est_id <> 7
--where fc_fecha < '20051231' and est_id <> 7
and emp_id = 2
--and doc.cico_id = 1

select @pagos = sum(opg_total) 
from ordenpago opg inner join documento doc on opg.doc_id = doc.doc_id and doc.cico_id = 1
where opg_fecha between '20050101' and '20051231' and est_id <> 7
--where opg_fecha < '20051231' and est_id <> 7
and opg.emp_id = 2
--and doc.cico_id = 1

select @saldo = sum(asi_debe)-sum(asi_haber), @debe = sum(asi_debe), @haber = sum(asi_haber) 
from asientoitem asi  inner join asiento ast on asi.as_id = ast.as_id
                      inner join documento doc on isnull(ast.doc_id_cliente,ast.doc_id) = doc.doc_id
where cue_id in (
                  select cue_id from cuenta 
                  where --cue_nombre like '%acree%'
                        cuec_id = 8
                )
and as_fecha between '20050101' and '20051231'
and cico_id = 1
and doc.emp_id = 2
and doct_id_cliente in (2,8,10,16)
and doct_id_cliente is not null

select @deuda as Deuda, 
       @pagos as Pagos, 
       @deuda-@pagos as saldo, 
       @deuda-@pagos+@saldo as diferencia,
       @saldo as 'saldo contable',
       @debe   as debe,
       @haber as haber

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------


-- Con FC ni OP

select doct_id_cliente, doct_nombre, cue_nombre as cuenta, sum(asi_debe)-sum(asi_haber) as saldo
from asientoitem asi  inner join asiento ast on asi.as_id = ast.as_id
                      inner join documento doc on isnull(ast.doc_id_cliente,ast.doc_id) = doc.doc_id
                      inner join cuenta cue on asi.cue_id = cue.cue_id
                      left join documentotipo doct on isnull(ast.doct_id_cliente,ast.doct_id) = doct.doct_id
where asi.cue_id in (
                  select cue_id from cuenta 
                  where --cue_nombre like '%acree%'
                        cuec_id = 8
                )
and as_fecha between '20050101' and '20051231'
and cico_id = 1
and doc.emp_id = 2
and isnull(doct_id_cliente,0) in (2,8,10,16)
and doct_id_cliente is not null

group by doct_id_cliente, doct_nombre, cue_nombre

-- Idem pero solo agrupado por cuenta

select cue_nombre as cuenta, sum(asi_debe)-sum(asi_haber) as saldo
from asientoitem asi  inner join asiento ast on asi.as_id = ast.as_id
                      inner join documento doc on isnull(ast.doc_id_cliente,ast.doc_id) = doc.doc_id
                      inner join cuenta cue on asi.cue_id = cue.cue_id
                      left join documentotipo doct on isnull(ast.doct_id_cliente,ast.doct_id) = doct.doct_id
where asi.cue_id in (
                  select cue_id from cuenta 
                  where --cue_nombre like '%acree%'
                        cuec_id = 8
                )
and as_fecha between '20050101' and '20051231'
and cico_id = 1
and doc.emp_id = 2
and isnull(doct_id_cliente,0) in (2,8,10,16)
and doct_id_cliente is not null

group by cue_nombre


------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------


-- Sin FC ni OP

select doct_id_cliente, doc_id_cliente, doct_nombre, cue_nombre as cuenta, sum(asi_debe)-sum(asi_haber) as saldo
from asientoitem asi  inner join asiento ast on asi.as_id = ast.as_id
                      inner join documento doc on isnull(ast.doc_id_cliente,ast.doc_id) = doc.doc_id
                      inner join cuenta cue on asi.cue_id = cue.cue_id
                      left join documentotipo doct on isnull(ast.doct_id_cliente,ast.doct_id) = doct.doct_id
where asi.cue_id in (
                  select cue_id from cuenta 
                  where --cue_nombre like '%acree%'
                        cuec_id = 8
                )
and as_fecha between '20050101' and '20051231'
and cico_id = 1
and doc.emp_id = 2
and isnull(doct_id_cliente,0) not in (2,8,10,16)
--and doct_id_cliente is not null

group by doct_id_cliente, doc_id_cliente, doct_nombre, cue_nombre


-- Sin FC ni OP Detallado

select as_fecha, as_numero, as_nrodoc, cue_nombre, asi_debe, asi_haber, as_descrip, us_nombre
from asientoitem asi  inner join asiento ast on asi.as_id = ast.as_id
                      inner join documento doc on isnull(ast.doc_id_cliente,ast.doc_id) = doc.doc_id
                      inner join cuenta cue on asi.cue_id = cue.cue_id
                      left join documentotipo doct on isnull(ast.doct_id_cliente,ast.doct_id) = doct.doct_id
                      inner join usuario us on ast.modifico = us.us_id
where asi.cue_id in (
                  select cue_id from cuenta 
                  where --cue_nombre like '%acree%'
                        cuec_id = 8
                )
and as_fecha between '20050101' and '20051231'
and cico_id = 1
and doc.emp_id = 2
and isnull(doct_id_cliente,0) not in (2,8,10,16)


select asi.cue_id, as_fecha, as_numero, as_nrodoc, cue_nombre, asi_debe, asi_haber, as_descrip, us_nombre
from asientoitem asi  inner join asiento ast on asi.as_id = ast.as_id
                      inner join documento doc on isnull(ast.doc_id_cliente,ast.doc_id) = doc.doc_id
                      inner join cuenta cue on asi.cue_id = cue.cue_id
                      left join documentotipo doct on isnull(ast.doct_id_cliente,ast.doct_id) = doct.doct_id
                      inner join usuario us on ast.modifico = us.us_id
where asi.as_id = 89993


select * from cuenta where cue_id = 227

select * from cuentacategoria where cuec_id = 3