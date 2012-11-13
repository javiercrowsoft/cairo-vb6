VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cSQLServer
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:
' Proposito:   Manejar los servicios basicos de SQL Server

'   - Backups
'   - Ejecucion de scripts
'   - Creacion y Eliminacion de bases de datos
'   - Definicion de tareas
'   - Listado de bases de datos
'   - Propiedades de bases de datos (Tamaño,Posicion de archivos)
'   - Recuperar codigo de Sps

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSQLServer"
' estructuras
' variables privadas
  Private m_Connection            As cConnection
  
#If Not PREPROC_SPSCRIPTOR Then
  Private m_Backup                As cBackup
  Private m_CreateDataBase        As cCreateDataBase
#End If

Private WithEvents m_SQLScript  As cSQLScript
Attribute m_SQLScript.VB_VarHelpID = -1
Private m_IsForInstall          As Boolean
' eventos
Public Event Msg(ByVal Msg As String)
Public Event ShowProgress(ByVal Percent As Single)
Public Event ShowProgress2(ByVal Percent As Single, ByVal Msg As String, ByRef Cancel As Boolean)
' propiedadades publicas
Public Property Get SQLScript() As cSQLScript
  Set SQLScript = m_SQLScript
End Property
Public Property Let IsForInstall(ByVal rhs As Boolean)
  m_IsForInstall = rhs
End Property

#If Not PREPROC_SPSCRIPTOR Then
  Public Property Get Backup() As cBackup
    Set Backup = m_Backup
  End Property
  Public Property Get CreateDataBase() As cCreateDataBase
    Set CreateDataBase = m_CreateDataBase
  End Property
  Public Property Get Conn() As cConnection
    Set Conn = m_Connection
  End Property
#End If
' propiedadades friend
' propiedades privadas
' funciones publicas
#If Not PREPROC_SPSCRIPTOR Then
  Public Sub Init(ByVal AppPath As String)
    gPathExe = AppPath
  End Sub
  
  Public Function ImportExcel(ByVal Database As String) As Boolean
    On Error GoTo ControlError
  
    Dim oImportExcel As cImportExcel
    Set oImportExcel = New cImportExcel
    
    Set oImportExcel.Conn = m_Connection
    
    If Not oImportExcel.Import(Database) Then Exit Function
  
    ImportExcel = True
  
    GoTo ExitProc
ControlError:
    MngError Err, "ImportExcel", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Function EditDefScriptIni(ByVal IniFile As String) As Boolean
    On Error GoTo ControlError
    
    Dim mng As cMngScriptBatch
    Set mng = New cMngScriptBatch
    
    EditDefScriptIni = mng.EditScriptIni(IniFile)
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditDefScriptIni", C_Module, ""
ExitProc:
    Set mng = Nothing
  End Function
  
  Public Sub StopServer()
    m_Connection.StopServer
  End Sub
  
  Public Function StartServerAndConnect(ByVal Server As String, ByVal User As String, ByVal Pwd As String) As Boolean
    StartServerAndConnect = m_Connection.StartServerAndConnect(Server, User, Pwd)
  End Function
  
  Public Function StopAndStartServer() As Boolean
    StopAndStartServer = m_Connection.StopAndStartServer()
  End Function
  
  Public Sub ShowProperties()
    Set fServerProperties.Conn = m_Connection
    fServerProperties.Show vbModal
  End Sub
  
  Public Sub GenerateScript(ByVal Database As String)
    With m_Connection
      Load fScriptor
      fScriptor.Script .ServerName, Database, .UserName, .Password, .NTSecurity
    End With
  End Sub
  
  Public Function CreateDataBaseWithWizard(ByRef DbName As String, Optional ByVal ScriptFile As String, Optional ByVal ScriptMacro As String, Optional ByVal ScriptBatch As String, Optional ByVal DoScript As Boolean) As Boolean
    On Error GoTo ControlError
    
    Dim cdb As cfCreateDataBase
    Set cdb = New cfCreateDataBase
    
    Set cdb.SQLServer = Me
    
    Dim Mouse As cMouseWait
    Set Mouse = New cMouseWait
    Mouse.SetMouseDefatul
    CreateDataBaseWithWizard = cdb.CreateDataBase(ScriptFile, ScriptMacro, ScriptBatch, DoScript)
    DbName = cdb.DbName
    
    GoTo ExitProc
