Attribute VB_Name = "mConfigRegional"
Option Explicit

'--------------------------------------------------------------------------------
' cConfigRegional
' 04-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' FunctionNamees

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_SepDecimal As String
' Properties publicas
' Properties privadas
' FunctionNamees publicas
' FunctionNamees privadas
' construccion - destruccion
Public Sub SetSepDecimal()
  If CInt("1.000") = 1 Then
    m_SepDecimal = "."
  ElseIf CInt("1,000") = 1 Then
    m_SepDecimal = ","
  End If
  If m_SepDecimal = "" Then _
    Err.Raise csErrorSepDecimalConfig, "Configuración", "No se puede determinar cual es el separador decimal. Confirme en el 'panel de control/configuración regional' que los valores de la ficha número coincidan con los valores de la ficha moneda en los campos 'simbolo decimal' y 'simbolo de separación de miles'. "
End Sub

Public Function GetSepDecimal() As String
  GetSepDecimal = m_SepDecimal
End Function




