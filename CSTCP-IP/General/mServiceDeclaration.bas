Attribute VB_Name = "mServiceDeclaration"
Option Explicit

'--------------------------------------------------------------------------------
' mServiceDeclaration
' 09-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mServiceDeclaration"

Public Const c_CompanyName = "CrowSoft"
Public Const c_GetCodigoStr = "Debe comunicarse con " & c_CompanyName & " para obtener un código de activación."

Public Const c_PasswordDomain = "Password_Domain"
Public Const c_CodigoActivacion = "Codigo_Activacion"
Public Const c_StrConnectDom2 = "strconnect_dom"

Public Const SRV_ID_CHAT = 1000
Public Const SRV_ID_ADOAUX = 1001
Public Const SRV_ID_EXECUTE = 1002
Public Const SRV_ID_SERVER = 1003
Public Const SRV_ID_ALARMAMAIL = 1004
Public Const SRV_ID_CATALOG = 1005

Public Const c_ClientComputer = "ClientComputer"
Public Const c_ClientUser = "ClientUser"
Public Const c_ClientTCP_ID = "ClientTCP_ID"
Public Const c_ClientConnected = "ClientConnected"
Public Const c_ClientProcessID = "ClientProcessId"
Public Const c_ClientState = "ClientState"
Public Const c_ClientIsMonitor = "ClientIsMonitor"

Public Const c_ErrorCode    As String = " 0 -  "
Public Const c_SucessCode   As String = "-1 -1-"
Public Const c_FailCode     As String = "-1 -0-"

Public Const c_ProgIDClient = 9 ' 0000 0000 - El id en la tabla sysModuloTCP
                                '             del componente

Public Const c_IDInstance = 9 ' 0000 0000 -   Un id que identifica la instancia
                              '               del componente dentro de la bolsa
                              '               de componentes TCP del cliente (Cairo)

Public Const c_TCPSep2      As String = "#"
Public Const c_TCPSep1      As String = "|"
Public Const c_TCPSep1_Aux  As String = "$%$#"

Public Const c_AnyComponentTCP = 11111111

' OJO LOS STRING DEBEN SER SI O SI DE 20
Public Const c_LIST_DBS                   As String = "LIST_DBS___________:"
Public Const c_ADD_CLIENT                 As String = "ADD_CLI____________:"
Public Const c_REMOVE_CLIENT              As String = "REMOVE_CLI_________:"
Public Const c_LIST_CLIENTS               As String = "LIST_CLIENTS_______:"
Public Const c_GET_INFO_CLIENT            As String = "GET_INFO_CLIENT____:"
Public Const c_LOGIN_ON                   As String = "LOGIN_ON___________:"
Public Const c_LOGIN_ON_DOMAIN            As String = "LOGIN_ON_DOM_______:"
Public Const c_LOGIN_ON_CHAT              As String = "LOGIN_ON_CHAT______:"
Public Const c_LOGIN_GET_CONNECT_STRING   As String = "CONNECT_STR________:"
Public Const c_LOGIN_GET_CONNECT_STR_DOM  As String = "CONNECT_STR_DOMAIN_:"
Public Const c_LOGIN_GET_CONNECT_STR_DOM2 As String = "CONNECT_STR_DOMAIN2:"
Public Const c_CLIENT_SHUT_DOWN           As String = "CLIENT_SHUTD_______:"
Public Const c_GET_CODIGO_MAC_ADDRESS     As String = "CODIGO_MAC_ADDRESS_:"
Public Const c_IS_ACTIVE                  As String = "IS_ACTIVE__________:"
Public Const c_REFRESH_ACTIVE_INFO        As String = "REFRESH_ACTIVE_____:"
Public Const c_REFRESH_LOGINON            As String = "REFRESH_LOGINON____:"
Public Const c_SET_CLIENT_ACTIVE          As String = "SET_CLIENT_ACTIVE__:"
Public Const c_LIST_CHAT_CLIENTS          As String = "LIST_CHAT_CLIENTS__:"
Public Const c_LIST_CLIENTS_RESP          As String = "LIST_CLIENTS_RESP__:"
Public Const c_LIST_CHAT_CLIENTS_RESP     As String = "LIST_CHAT_CLIENTS_R:"

' Chat Server
'
Public Const c_INIT_CHAT                  As String = "CHAT_INIT_CHAT_____:"
Public Const c_CLOSE_CHAT                 As String = "CHAT_CLOSE_CHAT____:"
Public Const c_INIT_CHAT_SET_REAL_ID      As String = "CHAT_INIT_SET_ID___:"
Public Const c_CHAT_SEND_TEXT             As String = "CHAT_SEND_TEXT_____:"
Public Const c_CHAT_RECEIVE_TEXT          As String = "CHAT_RECEIVE_TEXT__:"

