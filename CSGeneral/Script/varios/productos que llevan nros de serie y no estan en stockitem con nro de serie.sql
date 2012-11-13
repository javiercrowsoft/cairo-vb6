select distinct emp_nombre,st_fecha,

                (
                  case doct_id_cliente -- select * from documentotipo
                        when 1  then (select doc_nombre from FacturaVenta f  inner join Documento d on f.doc_id = d.doc_id and f.fv_id  = s.id_cliente)
                        when 3  then (select doc_nombre from RemitoVenta r   inner join Documento d on r.doc_id = d.doc_id and r.rv_id  = s.id_cliente)
                        when 7  then (select doc_nombre from FacturaVenta f  inner join Documento d on f.doc_id = d.doc_id and f.fv_id  = s.id_cliente)
                        when 2  then (select doc_nombre from FacturaCompra f inner join Documento d on f.doc_id = d.doc_id and f.fc_id  = s.id_cliente)
                        when 4  then (select doc_nombre from RemitoCompra r  inner join Documento d on r.doc_id = d.doc_id and r.rc_id  = s.id_cliente)
                        when 8  then (select doc_nombre from FacturaCompra f inner join Documento d on f.doc_id = d.doc_id and f.fc_id  = s.id_cliente)
                        when 28 then (select doc_nombre from RecuentoStock r inner join Documento d on r.doc_id = d.doc_id and r.rs_id  = s.id_cliente)
                        when 30 then (select doc_nombre + ' ' + ppk_nrodoc from ParteProdKit p  inner join Documento d on p.doc_id = d.doc_id and p.ppk_id = s.id_cliente)  
                  end
                )
                as doc_nombre,
                st_doc_cliente,pr_nombrecompra


from stock s inner join documento d       on s.doc_id  = d.doc_id
             inner join empresa e         on d.emp_id  = e.emp_id
             inner join stockitem si2     on s.st_id   = si2.st_id
             inner join producto p        on si2.pr_id = p.pr_id



where exists (
select st_id

from stockitem si inner join producto p    on si.pr_id = p.pr_id 
                  inner join producto p2   on si.pr_id_kit = p2.pr_id

where prns_id is null 
  and p.pr_llevanroserie<>0 
  and si.st_id   = s.st_id
  and si.sti_id  = si2.sti_id
  and si.pr_id   = si2.pr_id

group by emp_nombre,doc_nombre,p2.pr_nombrecompra, p.pr_nombrecompra, p2.pr_id, p.pr_id,st_id

)order by emp_nombre,st_fecha,doc_nombre,st_doc_cliente,pr_nombrecompra

--select pr_id,pr_nombrecompra,pr_codigo from producto where pr_llevanroserie = 0 and pr_eskit <>0 order by 1
