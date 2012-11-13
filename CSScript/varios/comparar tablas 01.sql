select * from sysobjects where name not in
(
select name from cairoenvios..sysobjects 
)and xtype = 'u'

select o.name,c.name from syscolumns c, sysobjects o where c.name not in
(
select cc.name from cairoenvios..syscolumns cc inner join cairoenvios..sysobjects t on cc.id = t.id where t.name = o.name
)and o.xtype = 'u'
and c.id = o.id
order by o.name