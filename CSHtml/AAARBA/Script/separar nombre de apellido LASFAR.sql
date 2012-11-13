update aaba_sociolasfar set aabasocl_apellido = substring(aabasocl_nombre,1,charindex(',',aabasocl_nombre,1)-1) where charindex(',',aabasocl_nombre,1)>0
update aaba_sociolasfar set aabasocl_nombre   = ltrim(substring(aabasocl_nombre,charindex(',',aabasocl_nombre,1)+1,100)) where charindex(',',aabasocl_nombre,1)>0

-- update aaba_sociolasfar set aabasocl_nombre   =aabasocl_descrip   
-- update aaba_sociolasfar set aabasocl_codigo   =aabasocl_id   