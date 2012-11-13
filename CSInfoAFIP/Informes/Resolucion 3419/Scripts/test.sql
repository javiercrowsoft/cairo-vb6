select top 10 comp2 from exp3419

alter table  exp3419 add comp2 varchar(15)
update exp3419 set comp2 = substring(comp,5,20)

select * from strad where comp not in (select comp2 from exp3419)