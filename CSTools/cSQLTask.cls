VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLTask"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cSQLTask
' 17-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSQLTask"

Private Const c_task_section = "TASK"
Private Const c_schedule_section = "TASK_SCHEDULES"
Private Const c_step_section = "TASK_STEPS"

Private Const c_task_name = "NAME"
Private Const c_task_category = "CATEGORY"

Private Const c_step_count = "COUNT"
Private Const c_step_name = "NAME_"
Private Const c_step_command = "COMMAND_"
Private Const c_step_database = "DATABASE_"

Private Const c_schedule_count = "COUNT"
Private Const c_schedule_Name = "NAME_"
Private Const c_schedule_FirtsRunStartAt = "FIRST_RUN_START_AT_"
Private Const c_schedule_LastRunEndAt = "LAST_RUN_END_AT_"
Private Const c_schedule_TimeEnd = "TIME_END_"
Private Const c_schedule_TimeStart = "TIME_START_"
Private Const c_schedule_RunEach = "RUN_EACH_"
Private Const c_schedule_TypeTime = "TYPE_TIME_"
Private Const c_schedule_RunEachType = "RUN_EACH_TYPE_"
Private Const c_schedule_TypeRun = "TYPE_RUN_"
Private Const c_schedule_Time = "TIME_"
Private Const c_schedule_RunDailyInterval = "RUN_DAILY_INTERVAL_"
Private Const c_schedule_RunWeeklyInterval = "RUN_WEEKLY_INTERVAL_"
Private Const c_schedule_RunSunday = "RUN_SUNDAY_"
Private Const c_schedule_RunMonday = "RUN_MONDAY_"
Private Const c_schedule_RunTuesday = "RUN_TUESDAY_"
Private Const c_schedule_RunWednesday = "RUN_WEDNESDAY_"
Private Const c_schedule_RunThursday = "RUN_THURSDAY_"
Private Const c_schedule_RunFriday = "RUN_FIRDAY_"
Private Const c_schedule_RunSaturday = "RUN_SATURDAY_"
Private Const c_schedule_RunMonthlyNumberDay = "RUN_MONTHLY_NUMBER_DAY_"
Private Const c_schedule_RunMonthlyInterval = "RUN_MONTHLY_INTERVAL_"
Private Const c_schedule_RunMonthlyCardinalDay = "RUN_MONTHLY_CARDINAL_DAY_"
Private Const c_schedule_RunMonthlyNameDay = "RUN_MONTHLY_NAME_DAY_"

' estructuras
' variables privadas
Private m_Connection                    As cConnection
Private m_Schedules                     As cSQLTaskSchedules
Private m_Steps                         As cSQLTaskSteps
Private m_TaskType                      As csScheduleTaskType
Private m_Name                          As String
Private m_Id                            As String
Private m_Category                      As String
Private m_MngMacro                      As cMngMacro

Private m_FileTemp        As String
' eventos
' propiedadades publicas
Public Property Get TaskType() As csScheduleTaskType
   TaskType = m_TaskType
End Property

Public Property Let TaskType(ByVal rhs As csScheduleTaskType)
   m_TaskType = rhs
End Property

Public Property Get Schedules() As cSQLTaskSchedules
   Set Schedules = m_Schedules
End Property

Public Property Set Schedules(ByRef rhs As cSQLTaskSchedules)
   Set m_Schedules = rhs
End Property

Public Property Get Steps() As cSQLTaskSteps
   Set Steps = m_Steps
End Property

Public Property Set Steps(ByRef rhs As cSQLTaskSteps)
   Set m_Steps = rhs
End Property

Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Id() As String
   Id = m_Id
End Property

Public Property Let Id(ByVal rhs As String)
   m_Id = rhs
End Property

Public Property Get Category() As String
   Category = m_Category
End Property

Public Property Let Category(ByVal rhs As String)
   m_Category = rhs
End Property

' propiedadades friend
Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property

Friend Property Get MngMacro() As cMngMacro
   Set MngMacro = m_MngMacro
End Property

Friend Property Set MngMacro(ByVal rhs As cMngMacro)
   Set m_MngMacro = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Delete(ByVal JobName As String) As Boolean
  On Error GoTo ControlError
  
  If JobName = "" Then Exit Function
  
  Dim jb As SQLDMO.Job
  Set jb = GetJobByName(JobName)
  
  If Not jb Is Nothing Then
    
    jb.Remove
    m_Connection.Server.JobServer.Jobs.Refresh
  End If
  
  Delete = True

  GoTo ExitProc
ControlError:
  MngError Err, "Delete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function LoadFromIni(ByVal IniFile As String) As Boolean
  On Error GoTo ControlError

  If Not FileExists(IniFile) Then Exit Function
  
  Dim IniTempOld As String
  IniTempOld = m_FileTemp
  
  m_FileTemp = IniFile
  
  m_Name = GetIniTempTask(c_task_name, "")
  m_Category = GetIniTempTask(c_task_category, "")
  
  LoadStepsFromIni
  LoadSchedulesFromIni

  LoadFromIni = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadFromIni", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_FileTemp = IniTempOld
