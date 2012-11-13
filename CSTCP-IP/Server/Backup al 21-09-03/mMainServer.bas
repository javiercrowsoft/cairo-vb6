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
  Dim Server  As JBSOCKETSERVERLib.Server
  Dim nPort   As Integer
  
  InitLog
  
  nPort = Val(IniGet(c_K_port, 5001))
  gSignOnAsUnicode = Val(IniGet(c_k_SignOnAsUnicode, 0))
  gLogTrafic = Val(IniGet(c_k_LogTrafic, 0))
  
  SaveLog "Connection to port " & nPort
  SaveLog "LogTrafic " & gLogTrafic
  
  Set Server = CreateSocketServer(nPort)
  
  If Server Is Nothing Then
  
    SaveLog "Connection fail"
    Exit Function
  End If
  
  SaveLog "Connection success"
  
  SaveLog "Start Listening"
  Server.StartListening
  
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

  m_Listen.Server.StopListening
  
  Set m_Listen = Nothing
  
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


