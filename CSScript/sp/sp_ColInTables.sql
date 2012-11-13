-- sp_ColInTables '%prns_id%'

alter procedure sp_ColInTables (

@@name varchar(255)

) as

begin

select o.name, c.name from sysobjects o inner join syscolumns c on o.id = c.id and o.xtype = 'U' and c.name like @@name

end