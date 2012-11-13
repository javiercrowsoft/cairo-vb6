select opgi.opg_id,opg_nrodoc,opgi_id,opgi_fecharetencion,opgi_nroretencion,opgi_importe,opgi_descrip,opgi_porcretencion 
from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id 
where ret_id in (8,9)

--sp_col ordenpagoitem