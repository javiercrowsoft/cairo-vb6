select 'update ' + s.name + ' set '+c.name+' = @@cue_id_replace where '+c.name+' = @@cue_id_find '
from sysobjects s inner join syscolumns c on s.id = c.id
where c.name like '%cue_id%'
 and s.xtype = 'u' and s.name not like '%tmp%'
