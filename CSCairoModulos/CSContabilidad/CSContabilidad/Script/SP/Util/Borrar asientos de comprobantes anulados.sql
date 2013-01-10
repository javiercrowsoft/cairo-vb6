declare @as_id int
declare @fv_id int

declare c_ast insensitive cursor for select as_id, fv_id from facturaventa where est_id = 7

open c_ast


fetch next from c_ast into @as_id, @fv_id
while @@fetch_status=0
begin

  update facturaventa set as_id = null where fv_id = @fv_id

  exec sp_DocAsientoDelete @as_id

  fetch next from c_ast into @as_id, @fv_id
end

close c_ast
deallocate c_ast

declare @as_id int
declare @fc_id int

declare c_ast insensitive cursor for select as_id, fc_id from facturacompra where est_id = 7

open c_ast


fetch next from c_ast into @as_id, @fc_id
while @@fetch_status=0
begin

  update facturacompra set as_id = null where fc_id = @fc_id

  exec sp_DocAsientoDelete @as_id

  fetch next from c_ast into @as_id, @fc_id
end

close c_ast
deallocate c_ast


declare @as_id int
declare @opg_id int

declare c_ast insensitive cursor for select as_id, opg_id from ordenpago where est_id = 7

open c_ast


fetch next from c_ast into @as_id, @opg_id
while @@fetch_status=0
begin

  update ordenpago set as_id = null where opg_id = @opg_id

  exec sp_DocAsientoDelete @as_id

  fetch next from c_ast into @as_id, @opg_id
end

close c_ast
deallocate c_ast

declare @as_id int
declare @cobz_id int

declare c_ast insensitive cursor for select as_id, cobz_id from Cobranza where est_id = 7

open c_ast


fetch next from c_ast into @as_id, @cobz_id
while @@fetch_status=0
begin

  update Cobranza set as_id = null where cobz_id = @cobz_id

  exec sp_DocAsientoDelete @as_id

  fetch next from c_ast into @as_id, @cobz_id
end

close c_ast
deallocate c_ast

declare @as_id int
declare @dbco_id int

declare c_ast insensitive cursor for select as_id, dbco_id from DepositoBanco where est_id = 7

open c_ast


fetch next from c_ast into @as_id, @dbco_id
while @@fetch_status=0
begin

  update DepositoBanco set as_id = null where dbco_id = @dbco_id

  exec sp_DocAsientoDelete @as_id

  fetch next from c_ast into @as_id, @dbco_id
end

close c_ast
deallocate c_ast

declare @as_id int
declare @mf_id int

declare c_ast insensitive cursor for select as_id, mf_id from MovimientoFondo where est_id = 7

open c_ast


fetch next from c_ast into @as_id, @mf_id
while @@fetch_status=0
begin

  update MovimientoFondo set as_id = null where mf_id = @mf_id

  exec sp_DocAsientoDelete @as_id

  fetch next from c_ast into @as_id, @mf_id
end

close c_ast
deallocate c_ast