VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cLogin
' 10-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    
'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_ClientProcessId               As Long
Private m_vDataBases()                  As String
Private m_Client                        As cTCPIPClient
Private m_UserName                      As String
Private m_db_id                         As Long
Private m_emp_id                        As Long
Private m_ConnectString                 As String
Private m_Password                      As String
Private m_Server                        As String
Private m_Port                          As Long
' propiedades publicas
Public Property Get ClientProcessId() As Long
   ClientProcessId = m_ClientProcessId
End Property

Public Property Let ClientProcessId(ByVal rhs As Long)
   m_ClientProcessId = rhs
End Property

Public Property Get Client() As cTCPIPClient
   Set Client = m_Client
End Property

Public Property Set Client(ByVal rhs As cTCPIPClient)
   Set m_Client = rhs
End Property

Public Property Get UserName() As String
  UserName = m_UserName
End Property

Public Property Get db_id() As String
  db_id = m_db_id
End Property

Public Property Get emp_id() As Long
  emp_id = m_emp_id
End Property

Public Property Get Password() As String
  Password = m_Password
End Property

Public Property Get ConnectString() As String
  ConnectString = m_ConnectString
End Property

Public Property Let Server(ByVal rhs As String)
  m_Server = rhs
End Property

Public Property Let Port(ByVal rhs As Long)
  m_Port = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function Login(ByVal AppName As String, ByRef Client As cTCPIPClient) As Boolean
  
  If Not pConnectToServer(Client) Then Exit Function
  
  Login = pLoginAux(AppName, Client)
End Function

Public Function LoginSilent(ByVal AppName As String, ByRef Client As cTCPIPClient, _
                            ByVal User As String, ByVal Password As String, _
                            ByVal db_id As Long, ByVal emp_id As Long) As Boolean
                            
  If Not pConnectToServer(Client) Then Exit Function
  
  LoginSilent = pLoginSilentAux(AppName, Client, User, Password, db_id, emp_id)
End Function

Public Function LoginToEmpresa(ByVal AppName As String, ByRef Client As cTCPIPClient, _
                               ByVal db_id As String, ByVal emp_nombre As String) As Boolean
                            
  If Not pConnectToServer(Client) Then Exit Function
  
  LoginToEmpresa = pLoginToEmpresaAux(AppName, Client, db_id, emp_nombre)
End Function

