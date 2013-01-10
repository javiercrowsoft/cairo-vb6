select 'use ' + convert(sysname,d.name) 
        + char(13) 
        + ' go' 
        + char(13) 
        + 'backup log ' + convert(sysname,d.name) + ' with truncate_only'
        + char(13)
        + ' go' 
        + char(13)
        + 'exec sp_force_shrink_log '
        + char(13) 
        + ' go' 
from master.dbo.sysdatabases d
where d.name not in('model','master','msdb','tempdb')  
order by 1