ControlError:
    MngError Err, "CreateDataBaseWithWizard", C_Module, ""
ExitProc:
    Set cdb = Nothing
  End Function
  
  Public Function CreateDataBaseWithWizardEx(ByRef DbName As String, _
                                             ByVal DataFile As String, _
                                             ByVal DataSize As Long, _
                                             ByVal LogFile As String, _
                                             ByVal LogSize As Long) As Boolean
    On Error GoTo ControlError
    
    Dim cdb As cfCreateDataBase
    Set cdb = New cfCreateDataBase
    
    Set cdb.SQLServer = Me
    
    Dim Mouse As cMouseWait
    Set Mouse = New cMouseWait
    Mouse.SetMouseDefatul
    cdb.IsForInstall = m_IsForInstall
    CreateDataBaseWithWizardEx = cdb.CreateDataBaseEx(DbName, DataFile, DataSize, LogFile, LogSize)
    DbName = cdb.DbName
    
    GoTo ExitProc
ControlError:
    MngError Err, "CreateDataBaseWithWizardEx", C_Module, ""
ExitProc:
    Set cdb = Nothing
  End Function
  
  Public Function OpenConnection(ByVal ServerName As String, _
                                 ByVal User As String, _
                                 ByVal Password As String, _
                                 ByVal UseTrusted As Boolean) As Boolean
    On Error GoTo ControlError
    
    Dim rtn As Boolean
    
    rtn = m_Connection.OpenConnection(ServerName, User, Password, UseTrusted)
    
    If Not rtn Then
      ' SQL Server no existe o acceso denegado. Tambien puede ser servicio detenido.
      If gLastError = -2147221504 Then
        If Ask("No fue posible iniciar la conexión con el servidor " & ServerName & "./n/nEs posible que el servicio se encuentre detenido./n/n¿Desea intentar arrancar el servicio?") Then
          rtn = StartServerAndConnect(ServerName, User, Password)
        End If
      End If
    End If
    
    OpenConnection = rtn
    
    GoTo ExitProc
ControlError:
    MngError Err, "OpenConnection", C_Module, ""
ExitProc:
  End Function
  
#End If
  
  Public Function OpenConnectionEx(ByVal ServerName As String, _
                                   ByVal User As String, _
                                   ByVal Password As String, _
                                   ByVal UseTrusted As Boolean) As Boolean
    On Error GoTo ControlError
    
    Dim rtn As Boolean
    
    rtn = m_Connection.OpenConnectionEx(ServerName, User, Password, UseTrusted)
    
#If Not PREPROC_SPSCRIPTOR Then
    
    If Not rtn Then
      ' SQL Server no existe o acceso denegado. Tambien puede ser servicio detenido.
      If gLastError = -2147221504 Then
        rtn = StartServerAndConnect(ServerName, User, Password)
      End If
    End If

#End If
    
    OpenConnectionEx = rtn
    
    GoTo ExitProc
ControlError:
    MngError Err, "OpenConnectionEx", C_Module, ""
ExitProc:
  End Function
  
#If Not PREPROC_SPSCRIPTOR Then
  
  Public Function CloseConnection() As Boolean
    On Error GoTo ControlError
    
    CloseConnection = m_Connection.CloseConnection()
    
    GoTo ExitProc
ControlError:
    MngError Err, "CloseConnection", C_Module, ""
ExitProc:
  End Function
  
  Public Function ListDataBases() As Object
    On Error GoTo ControlError
    
    Dim coll As Collection
    Set coll = New Collection
    
    If Not m_Connection.Connected() Then
      Err.Raise csConnectionClosed, C_Module & "ListDataBases", "La conexión no esta abierta. No es posible listar las bases de datos."
    End If
    
    Dim Db As SQLDMO.Database
    Dim dbInfo As cListDataBaseInfo
    For Each Db In m_Connection.Server.Databases
      Set dbInfo = New cListDataBaseInfo
      dbInfo.Name = Db.Name
      coll.Add dbInfo
    Next
    
    Set ListDataBases = coll
    
    GoTo ExitProc
