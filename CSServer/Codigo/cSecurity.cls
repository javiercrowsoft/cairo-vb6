VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSecurity"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cSecurity
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIService

' constantes
Private Const C_Module = "cSecurity"
' estructuras
' variables privadas
Private m_ServiceID           As Long
Private m_Server              As cIServer
Private m_db                  As cDataSource
Private m_ClientsProcess      As cClientsProcess
Private m_NextClientProcess   As Long
Private m_StatusCode          As Long
Private m_MaxUsers            As Long
Private m_DateActive          As Date
' eventos
' propiedadades publicas
Private Property Let cIService_ServiceID(ByVal rhs As Long)
  m_ServiceID = rhs
End Property

Private Property Get cIService_ServiceID() As Long
  cIService_ServiceID = m_ServiceID
End Property

Private Property Set cIService_Server(rhs As CSIService.cIServer)
  Set m_Server = rhs
End Property

Private Property Get cIService_Server() As CSIService.cIServer
  Set cIService_Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cIService_ClientShutDown(ByVal ClientId As Long)
  pClientShutDown ClientId
End Sub

Private Sub cIService_WndProc(ByVal ClientId As Long, Message() As Byte, Response() As Byte)
  On Error GoTo ControlError

  Dim sMessage          As String
  Dim ErrDescription    As String
  Dim ClientProcess     As Long
  
  m_Server.ByteArrayToString sMessage, Message

  ClientProcess = pGetClientProcess(sMessage)
  
  If Not pIsAddClientProcess(ClientProcess, ErrDescription) Then
    sMessage = c_ErrorCode & ErrDescription
    m_Server.StringToByteArray sMessage, Response
    Exit Sub
  End If
  
  Select Case TCPGetTypeMessage(sMessage)
    Case c_LIST_DBS
      If pGetDataBases(sMessage, ErrDescription) Then
        sMessage = c_SucessCode & sMessage
      Else
        sMessage = c_ErrorCode & ErrDescription
      End If
      m_Server.StringToByteArray sMessage, Response
    
    Case c_ADD_CLIENT
      ClientProcess = pAddClientProcess(TCPGetRealMessage(sMessage))
      sMessage = c_SucessCode & ClientProcess
      m_Server.StringToByteArray sMessage, Response
  
    Case c_REMOVE_CLIENT
      pRemoveClientProcess ClientProcess
      sMessage = c_SucessCode
      m_Server.StringToByteArray sMessage, Response
  
    Case c_LIST_CLIENTS
      sMessage = c_LIST_CLIENTS_RESP & pGetClients(False)
      sMessage = c_SucessCode & sMessage
      m_Server.StringToByteArray sMessage, Response
      
    Case c_GET_INFO_CLIENT
      sMessage = pGetInfoClient(Val(TCPGetRealMessage(sMessage)))
      sMessage = c_SucessCode & sMessage
      m_Server.StringToByteArray sMessage, Response
      
    Case c_LOGIN_ON
      If pLogginOn(TCPGetRealMessage(sMessage), sMessage, ClientProcess) Then
        sMessage = sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response
    
    Case c_LOGIN_GET_CONNECT_STR_DOM
      pGetConnectStrDom sMessage
      sMessage = c_SucessCode & sMessage
      m_Server.StringToByteArray sMessage, Response
    
    Case c_LOGIN_GET_CONNECT_STR_DOM2
      pGetConnectStrDom2 sMessage
      sMessage = c_SucessCode & sMessage
      m_Server.StringToByteArray sMessage, Response
    
    Case c_LOGIN_GET_CONNECT_STRING
      If pGetConnectString(TCPGetRealMessage(sMessage), sMessage) Then
        sMessage = c_SucessCode & sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response
    
    Case c_REFRESH_ACTIVE_INFO
      pValidateCodigo
      sMessage = c_SucessCode
      m_Server.StringToByteArray sMessage, Response
    
    Case c_IS_ACTIVE
      sMessage = m_StatusCode
      m_Server.StringToByteArray sMessage, Response
    
    Case c_GET_CODIGO_MAC_ADDRESS
      If pGetMacAddress(sMessage) Then
        sMessage = c_SucessCode & sMessage
      Else
        sMessage = c_ErrorCode & "No se pudo obtener el codigo"
      End If
      m_Server.StringToByteArray sMessage, Response
    
    Case c_LOGIN_ON_DOMAIN
      If pLogginOnDomain(TCPGetRealMessage(sMessage), ClientProcess, sMessage) Then
        sMessage = sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response
    
    Case c_LOGIN_ON_CHAT
      If pLogginOnChat(TCPGetRealMessage(sMessage), ClientProcess, sMessage) Then
        sMessage = sMessage
      Else
        sMessage = c_ErrorCode & sMessage
      End If
      m_Server.StringToByteArray sMessage, Response
    
    Case c_LIST_CHAT_CLIENTS
      sMessage = c_LIST_CHAT_CLIENTS_RESP & pGetClients(True)
      sMessage = c_SucessCode & sMessage
      m_Server.StringToByteArray sMessage, Response
    
    Case c_SET_CLIENT_ACTIVE
      pSetStateInClient ClientProcess, cClProcStateActive
      m_Server.StringToByteArray c_SucessCode, Response
    
    Case c_REFRESH_LOGINON
      pRefreshListClient
      m_Server.StringToByteArray c_SucessCode, Response
    
    Case c_REFRESH_SECURITY
      pRefreshSecurity sMessage
      m_Server.StringToByteArray c_SucessCode, Response
    
    Case c_REFRESH_AVISO
      pRefreshAviso sMessage
      m_Server.StringToByteArray c_SucessCode, Response
    Case Else
            
      ' No esta implementado
  
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIService_WndProc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
  m_Server.StringToByteArray c_ErrorCode & gErrorInfo, Response
ExitProc:
  On Error Resume Next
End Sub

Private Function pClientShutDown(ByVal ClientId As Long) As Boolean
  Dim ByteArray() As Byte
  
  Dim c As cClientProcess
  
  For Each c In m_ClientsProcess
    If c.IsMonitor Or c.IsChat Then
      If c.TCP_ID <> ClientId Then
        
        m_Server.StringToByteArray TCPGetMessage( _
                                     cTCPCommandClientShutDown, _
                                     c.ClientProcessId, _
                                     ClientId), _
                                   ByteArray
        
        If Not m_Server.SendMessage(c.TCP_ID, ByteArray) Then
          
          SaveLog "No se pudo enviar la notificación de 'fin de seción' del cliente " & _
                  ClientId & "  al servicio " & c.ClientComputer & ":" & c.TCP_ID
        End If
      End If
    End If
  Next
  
  For Each c In m_ClientsProcess
    If c.TCP_ID = ClientId Then
      m_ClientsProcess.Remove c.Key
      Exit For
    End If
  Next
  
  If gLogTrafic Then
    SaveLog "Cliente " & ClientId & " removido"
  End If
  pClientShutDown = True
End Function

Private Function pGetDataBaseInfo( _
                                ByVal bd_id As Long, _
                                ByRef Database As String, _
                                ByRef SqlLogin As String, _
                                ByRef SqlPassw As String, _
                                ByRef Server As String, _
                                ByRef UseNTSecurity As Integer _
                                ) As Boolean
                                
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
                                
  If Not pGetDBData(bd_id, "bd_login", SqlLogin) Then Exit Function
  If Not pGetDBData(bd_id, "bd_pwd", SqlPassw) Then Exit Function
  If Not pGetDBData(bd_id, "bd_server", Server) Then Exit Function
  If Not pGetDBData(bd_id, "bd_nombre", Database) Then Exit Function
  If Not pGetDBData(bd_id, "bd_securitytype", UseNTSecurity) Then Exit Function

  SqlLogin = Encrypt.Decript(SqlLogin, c_LoginSignature)
  SqlPassw = Encrypt.Decript(SqlPassw, c_LoginSignature)
  Server = Encrypt.Decript(Server, c_LoginSignature)
  Database = Encrypt.Decript(Database, c_LoginSignature)

  pGetDataBaseInfo = True

End Function

Private Sub pGetConnectStrDom(ByRef msg As String)
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  msg = Encrypt.Decript(m_db.ConnectString, c_LoginSignature)
End Sub

Private Sub pGetConnectStrDom2(ByRef msg As String)
  Dim sqlstmt     As String
  Dim rs          As ADODB.Recordset
  Dim strConnect  As String
  
  sqlstmt = "select si_valor from sistema where si_clave = '" & c_StrConnectDom2 & "'"
  If Not m_db.OpenRs(rs, sqlstmt) Then Exit Sub
  
  If rs.EOF Then
    Dim Encrypt As cEncrypt
    Set Encrypt = New cEncrypt
    msg = Encrypt.Decript(m_db.ConnectString, c_LoginSignature)
  Else
    msg = rs.Fields.Item(0).Value
  End If
End Sub

Private Function pGetConnectString(ByVal Message As String, ByRef msg As String) As Boolean
  Dim bd_id     As Long
  Dim Database As String
  Dim SqlLogin As String
  Dim SqlPassw As String
  Dim Server   As String
  Dim UseNTSecurity As Integer
  
  Dim vParams() As String
  
  vParams = Split(Message, c_TCPSep1)
  
  If UBound(vParams) < 0 Then
    msg = "Debe indicar el parametro bd_id al llamar a GetConnectString"
    Exit Function
  End If
  
  If Not IsNumeric(vParams(0)) Then
    msg = "Id de base de datos incorrecto " & Message
    Exit Function
  End If
  
  bd_id = CLng(vParams(0))
  
  If Not pGetDataBaseInfo(bd_id, Database, SqlLogin, SqlPassw, Server, UseNTSecurity) Then GoTo ShowErrorInfo
  
  msg = m_db.GetConnetString(Server, Database, SqlLogin, SqlPassw, UseNTSecurity = NTSecurity)
  
  pGetConnectString = True
  Exit Function
  
ShowErrorInfo:
  msg = gErrorInfo
End Function

Private Function pGetDBData(ByVal bd_id As Long, ByVal Field As String, ByRef rtn As Variant) As Boolean
  pGetDBData = m_db.GetData("BaseDatos", "bd_id", bd_id, Field, rtn)
End Function

Private Function pLogginOn(ByVal Message As String, ByRef msg As String, ByVal ClientProcess As Long) As Boolean
  If m_StatusCode <> c_ACTIVE_CODE_OK Then
    pValidateCodigo
  End If
  
  If m_StatusCode = c_ACTIVE_CODE_OK Then
  
    pLogginOn = pLogginOnAux(Message, msg, ClientProcess)
  
  ElseIf m_StatusCode = c_ACTIVE_CODE_ERROR Then
    msg = c_FailCode & "No se ha podido obtener el código de activación"
  ElseIf m_StatusCode = c_ACTIVE_CODE_INVALID_CODE Then
    msg = c_FailCode & "El código de activación no es valido.;;" & c_GetCodigoStr
  ElseIf m_StatusCode = c_ACTIVE_CODE_INVALID_DATE Then
    msg = c_FailCode & "Esta licencia se ha vencido el " & m_DateActive & " (El servidor indica que hoy es: " & Date & ").;;" & c_GetCodigoStr
  ElseIf m_StatusCode = c_ACTIVE_CODE_UNDEFINED Then
    msg = c_FailCode & "No podrá ingresar al sistema por que se encuentra inactivo.;;" & c_GetCodigoStr
  ElseIf m_StatusCode = 0 Then
    msg = c_FailCode & "No se ha podido obtener el código de activación"
  End If
  
  pLogginOn = True
End Function

Private Function pLogginOnAux(ByVal Message As String, _
                              ByRef msg As String, _
                              ByVal ClientProcess As Long) As Boolean
  Dim UserName      As String
  Dim Password      As String
  Dim bd_id         As Long
  Dim Database      As String
  Dim SqlLogin      As String
  Dim SqlPassw      As String
  Dim Server        As String
  Dim UseNTSecurity As Integer
  Dim ClientId      As Long
  Dim UsID          As Long
  Dim InternalUser  As Boolean
  Dim emp_id        As Long
  
  Dim vParams()     As String
  
  vParams = Split(Message, c_TCPSep1)
  
  ClientId = CLng(vParams(c_LOGIN_ON_TCP_ID))
  UserName = vParams(c_LOGIN_ON_User)
  Password = vParams(c_LOGIN_ON_Password)
  bd_id = CLng(vParams(c_LOGIN_ON_bd_id))
  emp_id = CLng(vParams(c_LOGIN_ON_emp_id))
  
  If Not m_Server.RegisterClient(ClientId, Me) Then
    gErrorInfo = "No fue posible registrar este cliente en el servidor CSTCP-IPServer"
    Exit Function
  End If
  
  If Not pGetDataBaseInfo(bd_id, Database, SqlLogin, SqlPassw, Server, UseNTSecurity) Then GoTo ShowErrorInfo
  
  Dim sqlstmt As String
  Dim db      As cDataSource
  Dim rs      As Recordset
  
  Set db = New cDataSource
  
  If Not db.OpenConnection(Server, Database, SqlLogin, SqlPassw, UseNTSecurity = NTSecurity, "") Then GoTo ShowErrorInfo
  
  sqlstmt = "sp_LoginGetLogin " & db.sqlString(UserName) & "," & emp_id
  
  If Not db.OpenRs(rs, sqlstmt) Then GoTo ShowErrorInfo
  
  If rs.EOF Then
    msg = c_FailCode & "El usuario no existe"
  
  ElseIf Encript(LCase(Password), c_LoginSignature) <> db.ValField(rs.Fields("us_clave")) Then
    msg = c_FailCode & "Clave invalida"
  
  ElseIf db.ValField(rs.Fields("activo")) = 0 Then
    msg = c_FailCode & "El usuario esta inactivo"
  
  Else
    
    Dim ProcessCount As Long
    
    ProcessCount = m_ClientsProcess.Count
    
    If ProcessCount > m_MaxUsers Then
      ProcessCount = pGetActiveProcessCount()
    End If
    'Debug.Print m_MaxUsers & "-" & ProcessCount
    If ProcessCount > m_MaxUsers Then
      msg = c_FailCode & "La cantidad de usuarios conectados es mayor a la cantidad de licencias registradas (" & m_MaxUsers & ").;;Debe solicitar más licencias a " & c_CompanyName
      'Debug.Print msg
    Else
      UsID = db.ValField(rs.Fields("us_id"))
      InternalUser = db.ValField(rs.Fields("us_externo")) = 0
      msg = c_SucessCode & UsID
    End If
  End If
  
  pSetConnectStringInClient ClientProcess, db.ConnectString
  pSetUserInClient ClientProcess, UserName, UsID, InternalUser
  pSetStateInClient ClientProcess, cClProcStateActive
  
  pNotifyMonitor cNotifyClientLoginOn, "", pGetClient(ClientProcess)
  
  pLogginOnAux = True
  Exit Function
    
ShowErrorInfo:
  msg = gErrorInfo
End Function

Private Function pGetActiveProcessCount() As Long
  Dim Client  As cClientProcess
  Dim iCount  As Long
  
  'pRefreshListClient
  
  For Each Client In m_ClientsProcess
    
    If Client.ClientState <> cClProcStateLonginOn Then
    
      pRefreshListClientAux Client.TCP_ID, Client.ClientProcessId, Client.IsMonitor
    End If
    DoEvents
  Next
  
  ' Por cada cliente lo pongo en el estado
  ' NO RESPONDE y le indico que debe
  ' Refrescar el login, para que el cliente
  ' me notifique que esta activo
  '
  For Each Client In m_ClientsProcess
    
    If Client.ClientState = cClProcStateActive And _
       Client.IsMonitor = False And _
       Client.IsChat = False Then
      iCount = iCount + 1
    End If
    
  Next
  
  pGetActiveProcessCount = iCount
  'Debug.Print iCount
End Function

Private Function pGetClient(ByVal ClientProcess As Long) As cClientProcess
  Set pGetClient = m_ClientsProcess(GetKey(ClientProcess))
End Function

Private Sub pSetConnectStringInClient(ByVal ClientProcess As Long, ByVal ConnectString)
  m_ClientsProcess.Item(GetKey(ClientProcess)).ConnectString = ConnectString
End Sub

Private Sub pSetUserInClient(ByVal ClientProcess As Long, _
                             ByVal User As String, _
                             ByVal UsID As Long, _
                             ByVal InternalUser As Boolean)
  With m_ClientsProcess.Item(GetKey(ClientProcess))
    .ClientUser = User
    .UsID = UsID
    .IsInternal = InternalUser
  End With
End Sub

Private Sub pSetStateInClient(ByVal ClientProcess As Long, ByVal State As csClientProcessState)
  m_ClientsProcess.Item(GetKey(ClientProcess)).ClientState = State
End Sub

Private Function pGetMacAddress(ByRef Message As String) As Boolean
  Dim Codigo As String
  Codigo = GetMACAddressInText(GetMACAddress(0))
  Message = Codigo
  pGetMacAddress = True
End Function

Private Function pLogginOnChat(ByVal Message As String, _
                               ByVal ClientProcess As Long, _
                               ByRef msg As String) As Boolean
  
  ' Es un loggin estandar
  ' mas un par de cositas
  '
  
  If m_StatusCode <> c_ACTIVE_CODE_OK Then
    pValidateCodigo
  End If
  
  If m_StatusCode = c_ACTIVE_CODE_OK Then
  
    pLogginOnChat = pLogginOnAux(Message, msg, ClientProcess)
  
    m_ClientsProcess.Item(GetKey(ClientProcess)).IsChat = True
  
  ElseIf m_StatusCode = c_ACTIVE_CODE_ERROR Then
    msg = c_FailCode & "No se ha podido obtener el código de activación"
  ElseIf m_StatusCode = c_ACTIVE_CODE_INVALID_CODE Then
    msg = c_FailCode & "El código de activación no es valido.;;" & c_GetCodigoStr
  ElseIf m_StatusCode = c_ACTIVE_CODE_INVALID_DATE Then
    msg = c_FailCode & "Esta licencia se ha vencido el " & m_DateActive & " (El servidor indica que hoy es: " & Date & ").;;" & c_GetCodigoStr
  ElseIf m_StatusCode = c_ACTIVE_CODE_UNDEFINED Then
    msg = c_FailCode & "No podrá ingresar al sistema por que se encuentra inactivo.;;" & c_GetCodigoStr
  End If
 
  pLogginOnChat = True
  Exit Function
    
ShowErrorInfo:
  msg = gErrorInfo
End Function

Private Function pLogginOnDomain(ByVal Message As String, ByVal ClientProcess As Long, ByRef msg As String) As Boolean
  Dim Password      As String
  Dim ClientId      As Long
  
  Dim vParams() As String
  
  vParams = Split(Message, c_TCPSep1)
  
  ClientId = CLng(vParams(c_LOGIN_ON_TCP_ID))
  Password = vParams(c_LOGIN_ON_DOMAIN_Password)
  
  If Not m_Server.RegisterClient(ClientId, Me) Then
    gErrorInfo = "No fue posible registrar este cliente en el servidor CSTCP-IPServer"
    Exit Function
  End If
  
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sqlstmt = "select si_valor from sistema where si_clave = '" & c_PasswordDomain & "'"
  
  If Not m_db.OpenRs(rs, sqlstmt) Then GoTo ShowErrorInfo
  
  If rs.EOF Then
    msg = c_FailCode & "Error de instalación del sistema no se ha encontrado una entrada en la tabla sistema para la clave de Administrador de Dominio."
  
  ElseIf Encript(LCase(Password), c_LoginSignature) <> m_db.ValField(rs.Fields("si_valor")) Then
    msg = c_FailCode & "Clave invalida"
  
  Else
    msg = c_SucessCode
  End If
  
  pSetUserInClient ClientProcess, "Administrador Cairo", -1000, True
  pSetStateInClient ClientProcess, cClProcStateActive
    
  pNotifyMonitor cNotifyClientLoginOn, "", pGetClient(ClientProcess)
  
  m_ClientsProcess.Item(GetKey(ClientProcess)).IsMonitor = True
  
  pLogginOnDomain = True
  Exit Function
    
ShowErrorInfo:
  msg = gErrorInfo
End Function

Private Function pGetInfoClient(ByVal ClientProcessId As Long) As String
  Dim c   As cClientProcess
  Dim rtn As String
  
  For Each c In m_ClientsProcess
    If c.ClientProcessId = ClientProcessId Then
      rtn = c_LIST_CLIENTS_RESP & pGetClientStr(c) & c_TCPSep2
      Exit For
    End If
  Next
  
  pGetInfoClient = pRemoveLastSep(rtn)
End Function

Private Function pGetClients(ByVal bOnlyInternal As Boolean) As String
  Dim c   As cClientProcess
  Dim rtn As String
  
  For Each c In m_ClientsProcess
    If Not bOnlyInternal Or c.IsInternal Then
      rtn = rtn & pGetClientStr(c) & c_TCPSep2
    End If
  Next
  
  pGetClients = pRemoveLastSep(rtn)
End Function

Private Function pGetClientStr(ByRef c As cClientProcess) As String
  pGetClientStr = c.ClientProcessId & c_TCPSep1 _
                & c.ClientComputer & c_TCPSep1 _
                & c.ClientUser & c_TCPSep1 _
                & c.TCP_ID & c_TCPSep1 _
                & TCPGetDateToString(c.ClientConnected) & c_TCPSep1 _
                & pGetState(c.ClientState) & c_TCPSep1 _
                 & CInt(c.IsMonitor)
End Function

Private Function pGetState(ByVal State As csClientProcessState) As String
  Select Case State
    Case cClProcStateActive
      pGetState = "Connectado-Activo"
    Case cClProcStateLonginOn
      pGetState = "Verificando el loggin"
    Case cClProcStateStandby
      pGetState = "Pausa"
    Case cClProcStateNotResponse
      pGetState = "No responde"
  End Select
End Function

Private Sub pRemoveClientProcess(ByVal ClientProcess As Long)
  m_ClientsProcess.Remove GetKey(ClientProcess)
End Sub

