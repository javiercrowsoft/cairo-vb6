Attribute VB_Name = "mPublic"
Option Explicit
'--------------------------------------------------------------------------------
' mPublic
' 26-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mPublic"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas

Public Sub ConvertStringtoArray(ByVal Cadena As String, ByRef Vector() As String, ByVal Separador As String)
  Dim i As Integer
  Dim p As Integer
  Dim q As Integer
  Dim h As String
  
  ReDim Vector(0)

  Cadena = Cadena & Separador
  p = 1
  i = InStr(p, Cadena, Separador, vbTextCompare)
  Do
    If i = 0 Then
      i = Len(Cadena) + 1
    End If
    
    h = Trim(Mid(Cadena, p, i - p))
    If h <> "" Then
      q = q + 1
      ReDim Preserve Vector(q)
      Vector(q) = h
    End If
    p = i + 1
    i = InStr(p, Cadena, Separador, vbTextCompare)
   
   Loop Until i = 0
End Sub


' funciones privadas
' construccion - destruccion
