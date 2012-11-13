Attribute VB_Name = "mPublic"
Option Explicit

'--------------------------------------------------------------------------------
' mPublic
' 16-12-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Public Declare Function ReleaseCapture Lib "user32" () As Long
    Public Declare Function SetCapture Lib "user32" (ByVal hwnd As Long) As Long
    Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublic"

Public Const m_def_BackColorPressed = &H8000000F
Public Const m_def_BackColorUnpressed = &H8000000F

Public Const c_Button = "csButton1"
Public Const c_Caption = "Caption"
Public Const c_BackColor = "BackColor"
Public Const c_BorderColor = "BorderColor"
Public Const c_Font = "Font"
Public Const c_FontBold = "FontBold"
Public Const c_FontItalic = "FontItalic"
Public Const c_FontName = "FontName"
Public Const c_FontSize = "FontSize"
Public Const c_FontStrikethru = "FontStrikethru"
Public Const c_FontUnderline = "FontUnderline"
Public Const c_ForeColor = "ForeColor"
Public Const c_BorderStyle = "BorderStyle"
Public Const c_Picture = "Picture"
Public Const c_BackColorPressed = "BackColorPressed"
Public Const c_BackColorUnpressed = "BackColorUnpressed"
Public Const c_Align = "Align"
Public Const c_Enabled = "Enabled"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public gbNoShowError As Boolean

' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub MngError(ByRef Err As Object, ByVal functionName As String, ByVal Module As String, ByVal InfoAdd As String)
  Dim msg As String
  
  If Not gbNoShowError Then
  
    msg = "Error detectado en " & Module & "." & functionName & vbCrLf & vbCrLf _
          & InfoAdd
  
    MsgBox msg, vbExclamation, "CSButton"
  
  End If
  
  Err.Clear
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
'  MngError err,vbnullstring, C_Module, vbnullstring
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