Private Sub pRefreshAviso(ByVal Message As String)
  Dim Client          As cClientProcess
  Dim vstrUsID()      As String
  Dim vUsID()         As Long
  Dim ClientProcessId As Long
  Dim i               As Long
  
  ' TODO: Obtener Id's
  ClientProcessId = pGetClientProcess(Message)
  Message = Mid(Message, c_Len_Type + 1)
  Message = Mid(Message, 1, Len(Message) - c_Len_ProcessId)
  
  ReDim vUsID(0)
  vstrUsID() = Split(Message, ",")
  
  For i = 0 To UBound(vstrUsID)
    ReDim vUsID(UBound(vUsID) + 1)
    vUsID(UBound(vUsID)) = Val(vstrUsID(i))
  Next
  
  For Each Client In m_ClientsProcess
    If pClientInList(Client.UsID, vUsID) Then
      pRefreshAvisoAux Client.TCP_ID, Client.ClientProcessId
    End If
  Next
End Sub

Private Sub pRefreshAvisoAux(ByVal TCP_ID As Long, ByVal ClientProcessId As Long)
  Dim ByteArray() As Byte
  Dim sMessage    As String
  
  
  ' Ojo con como se construye el mensaje
  ' no alteren la secuencia de estas cuatro lineas
  ' porque deja de andar
  sMessage = TCPSetDllID(c_AnyComponentTCP, "")
  sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
  sMessage = TCPSetDllProgID(csSecAviso, sMessage)
  sMessage = sMessage & TCPSecurityGetMessage(cTCPSecCommandAviso, ClientProcessId, "")
  sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
                                      ' Esta repetido aproposito para que no falle
                                      ' la primitiva TCPSetDllProgID
  
  m_Server.StringToByteArray sMessage, ByteArray
  m_Server.SendMessage TCP_ID, ByteArray
End Sub

Private Sub pRefreshListClient()
  Dim Client  As cClientProcess
  
  ' Por cada cliente lo pongo en el estado
  ' NO RESPONDE y le indico que debe
  ' Refrescar el login, para que el cliente
  ' me notifique que esta activo
  '
  For Each Client In m_ClientsProcess
    
    Client.ClientState = cClProcStateNotResponse
    
    pRefreshListClientAux Client.TCP_ID, Client.ClientProcessId, Client.IsMonitor
    
    DoEvents
  Next
End Sub

Private Sub pRefreshSecurity(ByVal Message As String)
  Dim Client As cClientProcess
  Dim UsID() As Long
  Dim UserId As Long
  Dim RolId  As Long
  Dim vMessage() As String
  Dim ClientProcessId As Long
  
  ' TODO: Obtener Id's
  ClientProcessId = pGetClientProcess(Message)
  Message = Mid(Message, c_Len_Type + 1)
  Message = Mid(Message, 1, Len(Message) - c_Len_ProcessId)
  
  vMessage() = Split(Message, ":")
  
  UserId = Val(vMessage(3))
  RolId = Val(vMessage(1))
  
  ReDim UsID(0)
  UsID = pGetUsers(UserId, RolId, pGetClient(ClientProcessId).ConnectString)
  
  For Each Client In m_ClientsProcess
    If pClientInList(Client.UsID, UsID()) Then
      pRefreshSecurityAux Client.TCP_ID, Client.ClientProcessId
    End If
  Next
End Sub

Private Function pClientInList(ByVal UserId As Long, ByRef UsID() As Long) As Boolean
  Dim i As Long
  For i = 1 To UBound(UsID)
    If UsID(i) = UserId Then
      pClientInList = True
      Exit Function
    End If
  Next
End Function

Private Function pGetUsers(ByVal UsID As Long, ByVal RolId As Long, ByVal ConnectString As String) As Long()
  Dim sqlstmt As String
  Dim rtn() As Long
  
  ReDim rtn(0)
  
  pGetUsers = rtn
  
  If UsID <> 0 Then
    ReDim Preserve rtn(1)
    rtn(1) = UsID
  End If
  
  If RolId <> 0 Then
    
    Dim db As cDataSource
    Dim rs As Recordset
        
    Set db = New cDataSource
    
    If Not db.OpenConnection("", "", "", "", False, ConnectString) Then Exit Function
    
    sqlstmt = "SP_SecGetUsuarioXRol " & RolId
    If Not db.OpenRs(rs, sqlstmt) Then Exit Function
    While Not rs.EOF
      ReDim Preserve rtn(UBound(rtn) + 1)
      rtn(UBound(rtn)) = db.ValField(rs.Fields("us_id"))
      rs.MoveNext
    Wend
  End If
  
  pGetUsers = rtn
End Function