Public Const c_LOGIN_ON_TCP_ID      As Integer = 0
Public Const c_LOGIN_ON_User        As Integer = 1
Public Const c_LOGIN_ON_Password    As Integer = 2
Public Const c_LOGIN_ON_bd_id       As Integer = 3
Public Const c_LOGIN_ON_emp_id      As Integer = 4

Public Const c_LOGIN_ON_DOMAIN_TCP_ID      As Integer = 0
Public Const c_LOGIN_ON_DOMAIN_Password    As Integer = 1

Public Const c_Len_Type = 20 ' OJO ESTO NO PUEDE CAMBIAR
Public Const c_Len_ProcessId = 8

Public Const c_TCPNewClientProcess = 11111111

' OJO: Esta constante esta declarada dos veces
'      Una vez aqui y otra en mMain de CSImportUsr
'      Si la cambian recuerden cambiar tambien en dicho exe
'      y tambien en mMainService
'
Public Const c_LoginSignature   As String = "Virginia Said-Neron-Catalina-la belleza"

Public Enum csEnumTCPCommand

  ' Comandos para el servicio de Seguridad
  '
  cTCPCommandListDbs = 1
  cTCPCommandAddClient
  cTCPCommandRemoveClient
  cTCPCommandListClients
  cTCPCommandGetInfoClient
  cTCPCommandLoginOn
  cTCPCommandGetConnectString
  cTCPCommandLoginOnDomain
  cTCPCommandClientShutDown
  cTCPCommandGetConnectStrDom
  cTCPCommandRefreshActiveInfo
  cTCPCommandCodigoMacAddress
  cTCPCommandRefreshLoginOn
  cTCPCommandSetClientActive
  cTCPCommandGetConnectStrDom2  ' Devuelve un string de conexion para CSUpdate
                                ' ya que este suele correr en pcs que no tienen
                                ' acceso al sql server por NT y necesitan un
                                ' strconnect de sql
  cTCPCommandLoginOnChat
  
  ' Comandos para el servicio de Chat
  '
  cTCPCommandInitChat
  cTCPCommandListChatClients
  cTCPCommandCloseChat
  cTCPCommandInitChatSetRealId
  cTCPCommandChatSendText
End Enum

Public Const NTSecurity = 1
Public Const SQLSecurity = 0

' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function TCPError(ByVal Message As String) As Boolean
  TCPError = Mid(Message, 1, Len(c_ErrorCode)) = c_ErrorCode
End Function

Public Function TCPGetResponse(ByVal Message As String) As String
  TCPGetResponse = Mid(Message, Len(c_SucessCode) + 1)
End Function

Public Function TCPGetFail(ByVal Message As String) As Boolean
  TCPGetFail = Mid(Message, 1, Len(c_FailCode)) = c_FailCode
End Function

Public Function TCPGetDateToString(ByVal oneDate As Date) As String
  TCPGetDateToString = Format(oneDate, "dd,mm,yyyy,hh,nn,ss")
End Function

Public Function TCPGetStringToDate(ByVal oneDate As String) As Date
  Dim y As Integer
  Dim m As Integer
  Dim d As Integer
  
  Dim v() As String
  
  Dim rtn As Date
  
  v = Split(oneDate, ",")
  
  y = v(2)
  m = v(1)
  d = v(0)
  
  rtn = DateSerial(y, m, d)
  
  Dim h As Integer
  Dim n As Integer
  Dim s As Integer
  
  h = v(3)
  n = v(4)
  s = v(5)
  
  rtn = DateAdd("h", h, rtn)
  rtn = DateAdd("n", n, rtn)
  rtn = DateAdd("s", s, rtn)
  
  TCPGetStringToDate = rtn
End Function