End Function

Public Function LoadJob(ByVal JobName As String) As Boolean
  On Error GoTo ControlError
  
  Dim jb As SQLDMO.Job
  
  For Each jb In m_Connection.Server.JobServer.Jobs
    If jb.Name = JobName Then Exit For
  Next
  
  If jb Is Nothing Then Exit Function
  
  m_Name = jb.Name
  m_Id = jb.JobId
  m_Category = jb.Category
  
  LoadJobSchedules jb
  LoadJobSteps jb
  LoadJob = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadJob", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function SaveScript(ByVal FileName As String) As Boolean
  On Error GoTo ControlError
  
  Dim Script As String
  Dim f As Integer
  
  If Not FileDelete(FileName) Then Exit Function
  
  Script = GetScriptTask
  
  f = FreeFile
  Open FileName For Output Access Write As f
  
  Print #f, Script
  
  SaveScript = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "SaveScript", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Close f
End Function

Public Function GetScriptTask() As String
  On Error GoTo ControlError
  
  SaveIniTempTask c_task_name, m_Name
  SaveIniTempTask c_task_category, m_Category
  
  GetScriptSteps
  GetScriptSchedules
  
  GetScriptTask = GetScriptFromIniTemp()
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetScriptTask", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function Save() As Boolean
  On Error GoTo ControlError
  
  Dim jb As SQLDMO.Job
  Dim AlterOpen  As Boolean
  
  If m_Id = "" Then
    Set jb = New SQLDMO.Job
    m_Connection.Server.JobServer.Jobs.Add jb
  Else
    Set jb = GetJobById(m_Id)
  End If
  
  jb.BeginAlter
  AlterOpen = True
  
  jb.Name = m_Name
  jb.Category = m_Category
  
  SetSteps jb
  SetSchedules jb
  
  jb.DoAlter
  AlterOpen = False
  
  If Not jb.HasServer Then jb.ApplyToTargetServer m_Connection.Server.Name
  
  Save = True

  GoTo ExitProc
ControlError:

  If Err.Number = -2147207235 Then '[Microsoft][ODBC SQL Server Driver][SQL Server]Job
                                   ''BckpLg_MAX_MASTER' is already targeted at server 'MESALINA'.
    ' Nada que hacer
  Else
    MngError Err, "Save", C_Module, ""
    
    If AlterOpen Then jb.CancelAlter
  End If
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones friend
' funciones privadas
Private Sub LoadStepsFromIni()
  On Error GoTo ControlError
  
  Dim stpscript As cSQLTaskCommandScript
  Dim i         As Integer
  
  '---------------------------------------
  ' Cargo los pasos desde el ini
  For i = 1 To Val(GetIniTempStp(c_step_count, "0"))
  
    Set stpscript = New cSQLTaskCommandScript
    m_Steps.Add stpscript
    
    stpscript.command = GetIniTempStp(c_step_command & i, "")
    stpscript.DataBase = GetIniTempStp(c_step_database & i, "")
    stpscript.Name = GetIniTempStp(c_step_name & i, "")
    
  Next
  
  GoTo ExitProc
ControlError:
  
  MngError Err, "LoadStepsFromIni", C_Module, ""
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Sub

