update aaba_socio set aabasoc_nombre   = ltrim(substring(aabasoc_descrip,charindex(',',aabasoc_descrip,1)+1,100)) where charindex(',',aabasoc_descrip,1)>0
update aaba_socio set aabasoc_apellido = substring(aabasoc_descrip,1,charindex(',',aabasoc_descrip,1)-1) where charindex(',',aabasoc_descrip,1)>0

update aaba_socio set aabasoc_nombre   = ltrim(substring(aabasoc_descrip,charindex(' ',aabasoc_descrip,1)+1,100)) where charindex(',',aabasoc_descrip,1)=0
update aaba_socio set aabasoc_apellido = substring(ltrim(aabasoc_descrip),1,charindex(' ',ltrim(aabasoc_descrip),1)-1) where charindex(' ',ltrim(aabasoc_descrip),1)>0 and charindex(',',aabasoc_descrip,1)=0

select * from aaba_socio  where charindex(',',aabasoc_descrip,1)=0

select * from aaba_socio  where aabasoc_apellido = ''

select * from aaba_socio

update aaba_socio set aabasoc_documento = docu_tipo + ' ' + convert(varchar,docu_nume) from  aaarbaweb..medicos where aabasoc_id = medico
update aaba_socio set aabasoc_documento = ltrim(aabasoc_documento)
update aaba_socio set aabasoc_documento = upper(aabasoc_documento)

select * from aaarbaweb..medicos