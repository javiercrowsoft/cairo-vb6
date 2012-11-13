Attribute VB_Name = "mConfig"
Option Explicit

'--------------------------------------------------------------------------------
' mConfig
' 27-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mConfig"
' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function EditConfig() As Boolean
  On Error GoTo ControlError

  fConfig.txServer.Text = IniGet(c_K_Server, "")
  fConfig.tnPort.Text = IniGet(c_k_Port, 5001)

  fConfig.Show vbModal

  EditConfig = fConfig.Ok

  GoTo ExitProc
ControlError:
  MngError Err, "EditConfig", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fConfig
End Function

Public Function SaveConfig() As Boolean
  On Error GoTo ControlError

  IniSave c_K_Server, fConfig.txServer.Text
  IniSave c_k_Port, fConfig.tnPort.Text

  SaveConfig = True

  GoTo ExitProc
ControlError:
  MngError Err, "SaveConfig", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
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