Private Sub pRefreshListClientAux(ByVal TCP_ID As Long, _
                                  ByVal ClientProcessId As Long, _
                                  ByVal IsMonitor As Boolean)
  Dim ByteArray() As Byte
  Dim sMessage    As String
  
  If IsMonitor Then
    m_Server.StringToByteArray TCPGetMessage(cTCPCommandRefreshLoginOn, ClientProcessId), ByteArray
        
  Else
  
    ' Ojo con como se construye el mensaje
    ' no alteren la secuencia de estas cuatro lineas
    ' porque deja de andar
    sMessage = TCPSetDllID(c_AnyComponentTCP, "")
    sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
    sMessage = TCPSetDllProgID(csSecPermisos, sMessage)
    sMessage = sMessage & TCPSecurityGetMessage(cTCPSecCommandRefreshLoginOn, ClientProcessId, "")
    sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
                                        ' Esta repetido aproposito para que no falle
                                        ' la primitiva TCPSetDllProgID
    
    m_Server.StringToByteArray sMessage, ByteArray
    
  End If
  
  m_Server.SendMessage TCP_ID, ByteArray
End Sub

Private Sub pRefreshSecurityAux(ByVal TCP_ID As Long, ByVal ClientProcessId As Long)
  Dim ByteArray() As Byte
  Dim sMessage    As String
  
  
  ' Ojo con como se construye el mensaje
  ' no alteren la secuencia de estas cuatro lineas
  ' porque deja de andar
  sMessage = TCPSetDllID(c_AnyComponentTCP, "")
  sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
  sMessage = TCPSetDllProgID(csSecPermisos, sMessage)
  sMessage = sMessage & TCPSecurityGetMessage(cTCPSecCommandRefresh, ClientProcessId, "")
  sMessage = c_SucessCode & sMessage  '(1) Ojo Esto no esta mal
                                      ' Esta repetido aproposito para que no falle
                                      ' la primitiva TCPSetDllProgID
  
  m_Server.StringToByteArray sMessage, ByteArray
  m_Server.SendMessage TCP_ID, ByteArray
End Sub

Private Function pAddClientProcess(ByVal sClientData As String) As Long
  Dim c As cClientProcess
  
  Set c = New cClientProcess
  
  m_NextClientProcess = m_NextClientProcess + 1
  
  c.ClientProcessId = m_NextClientProcess
  
  c.TCP_ID = GetToken(c_ClientTCP_ID, sClientData)
  c.ClientComputer = GetToken(c_ClientComputer, sClientData)
  c.ClientConnected = Now
  c.ClientState = cClProcStateLonginOn
  
  m_ClientsProcess.Add c, GetKey(c.ClientProcessId)
  
  pNotifyMonitor cNotifyClientAdd, , c
  
  pAddClientProcess = c.ClientProcessId
End Function

Private Sub pNotifyMonitor(ByVal What As csNotifyMonitor, _
                           Optional ByVal Message As String, _
                           Optional ByRef c As cClientProcess)
  Dim Monitor As cClientProcess
  
  For Each Monitor In m_ClientsProcess
    If Monitor.IsMonitor Or Monitor.IsChat Then
      
      If c.ClientState = cClProcStateActive Then
      
        If Monitor.IsMonitor Then
          pNotifyMonitorAux What, Monitor, Message, c
        
        ElseIf Monitor.IsChat And c.IsInternal Then
          pNotifyMonitorAux What, Monitor, Message, c
        End If
        
      End If
    End If
  Next
End Sub

Private Sub pNotifyMonitorAux(ByVal What As csNotifyMonitor, ByRef Monitor As cClientProcess, ByVal Message As String, Optional ByRef c As cClientProcess)
  Dim ByteArray() As Byte
  
  Select Case What
    
    Case cNotifyClientAdd
      
      Message = pGetClientStr(c)
      
      m_Server.StringToByteArray TCPGetMessage(cTCPCommandAddClient, c.ClientProcessId, Message), ByteArray
      
      m_Server.SendMessage Monitor.TCP_ID, ByteArray
  
    Case cNotifyClientLoginOn
      
      Message = pGetClientStr(c)
      
      m_Server.StringToByteArray TCPGetMessage(cTCPCommandLoginOn, c.ClientProcessId, Message), ByteArray
      
      m_Server.SendMessage Monitor.TCP_ID, ByteArray
  End Select
End Sub

Private Function pGetClientStringToken(ByRef c As cClientProcess) As String
  Dim rtn As String
  
  rtn = TCPCreateToken(c_ClientComputer, c.ClientComputer)
  rtn = rtn & TCPCreateToken(c_ClientConnected, c.ClientConnected)
  rtn = rtn & TCPCreateToken(c_ClientProcessID, c.ClientProcessId)
  rtn = rtn & TCPCreateToken(c_ClientState, c.ClientState)
  rtn = rtn & TCPCreateToken(c_ClientUser, c.ClientUser)
  rtn = rtn & TCPCreateToken(c_ClientIsMonitor, c.IsMonitor)
  rtn = rtn & TCPCreateToken(c_ClientTCP_ID, c.TCP_ID)
  
  pGetClientStringToken = rtn
