Attribute VB_Name = "mLogin"
Option Explicit

Private Const C_Module = "mLogin"

Private m_ClientProcessId               As Long
Private m_Client                        As cTCPIPClient

Private m_UserName                      As String
Private m_db_id                         As Long
Private m_emp_id                        As Long
Private m_Password                      As String
Private m_Server                        As String
Private m_Port                          As Integer

Public Function GetClientProcessId() As Long
  GetClientProcessId = m_ClientProcessId
End Function

Public Sub CloseSession()
  
  Set fMain.Client = Nothing
  
  If Not m_Client Is Nothing Then
    If m_Client.ConnectStatus = csSocketOpen Then
      m_Client.TerminateSession
    End If
    Set m_Client = Nothing
  End If
End Sub

Public Function ConnectChat(ByRef CallerId As Long, _
                            ByRef SessionKey As String, _
                            ByRef TempId As Long, _
                            Optional ByVal db_id As Long, _
                            Optional ByVal emp_id As Long, _
                            Optional ByVal Server As String, _
                            Optional ByVal Port As Long _
                            ) As Boolean
                        
  On Error GoTo ControlError
  
  ' Unicamente cuando ingreso por
  ' linea de comandos puedo
  ' recibir un chat por callerid
  '
  CallerId = 0
  
  Set fMain.Client = Nothing
  
  If m_Client Is Nothing Then
    Set m_Client = New cTCPIPClient
  End If
  
  m_Client.NoEOP2 = True
  
  If m_Client.ConnectStatus <> csSocketClosed Then
  
    m_Client.ClearResponse
    m_Client.Disconnect
    
  End If
  
  If Not pConnectToServer(m_Client, Server, Port) Then
    Exit Function
  End If
  
  ' Bien Harcode y sencillito
  '
  If gIsSoporte Then
    
    db_id = 2
    emp_id = 1
  
  Else
    
    If (db_id * emp_id) = 0 Then
    
      If Not pLoginFromCommandLine(db_id, _
                                   emp_id, _
                                   CallerId, _
                                   SessionKey, _
                                   TempId) Then
        If Not pSelectEmpId(db_id, emp_id) Then
          m_Client.ClearResponse
          m_Client.Disconnect
          Exit Function
        End If
      End If
    
    End If
  
  End If
    
  'MsgBox "empresa " & emp_id & " db " & db_id & " user " & fMain.txUser
  
  If Not pLoginSilentAux(APP_NAME, _
                         fMain.txUser, _
                         fMain.txPassword, _
                         db_id, _
                         emp_id) Then

    m_Client.ClearResponse
    m_Client.Disconnect

    Exit Function
  End If
  
  Set fMain.Client = m_Client
  fMain.lbUser.Caption = fMain.txUser.Text
  fMain.lbServer.Caption = m_Client.ServerName & " - " & _
                           m_Client.ServerPort
  
  If gIsSoporte Then
    fMain.Caption = "CrowSoft Chat Soporte - " _
                      & fMain.txUser.Text & " - " _
                      & fMain.lbServer.Caption
  Else
    fMain.Caption = "CrowSoft Chat Client - " _
                      & fMain.txUser.Text & " - " _
                      & fMain.lbServer.Caption
  End If
  
  ConnectChat = True
    
  GoTo ExitProc
ControlError:
  MngError Err, "ConnectChat", C_Module, ""
  Set m_Client = Nothing
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ReConnectChat() As Boolean

  On Error GoTo ControlError

  Set fMain.Client = Nothing

  If m_Client Is Nothing Then
    Set m_Client = New cTCPIPClient
  End If

  m_Client.NoEOP2 = True

  If m_Client.ConnectStatus <> csSocketClosed Then

    m_Client.ClearResponse
    m_Client.Disconnect

  End If

  If Not pConnectToServer(m_Client, m_Server, m_Port) Then
    Exit Function
  End If

  'MsgBox "empresa " & emp_id & " db " & db_id & " user " & fMain.txUser

  If Not pLoginSilentAux(APP_NAME, _
                         fMain.txUser, _
                         fMain.txPassword, _
                         m_db_id, _
                         m_emp_id) Then
    
    m_Client.ClearResponse
    m_Client.Disconnect
    Exit Function
  End If

  Set fMain.Client = m_Client
  fMain.lbUser.Caption = fMain.txUser.Text
  fMain.lbServer.Caption = m_Client.ServerName & " - " & _
                           m_Client.ServerPort

  If gIsSoporte Then
    fMain.Caption = "CrowSoft Chat Soporte - " _
                      & fMain.txUser.Text & " - " _
                      & fMain.lbServer.Caption
  Else
    fMain.Caption = "CrowSoft Chat Client - " _
                      & fMain.txUser.Text & " - " _
                      & fMain.lbServer.Caption
  End If

  ReConnectChat = True

  GoTo ExitProc
