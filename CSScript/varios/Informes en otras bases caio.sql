select 'use ' + convert(sysname,d.name) 
				+ char(13) 
				+ ' go' 
				+ char(13) 
				+ 'select '''+convert(sysname,d.name)+''''
				+ char(13) 
				+ 'select * from informe where inf_codigo not in (select inf_codigo from cairo..informe) and left(inf_codigo,1)=''D'' '
				+ char(13) 
				+ ' go' 
from master.dbo.sysdatabases d
where d.name not in('model','master','msdb','tempdb')	
order by 1