ControlError:
    MngError Err, "ListDataBases", C_Module, ""
ExitProc:
  End Function
  
  Public Function ListTasks() As Object
    On Error GoTo ControlError
    
    Dim coll As Collection
    Set coll = New Collection
    
    If Not m_Connection.Connected() Then
      Err.Raise csConnectionClosed, C_Module & "ListJobs", "La conexión no esta abierta. No es posible listar las tareas."
    End If
    
    Dim jb As SQLDMO.Job
    Dim tkInfo As cListTaskInfo
    
    For Each jb In m_Connection.Server.JobServer.Jobs
      Set tkInfo = New cListTaskInfo
      tkInfo.Name = jb.Name
      tkInfo.Id = jb.JobId
      coll.Add tkInfo
    Next
    
    Set ListTasks = coll
    
    GoTo ExitProc
ControlError:
    MngError Err, "ListTasks", C_Module, ""
ExitProc:
  End Function
  
  Public Function ShowBackup(ByVal Database As String, ByVal OverWrite As Boolean, ByVal File As String) As Boolean
    ShowBackup = ShowBackupRestore(True, Database, OverWrite, False, File)
  End Function
  
  Public Function ShowRestore(ByVal Database As String, ByVal OverWrite As Boolean, ByVal RestoreInNewDataBase As Boolean, ByVal File As String) As Boolean
    ShowRestore = ShowBackupRestore(False, Database, OverWrite, RestoreInNewDataBase, File)
  End Function
  
  Public Function DeleteTrigger(ByVal Database As String, ByVal Table As String, ByVal Trigger As String) As Boolean
    On Error GoTo ControlError
  
    m_Connection.Server.Databases(Database).Tables(Table).Triggers.Remove Trigger
    
    DeleteTrigger = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "DeleteTrigger", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Function DeleteView(ByVal Database As String, ByVal View As String) As Boolean
    On Error GoTo ControlError
  
    m_Connection.Server.Databases(Database).Views.Remove View
    
    DeleteView = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "DeleteView", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Function DeleteTable(ByVal Database As String, ByVal Table As String) As Boolean
    On Error GoTo ControlError
  
    m_Connection.Server.Databases(Database).Tables.Remove Table
    
    DeleteTable = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "DeleteTable", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Function DeleteSP(ByVal Database As String, ByVal SP As String) As Boolean
    On Error GoTo ControlError
  
    m_Connection.Server.Databases(Database).StoredProcedures.Remove SP
    
    DeleteSP = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "DeleteSP", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  
  Public Function DeleteTask(ByVal Name As String) As Boolean
    On Error GoTo ControlError
  
    Dim Task As cSQLTask
    Set Task = New cSQLTask
    Set Task.Conn = m_Connection
    
    DeleteTask = Task.Delete(Name)
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditTask", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
    
    Set Task = Nothing
  End Function
  
  Public Function DeleteDataBase(ByVal Name As String) As Boolean
    On Error GoTo ControlError
  
    m_Connection.Server.Databases.Remove Name
  
    DeleteDataBase = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "DeleteDataBase", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Sub EditSp(ByVal Database As String, ByVal SP As String)
    On Error GoTo ControlError
  
    Dim Script As String
    Script = m_Connection.Server.Databases(Database).StoredProcedures(SP).Script(SQLDMOScript_Drops + SQLDMOScript_IncludeIfNotExists + SQLDMOScript_PrimaryObject)
  
    EditScript Database, Script
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditSP", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Sub
  
  Public Sub EditSp2(ByVal Database As String, ByVal SP As String, ByVal WithEncrypt As Boolean)
    On Error GoTo ControlError
  
    Dim Script As String
    Script = m_Connection.Server.Databases(Database).StoredProcedures(SP).Script(SQLDMOScript_Drops + SQLDMOScript_IncludeIfNotExists + SQLDMOScript_PrimaryObject)
  
    If WithEncrypt Then Script = pEncryptSp(Script)
  
    EditScript Database, Script
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditSP2", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Sub
  
  Public Function GetSpCode(ByVal Database As String, ByVal SP As String, ByVal WithEncrypt As Boolean) As String
    On Error GoTo ControlError
  
    Dim Script As String
    Script = m_Connection.Server.Databases(Database).StoredProcedures(SP).Script(SQLDMOScript_Drops + SQLDMOScript_IncludeIfNotExists + SQLDMOScript_PrimaryObject)
  
    If WithEncrypt Then Script = pEncryptSp(Script)
  
    GetSpCode = Script
    
    GoTo ExitProc
