Attribute VB_Name = "mPublic"
Option Explicit
'--------------------------------------------------------------------------------
' mPublic
' 21-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
#If Not PREPROC_FV Then
Public Sub ActiveBar(Optional ByVal f As Form, Optional ByVal Caption As String)
  On Error Resume Next
  If Caption = "" Then
    Caption = f.Caption
  End If

  fMain.lbBar.Caption = Caption

End Sub

Public Sub DeactiveBar(Optional ByVal f As Form, Optional ByVal Caption As String)
  On Error Resume Next
  
  If Caption = "" Then
    Caption = f.Caption
  End If

  If Caption = fMain.lbBar.Caption Then fMain.lbBar.Caption = ""

End Sub
#End If

Public Function GetRptPath() As String
  GetRptPath = GetValidPath(IniGetEx(c_RPT_KEY, c_RPT_PathReportes, App.Path))
End Function

Public Function GetRptCommandTimeOut() As Long
  GetRptCommandTimeOut = Val(IniGetEx(c_RPT_KEY, c_RPT_CommandTimeOut, 0))
End Function

Public Function GetRptConnectionTimeOut() As Long
  GetRptConnectionTimeOut = Val(IniGetEx(c_RPT_KEY, c_RPT_ConnectionTimeOut, 0))
End Function
' funciones privadas
' construccion - destruccion

