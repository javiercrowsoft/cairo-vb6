Attribute VB_Name = "mTCPSecurity"
Option Explicit

'--------------------------------------------------------------------------------
' mTCPSecurity
' 03-01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mTCPSecurity"

' OJO LOS STRING DEBEN SER SI O SI DE 20
Public Const c_REFRESH_SECURITY          As String = "REFRESH_SECUTITY___:"
Public Const c_REFRESH_AVISO             As String = "REFRESH_AVISO______:"
Public Const c_OPEN_CHAT_CLIENT          As String = "OPEN_CHAT_CLIENT___:"

Public Const c_SecRol = "ROL:"
Public Const c_SecUser = "USER:"

Private Const c_Len_Type = 20  ' OJO ESTO NO PUEDE CAMBIAR
Private Const c_Len_ProcessId = 8

Public Enum csETCPSecCommand
  cTCPSecCommandRefresh = 1
  cTCPSecCommandAviso = 2
  cTCPSecCommandRefreshLoginOn = 3
  cTCPSecCommandOpenChatClient = 4
End Enum

Public Enum csSecSysModulo
  csSecPermisos = 1
  csSecAviso = 2
  csSecChat = 3
End Enum
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function TCPSecurityGetMessage(ByVal Command As csETCPSecCommand, ByVal ClientProcessId As Long, Optional ByVal Message As String) As String
  Dim rtn As String
  
  Select Case Command
    Case cTCPSecCommandRefresh
      rtn = c_REFRESH_SECURITY & Message & Format(ClientProcessId, String(c_Len_ProcessId, "0"))
    Case cTCPSecCommandAviso
      rtn = c_REFRESH_AVISO & Message & Format(ClientProcessId, String(c_Len_ProcessId, "0"))
    Case cTCPSecCommandRefreshLoginOn
      rtn = c_REFRESH_LOGINON & Message & Format(ClientProcessId, String(c_Len_ProcessId, "0"))
    Case cTCPSecCommandOpenChatClient
      rtn = c_OPEN_CHAT_CLIENT & Message & Format(ClientProcessId, String(c_Len_ProcessId, "0"))
  End Select
  
  TCPSecurityGetMessage = rtn
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