Public Function TCPGetMessage(ByVal Command As csEnumTCPCommand, ByVal ClientProcessId As Long, Optional ByVal Message As String) As String
  Dim rtn As String
  
  Select Case Command
    Case cTCPCommandListClients
      rtn = c_LIST_CLIENTS
    Case cTCPCommandListChatClients
      rtn = c_LIST_CHAT_CLIENTS
    Case cTCPCommandGetInfoClient
      rtn = c_GET_INFO_CLIENT
    Case cTCPCommandAddClient
      rtn = c_ADD_CLIENT
      ClientProcessId = c_TCPNewClientProcess
    Case cTCPCommandListDbs
      rtn = c_LIST_DBS
    Case cTCPCommandRemoveClient
      rtn = c_REMOVE_CLIENT
    Case cTCPCommandLoginOn
      rtn = c_LOGIN_ON
    Case cTCPCommandLoginOnChat
      rtn = c_LOGIN_ON_CHAT
    Case cTCPCommandInitChat
      rtn = c_INIT_CHAT
    Case cTCPCommandCloseChat
      rtn = c_CLOSE_CHAT
    Case cTCPCommandInitChatSetRealId
      rtn = c_INIT_CHAT_SET_REAL_ID
    Case cTCPCommandChatSendText
      rtn = c_CHAT_SEND_TEXT
    Case cTCPCommandGetConnectString
      rtn = c_LOGIN_GET_CONNECT_STRING
    Case cTCPCommandRefreshActiveInfo
      rtn = c_REFRESH_ACTIVE_INFO
    Case cTCPCommandGetConnectStrDom
      rtn = c_LOGIN_GET_CONNECT_STR_DOM
    Case cTCPCommandGetConnectStrDom2
      rtn = c_LOGIN_GET_CONNECT_STR_DOM2
    Case cTCPCommandLoginOnDomain
      rtn = c_LOGIN_ON_DOMAIN
    Case cTCPCommandClientShutDown
      rtn = c_CLIENT_SHUT_DOWN
    Case cTCPCommandCodigoMacAddress
      rtn = c_GET_CODIGO_MAC_ADDRESS
    Case cTCPCommandRefreshLoginOn
      rtn = c_REFRESH_LOGINON
    Case cTCPCommandSetClientActive
      rtn = c_SET_CLIENT_ACTIVE
  End Select
  
  rtn = rtn & Message & Format(ClientProcessId, String(c_Len_ProcessId, "0"))
  
  TCPGetMessage = rtn
End Function

Public Function TCPGetMessageLoginOnDomain(ByVal ClientId As Long, ByVal Password As String) As String
  Dim rtn As String
  
  rtn = ClientId & c_TCPSep1
  rtn = rtn & Password & c_TCPSep1
  
  TCPGetMessageLoginOnDomain = rtn
End Function

Public Function TCPGetMessageInitChat(ByVal ClientId As Long, ByVal ClientIdToChat As Long) As String
  Dim rtn As String
  
  rtn = ClientId & c_TCPSep1
  rtn = rtn & ClientIdToChat & c_TCPSep1
  
  TCPGetMessageInitChat = rtn
End Function

Public Function TCPGetMessageGetInfoClient(ByVal ClientId As Long) As String
  Dim rtn As String
  
  rtn = ClientId & c_TCPSep1
  
  TCPGetMessageGetInfoClient = rtn
End Function

Public Function TCPGetMessageCloseChat(ByVal ClientId As Long) As String
  Dim rtn As String
  
  rtn = ClientId & c_TCPSep1
  
  TCPGetMessageCloseChat = rtn
End Function

Public Function TCPGetMessageInitChatSetRealId(ByVal ClientId As Long, _
                                               ByVal TempId As Long, _
                                               ByVal SessionKey As String) As String
  Dim rtn As String
  
  rtn = TempId & c_TCPSep1
  rtn = rtn & SessionKey & c_TCPSep1
  
  TCPGetMessageInitChatSetRealId = rtn
End Function

Public Function TCPGetMessageChatSendText(ByVal ClientId As Long, _
                                          ByVal SessionKey As String, _
                                          ByVal Text As String) As String
  Dim rtn As String
  
  rtn = ClientId & c_TCPSep1
  rtn = rtn & SessionKey & c_TCPSep1
  rtn = rtn & Replace(Text, c_TCPSep1, c_TCPSep1_Aux) & c_TCPSep1
  
  TCPGetMessageChatSendText = rtn
End Function

Public Function TCPGetMessageLoginOn(ByVal ClientId As Long, ByVal User As String, ByVal Password As String, ByVal bd_id As Long, ByVal emp_id As Long) As String
  Dim rtn As String
  
  rtn = ClientId & c_TCPSep1
  rtn = rtn & User & c_TCPSep1
  rtn = rtn & Password & c_TCPSep1
  rtn = rtn & bd_id & c_TCPSep1
  rtn = rtn & emp_id & c_TCPSep1
  
  TCPGetMessageLoginOn = rtn
End Function

Public Function TCPGetMessageGetConnectString(ByVal bd_id As Long) As String
  Dim rtn As String
  
  rtn = bd_id & c_TCPSep1
  
  TCPGetMessageGetConnectString = rtn
End Function

