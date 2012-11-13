VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cConnection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cConection
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:
' Proposito:   Contiene una conexion con un servidor sql

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cConection"
' estructuras
' variables privadas
Private m_Server        As SQLDMO.SQLServer
Private m_Connected     As Boolean
' eventos
' propiedades publicas
Public Property Get Server() As SQLDMO.SQLServer
  Set Server = m_Server
End Property

Public Property Get Connected() As Boolean
  Connected = m_Connected = True
End Property

Public Property Get NTSecurity() As Boolean
  NTSecurity = m_Server.LoginSecure
End Property

Public Property Get ServerName()
  On Error GoTo ControlError
  
  If Not m_Connected Then Exit Property
  If m_Server Is Nothing Then Exit Property
  ServerName = m_Server.Name
  
  GoTo ExitProc
ControlError:
  MngError Err, "ServerName", C_Module, ""
ExitProc:
End Property

Public Property Get UserName()
  On Error GoTo ControlError
  
  If Not m_Connected Then Exit Property
  If m_Server Is Nothing Then Exit Property
  UserName = m_Server.TrueLogin
  
  GoTo ExitProc
ControlError:
  MngError Err, "UserName", C_Module, ""
ExitProc:
End Property

Public Property Get Password()
  On Error GoTo ControlError
  
  If Not m_Connected Then Exit Property
  If m_Server Is Nothing Then Exit Property
  Password = m_Server.Password
  
  GoTo ExitProc
ControlError:
  MngError Err, "Password", C_Module, ""
ExitProc:
End Property

' propiedades privadas
' funciones publicas
Public Function OpenConnectionEx(ByVal ServerName As String, _
                                 ByVal User As String, _
                                 ByVal Password As String, _
                                 ByVal UseTrusted As Boolean) As Boolean
  OpenConnectionEx = pOpenConnection(ServerName, User, Password, UseTrusted, True)
End Function

Public Function OpenConnection(ByVal ServerName As String, _
                               ByVal User As String, _
                               ByVal Password As String, _
                               ByVal UseTrusted As Boolean) As Boolean
  OpenConnection = pOpenConnection(ServerName, User, Password, UseTrusted, False)
End Function

Private Function pOpenConnection(ByVal ServerName As String, _
                                 ByVal User As String, _
                                 ByVal Password As String, _
                                 ByVal UseTrusted As Boolean, _
                                 ByVal bDontShowError As Boolean) As Boolean
  On Error GoTo ControlError

  If m_Server Is Nothing Then Set m_Server = New SQLDMO.SQLServer
  
  CloseConnection
  
  m_Server.LoginSecure = UseTrusted
  m_Server.Connect ServerName, User, Password

  m_Connected = True
  pOpenConnection = True
  
  GoTo ExitProc
ControlError:
  If Not bDontShowError Then
    MngError Err, "OpenConnection", C_Module, ""
  Else
    gLastError = Err.Number
  End If
ExitProc:
End Function

Public Function CloseConnection() As Boolean
  On Error GoTo ControlError
  
  If m_Connected Then
    If Not m_Server Is Nothing Then
      m_Server.DisConnect
    End If
    m_Connected = False
  End If
  
  CloseConnection = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "CloseConnection", C_Module, ""
ExitProc:
End Function

Public Sub StopServer()
  Server.Stop
  CloseConnection
End Sub

Public Function StartServerAndConnect(ByVal Server As String, ByVal User As String, ByVal Pwd As String) As Boolean
  CloseConnection
  Me.Server.Start True, Server, User, Pwd
  m_Connected = True
  StartServerAndConnect = Me.Server.Status = SQLDMOSvc_Running
End Function

Public Function StopAndStartServer() As Boolean
  Server.Stop
  StopAndStartServer = StartServerAndConnect(Server.Name, Server.Login, Server.Password)
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Server = New SQLDMO.SQLServer
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
ExitProc:
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  CloseConnection
  Set m_Server = Nothing
  
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

