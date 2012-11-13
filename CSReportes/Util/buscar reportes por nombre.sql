
select inf_storedprocedure, inf_nombre  from informe where inf_id in (
select inf_id from reporte where rpt_nombre like '%iva%' or rpt_nombre like '%i.v.a.%'
)
