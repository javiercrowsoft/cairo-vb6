VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSqlDMOServer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "fMain"

Private WithEvents m_SQLServer As cSQLServer
Attribute m_SQLServer.VB_VarHelpID = -1

Private m_ServerName           As String
Private m_UserName             As String
Private m_Password             As String
Private m_NTSecurity           As Boolean

Public Function Login(ByVal server As String, _
                      ByVal User As String, _
                      ByVal Pwd As String, _
                      ByVal bNt As Boolean) As Boolean
  
  If Not m_SQLServer.OpenConnectionEx(server, _
                                  User, _
                                  Pwd, _
                                  bNt) Then
    Exit Function
  End If

  m_ServerName = server
  m_UserName = User
  m_Password = Pwd
  m_NTSecurity = bNt

  Login = True

End Function

Public Function Backup(ByVal DataBase As String, _
                       ByVal BackupFolder As String) As Boolean
  On Error GoTo ControlError
  
  m_SQLServer.IsForInstall = True
  
  If Not m_SQLServer.ShowBackup(DataBase, _
                                True, _
                                ValidPath(BackupFolder) & DataBase & ".bak" _
                                ) Then Exit Function
  
  Backup = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Backup", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_SQLServer = New cSQLServer

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_SQLServer = Nothing

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub
