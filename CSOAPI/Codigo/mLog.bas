Attribute VB_Name = "mLog"
Option Explicit

'--------------------------------------------------------------------------------
' mLog
' 27-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mLog"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetLogFile() As String
  GetLogFile = App.Path & LOG_NAME
End Function

Public Sub InitLog()
  On Error Resume Next
  FileCopy App.Path & LOG_NAME, App.Path & LOG_NAME2 & Format(Now, "dd-mm-yy hh.nn.ss") & ".log"
  Kill App.Path & LOG_NAME
End Sub

Public Sub SaveLog(ByVal Message As String)
  On Error Resume Next
  Dim strTime As String
  
  strTime = Format(Now, "dd/mm/yy hh:nn:ss   ")
  Message = strTime & Message
  Message = Replace(Message, vbCrLf, vbCrLf & strTime)
  
  Dim f As Integer
  f = FreeFile
  Open App.Path & LOG_NAME For Append Access Write Shared As #f
  Print #f, Message
  Close f
End Sub

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

