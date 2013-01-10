--Actualiza la carpeta de imagenes

select pr_webimagefolder,marc_nombre,rubti_nombre 
from producto pr left join marca marc on pr.marc_id = marc.marc_id
                 left join rubrotablaitem rubti on pr.rubti_id3 = rubti.rubti_id
where exists (select * from CatalogoWebItem where pr_id = pr.pr_id and catw_id = 3)
and rub_id <> 42


begin tran

  update producto set pr_webimagefolder = '\'+marc_nombre + '\' +rubti_nombre
  from 
  marca marc, rubrotablaitem rubti 
  where producto.marc_id = marc.marc_id
    and producto.rubti_id3 = rubti.rubti_id
    and exists (select * from CatalogoWebItem where pr_id = producto.pr_id and catw_id = 3)
    and producto.rub_id <> 42
  
  select pr_webimagefolder,marc_nombre,rubti_nombre 
  from producto pr left join marca marc on pr.marc_id = marc.marc_id
                   left join rubrotablaitem rubti on pr.rubti_id3 = rubti.rubti_id
  where exists (select * from CatalogoWebItem where pr_id = pr.pr_id and catw_id = 3)
  and rub_id <> 42

rollback tran