select 

fc_fecha,fc_nrodoc,doc_id,

round( fc_total - (fc_ivari + fc_neto + fc_totalotros +  fc_totalpercepciones),2),

 fc_total,fc_ivari + fc_neto + fc_totalotros +  fc_totalpercepciones, fc_ivari, fc_neto, fc_totalotros, fc_totalpercepciones from facturacompra fc

where abs(fc_total - (fc_ivari + fc_neto + fc_totalotros +  fc_totalpercepciones))>0.01

