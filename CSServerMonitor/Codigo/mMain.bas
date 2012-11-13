Attribute VB_Name = "mMain"
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    Private Declare Function GetComputerName Lib "kernel32" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long
    Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mMain"
Public Const APP_NAME = "ServerMonitor"

Private Const c_CairoSysUser = "Cairo System Administrator"
' estructuras
' variables privadas
Private m_Client                        As cTCPIPClient
Private m_ClientProcessId               As Long
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function ClientProcessId() As Long
  ClientProcessId = m_ClientProcessId
End Function

Public Sub Main()

  pSplash
  
  CSKernelClient2.AppName = APP_NAME
  
  CSKernelClient2.Title = APP_NAME
  
  Set m_Client = New cTCPIPClient
  
  fMain.Show
  
  Unload fSplash
  
  ' Me conecto al server
  If Not pConnectToServer Then
    Unload fMain
    CloseApp
  
  ' Intengo el login
  ElseIf Not pLogin() Then
    Unload fMain
    CloseApp
  
  ' Ok todo bien ahora verifico el codigo de activacion
  Else
    pValidateActiveCode
  End If
End Sub

Private Sub pValidateActiveCode()
  On Error Resume Next
  Dim strCode As String
  
  If Not GetActiveCode(strCode) Then
    If GetComputer() = IniGet(c_K_Server, "") Then
      fActiveCode.Show vbModal
    End If
  Else
    If IsValidCode(strCode) <> c_ACTIVE_CODE_OK Then
    
      If GetComputer() = IniGet(c_K_Server, "") Then
        fActiveCode.Show vbModal
      End If
    End If
  End If
End Sub

Public Sub CloseApp()
  On Error Resume Next
  
  Set CSKernelClient2.OForms = Forms
      
  m_Client.TerminateSession
  Set m_Client = Nothing
End Sub

Public Sub ProcessMessage(ByVal Message As String)
  Select Case TCPGetTypeMessage(Message)
    Case c_ADD_CLIENT
      ListAddClient TCPGetRealMessage(Message)
    Case c_LOGIN_ON
      ListUpdateClient TCPGetRealMessage(Message)
    Case c_CLIENT_SHUT_DOWN
      ListRemoveClient Val(TCPGetRealMessage(Message))
    Case c_REFRESH_LOGINON
      pRefresLoginOn
  End Select
End Sub

Public Function GetErrorMessage(ByVal DataReceived As String) As String
  GetErrorMessage = "Ha ocurrido un error al intentar conectarse con el servidor.;;Descripción técnica: " & TCPGetResponse(DataReceived)
End Function
' funciones friend
' funciones privadas
Private Sub pSplash()
  fSplash.Show
  fSplash.ZOrder
  fSplash.Refresh
  Sleep 1500
End Sub

Private Function pConnectToServer() As Boolean
  Dim ErrTrayingConnect As Boolean
  
  fMain.Operation = "Conectando con el servidor"
  
  Do
    If pConnectToServerAux(ErrTrayingConnect) Then Exit Do
    If ErrTrayingConnect Then
      If Ask("Desea editar los parametros de conexión", vbYes) Then
        If Not EditConfig() Then Exit Function
      Else
        Exit Function
      End If
    End If
  Loop
  pConnectToServer = True
  
  Set fMain.Client = m_Client
  
  fMain.Operation = ""
End Function

Private Function pRefresLoginOn()
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
  
  pRefresLoginOn = True
End Function

Private Function pConnectToServerAux(ByRef ErrTrayingConnect As Boolean) As Boolean
  Dim Buffer    As String
  Dim Server    As String
  Dim Port      As Integer
  
  Server = IniGet(c_K_Server, "")
  Port = Val(IniGet(c_k_Port, ""))
  
  If Server = "" Or Port = 0 Then
    If Not EditConfig() Then
      ErrTrayingConnect = True
      Exit Function
    End If
    Server = IniGet(c_K_Server, "")
    Port = Val(IniGet(c_k_Port, ""))
  End If
  
  If Not m_Client.ConnectToServer(Server, Port) Then
    MsgError m_Client.ErrDescription
    ErrTrayingConnect = True
    Exit Function
  End If
  
  Buffer = TCPCreateToken(c_ClientComputer, GetComputer())
  Buffer = Buffer & TCPCreateToken(c_ClientTCP_ID, m_Client.ClientId)
  Buffer = Buffer & TCPCreateToken(c_ClientUser, c_CairoSysUser)
  
  Buffer = TCPGetMessage(cTCPCommandAddClient, m_ClientProcessId, Buffer)
  
  If Not m_Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  If TCPError(m_Client.DataReceived) Then
    MsgError GetErrorMessage(m_Client.DataReceived)
    ErrTrayingConnect = True
    Exit Function
  End If
    
  m_ClientProcessId = Val(TCPGetResponse(m_Client.DataReceived))
  
  fMain.Caption = fMain.Caption & " Conectado al server [" & Server & "] Por [" & Port & "]"
  
  pConnectToServerAux = True
End Function

Private Function pLogin() As Boolean
  On Error GoTo ControlError

  fLogin.Show vbModal
  pLogin = fLogin.Ok
  Unload fLogin

  GoTo ExitProc
ControlError:
  MngError Err, "pLogin", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function GetComputer() As String
    Dim lpBuffer    As String
    Dim nResult     As Integer
    Dim nSize       As Long
    
    lpBuffer = String(255, " ")
    nSize = Len(lpBuffer)
    nResult = GetComputerName(lpBuffer, nSize)
    If nResult = 0 Then Exit Function
    GetComputer = Mid(lpBuffer, 1, nSize)
End Function
' construccion - destruccion

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