Private Sub LoadSchedulesFromIni()
  On Error GoTo ControlError
  
  Dim sch   As cSQLTaskSchedule
  Dim i     As Integer
  
  '---------------------------------------
  ' carto las programaciones desde el ini
  For i = 1 To Val(GetIniTempStp(c_step_count, "0"))
    Set sch = m_Schedules.Add(Nothing)
    
    With sch
      '/////////////////////////////////////////////////////////
      ' Datos generales a toda programacion
      .Name = GetIniTempSch(c_schedule_Name & i, "")
      .FirtsRunStartAt = GetIniTempSch(c_schedule_FirtsRunStartAt & i, Now)
      .LastRunEndAt = GetIniTempSch(c_schedule_LastRunEndAt & i, csSchEndUndefined)
            
      '/////////////////////////////////////////////////////////
      ' De ocurrir mas de una vez, esta es la franja
      ' horaria
      .TimeEnd = GetIniTempSch(c_schedule_TimeEnd & i, #10:00:00 PM#)
      .TimeStart = GetIniTempSch(c_schedule_TimeStart & i, #6:00:00 AM#)
      
      '/////////////////////////////////////////////////////////
      ' Frecuencia - solo si ocurre mas de una vez
      .RunEach = GetIniTempSch(c_schedule_RunEach & i, "1")

      ' Aca se define si es por:
      '   - hora
      '   - minuto
      '   - o un momento determinado
      .TypeTime = GetIniTempSch(c_schedule_TypeTime & i, csSchTypeTimeRecurring)
      .RunEachType = GetIniTempSch(c_schedule_RunEachType & i, csSchEachTypeHour)
      '/////////////////////////////////////////////////////////

      ' Aca se divide entre :
      '   - Por unica vez
      '   - Diario
      '   - Semanl
      '   - Mensual
      '   - Mensual relativo
      .TypeRun = GetIniTempSch(c_schedule_TypeRun & i, csSchTypeRunDaily)
      
        '/////////////////////////////////////////////////////////
        ' Por unica vez
          .Time = GetIniTempSch(c_schedule_Time & i, Now)
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Diaria
          .RunDailyInterval = GetIniTempSch(c_schedule_RunDailyInterval & i, "1") ' Cada cuantos dias
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Semanal
          .RunWeeklyInterval = GetIniTempSch(c_schedule_RunWeeklyInterval & i, "1") ' Cada cuantas semanas
          
          ' Que dias
          .RunSunday = GetIniTempSch(c_schedule_RunSunday & i, "-1")
          .RunMonday = GetIniTempSch(c_schedule_RunMonday & i, "-1")
          .RunTuesday = GetIniTempSch(c_schedule_RunTuesday & i, "-1")
          .RunWednesday = GetIniTempSch(c_schedule_RunWednesday & i, "-1")
          .RunThursday = GetIniTempSch(c_schedule_RunThursday & i, "-1")
          .RunFriday = GetIniTempSch(c_schedule_RunFriday & i, "-1")
          .RunSaturday = GetIniTempSch(c_schedule_RunSaturday & i, "-1")
        '/////////////////////////////////////////////////////////
        
        
        '/////////////////////////////////////////////////////////
        ' Mensual
          .RunMonthlyNumberDay = GetIniTempSch(c_schedule_RunMonthlyNumberDay & i, "1") ' Que dia
          .RunMonthlyInterval = GetIniTempSch(c_schedule_RunMonthlyInterval & i, "1") ' Cada cuantos meses
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Mensual relativa
          .RunMonthlyInterval = GetIniTempSch(c_schedule_RunMonthlyInterval & i, "1") ' Cada cuantos meses
          
          ' Que cardinal
          .RunMonthlyCardinalDay = GetIniTempSch(c_schedule_RunMonthlyCardinalDay & i, csSchRunMonCard_1st)
          
          ' que dia
          .RunMonthlyNameDay = GetIniTempSch(c_schedule_RunMonthlyNameDay & i, csSchRunMonName_Saturday)
        '/////////////////////////////////////////////////////////
      
        '/////////////////////////////////////////////////////////
        ' No soportada
          ' Nada que hacer
        '/////////////////////////////////////////////////////////
    End With
    
  Next
  
  GoTo ExitProc
ControlError:
  
  MngError Err, "LoadSchedulesFromIni", C_Module, ""
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub GetScriptSteps()
  On Error GoTo ControlError
  
  Dim stp       As cISQLTaskStep
  Dim stpscript As cSQLTaskCommandScript
  Dim stpbackup As cSQLTaskCommandBackup
  Dim command   As String
  Dim DataBase  As String
  Dim Name      As String
  Dim i         As Integer
  
  SaveIniTempStp c_step_count, m_Steps.Count
  
  '---------------------------------------
  ' Guardo los pasos en el ini temporal
  For Each stp In m_Steps
    i = i + 1
    If stp.CmdType = csSchTypeScript Then
      Set stpscript = stp
      command = stpscript.command
      DataBase = stpscript.DataBase
      Name = stpscript.Name
      
    Else
      ' Preparo el comando de backup
      Set stpbackup = stp
      command = stpbackup.command
      DataBase = stpbackup.DataBase
      Name = stpbackup.Name
    End If
      
    SaveIniTempStp c_step_command & i, command
    SaveIniTempStp c_step_database & i, DataBase
    SaveIniTempStp c_step_name & i, Name
    
  Next
  
  GoTo ExitProc
ControlError:
  
  MngError Err, "GetScriptSteps", C_Module, ""
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Sub

Private Sub GetScriptSchedules()
  On Error GoTo ControlError
  
  Dim sch   As cSQLTaskSchedule
  Dim i     As Integer
  
  SaveIniTempSch c_schedule_count, m_Schedules.Count
  
  '---------------------------------------
  ' Grabo las programaciones en el ini temporal
  For Each sch In m_Schedules
   
    i = i + 1
    
    With sch
      '/////////////////////////////////////////////////////////
      ' Datos generales a toda programacion
      SaveIniTempSch c_schedule_Name & i, .Name
      SaveIniTempSch c_schedule_FirtsRunStartAt & i, .FirtsRunStartAt
      SaveIniTempSch c_schedule_LastRunEndAt & i, .LastRunEndAt
            
      '/////////////////////////////////////////////////////////
      ' De ocurrir mas de una vez, esta es la franja
      ' horaria
      SaveIniTempSch c_schedule_TimeEnd & i, .TimeEnd
      SaveIniTempSch c_schedule_TimeStart & i, .TimeStart
      
      '/////////////////////////////////////////////////////////
      ' Frecuencia - solo si ocurre mas de una vez
      SaveIniTempSch c_schedule_RunEach & i, .RunEach

      ' Aca se define si es por:
      '   - hora
      '   - minuto
      '   - o un momento determinado
      SaveIniTempSch c_schedule_TypeTime & i, .TypeTime
      SaveIniTempSch c_schedule_RunEachType & i, .RunEachType
      '/////////////////////////////////////////////////////////

      ' Aca se divide entre :
      '   - Por unica vez
      '   - Diario
      '   - Semanl
      '   - Mensual
      '   - Mensual relativo
      SaveIniTempSch c_schedule_TypeRun & i, .TypeRun
      
        '/////////////////////////////////////////////////////////
        ' Por unica vez
          SaveIniTempSch c_schedule_Time & i, .Time
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Diaria
          SaveIniTempSch c_schedule_RunDailyInterval & i, .RunDailyInterval ' Cada cuantos dias
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Semanal
          SaveIniTempSch c_schedule_RunWeeklyInterval & i, .RunWeeklyInterval ' Cada cuantas semanas
          
          ' Que dias
          SaveIniTempSch c_schedule_RunSunday & i, .RunSunday
          SaveIniTempSch c_schedule_RunMonday & i, .RunMonday
          SaveIniTempSch c_schedule_RunTuesday & i, .RunTuesday
          SaveIniTempSch c_schedule_RunWednesday & i, .RunWednesday
          SaveIniTempSch c_schedule_RunThursday & i, .RunThursday
          SaveIniTempSch c_schedule_RunFriday & i, .RunFriday
          SaveIniTempSch c_schedule_RunSaturday & i, .RunSaturday
        '/////////////////////////////////////////////////////////
        
        
        '/////////////////////////////////////////////////////////
        ' Mensual
          SaveIniTempSch c_schedule_RunMonthlyNumberDay & i, .RunMonthlyNumberDay  ' Que dia
          SaveIniTempSch c_schedule_RunMonthlyInterval & i, .RunMonthlyInterval  ' Cada cuantos meses
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Mensual relativa
          SaveIniTempSch c_schedule_RunMonthlyInterval & i, .RunMonthlyInterval  ' Cada cuantos meses
          
          ' Que cardinal
          SaveIniTempSch c_schedule_RunMonthlyCardinalDay & i, .RunMonthlyCardinalDay
          
          ' que dia
          SaveIniTempSch c_schedule_RunMonthlyNameDay & i, .RunMonthlyNameDay
        '/////////////////////////////////////////////////////////
      
        '/////////////////////////////////////////////////////////
        ' No soportada
          ' Nada que hacer
        '/////////////////////////////////////////////////////////
    End With
    
  Next
  
  GoTo ExitProc
ControlError:
  
  MngError Err, "GetScriptSchedules", C_Module, ""
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function GetScriptFromIniTemp() As String
  On Error GoTo ControlError
  
  Dim f As Integer
  Dim s As String
  Dim rtn As String
  
  Err.Clear
  
  f = FreeFile
  Open m_FileTemp For Input Access Read As f
  While Not EOF(f)
    Line Input #f, s
    
    rtn = rtn + s + vbCrLf
  Wend
  
  GetScriptFromIniTemp = rtn
ControlError:
  Close f
  If Err.Number <> 0 Then Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
End Function

Private Sub SetSteps(ByRef jb As SQLDMO.Job)
  Dim jbstep As SQLDMO.JobStep
  Dim stp    As cISQLTaskStep
  Dim stpscript As cSQLTaskCommandScript
  Dim stpbackup As cSQLTaskCommandBackup
  Dim command   As String
  Dim DataBase  As String
  Dim Name      As String
  Dim i As Integer
  Dim found As Boolean
  Dim AlterOpen  As Boolean
  
  '---------------------------------------
  ' Primero elimino los pasos borrados
  i = 1
  ' Por cada step que hay en el job
  While i <= jb.JobSteps.Count
    found = False
    
    ' Lo busco entre los comandos
    For Each stp In m_Steps
      ' Solo los comandos de tipo script tienen paso asociado
      If stp.CmdType = csSchTypeScript Then
        Set stpscript = stp
        If jb.JobSteps(i).StepID = stpscript.JobStep.StepID Then
          found = True
          Exit For
        End If
      End If
    Next
    
    If found Then
      i = i + 1
    ' Si no lo encuentro lo borror
    Else
      jb.JobSteps.Remove i
      jb.JobSteps.Refresh
    End If
  Wend
  '---------------------------------------
  
  On Error GoTo ControlError
  
  '---------------------------------------
  ' Ahora actualizo e inserto nuevos pasos
  For Each stp In m_Steps
    
    If stp.CmdType = csSchTypeScript Then
      Set stpscript = stp
      
      ' Nuevo paso
      If stpscript.JobStep Is Nothing Then
        Set jbstep = New JobStep
      Else
        Set jbstep = stpscript.JobStep
      End If
      
      command = stpscript.command
      DataBase = stpscript.DataBase
      Name = stpscript.Name
      
    Else
      ' Preparo el comando de backup
      Set stpbackup = stp
      command = stpbackup.command
      DataBase = stpbackup.DataBase
      Name = stpbackup.Name
      Set stpscript = New cSQLTaskCommandScript
      Set jbstep = New JobStep
    End If
      
    If stpscript.JobStep Is Nothing Then
      jbstep.OnFailAction = SQLDMOJobStepAction_QuitWithFailure
      jbstep.OnSuccessAction = SQLDMOJobStepAction_QuitWithSuccess
      
      jbstep.Name = Name
      jbstep.StepID = 1
      
      jb.JobSteps.Add jbstep
    End If
  
    jbstep.BeginAlter
    AlterOpen = True
    
    jbstep.command = m_MngMacro.ResolveMacros(command)
    jbstep.DataBaseName = DataBase
    jbstep.Name = Name
    
    jbstep.DoAlter
    AlterOpen = False
  Next
  
  GoTo ExitProc
ControlError:
  
  MngError Err, "SetSteps", C_Module, ""
  
  If AlterOpen Then jbstep.CancelAlter
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub SetSchedules(ByRef jb As SQLDMO.Job)
  Dim jbsch As SQLDMO.JobSchedule
  Dim sch   As cSQLTaskSchedule
  Dim i As Integer
  Dim found As Boolean
  Dim AlterOpen  As Boolean
  
  '---------------------------------------
  ' Primero elimino los pasos borrados
  i = 1
  ' Por cada step que hay en el job
  While i <= jb.JobSchedules.Count
    found = False
    
    ' Lo busco entre los pasos
    For Each sch In m_Schedules
      If jb.JobSchedules(i).ScheduleID = sch.Schedule.ScheduleID Then
        found = True
        Exit For
      End If
    Next
    
    If found Then
      i = i + 1
    ' Si no lo encuentro lo borror
    Else
      jb.JobSchedules.Remove i
      jb.JobSchedules.Refresh
    End If
  Wend
  '---------------------------------------
  
  On Error GoTo ControlError
  
  '---------------------------------------
  ' Ahora actualizo e inserto nuevos pasos
  For Each sch In m_Schedules
    Set sch = sch
    
    ' Nuevo paso
    If sch.Schedule Is Nothing Then
      Set jbsch = New JobSchedule
    Else
      Set jbsch = sch.Schedule
    End If
    
    If Not sch.Schedule Is Nothing Then
      jbsch.BeginAlter
      AlterOpen = True
    End If
    
    With sch
      '/////////////////////////////////////////////////////////
      ' Datos generales a toda programacion
      jbsch.Name = .Name
      jbsch.Schedule.ActiveStartDate = GetDateFromCSJobFormat(.FirtsRunStartAt)
      jbsch.Schedule.ActiveEndDate = GetDateFromCSJobFormat(.LastRunEndAt)
            
      '/////////////////////////////////////////////////////////
      ' De ocurrir mas de una vez, esta es la franja
      ' horaria
      jbsch.Schedule.ActiveEndTimeOfDay = GetTimeFromCSJobFormat(.TimeEnd)
      jbsch.Schedule.ActiveStartTimeOfDay = GetTimeFromCSJobFormat(.TimeStart)
      
      '/////////////////////////////////////////////////////////
      ' Frecuencia - solo si ocurre mas de una vez
      jbsch.Schedule.FrequencySubDayInterval = .RunEach

      ' Aca se define si es por:
      '   - hora
      '   - minuto
      '   - o un momento determinado
      
      Select Case .TypeTime
        Case csSchTypeTimeAtThisTime
          jbsch.Schedule.FrequencySubDay = SQLDMOFreqSub_Once
        Case csSchTypeTimeRecurring
          Select Case .RunEachType
            Case csSchEachTypeHour
              jbsch.Schedule.FrequencySubDay = SQLDMOFreqSub_Hour
            Case csSchEachTypeMinute
              jbsch.Schedule.FrequencySubDay = SQLDMOFreqSub_Minute
          End Select
      End Select
      '/////////////////////////////////////////////////////////

      ' Aca se divide entre :
      '   - Por unica vez
      '   - Diario
      '   - Semanl
      '   - Mensual
      '   - Mensual relativo
      Select Case .TypeRun
      
        '/////////////////////////////////////////////////////////
        ' Por unica vez
        Case csSchTypeRunOnce
          jbsch.Schedule.FrequencyType = SQLDMOFreq_OneTime

          jbsch.Schedule.ActiveStartDate = GetDateFromCSJobFormat(.Time)
          jbsch.Schedule.ActiveStartTimeOfDay = GetTimeFromCSJobFormat(.Time)
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Diaria
        Case csSchTypeRunDaily
          jbsch.Schedule.FrequencyType = SQLDMOFreq_Daily
          jbsch.Schedule.FrequencyInterval = .RunDailyInterval  ' Cada cuantos dias
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Semanal
        Case csSchTypeRunWeekly
          jbsch.Schedule.FrequencyType = SQLDMOFreq_Weekly
          jbsch.Schedule.FrequencyRecurrenceFactor = .RunWeeklyInterval ' Cada cuantas semanas
          
          ' Que dias
          jbsch.Schedule.FrequencyInterval = IIf(.RunSunday, SQLDMOWeek_Sunday, 0)
          jbsch.Schedule.FrequencyInterval = jbsch.Schedule.FrequencyInterval Or IIf(.RunMonday, SQLDMOWeek_Monday, 0)
          jbsch.Schedule.FrequencyInterval = jbsch.Schedule.FrequencyInterval Or IIf(.RunTuesday, SQLDMOWeek_Tuesday, 0)
          jbsch.Schedule.FrequencyInterval = jbsch.Schedule.FrequencyInterval Or IIf(.RunWednesday, SQLDMOWeek_Wednesday, 0)
          jbsch.Schedule.FrequencyInterval = jbsch.Schedule.FrequencyInterval Or IIf(.RunThursday, SQLDMOWeek_Thursday, 0)
          jbsch.Schedule.FrequencyInterval = jbsch.Schedule.FrequencyInterval Or IIf(.RunFriday, SQLDMOWeek_Friday, 0)
          jbsch.Schedule.FrequencyInterval = jbsch.Schedule.FrequencyInterval Or IIf(.RunSaturday, SQLDMOWeek_Saturday, 0)
        '/////////////////////////////////////////////////////////
        
        
        '/////////////////////////////////////////////////////////
        ' Mensual
        Case csSchTypeRunMonthly
          jbsch.Schedule.FrequencyType = SQLDMOFreq_Monthly
          jbsch.Schedule.FrequencyInterval = .RunMonthlyNumberDay ' Que dia
          jbsch.Schedule.FrequencyRecurrenceFactor = .RunMonthlyInterval ' Cada cuantos meses
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Mensual relativa
        Case csSchTypeRunMonthlyRelative
          jbsch.Schedule.FrequencyType = SQLDMOFreq_MonthlyRelative
          jbsch.Schedule.FrequencyRecurrenceFactor = .RunMonthlyInterval ' Cada cuantos meses
          
          ' Que cardinal
          Select Case .RunMonthlyCardinalDay
            Case csSchRunMonCard_1st
              jbsch.Schedule.FrequencyRelativeInterval = SQLDMOFreqRel_First
            Case csSchRunMonCard_4th
              jbsch.Schedule.FrequencyRelativeInterval = SQLDMOFreqRel_Fourth
            Case csSchRunMonCard_Last
              jbsch.Schedule.FrequencyRelativeInterval = SQLDMOFreqRel_Last
            Case csSchRunMonCard_2nd
              jbsch.Schedule.FrequencyRelativeInterval = SQLDMOFreqRel_Second
            Case csSchRunMonCard_3rd
              jbsch.Schedule.FrequencyRelativeInterval = SQLDMOFreqRel_Third
            Case csSchRunMonCard_UnSupported
              jbsch.Schedule.FrequencyRelativeInterval = SQLDMOFreqRel_Unknown
          End Select
          
          ' que dia
          Select Case .RunMonthlyNameDay
            Case csSchRunMonName_Sunday
              jbsch.Schedule.FrequencyInterval = SQLDMOMonth_Sunday
            Case csSchRunMonName_Monday
              jbsch.Schedule.FrequencyInterval = SQLDMOMonth_Monday
            Case csSchRunMonName_Tuesday
              jbsch.Schedule.FrequencyInterval = SQLDMOMonth_Tuesday
            Case csSchRunMonName_Wednesday
              jbsch.Schedule.FrequencyInterval = SQLDMOMonth_Wednesday
            Case csSchRunMonName_Thursday
              jbsch.Schedule.FrequencyInterval = SQLDMOMonth_Thursday
            Case csSchRunMonName_FriDay
              jbsch.Schedule.FrequencyInterval = SQLDMOMonth_Friday
            Case csSchRunMonName_Saturday
              jbsch.Schedule.FrequencyInterval = SQLDMOMonth_Saturday
          End Select
        '/////////////////////////////////////////////////////////
      
        '/////////////////////////////////////////////////////////
        ' No soportada
        Case csSchTypeUnSupported
          ' Nada que hacer
        '/////////////////////////////////////////////////////////
      End Select
    End With
    
    If sch.Schedule Is Nothing Then
      jb.JobSchedules.Add jbsch
    Else
      jbsch.DoAlter
      AlterOpen = False
    End If
    
  Next
  
  GoTo ExitProc
ControlError:
  
  MngError Err, "SetSchedules", C_Module, ""
  
  If AlterOpen Then jbsch.CancelAlter
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function GetJobById(ByVal JobId As String) As SQLDMO.Job
  Dim jb As SQLDMO.Job
  
  For Each jb In m_Connection.Server.JobServer.Jobs
    If jb.JobId = JobId Then Exit For
  Next

  Set GetJobById = jb
End Function

Private Function GetJobByName(ByVal JobName As String) As SQLDMO.Job
  Dim jb As SQLDMO.Job
  
  For Each jb In m_Connection.Server.JobServer.Jobs
    If jb.Name = JobName Then Exit For
  Next

  Set GetJobByName = jb
End Function

Private Sub LoadJobSteps(ByRef jb As SQLDMO.Job)
  Dim jbstep As SQLDMO.JobStep
  Dim stp    As cSQLTaskCommandScript

  For Each jbstep In jb.JobSteps
    Set stp = m_Steps.Add(Nothing)
    
    With stp
      Set .JobStep = jbstep
    End With
  Next
End Sub

Private Sub LoadJobSchedules(ByRef jb As SQLDMO.Job)
  Dim jbsch As SQLDMO.JobSchedule
  Dim sch   As cSQLTaskSchedule
  
  For Each jbsch In jb.JobSchedules
    Set sch = m_Schedules.Add(Nothing)
    
    With sch
    
      '/////////////////////////////////////////////////////////
      ' Guardo una referencia al schedule
      Set .Schedule = jbsch
    
      '/////////////////////////////////////////////////////////
      ' Datos generales a toda programacion
      .Name = jbsch.Name
      .FirtsRunStartAt = GetDateFromSQLJobFormat(jbsch.Schedule.ActiveStartDate)
      .LastRunEndAt = GetDateFromSQLJobFormat(jbsch.Schedule.ActiveEndDate)
            
      '/////////////////////////////////////////////////////////
      ' De ocurrir mas de una vez, esta es la franja
      ' horaria
      .TimeEnd = GetTimeFromSQLJobFormat(jbsch.Schedule.ActiveEndTimeOfDay)
      .TimeStart = GetTimeFromSQLJobFormat(jbsch.Schedule.ActiveStartTimeOfDay)
      
      '/////////////////////////////////////////////////////////
      ' Frecuencia - solo si ocurre mas de una vez
      .RunEach = jbsch.Schedule.FrequencySubDayInterval

      '/////////////////////////////////////////////////////////
      ' Frecuencia diaria
      .TypeTime = csSchTypeTimeRecurring
      
      ' Aca se define si es por:
      '   - hora
      '   - minuto
      '   - o un momento determinado
      Select Case jbsch.Schedule.FrequencySubDay
        Case SQLDMOFreqSub_Hour
          .RunEachType = csSchEachTypeHour
        Case SQLDMOFreqSub_Minute
          .RunEachType = csSchEachTypeMinute
        Case SQLDMOFreqSub_Once
          .TypeTime = csSchTypeTimeAtThisTime
        Case SQLDMOFreqSub_Unknown, SQLDMOFreqSub_Valid
          .TypeTime = csSchTypeTimeUnSupported
      End Select
      '/////////////////////////////////////////////////////////

      ' Aca se divide entre :
      '   - Por unica vez
      '   - Diario
      '   - Semanl
      '   - Mensual
      '   - Mensual relativo
      Select Case jbsch.Schedule.FrequencyType
      
        '/////////////////////////////////////////////////////////
        ' Por unica vez
        Case SQLDMOFreq_OneTime
          .TypeRun = csSchTypeRunOnce
          .Time = GetDateFromSQLJobFormat(jbsch.Schedule.ActiveStartDate) + GetTimeFromSQLJobFormat(jbsch.Schedule.ActiveStartTimeOfDay)
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Diaria
        Case SQLDMOFreq_Daily
          .TypeRun = csSchTypeRunDaily
          .RunDailyInterval = jbsch.Schedule.FrequencyInterval  ' Cada cuantos dias
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Semanal
        Case SQLDMOFreq_Weekly
          .TypeRun = csSchTypeRunWeekly
          .RunWeeklyInterval = jbsch.Schedule.FrequencyRecurrenceFactor ' Cada cuantas semanas
          
          ' Que dias
          .RunSunday = jbsch.Schedule.FrequencyInterval And SQLDMOWeek_Sunday
          .RunMonday = jbsch.Schedule.FrequencyInterval And SQLDMOWeek_Monday
          .RunTuesday = jbsch.Schedule.FrequencyInterval And SQLDMOWeek_Tuesday
          .RunWednesday = jbsch.Schedule.FrequencyInterval And SQLDMOWeek_Wednesday
          .RunThursday = jbsch.Schedule.FrequencyInterval And SQLDMOWeek_Thursday
          .RunFriday = jbsch.Schedule.FrequencyInterval And SQLDMOWeek_Friday
          .RunSaturday = jbsch.Schedule.FrequencyInterval And SQLDMOWeek_Saturday
        '/////////////////////////////////////////////////////////
        
        
        '/////////////////////////////////////////////////////////
        ' Mensual
        Case SQLDMOFreq_Monthly
          .TypeRun = csSchTypeRunMonthly
          .RunMonthlyNumberDay = jbsch.Schedule.FrequencyInterval ' Que dia
          .RunMonthlyInterval = jbsch.Schedule.FrequencyRecurrenceFactor ' Cada cuantos meses
        '/////////////////////////////////////////////////////////
        
        '/////////////////////////////////////////////////////////
        ' Mensual relativa
        Case SQLDMOFreq_MonthlyRelative
          .TypeRun = csSchTypeRunMonthlyRelative
          .RunMonthlyInterval = jbsch.Schedule.FrequencyRecurrenceFactor ' Cada cuantos meses
          
          ' Que cardinal
          Select Case jbsch.Schedule.FrequencyRelativeInterval
            Case SQLDMOFreqRel_First
              .RunMonthlyCardinalDay = csSchRunMonCard_1st
            Case SQLDMOFreqRel_Fourth
              .RunMonthlyCardinalDay = csSchRunMonCard_4th
            Case SQLDMOFreqRel_Last
              .RunMonthlyCardinalDay = csSchRunMonCard_Last
            Case SQLDMOFreqRel_Second
              .RunMonthlyCardinalDay = csSchRunMonCard_2nd
            Case SQLDMOFreqRel_Third
              .RunMonthlyCardinalDay = csSchRunMonCard_3rd
            Case SQLDMOFreqRel_Unknown
              .RunMonthlyCardinalDay = csSchRunMonCard_UnSupported
          End Select
          
          ' que dia
          Select Case jbsch.Schedule.FrequencyInterval
            Case SQLDMOMonth_Sunday
              .RunMonthlyNameDay = csSchRunMonName_Sunday
            Case SQLDMOMonth_Monday
              .RunMonthlyNameDay = csSchRunMonName_Monday
            Case SQLDMOMonth_Tuesday
              .RunMonthlyNameDay = csSchRunMonName_Tuesday
            Case SQLDMOMonth_Wednesday
              .RunMonthlyNameDay = csSchRunMonName_Wednesday
            Case SQLDMOMonth_Thursday
              .RunMonthlyNameDay = csSchRunMonName_Thursday
            Case SQLDMOMonth_Friday
              .RunMonthlyNameDay = csSchRunMonName_FriDay
            Case SQLDMOMonth_Saturday
              .RunMonthlyNameDay = csSchRunMonName_Saturday
          End Select
        '/////////////////////////////////////////////////////////
      
        '/////////////////////////////////////////////////////////
        ' No soportada
        Case SQLDMOFreq_Autostart, SQLDMOFreq_Valid, SQLDMOFreq_OnIdle, SQLDMOFreq_Unknown
          .TypeRun = csSchTypeUnSupported
        '/////////////////////////////////////////////////////////
      End Select
    End With
  Next
End Sub

' Operaciones con archivos ini
Private Function GetIniTempTask(ByVal Item As String, ByVal Default As String) As String
  GetIniTempTask = GetIniTemp(c_task_section, Item, Default)
End Function

Private Sub SaveIniTempTask(ByVal Item As String, ByVal Value As Variant)
  SaveIniTemp c_task_section, Item, Value
End Sub

Private Function GetIniTempStp(ByVal Item As String, ByVal Default As String) As String
  GetIniTempStp = GetIniTemp(c_step_section, Item, Default)
End Function

Private Sub SaveIniTempStp(ByVal Item As String, ByVal Value As Variant)
  SaveIniTemp c_step_section, Item, Value
End Sub

Private Function GetIniTempSch(ByVal Item As String, ByVal Default As String) As String
  GetIniTempSch = GetIniTemp(c_schedule_section, Item, Default)
End Function

Private Sub SaveIniTempSch(ByVal Item As String, ByVal Value As Variant)
  SaveIniTemp c_schedule_section, Item, Value
End Sub

Private Function GetIniTemp(ByVal Section As String, ByVal Item As String, ByVal Default As String) As String
  GetIniTemp = GetIniValue(Section, Item, Default, m_FileTemp)
End Function

Public Sub SaveIniTemp(ByVal Section As String, ByVal Item As String, ByVal Value As Variant)
  SaveIniValue Section, Item, Value, m_FileTemp
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Schedules = New cSQLTaskSchedules
  Set m_Steps = New cSQLTaskSteps
  Set m_MngMacro = New cMngMacro
  
  m_Id = ""
  
  m_FileTemp = FileGetValidPath(GetTempPath()) & "~task" & GetDateFromCSJobFormat(Date) & GetTimeFromCSJobFormat(Now) & ".tmp"
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Connection = Nothing
  Set m_Schedules = Nothing
  Set m_Steps = Nothing
  Set m_MngMacro = Nothing
  
  FileDelete m_FileTemp
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

