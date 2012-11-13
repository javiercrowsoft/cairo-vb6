begin transaction

exec sp_docstocksave 114

rollback transaction

/*

select * from stockcache

select * from stock
select * from stockitem
select * from stocktmp

sp_docstockcachecreate 0

delete stockcache

delete stockitemtmp
delete stocktmp

delete stockitem
delete stock


update ImportacionTemp set st_id = null

update RecuentoStock set st_id1 = null
update RecuentoStock set st_id2 = null

update facturacompra set st_id = null
update remitocompra set st_id = null

update facturaventa set st_id = null
update remitoventa set st_id = null*/