VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBackup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cBackUp
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:
' Proposito:  Implementar rutinas de backup y restore

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cBackUp"
' estructuras
' variables privadas
Private WithEvents m_Backup     As SQLDMO.Backup
Attribute m_Backup.VB_VarHelpID = -1
Private WithEvents m_Restore    As SQLDMO.Restore
Attribute m_Restore.VB_VarHelpID = -1

Private m_Connection  As cConnection
Private m_Result      As Boolean
Private m_DataBase    As String
' eventos
Public Event BackupPercentComplete(ByVal Message As String, ByVal Percent As Long, ByRef Cancel As Boolean)
Public Event RestorePercentComplete(ByVal Message As String, ByVal Percent As Long, ByRef Cancel As Boolean)
Public Event Initialize()
Public Event Finalize()

' propiedades publicas
Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property

Public Property Get DataBase() As String
  DataBase = m_DataBase
End Property

Public Property Get Server() As String
  If Not m_Connection Is Nothing Then
    Server = m_Connection.ServerName
  Else
    Server = ""
  End If
End Property

' propiedades privadas
' funciones publicas
Public Function ShowFindFileBackup(ByVal DataBase As String, ByVal File As String, ByVal Title As String) As String
  ShowFindFileBackup = ShowFindFile(DataBase, File, Title, m_Connection.Server)
End Function

Public Function Backup(ByVal Init As Boolean, ByVal DataBase As String, ByVal File As String) As Boolean
  If Not BackupStep1(Init, DataBase, File) Then Exit Function
  Backup = BackupStep2()
End Function

Public Function Restore(ByVal DataBase As String, ByVal File As String, ByVal OverWrite As Boolean) As Boolean
  If Not RestoreStep1(DataBase, File, OverWrite) Then Exit Function
  Restore = RestoreStep2()
End Function

' funciones friend
Friend Function BackupStep1(ByVal Init As Boolean, ByVal DataBase As String, ByVal File As String) As Boolean
  On Error GoTo ControlError
  
  Dim Id As Long
  
  If File = "" Then
    info "Debe indicar un archivo para realizar el backup"
    GoTo ExitProc
  End If
  
  m_DataBase = DataBase
  m_Backup.DataBase = DataBase
  
  m_Backup.Initialize = Init
  
  m_Backup.BackupSetName = DataBase + "_Backup"
  
  m_Backup.Files = "[" & File & "]"
  
  m_Backup.Initialize = True
  
  m_Result = False
  
  RaiseEvent Initialize

  GoTo ExitProc
ControlError:
  MngError Err, "BackupStep1", C_Module, ""
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  BackupStep1 = m_Result
  
  RaiseEvent Finalize
End Function

Friend Function BackupStep2() As Boolean
  On Error GoTo ControlError
  
  m_Backup.SQLBackup m_Connection.Server

  m_Result = True

  GoTo ExitProc
ControlError:
  ' Estos no son realmente errores
  ' -2147199222 = operacion cancelada por el usuario
  ' -2147221499 = EXCEPTION_ACCESS_VIOLATION
  If Err.Number <> -2147199222 And Err.Number <> -2147221499 Then
    MngError Err, "BackupStep2", C_Module, ""
  Else
    m_Result = True
  End If
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  BackupStep2 = m_Result
End Function

Friend Function RestoreStep1(ByVal DataBase As String, ByVal File As String, ByVal OverWrite As Boolean) As Boolean
  On Error GoTo ControlError
  
  If CheckDataBaseInUse(DataBase) Then Exit Function
  
  m_DataBase = DataBase
  m_Restore.DataBase = DataBase
  
  m_Restore.Files = "[" & File & "]"
  
  Dim ql As SQLDMO.QueryResults
  
  If OverWrite Then
    m_Restore.ReplaceDatabase = True
    
    Dim BackupFile As String
    Dim i As Integer
    Set ql = m_Restore.ReadFileList(m_Connection.Server)
    
    ' data
    BackupFile = "[" & ql.GetColumnString(1, 1) & "],[" & _
                   Trim(m_Connection.Server(DataBase).FileGroups(1).DBFiles(1).PhysicalName) & "]"
    ' log
    BackupFile = BackupFile & ",[" & ql.GetColumnString(2, 1) & "],[" & _
                   Trim(m_Connection.Server(DataBase).TransactionLog.LogFiles(1).PhysicalName) & "]"
    
    m_Restore.RelocateFiles = BackupFile
  End If
  
  m_Result = False
  
  RaiseEvent Initialize
  
  GoTo ExitProc
