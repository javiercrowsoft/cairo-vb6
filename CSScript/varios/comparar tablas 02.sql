select * from sysobjects where name not in
(
select name from cairo..sysobjects 
)and xtype = 'u'

select o.name,c.name from syscolumns c, sysobjects o where c.name not in
(
select name from cairo..syscolumns
)and o.xtype = 'u'
and c.id = o.id
order by o.name