ControlError:
    MngError Err, "GetSpCode", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function pEncryptSp(ByVal Script As String) As String
    Dim i     As Long
    
    If pGetWordInSp(Script, "create") = 0 Then Exit Function
    If pGetWordInSp(Script, "procedure") = 0 Then Exit Function
    i = pGetWordInSp(Script, "as")
    
    pEncryptSp = Mid(Script, 1, i - 3) & vbCrLf & "  with encryption " & vbCrLf & "as" & vbCrLf & Mid(Script, i)
   
  End Function
  
  Private Function pGetWordInSp(ByVal Script As String, ByVal toSearch As String) As Integer
    Dim i     As Long
    Dim c     As String
    Dim word  As String
    
    For i = 1 To Len(Script)
      c = LCase(Mid(Script, i, 1))
      If pIsSeparator(c) Then
        If word = toSearch Then
          pGetWordInSp = i
          Exit Function
        Else
          word = ""
        End If
      Else
        word = word & c
      End If
    Next
  End Function
  
  Private Function pIsSeparator(ByVal c As String) As Boolean
    pIsSeparator = True
    If c = " " Then Exit Function
    If c = vbTab Then Exit Function
    If c = vbCr Then Exit Function
    If c = vbLf Then Exit Function
    If c = "," Then Exit Function
    If c = "(" Then Exit Function
    If c = ")" Then Exit Function
    pIsSeparator = False
  End Function
  
  Public Sub EditView(ByVal Database As String, ByVal View As String)
    On Error GoTo ControlError
  
    Dim Script As String
    Script = m_Connection.Server.Databases(Database).Views(View).Script(SQLDMOScript_Drops + SQLDMOScript_IncludeIfNotExists + SQLDMOScript_PrimaryObject)
    
    EditScript Database, Script
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditView", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Sub
  
  Public Sub EditTable(ByVal Database As String, ByVal Table As String)
    On Error GoTo ControlError
  
    Dim Script As String
    Script = m_Connection.Server.Databases(Database).Tables(Table).Script(SQLDMOScript_Drops + SQLDMOScript_IncludeIfNotExists + SQLDMOScript_PrimaryObject)
    
    EditScript Database, Script
  
    GoTo ExitProc
ControlError:
    MngError Err, "EditTable", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Sub
  
  Public Sub EditTrigger(ByVal Database As String, ByVal Table As String, ByVal Trigger As String)
    On Error GoTo ControlError
  
    Dim Script As String
    Script = m_Connection.Server.Databases(Database).Tables(Table).Triggers(Trigger).Script(SQLDMOScript_Drops + SQLDMOScript_IncludeIfNotExists + SQLDMOScript_PrimaryObject)
  
    EditScript Database, Script
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditTrigger", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Sub
  
  Public Function EditTask(ByVal Name As String) As Boolean
    On Error GoTo ControlError
  
    Dim f As fTask
    Set f = New fTask
    
    Set f.SQLServer = Me
    
    If Not f.Task.LoadJob(Name) Then Exit Function
    
    f.Show vbModal
  
    If Not f.Ok Then GoTo ExitProc
    
    Set f.Task.MngMacro = New cMngMacro
    
    f.Task.Save
  
    EditTask = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditTask", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
    
    Unload f
  End Function
  
  Public Function GetTask(ByVal JobName As String) As cSQLTask
    On Error GoTo ControlError
  
    Dim Task As cSQLTask
    
    Set Task = New cSQLTask
    Set Task.Conn = m_Connection
    
    If Not Task.LoadJob(JobName) Then GoTo ExitProc
    
    Set GetTask = Task
    
    GoTo ExitProc
