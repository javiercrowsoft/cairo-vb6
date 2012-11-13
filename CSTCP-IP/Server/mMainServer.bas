Attribute VB_Name = "mMainServer"
Option Explicit

'--------------------------------------------------------------------------------
' mMainServer
' 25-10-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mMainServer"

' OJO: Esta constante esta declarada dos veces
'      Una vez aqui y otra en mMain de CSImportUsr
'      Si la cambian recuerden cambiar tambien en dicho exe
'
Public Const c_LoginSignature   As String = "Virginia Said-Neron-Catalina-la belleza"

' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gSignOnAsUnicode As Boolean
Public gLogTrafic       As Boolean
' propiedadades friend
' propiedades privadas
Private m_Listen As cListen
' funciones publicas
Public Function MSSartTCPServer() As Boolean
  On Error GoTo ControlError
  
  Dim Server  As cSocket
  Dim nPort   As Integer
  
  nPort = Val(IniGet(c_K_port, 5001))
  gSignOnAsUnicode = Val(IniGet(c_k_SignOnAsUnicode, 0))
  gLogTrafic = Val(IniGet(c_k_LogTrafic, 0))
  
  SaveLog "Connection to port " & nPort
  SaveLog "LogTrafic " & gLogTrafic
  
  Set Server = pCreateSocketServer(nPort)
  
  If Server Is Nothing Then
  
    SaveLog "Connection fail"
    Exit Function
  End If
  
  SaveLog "Connection success"
  
  SaveLog "Start Listening"
  Server.Listen
  
  Set m_Listen = New cListen
  
  m_Listen.SetServer Server
  
  MSSartTCPServer = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "MSSartTCPServer", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function MSShutDownTCPServer() As Boolean
  On Error GoTo ControlError

  If Not m_Listen Is Nothing Then
  
    m_Listen.Server.CloseSocket
    
    m_Listen.UnLoadServices
    
    Set m_Listen = Nothing
  
  End If
  
  SaveLog "ShutDown Server"
  
  MSShutDownTCPServer = True
  GoTo ExitProc
ControlError:
  MngError Err, "MSShutDownTCPServer", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function GetMessage(ByVal Message As String) As String
  GetMessage = Message
End Function

Public Function Encrypt(ByVal toEncrypt As String) As String
  On Error GoTo ControlError
  
  Dim obj As Object
  Set obj = CreateObject("CSEncrypt.cEncrypt")
  
  Encrypt = obj.Encript(toEncrypt, c_LoginSignature)

  GoTo ExitProc
ControlError:
  MngError Err, "Encrypt", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas
Private Function pCreateSocketServer(ByVal nPort As Integer) As cSocket
  Dim Socket As cSocket
  Set Socket = New cSocket
  
  Socket.LocalPort = nPort
  
  Set pCreateSocketServer = Socket
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