ControlError:
  MngError Err, "RestoreStep1", C_Module, ""
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  RestoreStep1 = m_Result
  
  RaiseEvent Finalize
End Function

Friend Function RestoreStep2()
  On Error GoTo ControlError
  
  m_Restore.SQLRestore m_Connection.Server
      
  m_Connection.Server.Databases.Refresh
  
  m_Result = True
  
  GoTo ExitProc
ControlError:
  If Err.Number = -2147218363 Or Err.Number = -2147218362 Then
    info "Este Backup pertenece a otra base de datos, indique 'sobre escribir' la base de datos para porder utilizarlo."
  
  ElseIf Err.Number = -2147218403 Then
  
    info "Esta base esta siendo utilizada. Si hay otros usuarios conectados debe pedirles que cierren sus conexiones."
  
  ' Estos no son realmente errores
  ' -2147199222 = operacion cancelada por el usuario
  ' -2147221499 = EXCEPTION_ACCESS_VIOLATION
  ElseIf Err.Number = -2147199222 Or Err.Number = -2147221499 Then
      m_Result = True
  Else
    MngError Err, "RestoreStep1", C_Module, ""
  End If
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  RestoreStep2 = m_Result
End Function

' funciones privadas
Private Function CheckDataBaseInUse(ByVal DataBase As String) As Boolean
  On Error GoTo ControlError
  
  Dim ql      As SQLDMO.QueryResults
  Dim Puesto  As String
  Dim i       As Integer
  
  Set ql = m_Connection.Server.EnumProcesses()
  
  Puesto = GetComputerName()
  
  Dim s As String
  s = ""
  For i = 1 To ql.Rows
    If Trim(LCase(ql.GetColumnString(i, 7))) = Trim(LCase(DataBase)) And Trim(LCase(ql.GetColumnString(i, 4))) <> Trim(LCase(Puesto)) Then
      s = s & "Proceso: " & Mid(ql.GetColumnString(i, 7) & "     ", 1, 5)
      s = s & "  Usuario: " & Mid(ql.GetColumnString(i, 3) & String(30, " "), 1, 30)
      s = s & "  Puesto: " & Mid(ql.GetColumnString(i, 4) & String(30, " "), 1, 30)
      s = s & vbCrLf
    End If
  Next
  
  If Not Trim(s) = "" Then
    If Not Ask("Los siguientes procesos estan conectados a la base " & _
                 DataBase & ":" & vbCrLf & vbCrLf & s & vbCrLf & vbCrLf & _
                 ". Para continuar con la recuperacion del backup debera cerrar estos procesos." & _
                 vbCrLf & vbCrLf & "¿Desea Continuar?") Then
      Exit Function
    End If
  End If

  For i = 1 To ql.Rows
    If Trim(LCase(ql.GetColumnString(i, 7))) = (LCase(DataBase)) Then
      On Error Resume Next
      
      Err.Clear
      
      m_Connection.Server.KillProcess ql.GetColumnLong(i, 1)
      
      ' El pool termino el proceso y al intentar cerrarlo me da un error
      '-2147215398
      If Err.Number <> -2147215398 And Err.Number <> 0 Then
        Resume RaiseError
RaiseError:
        On Error GoTo ControlError
        Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
      End If
      
    End If
  Next i

  GoTo ExitProc
ControlError:
  MngError Err, "CehckDataBaseInUse", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Function

Private Sub m_Restore_PercentComplete(ByVal Message As String, ByVal Percent As Long)
  On Error GoTo ControlError
  
  Dim Cancel As Boolean
  
  RaiseEvent RestorePercentComplete(Message, Percent, Cancel)
  
  If Cancel Then m_Restore.Abort
  
ControlError:
End Sub

Private Sub m_Backup_PercentComplete(ByVal Message As String, ByVal Percent As Long)
  On Error GoTo ControlError
  
  Dim Cancel As Boolean
  
  RaiseEvent BackupPercentComplete(Message, Percent, Cancel)
  
  If Cancel Then m_Backup.Abort
  
ControlError:
End Sub
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Backup = New SQLDMO.Backup
  Set m_Restore = New SQLDMO.Restore
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Backup = Nothing
  Set m_Restore = Nothing
  Set m_Connection = Nothing
  
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


