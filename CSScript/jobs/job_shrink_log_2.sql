/*

Plantilla de shrink del log

Reemplazar __database_name__ por el nombre de la base de datos usando
search and replace (el famoso ctrl+H)


*/

BEGIN TRANSACTION            
  DECLARE @JobID BINARY(16)  
  DECLARE @ReturnCode INT    
  SELECT @ReturnCode = 0     
IF (SELECT COUNT(*) FROM msdb.dbo.syscategories WHERE name = N'Database Maintenance') < 1 
  EXECUTE msdb.dbo.sp_add_category @name = N'Database Maintenance'

  -- Delete the job with the same name (if it exists)
  SELECT @JobID = job_id     
  FROM   msdb.dbo.sysjobs    
  WHERE (name = N'Shrink Log 2')       
  IF (@JobID IS NOT NULL)    
  BEGIN  
  -- Check if the job is a multi-server job  
  IF (EXISTS (SELECT  * 
              FROM    msdb.dbo.sysjobservers 
              WHERE   (job_id = @JobID) AND (server_id <> 0))) 
  BEGIN 
    -- There is, so abort the script 
    RAISERROR (N'Unable to import job ''Shrink Log 2'' since there is already a multi-server job with this name.', 16, 1) 
    GOTO QuitWithRollback  
  END 
  ELSE 
    -- Delete the [local] job 
    EXECUTE msdb.dbo.sp_delete_job @job_name = N'Shrink Log 2' 
    SELECT @JobID = NULL
  END 

BEGIN 

  -- Add the job
  EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_id = @JobID OUTPUT , 
					@job_name = N'Shrink Log 2', 
					@owner_login_name = N'sa', 
					@description = N'No description available.', 
					@category_name = N'Database Maintenance', 
					@enabled = 1, 
					@notify_level_email = 0, 
					@notify_level_page = 0, 
					@notify_level_netsend = 0, 
					@notify_level_eventlog = 2, 
					@delete_level= 0
					
  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- Add the job steps
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, 
					@step_id = 1, 
					@step_name = N'Paso_0', 
					@command = N'declare @db         sysname, 
				@sqlstmt		varchar(5000),
				@log_size   decimal(15,2)

select  @db = db_name()

create table #loginfo ( 
    id          int identity, 
    FileId      int, 
    FileSize    numeric(22,0), 
    StartOffset numeric(22,0), 
    FSeqNo      int, 
    Status      int, 
    Parity      smallint, 
    CreateTime  varchar(255) 
)

insert  #loginfo ( FileId, FileSize, StartOffset, FSeqNo, Status, Parity, CreateTime ) exec ( ''dbcc loginfo'' )

select  @log_size = sum( FileSize ) / 1048576.00
from    #loginfo

if @log_size < 90 begin

	set @sqlstmt = ''ALTER DATABASE ''+@db+'' MODIFY FILE (NAME = Cairo_Log, SIZE = 100MB)''

	exec(@sqlstmt)

end

drop table #loginfo 
', 
					@database_name = N'__database_name__', 
					@server = N'', 
					@database_user_name = N'', 
					@subsystem = N'TSQL', 
					@cmdexec_success_code = 0, 
					@flags = 0, 
					@retry_attempts = 0, 
					@retry_interval = 0, 
					@output_file_name = N'', 
					@on_success_step_id = 0, 
					@on_success_action = 1, 
					@on_fail_step_id = 0, 
					@on_fail_action = 2

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 
  EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1 

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- Add the job schedules
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, 
					@name = N'Programacion_0', 
					@enabled = 1, 
					@freq_type = 4, 
					@active_start_date = 20070312, 
					@active_start_time = 233000, 
					@freq_interval = 1, 
					@freq_subday_type = 1, 
					@freq_subday_interval = 0, 
					@freq_relative_interval = 1, 
					@freq_recurrence_factor = 0, 
					@active_end_date = 99991231, 
					@active_end_time = 235959

  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

  -- Add the Target Servers
  EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'(local)' 
  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback 

END
COMMIT TRANSACTION          
GOTO   EndSave              
QuitWithRollback:
  IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION 
EndSave: 


