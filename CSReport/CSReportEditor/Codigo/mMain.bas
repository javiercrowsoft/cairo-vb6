Attribute VB_Name = "mMain"
Option Explicit
'--------------------------------------------------------------------------------
' mMain
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "mMain"
Public Const APP_NAME = "CSReportEditor"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Public Sub Main()
  On Error GoTo ControlError

  '--------------------------------
  ' Antes que nada hay que decirle al
  ' Kernel cual es la aplicacion CSKernelClient
  CSKernelClient2.AppName = APP_NAME
  CSKernelClient2.Title = APP_NAME

  LoadToolOptions

  fMain.Show
  SetDocActive Nothing

  GoTo ExitProc
ControlError:
  MngError Err(), "Main", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub CloseApp()
  On Error Resume Next

  If Not fMain.IsClosing Then Unload fMain

  Unload fToolbox
  SetDocActive Nothing
End Sub