' funciones friend
Friend Function Login_(ByVal User As String, ByVal Password As String, ByVal bd_id As Long, ByVal emp_id As Long, ByRef ErrorMsg As String) As Boolean

  Dim Buffer    As String
  Dim Message   As String
  Dim EmpId     As Long
  Dim bdidtmp   As Long
  
  If emp_id = 0 Then
    bdidtmp = bd_id / 1000000
    EmpId = bd_id - (1000000 * bdidtmp)
    bd_id = bdidtmp
  Else
    EmpId = emp_id
  End If
  
  Message = TCPGetMessageLoginOn(m_Client.ClientId, User, Password, bd_id, EmpId)
  
  Buffer = TCPGetMessage(cTCPCommandLoginOn, m_ClientProcessId, Message)
  If Not m_Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(m_Client.DataReceived) Then
    MsgError "Ha ocurrido un error al verificar sus credenciales de usuario.;;Descripción técnica: " & TCPGetResponse(m_Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(m_Client.DataReceived)
  
  If TCPGetFail(m_Client.DataReceived) Then
    ErrorMsg = Buffer
    
    ' Si fallo me vuelvo a conectar para evitar rebotes
    '
    m_Client.ClearResponse
    m_Client.Disconnect
    '
    '
    pConnectToServer m_Client
    Exit Function
  End If
  
  m_db_id = bd_id
  m_emp_id = EmpId
  
  m_UserName = User
  m_Password = Password
  
  Message = TCPGetMessageGetConnectString(bd_id)
  
  Buffer = TCPGetMessage(cTCPCommandGetConnectString, m_ClientProcessId, Message)
  If Not m_Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(m_Client.DataReceived) Then
    MsgError "Ha ocurrido un error al intentar obtener el string de conexión.;;Descripción técnica: " & TCPGetResponse(m_Client.DataReceived)
    Exit Function
  End If
  
  m_ConnectString = TCPGetResponse(m_Client.DataReceived)

  Login_ = True

End Function

' funciones privadas
Private Function pLoginAux(ByVal AppName As String, ByRef Client As cTCPIPClient) As Boolean
  Dim f As fLogin
  Set f = New fLogin
  Load f
  
  If Not pFillDataBases(Client, f) Then
    Unload f
    Exit Function
  End If
  
  Set m_Client = Client
  Set f.Login = Me
  f.Init AppName
  f.Show vbModal
  
  pLoginAux = f.Ok
  
  Set f.Login = Nothing
  Unload f
  Set m_Client = Nothing
End Function

Private Function pSelectDatabaseForEmpNombre( _
                ByVal cb As Object, _
                ByVal db_id As String, _
                ByVal emp_nombre As String) As Boolean
  
  Dim i As Long
  Dim vDataBasesData() As String

  For i = 0 To UBound(m_vDataBases)
    vDataBasesData = Split(m_vDataBases(i), c_TCPSep1)
    
    If vDataBasesData(0) = db_id And vDataBasesData(1) = emp_nombre Then
      ListSetListIndexForId cb, vDataBasesData(0) * 1000000 + vDataBasesData(5)
      pSelectDatabaseForEmpNombre = True
      Exit Function
    End If
  Next
  
  MsgWarning "No se ha podido establecer una conexión con la base de datos del sistema.", "Login"
  
End Function

Private Function pLoginToEmpresaAux(ByVal AppName As String, ByRef Client As cTCPIPClient, _
                                    ByVal db_id As String, ByVal emp_nombre As String) As Boolean
  Dim f As fLogin
  Set f = New fLogin
  Load f
  
  If Not pFillDataBases(Client, f) Then
    Unload f
    Exit Function
  End If
    
  Set m_Client = Client
  Set f.Login = Me
  f.Init AppName
  
  If Not pSelectDatabaseForEmpNombre(f.cbCompany, db_id, emp_nombre) Then
    Set f.Login = Nothing
    Unload f
    Exit Function
  End If
  
  
  f.cbCompany.Visible = False
  f.lbCompany.Visible = False
  f.lbPassword.Top = f.lbUser.Top
  f.TxPassword.Top = f.TxUser.Top
  f.lbUser.Top = f.lbCompany.Top
  f.TxUser.Top = f.cbCompany.Top
  
  f.Show vbModal
  
  pLoginToEmpresaAux = f.Ok
  
  Set f.Login = Nothing
  Unload f
  Set m_Client = Nothing
End Function

Private Function pLoginSilentAux(ByVal AppName As String, ByRef Client As cTCPIPClient, _
                                 ByVal User As String, ByVal Password As String, _
                                 ByVal db_id As Long, ByVal emp_id As Long) As Boolean
  Dim ErrorMsg As String
  
  Set m_Client = Client
  
  If Login_(User, Password, db_id, emp_id, ErrorMsg) Then
    pLoginSilentAux = True
  Else
    CSKernelClient2.MsgWarning ErrorMsg, "Login"
    pLoginSilentAux = False
  End If
  
  Set m_Client = Nothing
End Function

Private Function pFillDataBases(ByRef Client As cTCPIPClient, ByRef f As fLogin) As Boolean
  Dim Buffer    As String
  Dim i         As Integer
  
  Buffer = TCPGetMessage(cTCPCommandListDbs, m_ClientProcessId)
  
  If Not Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(Client.DataReceived) Then
    MsgError "Ha ocurrido un error al intentar obtener la lista de empresas.;;Descripción técnica: " & TCPGetResponse(Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(Client.DataReceived)
  
  Dim vDataBasesData() As String
  m_vDataBases = Split(Buffer, c_TCPSep2)
  
  f.cbCompany.Clear
  
  For i = 0 To UBound(m_vDataBases)
    vDataBasesData = Split(m_vDataBases(i), c_TCPSep1)
    
    With f.cbCompany
      .AddItem vDataBasesData(1)
      .ItemData(.NewIndex) = vDataBasesData(0) * 1000000 + vDataBasesData(5)
    End With
  Next

  pFillDataBases = UBound(m_vDataBases) >= 0
End Function

Private Function pConnectToServer(ByRef Client As cTCPIPClient) As Boolean
  Dim Buffer    As String
  Dim Server    As String
  Dim Port      As Integer
  
  If m_Server <> vbNullString Then
    Server = m_Server
  Else
    Server = IniGet(c_K_Server, "")
  End If
  If m_Port <> 0 Then
    Port = m_Port
  Else
    Port = Val(IniGet(c_k_Port, ""))
  End If
  
  If Server = "" Then
    MsgError "Debe indicar un servidor en el archivo " & c_MainIniFile
    Exit Function
  End If
  
  If Port = 0 Then
    MsgError "Debe indicar un port en el archivo " & c_MainIniFile
    Exit Function
  End If
  
  If Not Client.ConnectToServer(Server, Port) Then
    MsgError "No se ha podido crear la conexión con el server Cairo.;;Descripción técnica: " & Client.ErrDescription
    Exit Function
  End If
  
  Buffer = TCPCreateToken(c_ClientComputer, GetComputerName())
  Buffer = Buffer & TCPCreateToken(c_ClientTCP_ID, Client.ClientId)
  Buffer = Buffer & TCPCreateToken(c_ClientUser, "")
  
  Buffer = TCPGetMessage(cTCPCommandAddClient, m_ClientProcessId, Buffer)
  
  If Not Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(Client.DataReceived) Then
    MsgError "Ha ocurrido un error al intentar registrarce con el servidor Cairo.;;Descripción técnica: " & TCPGetResponse(Client.DataReceived)
    Exit Function
  End If
    
  m_ClientProcessId = Val(TCPGetResponse(Client.DataReceived))
  
  pConnectToServer = True
End Function
' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_Client = Nothing
End Sub
