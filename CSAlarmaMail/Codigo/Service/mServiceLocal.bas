Attribute VB_Name = "mServiceLocal"
Option Explicit

'--------------------------------------------------------------------------------
' mServiceLocal
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
Private Const C_Module = "mServiceLocal"

Public Const LOG_NAME = "\Log\CSAlarmaMail.log"
Public Const LOG_NAME2 = "\Log\CSAlarmaMail"

' estructuras
' variables privadas
' eventos
' propiedadades publicas
Public gLogTrafic As Boolean

Public gEmailServer       As String
Public gEmailAddress      As String
Public gEmailPort         As Long
Public gEmailUser         As String
Public gEmailPwd          As String

' propiedadades friend
' propiedades privadas
' funciones publicas
Private Function CreateObject(ByVal Class As String) As Object
  On Error GoTo ControlError
  Set CreateObject = Interaction.CreateObject(Class)
  Exit Function
ControlError:
  Err.Raise Err.Number, Err.Source, "No se pudo crear el objeto " & Class & ".\nError Original: " & Err.Description, Err.HelpFile, Err.HelpContext
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