ControlError:
  MngError Err, "ReConnectChat", C_Module, ""
  Set m_Client = Nothing
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pConnectToServer(ByRef Client As cTCPIPClient, _
                                  ByVal Server As String, _
                                  ByVal Port As Integer _
                                  ) As Boolean

  Dim Buffer    As String
  
  If LoginFromCommandLineAux() Then
  
    Server = pGetCommandLine(c_server)
    Port = Val(pGetCommandLine(c_port))
    
  End If
  
  If LenB(Server) = 0 Then
  
    Server = IniGet(c_K_Server, "")
    Port = Val(IniGet(c_k_Port, ""))
    
  End If
  
  If LenB(Server) = 0 Then
    MsgError "Debe indicar un servidor en el archivo " & c_MainIniFile
    Exit Function
  End If
  
  If Port = 0 Then
    MsgError "Debe indicar un port en el archivo " & c_MainIniFile
    Exit Function
  End If
    
  ' Bien Harcode y sencillito
  '
  If gIsSoporte Then
    Server = "crowsoft.dyndns.org"
    Port = 5001
  End If
  
  'MsgBox "server " & Server & " port " & Port
  
  If Not Client.ConnectToServer(Server, Port) Then
    MsgError "No se ha podido crear la conexión con el server Cairo.;;Descripción técnica: " & _
              Client.ErrDescription
    Exit Function
  End If
  
  Buffer = TCPCreateToken(c_ClientComputer, GetComputerName())
  Buffer = Buffer & TCPCreateToken(c_ClientTCP_ID, Client.ClientId)
  Buffer = Buffer & TCPCreateToken(c_ClientUser, "")
  
  Buffer = TCPGetMessage(cTCPCommandAddClient, m_ClientProcessId, Buffer)
  
  If Not Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(Client.DataReceived) Then
    MsgError "Ha ocurrido un error al intentar registrarce con el servidor Cairo.;;Descripción técnica: " & _
              TCPGetResponse(Client.DataReceived)
    Exit Function
  End If
    
  m_ClientProcessId = Val(TCPGetResponse(Client.DataReceived))
  
  'MsgBox "client: server " & Client.ServerName & " port " & Client.ServerPort
  
  m_Server = Server
  m_Port = Port
  
  pConnectToServer = True
End Function

Private Function Login_(ByVal User As String, ByVal Password As String, ByVal bd_id As Long, ByVal emp_id As Long, ByRef ErrorMsg As String) As Boolean
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
  
  Buffer = TCPGetMessage(cTCPCommandLoginOnChat, m_ClientProcessId, Message)
  If Not m_Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(m_Client.DataReceived) Then
    MsgError "Ha ocurrido un error al verificar sus credenciales de usuario.;;Descripción técnica: " & TCPGetResponse(m_Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(m_Client.DataReceived)
  
  If TCPGetFail(m_Client.DataReceived) Then
    ErrorMsg = Buffer
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
  
  Login_ = True
End Function

Private Function pLoginSilentAux(ByVal AppName As String, _
                                 ByVal User As String, ByVal Password As String, _
                                 ByVal db_id As Long, ByVal emp_id As Long) As Boolean
  Dim ErrorMsg As String
  
  If Login_(User, Password, db_id, emp_id, ErrorMsg) Then
    pLoginSilentAux = True
  Else
    CSKernelClient2.MsgWarning ErrorMsg, "Login"
    pLoginSilentAux = False
  End If
  
End Function

Public Function RefresLoginOn() As Boolean
  Dim Buffer    As String
  
  Buffer = TCPGetMessage(cTCPCommandSetClientActive, m_ClientProcessId)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(fMain.Client.DataReceived) Then
    MsgError "Ha ocurrido un error al verificar sus credenciales de usuario.;;Descripción técnica: " & TCPGetResponse(fMain.Client.DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(fMain.Client.DataReceived)
  
  If TCPGetFail(fMain.Client.DataReceived) Then
    MsgError Buffer
    Exit Function
  End If
  
  RefresLoginOn = True
End Function

Private Function pLoginFromCommandLine(ByRef db_id As Long, _
                                       ByRef emp_id As Long, _
                                       ByRef CallerId As Long, _
                                       ByRef SessionKey As String, _
                                       ByRef TempId As Long) As Boolean
  If LoginFromCommandLineAux() Then
    
    db_id = pGetCommandLine(c_db_id)
    emp_id = pGetCommandLine(c_emp_id)
    
    Dim User      As String
    Dim pwd       As String
    
    User = pGetCommandLine(c_user)
    If LenB(User) Then
      
      pwd = pGetCommandLine(c_password)
      CallerId = pGetCommandLine(c_callerId)
      SessionKey = pGetCommandLine(c_sessionKey)
      TempId = pGetCommandLine(c_tempId)
      
      fMain.txUser.Text = User
      fMain.txPassword.Text = pwd
      
    End If
    
    pLoginFromCommandLine = True
  End If
End Function

Public Function LoginFromCommandLineAux() As Boolean
  If Command$ = "" Then Exit Function
  LoginFromCommandLineAux = Val(GetToken(c_login, Command$))
End Function

Private Function pGetCommandLine(ByVal Token As String)
  pGetCommandLine = GetToken(Token, Command$)
End Function

Private Function pSelectEmpId(ByRef db_id As Long, _
                              ByRef emp_id As Long) As Boolean
  fEmpresas.cbCompany.Clear
  pFillDataBases m_Client, fEmpresas
  fEmpresas.Init
  fEmpresas.Show vbModal
  If fEmpresas.Ok Then
    
    Dim dbidtmp As Long
    db_id = ListID(fEmpresas.cbCompany)
    dbidtmp = db_id / 1000000
    emp_id = db_id - (1000000 * dbidtmp)
    db_id = dbidtmp
    
    pSelectEmpId = emp_id * db_id
  End If
End Function

Private Function pFillDataBases(ByRef Client As cTCPIPClient, _
                                ByRef f As fEmpresas) As Boolean
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
  Dim vDataBases()     As String
  vDataBases = Split(Buffer, c_TCPSep2)
  
  f.cbCompany.Clear
  
  For i = 0 To UBound(vDataBases)
    vDataBasesData = Split(vDataBases(i), c_TCPSep1)
    
    With f.cbCompany
      .AddItem vDataBasesData(1)
      .ItemData(.NewIndex) = vDataBasesData(0) * 1000000 + vDataBasesData(5)
    End With
  Next

  pFillDataBases = UBound(vDataBases) >= 0
End Function

