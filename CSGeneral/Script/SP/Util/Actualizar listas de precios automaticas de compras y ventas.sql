declare @doct_id int
declare @doc_id  int
declare @doc_fecha datetime

declare c_doc insensitive cursor for 
select distinct fc.fc_id, doct_id, fc_fecha 
from facturacompra fc inner join facturacompraitem fci on fc.fc_id = fci.fc_id
where fc_fecha in
(select max(fc_fecha) from facturacompraitem fci inner join facturacompra fc on fc.fc_id = fci.fc_id
where pr_id in (select pr_id 
								from listaprecioitem lpi inner join listaprecio lp on lpi.lp_id = lpi.lp_id
								where lp_autoXcompra <> 0
							)
group by pr_id
)
and pr_id in (select pr_id 
								from listaprecioitem lpi inner join listaprecio lp on lpi.lp_id = lpi.lp_id
								where lp_autoXcompra <> 0
							)
open c_doc

fetch next from c_doc into @doc_id, @doct_id, @doc_fecha
while @@fetch_status=0
begin

	exec sp_ListaPrecioSaveAuto @doc_id, @doct_id, 0, @doc_fecha

	fetch next from c_doc into @doc_id, @doct_id, @doc_fecha
end

close c_doc
deallocate c_doc

declare c_doc insensitive cursor for 
select distinct rc.rc_id, doct_id, rc_fecha 
from remitocompra rc inner join remitocompraitem rci on rc.rc_id = rci.rc_id
where rc_fecha in
(select max(rc_fecha) from remitocompraitem rci inner join remitocompra rc on rc.rc_id = rci.rc_id
where pr_id in (select pr_id 
								from listaprecioitem lpi inner join listaprecio lp on lpi.lp_id = lpi.lp_id
								where lp_autoXcompra <> 0
							)
group by pr_id
)
and pr_id in (select pr_id 
								from listaprecioitem lpi inner join listaprecio lp on lpi.lp_id = lpi.lp_id
								where lp_autoXcompra <> 0
							)
open c_doc

fetch next from c_doc into @doc_id, @doct_id, @doc_fecha
while @@fetch_status=0
begin

	exec sp_ListaPrecioSaveAuto @doc_id, @doct_id, 0, @doc_fecha

	fetch next from c_doc into @doc_id, @doct_id, @doc_fecha
end

close c_doc
deallocate c_doc

