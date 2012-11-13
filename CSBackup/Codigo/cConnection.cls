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
Attribute VB_Exposed = False
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
Private m_Server        As ADODB.Connection
Private m_Connected     As Boolean
' eventos
' propiedades publicas
Public Property Get Server() As ADODB.Connection
  Set Server = m_Server
End Property

Public Property Get Connected() As Boolean
  Connected = m_Connected = True
End Property

Public Property Get NTSecurity() As Boolean
  NTSecurity = m_Server.LoginSecure
End Property

Public Property Get ServerName() As String
  On Error GoTo ControlError
  
  If Not m_Connected Then Exit Property
  If m_Server Is Nothing Then Exit Property
  ServerName = m_Server.Name
  
  GoTo ExitProc
ControlError:
  MngError Err, "ServerName", C_Module, ""
ExitProc:
End Property

Public Property Get UserName() As String

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
Public Function Execute(ByVal sqlstmt As String, _
                        ByVal bSilent As Boolean, _
                        Optional ByRef strError As String) As Boolean
                        
  On Error GoTo ControlError
  
  ' El metodo open de los recordset funciona
  ' mejor que execute de connection
  '
  Dim rs As ADODB.Recordset
  Set rs = New ADODB.Recordset
  Set rs.ActiveConnection = m_Server
  rs.Open sqlstmt
  Set rs = Nothing
  
  Execute = True
  
  GoTo ExitProc
ControlError:
  strError = Err.Description
  If Not bSilent Then
    MngError Err, "Execute", C_Module, ""
  End If
ExitProc:
End Function

Public Function OpenConnectionEx(ByVal ServerName As String, _
                                 ByVal User As String, _
                                 ByVal Password As String, _
                                 ByVal UseTrusted As Boolean, _
                                 ByVal DataBase As String, _
                                 ByVal bSilent As Boolean, _
                                 Optional ByRef strError As String) As Boolean
                                 
  OpenConnectionEx = pOpenConnection(ServerName, _
                                     User, _
                                     Password, _
                                     UseTrusted, _
                                     True, _
                                     DataBase, _
                                     bSilent, _
                                     strError)
End Function

Private Function pOpenConnection(ByVal ServerName As String, _
                                 ByVal User As String, _
                                 ByVal Password As String, _
                                 ByVal UseTrusted As Boolean, _
                                 ByVal bDontShowError As Boolean, _
                                 ByVal DataBase As String, _
                                 ByVal bSilent As Boolean, _
                                 Optional ByRef strError As String) As Boolean
  On Error GoTo ControlError

  If m_Server Is Nothing Then Set m_Server = New ADODB.Connection
  
  CloseConnection
  
  Dim strConnect
  
  If UseTrusted Then
    strConnect = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;User ID=@@user@@;Initial Catalog=@@database@@;Data Source=@@SERVER@@"
  Else
    strConnect = "Provider=SQLOLEDB.1;Password=@@password@@;Persist Security Info=True;User ID=@@user@@;Initial Catalog=@@database@@;Data Source=@@SERVER@@"
  End If
  
  strConnect = Replace(strConnect, "@@SERVER@@", ServerName)
  strConnect = Replace(strConnect, "@@user@@", User)
  strConnect = Replace(strConnect, "@@password@@", Password)
  strConnect = Replace(strConnect, "@@database@@", DataBase)
  
  m_Server.Open strConnect

  m_Connected = True
  pOpenConnection = True
  
  GoTo ExitProc
ControlError:
  strError = Err.Description
  If Not bSilent Then
    MngError Err, "OpenConnection", C_Module, ""
  End If
ExitProc:
End Function

Public Function CloseConnection() As Boolean
  On Error GoTo ControlError
  
  If m_Connected Then
    If Not m_Server Is Nothing Then
      m_Server.Close
    End If
    m_Connected = False
  End If
  
  CloseConnection = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "CloseConnection", C_Module, ""
ExitProc:
End Function

Public Function ListDataBases() As Object
  On Error GoTo ControlError
  
  Dim coll As Collection
  Set coll = New Collection
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_databases"
  Set rs = New ADODB.Recordset
  Set rs.ActiveConnection = m_Server
  rs.CursorLocation = adUseClient
  rs.Open sqlstmt, , adOpenStatic
  Set rs.ActiveConnection = Nothing
  
  While Not rs.EOF
  
    coll.Add rs.Fields.Item("database_name").Value
  
    rs.MoveNext
  Wend
  Set ListDataBases = coll
  
  GoTo ExitProc
ControlError:
  MngError Err, "ListDataBases", C_Module, ""
ExitProc:
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Server = New ADODB.Connection

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

