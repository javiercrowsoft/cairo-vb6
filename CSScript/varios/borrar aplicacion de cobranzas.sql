declare @cobz_id 			int
declare @cobztmp_id 	int
declare @doc_id       int
declare @cli_id       int
declare @suc_id       int
declare @est_id       int
declare @cobz_numero  int

declare c_cobtodel insensitive cursor for select cobz_id, doc_id, cli_id, suc_id, est_id, 
																								 cobz_numero
from cobranza where doc_id in (107,113,114)
open c_cobtodel
fetch next from c_cobtodel into @cobz_id, @doc_id, @cli_id, @suc_id, @est_id, @cobz_numero
while @@fetch_status=0
begin

	exec sp_dbgetnewid 'CobranzaTMP','cobztmp_id',@cobztmp_id out, 0

	insert into cobranzatmp (cobztmp_id,cobz_id,doc_id,cli_id,suc_id,est_id,cobz_numero,modifico) 
	values(@cobztmp_id,@cobz_id,@doc_id,@cli_id,@suc_id,@est_id,@cobz_numero,1)

	exec sp_DocCobranzaSaveAplic @cobztmp_id,0,0,1

	fetch next from c_cobtodel into @cobz_id, @doc_id, @cli_id, @suc_id, @est_id, @cobz_numero
end
close c_cobtodel
deallocate c_cobtodel


-- select cobz_pendiente,cobz_total
-- from cobranza where doc_id in (107,113,114)