ControlError:
    MngError Err, "GetTaskScript", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Function EditTaskOjb(ByRef Task As cSQLTask) As Boolean
    On Error GoTo ControlError
  
    Dim f As fTask
    
    If Task Is Nothing Then Exit Function
    
    Set f = New fTask
    
    Set f.SQLServer = Me
    
    Set f.Task = Task
    
    f.Show vbModal
  
    If Not f.Ok Then GoTo ExitProc
    
    f.Task.Save
  
    EditTaskOjb = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "EditTaskOjb", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
    
    Unload f
  End Function
  
  Public Function LoadTaskFromIni(ByVal IniFile As String) As cSQLTask
    On Error GoTo ControlError
  
    Dim Task As cSQLTask
    
    Set Task = New cSQLTask
    Set Task.Conn = m_Connection
    
    If Not Task.LoadFromIni(IniFile) Then Set Task = Nothing
    
    Set LoadTaskFromIni = Task
    
    GoTo ExitProc
ControlError:
    MngError Err, "LoadTaskFromIni", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Function GetTaskScript(ByVal JobName As String) As String
    On Error GoTo ControlError
  
    Dim Task As cSQLTask
    
    Set Task = New cSQLTask
    Set Task.Conn = m_Connection
    
    If Not Task.LoadJob(JobName) Then GoTo ExitProc
    
    GetTaskScript = Task.GetScriptTask()
    
    GoTo ExitProc
ControlError:
    MngError Err, "GetTaskScript", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
    Set Task = Nothing
  End Function
  
  Public Function CreateTask() As Boolean
    On Error GoTo ControlError
  
    Dim f As fTask
    Set f = New fTask
    
    Set f.SQLServer = Me
    
    f.Show vbModal
    
    If Not f.Ok Then GoTo ExitProc
    
    f.Task.Save
  
    CreateTask = True
    
    GoTo ExitProc
ControlError:
    MngError Err, "CreateTask", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Public Sub EditScript(Optional ByVal Database As String, Optional ByVal Script As String)
    On Error GoTo ControlError
    
    Dim f As fEditScript
    Set f = New fEditScript
    Set f.SQLServer = Me
    Load f
    f.Database = Database
    f.Script = Script
    f.Show
  
    GoTo ExitProc
ControlError:
    MngError Err, "EditScript", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Sub
  
  Public Function LoadTriggers(ByRef Database As cDataBase) As Boolean
    On Error GoTo ControlError
    
    Dim q As Integer
    Dim i As Integer
    Dim Db    As SQLDMO.Database
    Dim tb    As cTable
    
    Set Db = m_Connection.Server.Databases(Database.Name)
    
    RaiseEvent Msg("Cargando Triggers")
    
    q = Db.Tables.Count
    For i = 1 To q
      With Db.Tables(i)
        Set tb = Database.Tables(.Name)
        
        If tb Is Nothing Then
          Set tb = Database.Tables.Add(Nothing, .Name)
          tb.Name = .Name
        
          If .SystemObject Then
            tb.TblType = csTblSystem
          Else
            tb.TblType = csTblUser
          End If
          
          tb.CreateDate = .CreateDate
        End If
        LoadTriggersAux tb, Db.Tables(i)
      End With
      RaiseEvent ShowProgress(i / q)
    Next
    
    LoadTriggers = True
  
    GoTo ExitProc