Public Function TCPCreateToken(ByVal Token As String, ByVal Value As String) As String
  TCPCreateToken = Token & "=" & Value & ";"
End Function

Public Function TCPGetTypeMessage(ByVal Message As String) As String
  TCPGetTypeMessage = Mid(Message, 1, c_Len_Type)
End Function

Public Function TCPGetRealMessage(ByVal Message As String) As String
  Dim LenMessage As Long
  
  LenMessage = Len(Message) - c_Len_Type - c_Len_ProcessId
  If LenMessage < 0 Then LenMessage = 0
  
  TCPGetRealMessage = Mid(Message, c_Len_Type + 1, LenMessage)
End Function

Public Function TCPGetDllID(ByVal Message As String) As Long
  TCPGetDllID = Val(Mid(Message, Len(c_SucessCode) + 1, c_IDInstance - 1))
End Function

Public Function TCPSetDllID(ByVal Id As Long, ByVal Message As String) As String
  Dim strProgID  As String
  Dim ProgId     As Long
  
  ' Si el mensaje no esta vacio
  If LenB(Message) Then
    ' Busco un ProgID
    ProgId = TCPGetDllProgID(Message)
    
    ' Si hay un ProgID
    If ProgId <> 0 Then
      ' Obtengo un string con el ProgID
      strProgID = TCPSetDllProgID(ProgId, vbNullString)
      
      ' Le quito al mensaje el ProgID
      Message = TCPGetSrvToClientMsg(Message)
    End If
  End If
  
  ' Le agrego al mensaje el DllID y el ProgID
  TCPSetDllID = Format(Id, "00000000") & "-" & strProgID & Message
End Function

Public Function TCPSetDllProgID(ByVal Id As Long, ByVal Message As String) As String
  Dim strDLLID  As String
  Dim DllId     As Long
  
  ' Si el mensaje no esta vacio
  If LenB(Message) Then
    ' Busco un DllID
    DllId = TCPGetDllID(Message)
    
    ' Si hay un DllID
    If DllId <> 0 Then
      
      ' Obtengo un string con el DllID
      strDLLID = TCPSetDllID(DllId, vbNullString)
      
      ' Le quito al mensaje el DllID
      Message = TCPGetSrvToClientMsg(Message)
    End If
  End If
  
  ' Le agrego al mensaje el DllID y el ProgID
  TCPSetDllProgID = strDLLID & Format(Id, "00000000") & "-" & Message
End Function

Public Function TCPGetDllProgID(ByVal Message As String) As Long
  TCPGetDllProgID = Val(Mid(Message, Len(c_SucessCode) + c_IDInstance + 1, c_ProgIDClient - 1))
End Function

Public Function TCPGetSrvToClientIDMsg(ByVal Message As String) As String
  Dim rtn As String
  rtn = Mid(Message, Len(c_SucessCode) + c_IDInstance + c_ProgIDClient + 1)
  If Len(rtn) - c_Len_ProcessId > 0 Then
    rtn = Mid(rtn, 1, c_Len_Type)
  Else
    rtn = vbNullString
  End If
  TCPGetSrvToClientIDMsg = rtn
End Function

Public Function TCPGetSrvToClientMsg(ByVal Message As String) As String
  Dim rtn As String
  rtn = Mid(Message, Len(c_SucessCode) + c_IDInstance + c_ProgIDClient + 1)
  If Len(rtn) - c_Len_ProcessId > 0 Then
    rtn = Mid(rtn, 1, Len(rtn) - c_Len_ProcessId)
  Else
    rtn = vbNullString
  End If
  TCPGetSrvToClientMsg = rtn
End Function

Public Function TCPGetSrvToClientMsgValue(ByVal Message As String) As String
  Dim rtn As String
  rtn = Mid(Message, Len(c_SucessCode) + c_IDInstance + c_ProgIDClient + 1)
  If Len(rtn) - c_Len_ProcessId > 0 Then
    rtn = Mid(rtn, c_Len_Type + 1, c_Len_ProcessId)
  Else
    rtn = vbNullString
  End If
  TCPGetSrvToClientMsgValue = rtn
End Function

Public Function TCPGetSrvToClientMsgValueEx(ByVal Message As String) As String
  Dim rtn As String
  rtn = Mid(Message, Len(c_SucessCode) + c_IDInstance + c_ProgIDClient + 1)
  If Len(rtn) - c_Len_ProcessId > 0 Then
    rtn = Mid(rtn, c_Len_Type + c_Len_ProcessId + 1)
  Else
    rtn = vbNullString
  End If
  TCPGetSrvToClientMsgValueEx = rtn
End Function

' funciones friend
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


