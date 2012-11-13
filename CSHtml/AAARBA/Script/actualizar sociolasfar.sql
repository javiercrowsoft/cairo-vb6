--select aabasocl_nombre from aaba_sociolasfar soc inner join aaba_asociacion asoc on soc.aabasocl_asociacion = asoc.aabaasoc_nombre

update aaba_sociolasfar set aabaasoc_id = asoc.aabaasoc_id

from aaba_asociacion asoc where aaba_sociolasfar.aabasocl_asociacion = asoc.aabaasoc_nombre

--select * from aaba_sociolasfar where aabaasoc_id = 5