ControlError:
    MngError Err, "LoadTriggers", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Sub LoadTriggersAux(ByRef tb As cTable, ByRef Table As SQLDMO.Table)
    Dim tg    As cTrigger
    Dim j     As Integer
    With Table
      For j = 1 To .Triggers.Count
        Set tg = tb.Triggers.Add(Nothing)
        tg.Name = .Triggers(j).Name
      Next
    End With
  End Sub
  
  Public Function GetDataBaseInfoObj(ByVal DbName As String, Optional ByRef dbObj As cDataBase) As cDataBase
    Dim rtn As cDataBase
    
    If dbObj Is Nothing Then
      Set rtn = New cDataBase
      rtn.Name = DbName
    Else
      Set rtn = dbObj
    End If
    
    Set rtn.Conn = m_Connection
    Set GetDataBaseInfoObj = rtn
  End Function
  
  Public Function GetCurrentActivity() As Collection
    Dim qr As SQLDMO.QueryResults
    Dim rtn As Collection
    Dim pr As cProcess
    Dim i As Integer
    
    Set rtn = New Collection
    Set qr = m_Connection.Server.EnumProcesses()
    
    For i = qr.Rows To 1 Step -1
      Set pr = New cProcess
      With pr
        .Blocked = qr.GetColumnString(i, 9)
        .Cmd = qr.GetColumnString(i, 6)
        .Cpu = qr.GetColumnString(i, 10)
        .DbName = qr.GetColumnString(i, 7)
        .Hostname = qr.GetColumnString(i, 4)
        .Loginname = qr.GetColumnString(i, 3)
        .Memusage = qr.GetColumnString(i, 8)
        .ProgramName = qr.GetColumnString(i, 5)
        .Spid = qr.GetColumnString(i, 1)
        .Status = qr.GetColumnString(i, 2)
      End With
      rtn.Add pr
    Next
    
    Set GetCurrentActivity = rtn
  End Function
  
  Public Function GetLocks() As Collection
    Dim qr As SQLDMO.QueryResults
    Dim rtn As Collection
    Dim lk As cLock
    Dim i As Integer
    
    Set rtn = New Collection
    Set qr = m_Connection.Server.EnumLocks()
    
    For i = qr.Rows To 1 Step -1
      Set lk = New cLock
      With lk
        .DbName = qr.GetColumnString(i, 5)
        .IndexName = qr.GetColumnString(i, 2)
        .LockType = qr.GetColumnString(i, 6)
        .ReqSpid = qr.GetColumnString(i, 1)
        .Status = qr.GetColumnString(i, 6)
        .TableName = qr.GetColumnString(i, 3)
      End With
      rtn.Add lk
    Next
    
    Set GetLocks = rtn
  End Function
    
  Public Function GetLogs() As Collection
    Dim qr As SQLDMO.QueryResults
    Dim rtn As Collection
    Dim Log As cLogInfo
    Dim i As Integer
    
    Set rtn = New Collection
    Set qr = m_Connection.Server.EnumErrorLogs()
    
    For i = qr.Rows To 1 Step -1
      Set Log = New cLogInfo
      Log.Created = qr.GetColumnString(i, 2)
      Log.File = qr.GetColumnString(i, 1)
      rtn.Add Log
    Next
    
    Set GetLogs = rtn
  End Function
  
  Public Function GetLogInfo(ByVal Id As Integer) As Collection
    On Error GoTo ControlError
    Dim File As String
    Dim Log  As String
    Dim Logs As Collection
    Dim oLog As cLogInfo
    Dim q    As Long
    
    File = m_Connection.Server.Registry.ErrorLogPath
    If Id <> 0 Then File = File & "." & Id
    FileReadFullFile File, Log, False
    
    q = pGetLinePos(Log, 6)
    Set Logs = New Collection
    
    While pGetNewLog(Log, q, oLog)
      Logs.Add oLog
    Wend
    
    Set GetLogInfo = Logs
    
    GoTo ExitProc