End Function

Private Function pIsAddClientProcess(ByVal ClientProcess As Long, ByRef ErrDescription As String) As Boolean
  If ClientProcess = 0 Then
    ErrDescription = "Invalid Client Process ID: " & ClientProcess
    Exit Function
  End If
  
  If ClientProcess <> c_TCPNewClientProcess Then
    If m_ClientsProcess(GetKey(ClientProcess)) Is Nothing Then
      ErrDescription = "Invalid Client Process ID: " & ClientProcess
      Exit Function
    End If
  End If
  
  pIsAddClientProcess = True
End Function

Private Function pGetClientProcess(ByVal sMessage As String) As Long
  pGetClientProcess = Val(Right$(sMessage, c_Len_ProcessId))
End Function

Private Function pGetDataBases(ByRef sMessage As String, ByRef ErrDescription As String) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As Recordset
  
  sMessage = ""
  
  sqlstmt = "sp_SysDomainGetEmpresas"
  
  If Not m_db.OpenRs(rs, sqlstmt) Then
    ErrDescription = gErrorInfo
    GoTo ExitProc
  End If
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  While Not rs.EOF
    sMessage = sMessage & m_db.ValField(rs.Fields("bd_id")) & c_TCPSep1 _
                        & Encrypt.Decript(m_db.ValField(rs.Fields("emp_nombre")), c_LoginSignature) & c_TCPSep1 _
                        & Encrypt.Decript(m_db.ValField(rs.Fields("bd_server")), c_LoginSignature) & c_TCPSep1 _
                        & Encrypt.Decript(m_db.ValField(rs.Fields("bd_securitytype")), c_LoginSignature) & c_TCPSep1 _
                        & Encrypt.Decript(m_db.ValField(rs.Fields("bd_pwd")), c_LoginSignature) & c_TCPSep1 _
                        & m_db.ValField(rs.Fields("emp_id")) & c_TCPSep2
    rs.MoveNext
  Wend
  
  If sMessage <> "" Then
  
    sMessage = pRemoveLastSep(sMessage)
  
    pGetDataBases = True
  Else
  
    ErrDescription = "El sistema no tiene ninguna empresa registrada."
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pGetDataBases", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pRemoveLastSep(ByVal sMessage As String) As String
  If Right$(sMessage, 1) = c_TCPSep2 Then sMessage = Left$(sMessage, Len(sMessage) - 1)
  pRemoveLastSep = sMessage
End Function

Private Sub pOpenDB()
  On Error GoTo ControlError

  Dim Server    As String
  Dim Database  As String
  Dim User      As String
  Dim Password  As String
  Dim TrustedConnection As Boolean
  
  Server = IniGet(c_K_Server, "(Local)")
  Database = IniGet(c_k_DataBase, "Master")
  User = IniGet(c_k_User, "sa")
  Password = IniGet(c_k_Password, "")
  TrustedConnection = IniGet(c_k_TrustedConnection, "0")
  
  m_db.OpenConnection Server, Database, User, Password, TrustedConnection

  GoTo ExitProc
ControlError:
  MngError Err, "pOpenDB", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_ClientsProcess = New cClientsProcess

  m_ServiceID = SRV_ID_SERVER

  Set m_Server = gServer
  gServiceCreated = True
  
  Set m_db = New cDataSource
  pOpenDB
  pValidateCodigo

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pValidateCodigo()
  Dim sqlstmt   As String
  Dim rs        As ADODB.Recordset
  Dim strCode   As String
  
  ' Para demos
  
'  m_MaxUsers = 2
'  m_StatusCode = c_ACTIVE_CODE_OK
  
  ' Para clientes
  
  m_StatusCode = c_ACTIVE_CODE_ERROR
  m_MaxUsers = 0

  sqlstmt = "select si_valor from sistema where si_clave = '" & c_CodigoActivacion & "'"
  If Not m_db.OpenRs(rs, sqlstmt) Then Exit Sub

  If rs.EOF Then
    m_StatusCode = c_ACTIVE_CODE_UNDEFINED
  Else
    strCode = rs.Fields.Item(0).Value
    m_StatusCode = IsValidCode(strCode)
    m_DateActive = GetVto(strCode)
    If m_StatusCode = c_ACTIVE_CODE_OK Then
      m_MaxUsers = GetUsuarios(strCode)
    End If
  End If
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Server = Nothing
  gServiceCreated = False
  
  Set m_db = Nothing
  Set m_ClientsProcess = Nothing
  
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
