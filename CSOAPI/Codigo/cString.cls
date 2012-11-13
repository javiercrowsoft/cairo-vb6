VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cString"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cString
' 27-12-99

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
' Properties publicas
' Properties privadas
' funciones publicas
Public Function Replace(ByVal Source As String, ByVal Search As String, ByVal Value As String) As String
  Replace = Strings.Replace(Source, Search, Value)
End Function
Public Function StrReturn(ByVal texto As String) As String
    StrReturn = Replace(texto, "/n", vbCrLf)
End Function
Public Function ArrayToString(ByVal v As Variant) As String
    ArrayToString = ArrayToString(v)
End Function
' funciones privadas


