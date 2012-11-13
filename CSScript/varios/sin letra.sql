--select * from talonario order by ta_mascara
update talonario set ta_mascara = 'B-'+ta_mascara where ta_id = 55
--update facturaventa set fv_nrodoc = 'B-'+fv_nrodoc where isnumeric(substring(fv_nrodoc,1,1))<>0

select fv_id,fv_nrodoc from facturaventa
where isnumeric(substring(fv_nrodoc,1,1))<>0
and 'B-'+fv_nrodoc in (select fv_nrodoc from facturaventa)

--update facturaventa set fv_nrodoc = fv_nrodoc+'z' where fv_id in (2217,2336)