ControlError:
    MngError Err, "GetLogInfo", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
  End Function
  
  Private Function pGetNewLog(ByRef Log As String, ByRef q As Long, ByRef oLog As cLogInfo) As Boolean
    Dim k     As Integer
    Dim slog  As String
    
    If q > Len(Log) Then Exit Function
    
    k = InStr(q + 1, Log, vbCrLf)
    slog = Mid(Log, q, k - q)
    Set oLog = New cLogInfo
    
    oLog.Occurs = Mid(slog, 1, 22)
    oLog.Source = Mid(slog, 24, 10)
    oLog.Message = Mid(slog, 34)
    
    q = k + 2
    
    pGetNewLog = True
  End Function
  
  Private Function pGetLinePos(ByRef Log As String, ByVal Line As Long) As Integer
    Dim q As Integer
    Dim i As Integer
    
    For i = 1 To Line - 1
      q = InStr(q + 1, Log, vbCrLf)
      If q = 0 Then Exit For
      q = q + 1
    Next
    pGetLinePos = q + 1
  End Function
  
  Public Function GetDataBaseInfo(ByVal DbName As String, Optional ByVal Fast As Boolean, Optional ByVal WithTriggers As Boolean, Optional ByRef rtn As cDataBase) As cDataBase
    
    If rtn Is Nothing Then Set rtn = New cDataBase
    rtn.Name = DbName
    Set rtn.Conn = m_Connection
    
    ' Sps
    GetSps DbName, rtn, Fast
    
    ' Tablas
    GetTables DbName, rtn, WithTriggers
    
    ' Views
    GetViews DbName, rtn, Fast
    
    rtn.Loaded = True
    
    Set GetDataBaseInfo = rtn
  End Function
  
  Public Sub GetViews(ByVal DbName As String, ByRef rtn As cDataBase, ByVal Fast As Boolean)
    Dim Db    As SQLDMO.Database
    Dim q     As Integer
    Dim i     As Integer
    Dim j     As Integer
    Dim vw    As cView
    Dim c     As cColumn
    Dim lobj  As Object
    
    Set Db = m_Connection.Server.Databases(DbName)
    
    rtn.Views.Clear
    
    q = Db.Views.Count
    RaiseEvent Msg("Cargando Vistas")
    For i = 1 To q
      Set vw = rtn.Views.Add(Nothing)
      With Db.Views(i)
        vw.Name = .Name
        
        If .SystemObject Then
          vw.VwType = csVwSystem
        Else
          vw.VwType = csVwUser
        End If
        
        vw.CreateDate = .CreateDate
        
        If Not Fast Then
          For j = 1 To .ListColumns().Count
            Set lobj = .ListColumns(j)
            Set c = vw.Columns.Add(Nothing)
            c.Name = lobj.Name
            c.SqlType = lobj.Datatype
          Next
        End If
      End With
      RaiseEvent ShowProgress(i / q)
    Next
  End Sub
  
  Public Sub GetTables(ByVal DbName As String, ByRef rtn As cDataBase, _
                       Optional ByVal WithTriggers As Boolean)
                       
    Dim Db    As SQLDMO.Database
    Dim q     As Integer
    Dim i     As Integer
    Dim tb    As cTable
    Dim c     As cColumn
    
    Set Db = m_Connection.Server.Databases(DbName)
    
    rtn.Tables.Clear
    
    q = Db.Tables.Count
    
    RaiseEvent Msg("Cargando Tablas")
    
    For i = 1 To q
      
      With Db.Tables(i)
        Set tb = rtn.Tables.Add(Nothing, .Name)
        tb.Name = .Name
        
        If .SystemObject Then
          tb.TblType = csTblSystem
        Else
          tb.TblType = csTblUser
        End If
        
        tb.CreateDate = .CreateDate
        If WithTriggers Then
          LoadTriggersAux tb, Db.Tables(i)
        End If
      End With
      
      RaiseEvent ShowProgress(i / q)
    Next
  End Sub
  
  Public Sub GetSps(ByVal DbName As String, ByRef rtn As cDataBase, Optional ByVal Fast As Boolean)
    Dim p     As cParameter
    Dim q     As Integer
    Dim j     As Integer
    Dim i     As Integer
    Dim SP    As cStoredProcedure
    Dim qr    As SQLDMO.QueryResults
    Dim Db    As SQLDMO.Database
    
    Set Db = m_Connection.Server.Databases(DbName)
  
    rtn.Procedures.Clear
  
    q = Db.StoredProcedures.Count
    RaiseEvent Msg("Cargando Procedimientos almacenados")
    For i = 1 To q
      Set SP = rtn.Procedures.Add(Nothing)
      With Db.StoredProcedures(i)
        SP.Name = .Name
        
        If .SystemObject Then
          SP.SpType = csSpSystem
        Else
          SP.SpType = csSpUser
        End If
        
        SP.CreateDate = .CreateDate
        
        If Not Fast Then
          Set qr = .EnumParameters()
          For j = 1 To qr.Rows
            Set p = SP.Parameters.Add(Nothing)
            p.Name = qr.GetColumnString(j, 1)
            p.SqlType = qr.GetColumnString(j, 2)
          Next
        End If
      End With
      RaiseEvent ShowProgress(i / q)
    Next
  End Sub
