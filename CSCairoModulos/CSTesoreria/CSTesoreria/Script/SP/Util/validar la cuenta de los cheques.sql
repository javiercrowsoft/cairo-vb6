select * from cheque 
where cue_id <> (select cue_id from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id
                  where opgi_id = (select max(opgi_id) from ordenpagoitem where cheq_id = cheque.cheq_id)
                    and est_id <> 7
                )

select * from cheque 
where cue_id <> (select cue_id from movimientofondoitem where 
                  mfi_id = (select max(mfi_id) from movimientofondoitem where cheq_id = cheque.cheq_id)
                )


select * from cheque 
where cue_id is not null
and exists(select cue_id from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id
                  where opgi_id = (select max(opgi_id) from ordenpagoitem where cheq_id = cheque.cheq_id)              
            and est_id <> 7
                )


-- update cheque set cue_id = null where cheq_id in (
-- 
-- select cheq_id from cheque 
-- where cue_id is not null
-- and exists(select cue_id from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id
--                   where opgi_id = (select max(opgi_id) from ordenpagoitem where cheq_id = cheque.cheq_id)              
--             and est_id <> 7
--                 )
-- 
-- 
-- )