#End If

' funciones friend

' Proposito: Responde si una base existe.
' Nota: no controla errores, por que si la operacion
'       falla, la respuesta no es ni True ni False
#If Not PREPROC_SPSCRIPTOR Then
  Friend Function DataBaseExists(ByVal Database As String) As Boolean
    Dim o As cListDataBaseInfo
    Dim coll As Collection
    
    Set coll = ListDataBases()
    
    For Each o In coll
      If LCase(o.Name) = LCase(Database) Then
        DataBaseExists = True
        Exit For
      End If
    Next
    
  End Function
  
  Friend Function GetInfoTable(ByRef Table As cTable, ByVal DbName As String, tblName As String)
    Dim Db    As SQLDMO.Database
    Dim j     As Integer
    Dim tb    As cTable
    Dim c     As cColumn
    
    Set Db = m_Connection.Server.Databases(DbName)
    
    With Db.Tables(tblName)
      For j = 1 To .Columns.Count
        Set c = tb.Columns.Add(Nothing)
        With .Columns(j)
          c.Name = .Name
          c.SqlType = .Datatype
        End With
      Next
    End With
  End Function
#End If

' funciones privadas
#If Not PREPROC_SPSCRIPTOR Then
  Private Function ShowBackupRestore(ByVal Backup As Boolean, ByVal Database As String, ByVal OverWrite As Boolean, ByVal RestoreInNewDataBase As Boolean, ByVal File As String) As Boolean
    On Error GoTo ControlError
  
    Dim f As fBackupRestore
    Set f = New fBackupRestore
    Set f.SQLServer = Me
    f.Ok = False
    
    Load f
    If Backup Then
      f.Caption = "Generar Backup de la base de datos " & Database
      f.chkRestoreInNewDataBase.Visible = False
      f.Action = csBakActionBackup
    Else
      f.Caption = "Recuperar la base de datos " & Database
      f.chkRestoreInNewDataBase.Visible = True
      f.Action = csBakActionRestore
    End If
    
    f.chkOverWrite.Value = IIf(OverWrite, vbChecked, vbUnchecked)
    f.chkRestoreInNewDataBase.Value = IIf(RestoreInNewDataBase, vbChecked, vbUnchecked)
    
    SelectDataBase f.cbDataBases, Database
    
    If f.cbDataBases.ListIndex = -1 Then
      f.cbDataBases.ListIndex = 0
    End If
    
    f.txFile.Text = File
    
    Dim Mouse As cMouseWait
    Set Mouse = New cMouseWait
    Mouse.SetMouseDefatul
    
    f.IsForInstall = m_IsForInstall
    
    f.Show vbModal
    
    ShowBackupRestore = f.Ok
  
    GoTo ExitProc
ControlError:
    MngError Err, "ShowBackupRestore", C_Module, ""
    If Err.Number <> 0 Then Resume ExitProc
ExitProc:
    On Error Resume Next
    
    Unload f
    Set f = Nothing
    
  End Function
  
  Private Sub SelectDataBase(ByRef List As ComboBox, ByVal Database As String)
    Dim i As Integer
    
    If Database = "" Then Exit Sub
    For i = 0 To List.ListCount - 1
      If List.List(i) = Database Then
        List.ListIndex = i
      End If
    Next
  End Sub
#End If

Private Sub m_SQLScript_Progress(ByVal Percent As Integer, ByVal Descrip As String, Cancel As Boolean)
  RaiseEvent ShowProgress2(Percent, Descrip, Cancel)
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Connection = New cConnection
  Set m_SQLScript = New cSQLScript
  Set m_SQLScript.Conn = m_Connection

#If Not PREPROC_SPSCRIPTOR Then
  Set m_Backup = New cBackup
  Set m_Backup.Conn = m_Connection
  Set m_CreateDataBase = New cCreateDataBase
  Set m_CreateDataBase.SQLServer = Me
#End If

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
ExitProc:
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Connection = Nothing
  Set m_SQLScript = Nothing

#If Not PREPROC_SPSCRIPTOR Then
  Set m_Backup = Nothing
  Set m_CreateDataBase = Nothing
#End If

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
ExitProc:
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

